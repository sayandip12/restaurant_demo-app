import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

final savedAddressesProvider =
    StateNotifierProvider<SavedAddressesNotifier, List<Map<String, dynamic>>>(
        (ref) {
  final user = ref.watch(currentUserProvider);
  return SavedAddressesNotifier(user?.id);
});

class SavedAddressesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final String? userId;
  final _supabase = Supabase.instance.client;

  SavedAddressesNotifier(this.userId) : super([]) {
    _load();
  }

  Future<void> _load() async {
    print('DEBUG [AddressProvider]: _load() called for userId: $userId');
    if (userId == null) return;
    try {
      final data = await _supabase
          .from('addresses')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: false);

      print(
          'DEBUG [AddressProvider]: Number of addresses returned from Supabase: ${data.length}');
      print('DEBUG [AddressProvider]: Data returned: $data');

      state = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('DEBUG [AddressProvider]: Error loading addresses: $e');
    }
  }

  Future<void> addAddress(Map<String, dynamic> address) async {
    if (userId == null) return;
    try {
      final insertData = {
        'user_id': userId,
        'name': address['name'],
        'phone': address['phone'],
        'address': address['address'],
        'pincode': address['pincode'],
        'landmark': address['landmark'],
      };

      final data = await _supabase
          .from('addresses')
          .insert(insertData)
          .select()
          .single();
      state = [data, ...state];
    } catch (e) {
      // ignore
    }
  }

  Future<void> removeAddress(String addressId) async {
    if (userId == null) return;
    try {
      await _supabase.from('addresses').delete().eq('id', addressId);
      state = state.where((addr) => addr['id'] != addressId).toList();
    } catch (e) {
      // ignore
    }
  }
}
