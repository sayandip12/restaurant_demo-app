import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

void main() async {
  try {
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
    final url = dotenv.env['SUPABASE_URL'] ?? 'null';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? 'null';
    print('RUNTIME_URL: $url');
    print('RUNTIME_KEY: $key');
    
    final client = SupabaseClient(url, key);
    final email = 'test_login_${DateTime.now().millisecondsSinceEpoch}@example.com';
    try {
      await client.auth.signUp(email: email, password: 'Password123!');
      final res = await client.auth.signInWithPassword(email: email, password: 'Password123!');
      print('RUNTIME_AUTH_RESULT: SUCCESS, Session: ${res.session?.accessToken != null}');
    } on AuthException catch (e) {
      print('RUNTIME_AUTH_ERROR: ${e.message} (Code: ${e.statusCode})');
    } catch (e) {
      print('RUNTIME_AUTH_ERROR: $e');
    }
  } catch (e) {
    print('ERROR: $e');
  }
  exit(0);
}
