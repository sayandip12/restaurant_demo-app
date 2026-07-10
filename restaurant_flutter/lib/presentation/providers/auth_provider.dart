import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Auth State ────────────────────────────────────────────────────────────────

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage,
      );
}

// ── Auth Notifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  final _client = Supabase.instance.client;

  void _init() {
    // Check current session on startup
    final session = _client.auth.currentSession;
    print('DEBUG_AUTH: _init() called. currentSession=${session?.user.email}');
    if (session != null) {
      state = AuthState(status: AuthStatus.authenticated, user: session.user);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }

    // Listen for auth changes (login, logout, token refresh)
    _client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      print(
          'DEBUG_AUTH: onAuthStateChange event=$event, sessionUser=${session?.user.email}');

      if ((event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.initialSession) &&
          session != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: session.user,
        );
      } else if (event == AuthChangeEvent.signedOut) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else if (event == AuthChangeEvent.tokenRefreshed && session != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: session.user,
        );
      } else if (event == AuthChangeEvent.initialSession && session == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
  }

  /// Sign in with email + password
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      if (response.user != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: response.user,
        );
        return true;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Login failed. Please check your credentials.',
      );
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred.',
      );
      return false;
    }
  }

  /// Register new account
  Future<bool> signUp(String email, String password, String name) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': name.trim()},
      );
      if (response.user != null) {
        // Supabase may require email confirmation — handle both cases
        if (response.session != null) {
          state = AuthState(
            status: AuthStatus.authenticated,
            user: response.user,
          );
        } else {
          // Email confirmation required
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
        return true;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Registration failed.',
      );
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred.',
      );
      return false;
    }
  }

  /// Send password reset email
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to send reset email.',
      );
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(
      status: state.isAuthenticated
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// Convenience: just the current Supabase User (null if not logged in)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});
