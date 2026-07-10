import 'dart:io';
import 'package:supabase/supabase.dart';
import 'package:http/http.dart' as http;

void main() async {
  final supabaseUrl = 'https://pegmlyoebbgzbvcivntb.supabase.co';
  final supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlZ21seW9lYmJnemJ2Y2l2bnRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4OTA5MTcsImV4cCI6MjA5NzQ2NjkxN30.Am2dDtIZJKaqnaKIPSCM0W5O1EyWHgj7xtN4jVsla5o';
  
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  
  final orderId = 'ORD-20260629-0001-TEST';
  final file = File('test_receipt_$orderId.pdf');
  await file.writeAsString('%PDF-1.4\n%EOF\nThermal Receipt PDF Test');
  
  print('--- END-TO-END VERIFICATION ---');
  print('PDF local path: ${file.absolute.path}');
  print('PDF file size: ${await file.length()} bytes');
  
  String pdfUrl = '';
  
  try {
    final response = await client.storage.from('receipts').upload(
      'orders/$orderId.pdf',
      file,
      fileOptions: const FileOptions(upsert: true, contentType: 'application/pdf'),
    );
    print('Upload response: $response');
    print('Uploaded object path: orders/$orderId.pdf');
    
    pdfUrl = client.storage.from('receipts').getPublicUrl('orders/$orderId.pdf');
    print('Generated public URL: $pdfUrl');
    
  } catch (e, stack) {
    print('StorageException: $e');
    print('Stack trace: $stack');
    return;
  }
  
  print('\n--- VERIFYING HTTP GET ---');
  try {
    final res = await http.get(Uri.parse(pdfUrl));
    print('HTTP status code: ${res.statusCode}');
    print('Content-Type: ${res.headers['content-type']}');
  } catch (e) {
    print('HTTP GET failed: $e');
  }
}
