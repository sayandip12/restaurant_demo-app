import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Generates order IDs matching web format: ORD-YYYYMMDD-NNNN-XXXX
class OrderIdGenerator {
  static const _lastDateKey = 'rita-last-order-date';
  static const _lastSeqKey = 'rita-last-order-sequence';
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static Future<String> generate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    final lastDate = prefs.getString(_lastDateKey);
    int sequence = 1;

    if (lastDate == dateStr) {
      final lastSeq = prefs.getInt(_lastSeqKey) ?? 0;
      sequence = lastSeq + 1;
    }

    await prefs.setString(_lastDateKey, dateStr);
    await prefs.setInt(_lastSeqKey, sequence);

    final seqStr = sequence.toString().padLeft(4, '0');

    // Random 4-char suffix to prevent collisions
    final rng = Random();
    final suffix = List.generate(4, (_) => _chars[rng.nextInt(_chars.length)]).join();

    return 'ORD-$dateStr-$seqStr-$suffix';
  }
}
