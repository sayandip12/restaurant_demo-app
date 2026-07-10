import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignUp = false;
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).clearError();

    bool success;
    if (_isSignUp) {
      success = await ref.read(authProvider.notifier).signUp(
            _emailCtrl.text,
            _passwordCtrl.text,
            _nameCtrl.text,
          );
      if (success && mounted) {
        final auth = ref.read(authProvider);
        if (auth.isAuthenticated) {
          context.go('/'); // Email confirmation not required
        } else {
          _showSnack(
            'Registration successful! Please check your email to confirm your account.',
            isError: false,
          );
        }
      }
    } else {
      print('DEBUG_LOGIN: Attempting signIn...');
      success = await ref.read(authProvider.notifier).signIn(
            _emailCtrl.text,
            _passwordCtrl.text,
          );
      print('DEBUG_LOGIN: signIn success=$success');
      final authState = ref.read(authProvider);
      final currentSession = Supabase.instance.client.auth.currentSession;
      print(
          'DEBUG_LOGIN: After signIn, authState.status=${authState.status}, sessionUser=${currentSession?.user.email}');

      if (success) {
        final currentSession = Supabase.instance.client.auth.currentSession;
        if (currentSession != null && currentSession.user != null) {
          if (mounted) {
            print('DEBUG_LOGIN: Navigating to / (session valid)');
            context.go('/');
          }
        } else {
          print('DEBUG_LOGIN: session is null after success!');
          if (mounted)
            _showSnack('Session could not be established. Please try again.');
        }
      }
    }
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.danger : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    // Show errors from provider
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        _showSnack(next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s4),

                // ── Logo / Brand ──────────────────────────────────────────
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Center(
                  child: Text(
                    'Rita Foodland',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Center(
                  child: Text(
                    _isSignUp ? 'Create your account' : 'Welcome back!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.s8),

                // ── Name (sign-up only) ───────────────────────────────────
                if (_isSignUp) ...[
                  _label('Full Name'),
                  const SizedBox(height: AppSpacing.s2),
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDec(
                      'Enter your full name',
                      Icons.person_outline,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                ],

                // ── Email ─────────────────────────────────────────────────
                _label('Email Address'),
                const SizedBox(height: AppSpacing.s2),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDec(
                    'Enter your email',
                    Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.s4),

                // ── Password ──────────────────────────────────────────────
                _label('Password'),
                const SizedBox(height: AppSpacing.s2),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: _inputDec(
                    'Enter your password',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),

                // ── Forgot password ───────────────────────────────────────
                if (!_isSignUp) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else
                  const SizedBox(height: AppSpacing.s4),

                // ── Submit button ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isSignUp ? 'Create Account' : 'Login'),
                  ),
                ),

                const SizedBox(height: AppSpacing.s6),

                // ── Toggle sign-in / sign-up ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignUp
                          ? 'Already have an account? '
                          : "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          _formKey.currentState?.reset();
                          ref.read(authProvider.notifier).clearError();
                        });
                      },
                      child: Text(
                        _isSignUp ? 'Login' : 'Sign Up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  InputDecoration _inputDec(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      );
}
