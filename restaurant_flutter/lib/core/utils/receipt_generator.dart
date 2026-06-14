import '../../domain/entities/order.dart';

/// Generates thermal-printer-style receipt text
/// Matches the web generateReceipt() function output exactly
class ReceiptGenerator {
  static const _w = 40; // character width

  static String generate(Order order) {
    final line = '─' * _w;
    final dline = '═' * _w;

    String pad(String l, String r, {int w = _w}) {
      final gap = w - l.length - r.length;
      return l + ' ' * (gap < 1 ? 1 : gap) + r;
    }

    final dateStr = _formatDate(order.createdAt);
    final timeStr = _formatTime(order.createdAt);

    final buf = StringBuffer();
    buf.writeln(dline);
    buf.writeln('       RITA FOODLAND');
    buf.writeln('     Authentic Cuisine');
    buf.writeln('   J.N. Colony, Kalyani');
    buf.writeln(dline);
    buf.writeln('Order: ${order.id}');
    buf.writeln('Date:  $dateStr');
    buf.writeln('Time:  $timeStr');
    buf.writeln(line);
    buf.writeln('Customer: ${order.customerName}');
    buf.writeln('Phone:    ${order.phone}');
    buf.writeln('Address:  ${order.address}');
    if (order.landmark.isNotEmpty) buf.writeln('Landmark: ${order.landmark}');
    if (order.notes.isNotEmpty) buf.writeln('Notes:    ${order.notes}');
    buf.writeln(line);
    buf.writeln(pad('ITEM', 'TOTAL'));
    buf.writeln(line);

    for (final item in order.items) {
      buf.writeln('${item.quantity} x ${item.name}');
      buf.writeln(pad('', '₹${item.total}'));
    }

    buf.writeln(line);
    buf.writeln(pad('Subtotal:', '₹${order.subtotal}'));
    buf.writeln(dline);
    buf.writeln(pad('GRAND TOTAL:', '₹${order.total}'));
    buf.writeln(dline);
    buf.writeln('');
    buf.writeln('  Thank you for ordering!');
    buf.writeln('  Restaurant will contact you.');
    buf.writeln('');

    return buf.toString();
  }

  static String _formatDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }

  static String buildWhatsAppMessage(Order order) {
    final receipt = generate(order);
    return '🍽️ *New Order from Rita Foodland*\n\n$receipt';
  }
}
