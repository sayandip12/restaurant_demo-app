import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/order.dart';

/// 58mm thermal printer receipt generator (black & white, compact)
class ReceiptGenerator {
  // 58mm thermal paper = ~164pt wide
  static final _thermalFormat = PdfPageFormat(
    58 * PdfPageFormat.mm,
    double.infinity, // continuous roll
    marginAll: 3 * PdfPageFormat.mm,
  );

  static Future<Uint8List> generatePdf(Order order) async {
    final doc = pw.Document();

    // Load logo — fail silently if not found
    pw.ImageProvider? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/logo.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      print('[ReceiptGenerator] Logo loaded successfully.');
    } catch (e) {
      print('[ReceiptGenerator] Logo not found, skipping: $e');
    }

    // Load NotoSans fonts (full Unicode support including ₹ symbol)
    pw.Font fontNormal;
    pw.Font fontBold;
    try {
      final regularData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
      fontNormal = pw.Font.ttf(regularData);
      fontBold = pw.Font.ttf(boldData);
      print('[ReceiptGenerator] NotoSans fonts loaded.');
    } catch (e) {
      print('[ReceiptGenerator] Font load failed, using fallback: $e');
      fontNormal = pw.Font.helvetica();
      fontBold = pw.Font.helveticaBold();
    }

    doc.addPage(
      pw.Page(
        pageFormat: _thermalFormat,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo
              if (logoImage != null)
                pw.Container(
                  height: 50,
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),

              pw.SizedBox(height: 4),
              pw.Text('RITA FOODLAND',
                  style: pw.TextStyle(font: fontBold, fontSize: 13)),
              pw.Text('Authentic Cuisine',
                  style: pw.TextStyle(font: fontNormal, fontSize: 9)),
              pw.Text('J.N. Colony, Kalyani',
                  style: pw.TextStyle(font: fontNormal, fontSize: 9)),

              _dashedLine(fontNormal),

              // Order info
              _row2col('Order', order.id, fontNormal),
              _row2col('Date', _formatDate(order.createdAt), fontNormal),
              _row2col('Time', _formatTime(order.createdAt), fontNormal),

              _dashedLine(fontNormal),

              // Customer details
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('Customer Details',
                    style: pw.TextStyle(font: fontBold, fontSize: 10)),
              ),
              pw.SizedBox(height: 2),
              _row2col('Name', order.customerName, fontNormal),
              _row2col('Phone', order.phone, fontNormal),
              _row2col(
                  'Address',
                  [
                    order.address,
                    if (order.pincode.isNotEmpty) order.pincode,
                    if (order.landmark.isNotEmpty) order.landmark,
                  ].join(', '),
                  fontNormal),

              _dashedLine(fontNormal),

              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('Items',
                    style: pw.TextStyle(font: fontBold, fontSize: 10)),
              ),
              pw.SizedBox(height: 2),

              // Items
              for (final item in order.items)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 2),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Text('${item.quantity} x ${item.name}',
                            style: pw.TextStyle(font: fontNormal, fontSize: 9)),
                      ),
                      pw.Text('₹${item.price * item.quantity}',
                          style: pw.TextStyle(font: fontNormal, fontSize: 9)),
                    ],
                  ),
                ),

              // Grand total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL',
                      style: pw.TextStyle(font: fontBold, fontSize: 10)),
                  pw.Text('₹${order.total}',
                      style: pw.TextStyle(font: fontBold, fontSize: 10)),
                ],
              ),

              _dashedLine(fontNormal),

              pw.Text('STATUS: ${order.status.toUpperCase()}',
                  style: pw.TextStyle(font: fontBold, fontSize: 10)),

              _dashedLine(fontNormal),

              pw.SizedBox(height: 4),
              pw.Text('Thank You For Ordering',
                  style: pw.TextStyle(font: fontNormal, fontSize: 9)),
              pw.SizedBox(height: 2),
              pw.Text('Restaurant Will Contact You',
                  style: pw.TextStyle(font: fontNormal, fontSize: 9)),
              pw.SizedBox(height: 8),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();
    print('[ReceiptGenerator] PDF generated. Size: ${bytes.length} bytes');
    return bytes;
  }

  static pw.Widget _dashedLine(pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Text('- ' * 26,
          style: pw.TextStyle(font: font, fontSize: 7)),
    );
  }

  static pw.Widget _solidLine(pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Divider(height: 1, thickness: 0.5),
    );
  }

  static pw.Widget _row2col(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
              width: 44,
              child: pw.Text(label,
                  style: pw.TextStyle(font: font, fontSize: 9))),
          pw.Text(': ',
              style: pw.TextStyle(font: font, fontSize: 9)),
          pw.Expanded(
              child: pw.Text(value,
                  style: pw.TextStyle(font: font, fontSize: 9))),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    dt = dt.toLocal();
    const months = [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
  }

  static String _formatTime(DateTime dt) {
    dt = dt.toLocal();
    final h =
        dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }
}
