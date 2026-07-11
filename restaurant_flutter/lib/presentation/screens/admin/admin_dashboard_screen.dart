import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/menu_provider.dart';
import 'admin_food_form_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _isLoading = false;
  
  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }
  
  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  Future<void> _toggleRestaurantStatus(bool currentStatus) async {
    if (_isLoading) return;
    _setLoading(true);
    try {
      final client = Supabase.instance.client;
      final data = await client.from('restaurant_settings').select('id').eq('id', 1).maybeSingle().timeout(const Duration(seconds: 10));
      
      if (data == null) {
        await client.from('restaurant_settings').insert({
          'id': 1,
          'is_open': !currentStatus,
          'opening_time': '12:00 PM',
          'closing_time': '12:00 AM',
        }).timeout(const Duration(seconds: 10));
      } else {
        await client.from('restaurant_settings').update({
          'is_open': !currentStatus
        }).eq('id', 1).timeout(const Duration(seconds: 10));
      }
      
      if (!mounted) return;
      _showSuccess('Restaurant status updated');
    } on PostgrestException catch (e) {
      if (!mounted) return;
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        _showError('Permission denied: Administrator privileges required.');
      } else {
        _showError('Database error: ${e.message}');
      }
    } on TimeoutException {
      if (!mounted) return;
      _showError('Network timeout. Please check your connection.');
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to update status: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _toggleStock(String id, bool currentStock) async {
    if (_isLoading) return;
    _setLoading(true);
    try {
      await Supabase.instance.client
          .from('menu_items')
          .update({'is_available': !currentStock})
          .eq('id', id)
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      _showSuccess('Stock status updated');
    } on PostgrestException catch (e) {
      if (!mounted) return;
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        _showError('Permission denied: Administrator privileges required.');
      } else {
        _showError('Database error: ${e.message}');
      }
    } on TimeoutException {
      if (!mounted) return;
      _showError('Network timeout. Please check your connection.');
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to update stock: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _confirmDelete(String id, String name) {
    if (_isLoading) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food?'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _setLoading(true);
              try {
                await Supabase.instance.client
                    .from('menu_items')
                    .update({'is_deleted': true, 'is_available': false})
                    .eq('id', id)
                    .timeout(const Duration(seconds: 10));
                if (!mounted) return;
                _showSuccess('Food deleted successfully');
              } on PostgrestException catch (e) {
                if (!mounted) return;
                if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
                  _showError('Permission denied: Administrator privileges required.');
                } else {
                  _showError('Database error: ${e.message}');
                }
              } on TimeoutException {
                if (!mounted) return;
                _showError('Network timeout. Please check your connection.');
              } catch (e) {
                if (!mounted) return;
                _showError('Failed to delete food: $e');
              } finally {
                _setLoading(false);
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final settings = ref.watch(restaurantSettingsProvider);
    final isRestaurantOpen = settings.isOpen;
    
    // Flatten all items from all categories
    final allFoods = categories.expand((c) => c.items).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Restaurant Status Card
              Container(
                margin: const EdgeInsets.all(AppSpacing.s4),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6, vertical: AppSpacing.s4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: isRestaurantOpen ? Colors.green : Colors.red, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRestaurantOpen ? 'Restaurant is OPEN' : 'Restaurant is CLOSED',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isRestaurantOpen ? Colors.green : Colors.red,
                            ),
                          ),
                          const Text(
                            'Toggle to change status',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        value: isRestaurantOpen,
                        activeColor: Colors.green,
                        onChanged: _isLoading ? null : (val) => _toggleRestaurantStatus(isRestaurantOpen),
                      ),
                    ),
                  ],
                ),
              ),

              // Add Food Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminFoodFormScreen()));
                        },
                  icon: const Icon(Icons.add, size: 28),
                  label: const Text('ADD NEW FOOD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),

              // Food List Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Menu Items', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.s2),

              // Food List
              Expanded(
                child: allFoods.isEmpty
                    ? const Center(
                        child: Text(
                          'No menu items found.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s2),
                        itemCount: allFoods.length,
                        itemBuilder: (context, index) {
                          final food = allFoods[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.s4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s4),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    image: food.image.isNotEmpty
                                        ? DecorationImage(
                                            image: food.isAsset 
                                                ? AssetImage(food.image) as ImageProvider 
                                                : CachedNetworkImageProvider(food.image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: food.image.isEmpty ? const Icon(Icons.fastfood, size: 40, color: Colors.grey) : null,
                                ),
                                const SizedBox(width: AppSpacing.s4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Half: ₹${food.price} | Full: ${food.priceL != null ? '₹${food.priceL}' : 'N/A'}',
                                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            food.available ? 'In Stock' : 'Out of Stock',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: food.available ? Colors.green : Colors.red,
                                            ),
                                          ),
                                          Switch(
                                            value: food.available,
                                            activeColor: Colors.green,
                                            onChanged: _isLoading ? null : (val) => _toggleStock(food.id, food.available),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => AdminFoodFormScreen(foodItem: food)),
                                          );
                                        },
                                  icon: const Icon(Icons.edit, size: 24, color: Colors.blue),
                                  label: const Text('EDIT', style: TextStyle(fontSize: 18, color: Colors.blue)),
                                ),
                                Container(width: 1, height: 30, color: Colors.grey.shade300),
                                TextButton.icon(
                                  onPressed: _isLoading ? null : () => _confirmDelete(food.id, food.name),
                                  icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                                  label: const Text('DELETE', style: TextStyle(fontSize: 18, color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
