import 'dart:io';
import 'package:supabase/supabase.dart';

void main() async {
  final supabaseUrl = 'https://pegmlyoebbgzbvcivntb.supabase.co';
  final supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlZ21seW9lYmJnemJ2Y2l2bnRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4OTA5MTcsImV4cCI6MjA5NzQ2NjkxN30.Am2dDtIZJKaqnaKIPSCM0W5O1EyWHgj7xtN4jVsla5o';
  
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  
  // Create a dummy PDF
  final file = File('ORD-TEST-0002.pdf');
  await file.writeAsString('%PDF-1.4\n%EOF\nDummy Content');
  
  print('PDF Path: ${file.absolute.path}');
  print('PDF Size: ${await file.length()} bytes');
  print('Bucket: receipts');
  
  try {
    await client.storage.createBucket('receipts', const BucketOptions(public: true));
    print('Bucket "receipts" created.');
  } catch (e) {
    print('Bucket might already exist or error: $e');
  }

  try {
    final response = await client.storage.from('receipts').upload(
      'orders/ORD-TEST-0002.pdf',
      file,
      fileOptions: const FileOptions(upsert: true, contentType: 'application/pdf'),
    );
    print('Upload Response: $response');
  } catch (e) {
    print('Upload Error: $e');
  }
  
  final pdfUrl = client.storage.from('receipts').getPublicUrl('orders/ORD-TEST-0002.pdf');
  print('Public URL: $pdfUrl');
}
