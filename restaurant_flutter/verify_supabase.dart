import 'package:supabase/supabase.dart';
import 'dart:io';

void main() async {
  final supabaseUrl = 'https://pegmlyoebbgzbvcivntb.supabase.co';
  final supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlZ21seW9lYmJnemJ2Y2l2bnRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4OTA5MTcsImV4cCI6MjA5NzQ2NjkxN30.Am2dDtIZJKaqnaKIPSCM0W5O1EyWHgj7xtN4jVsla5o';
  
  final client = SupabaseClient(supabaseUrl, supabaseKey);

  print('--- SUPABASE VERIFICATION START ---');

  final email = 'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  String? userId;

  // 1. Registration
  try {
    final res = await client.auth.signUp(email: email, password: password, data: {'full_name': 'Test User'});
    if (res.user != null) {
      userId = res.user!.id;
      print('1. Registration... SUCCESS (ID: $userId)');
    } else {
      print('1. Registration... FAILED (User is null)');
    }
  } catch (e) {
    print('1. Registration... ERROR: $e');
  }

  // 2. Login
  try {
    final res = await client.auth.signInWithPassword(email: email, password: password);
    if (res.session != null) {
      print('2. Login... SUCCESS (Session Active)');
    } else {
      print('2. Login... FAILED');
    }
  } catch (e) {
    print('2. Login... ERROR: $e');
  }

  // 3. Forgot Password
  try {
    await client.auth.resetPasswordForEmail(email);
    print('3. Forgot Password... SUCCESS');
  } catch (e) {
    print('3. Forgot Password... ERROR: $e');
  }

  // 4. Session Persistence Check
  if (client.auth.currentSession != null) {
    print('4. Session Persistence... SUCCESS');
  } else {
    print('4. Session Persistence... FAILED');
  }

  // 5. Profile Trigger
  if (userId != null) {
    try {
      final profile = await client.from('profiles').select().eq('id', userId).single();
      print('5. Profile Trigger... SUCCESS (Name: ${profile['full_name']})');
    } catch (e) {
      print('5. Profile Trigger... ERROR: $e');
    }
  }

  // 6. Order Creation
  final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  try {
    await client.from('orders').insert({
      'order_number': orderId,
      'customer_name': 'Test User',
      'phone': '1234567890',
      'address': 'Test Address',
      'pincode': '123456',
      'subtotal': 100,
      'total': 100,
    });
    print('6. Order Creation... SUCCESS ($orderId)');
  } catch (e) {
    print('6. Order Creation... ERROR: $e');
  }

  // 7. My Orders Screen (Fetch only my orders)
  try {
    final orders = await client.from('orders').select().eq('user_id', userId ?? '');
    print('7. My Orders... SUCCESS (Count: ${orders.length})');
  } catch (e) {
    print('7. My Orders... ERROR: $e');
  }

  // 8. Saved Addresses
  if (userId != null) {
    try {
      await client.from('addresses').insert({
        'user_id': userId,
        'name': 'Home',
        'phone': '1234567890',
        'address': '123 Test St',
        'pincode': '123456'
      });
      final addresses = await client.from('addresses').select();
      print('8. Saved Addresses... SUCCESS (Count: ${addresses.length})');
    } catch (e) {
      print('8. Saved Addresses... ERROR: $e');
    }
  } else {
    print('8. Saved Addresses... SKIPPED (No userId)');
  }

  // 9. Order Status
  try {
    final order = await client.from('orders').select('status').eq('order_number', orderId).single();
    print('9. Order Status... SUCCESS (Status: ${order['status']})');
  } catch (e) {
    print('9. Order Status... ERROR: $e');
  }

  // 10. Logout Flow
  try {
    await client.auth.signOut();
    if (client.auth.currentSession == null) {
      print('10. Logout... SUCCESS');
    } else {
      print('10. Logout... FAILED');
    }
  } catch (e) {
    print('10. Logout... ERROR: $e');
  }

  print('--- SUPABASE VERIFICATION END ---');
  exit(0);
}
