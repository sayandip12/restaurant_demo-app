import 'dart:convert';

void main() {
  print('--- 4. RESTAURANT TIMING LOGIC ---');
  bool isRestaurantOpen(DateTime now) {
    final h = now.hour;
    return (h >= 11 || h == 0);
  }
  
  final times = [
    DateTime(2026, 6, 23, 0, 30), 
    DateTime(2026, 6, 23, 0, 59), 
    DateTime(2026, 6, 23, 1, 1),  
    DateTime(2026, 6, 23, 10, 0), 
    DateTime(2026, 6, 23, 11, 0), 
  ];
  
  for (var t in times) {
    final hour12 = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    final m = t.minute.toString().padLeft(2, '0');
    final timeStr = '${hour12}:${m} ${ampm}';
    final status = isRestaurantOpen(t) ? 'OPEN' : 'CLOSED';
    print('${timeStr} = ${status}');
  }

  print('\n--- 5. TIMEZONE LOGIC ---');
  final localPlacementTime = DateTime(2026, 6, 23, 0, 22); 
  final utcToSend = localPlacementTime.toUtc();
  print('raw created_at (to DB): ${utcToSend.toIso8601String()}');
  
  final parsedTime = DateTime.parse(utcToSend.toIso8601String()).toUtc();
  print('parsed time (from DB): $parsedTime');
  
  final displayTime = parsedTime.toLocal();
  final h12 = displayTime.hour > 12 ? displayTime.hour - 12 : (displayTime.hour == 0 ? 12 : displayTime.hour);
  final ap = displayTime.hour >= 12 ? 'PM' : 'AM';
  final min = displayTime.minute.toString().padLeft(2, '0');
  print('displayed time: ${h12}:${min} ${ap}');
}
