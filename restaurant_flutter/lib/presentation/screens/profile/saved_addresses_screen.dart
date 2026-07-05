import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../providers/address_provider.dart';
import '../../providers/auth_provider.dart';

class SavedAddressesScreen extends ConsumerStatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  ConsumerState<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends ConsumerState<SavedAddressesScreen> {
  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(savedAddressesProvider);
    final isLoggedIn = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: !isLoggedIn
          ? _buildLoginPrompt()
          : addresses.isEmpty
              ? _buildEmpty()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s3),
                  itemBuilder: (context, i) {
                    final addr = addresses[i];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.s4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                          const SizedBox(width: AppSpacing.s3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(addr['name'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(addr['phone'] ?? '',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(addr['address'] ?? '',
                                    style: const TextStyle(fontSize: 13, height: 1.4)),
                                if (addr['pincode'] != null && addr['pincode']!.isNotEmpty)
                                  Text('Pincode: ${addr['pincode']}',
                                      style: const TextStyle(fontSize: 13, height: 1.4)),
                                if (addr['landmark'] != null && addr['landmark']!.isNotEmpty)
                                  Text('Landmark: ${addr['landmark']}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text('Delete Address'),
                                  content: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete', style: TextStyle(color: AppColors.danger))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final addrId = addr['id']?.toString();
                                if (addrId != null) {
                                  ref.read(savedAddressesProvider.notifier).removeAddress(addrId);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton.extended(
              onPressed: () => _showAddAddressDialog(context, ref),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_off_outlined, size: 64, color: AppColors.border),
          const SizedBox(height: AppSpacing.s4),
          const Text('Login to save addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s4),
          ElevatedButton(onPressed: () => context.push('/login'), child: const Text('Login')),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.map_outlined, size: 64, color: AppColors.border),
          const SizedBox(height: AppSpacing.s4),
          const Text('No addresses saved yet', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final pincodeCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.s4,
          right: AppSpacing.s4,
          top: AppSpacing.s4,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.s4,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.s4),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name *', prefixIcon: Icon(Icons.person_outline)),
                  validator: AppValidators.validateName,
                ),
                const SizedBox(height: AppSpacing.s3),
                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone *', prefixIcon: Icon(Icons.phone_outlined)),
                  validator: AppValidators.validatePhone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.s3),
                TextFormField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'Address *', prefixIcon: Icon(Icons.location_on_outlined)),
                  validator: AppValidators.validateAddress,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.s3),
                TextFormField(
                  controller: pincodeCtrl,
                  decoration: const InputDecoration(labelText: 'Pincode *', prefixIcon: Icon(Icons.pin_drop_outlined)),
                  validator: AppValidators.validatePincode,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.s3),
                TextFormField(
                  controller: landmarkCtrl,
                  decoration: const InputDecoration(labelText: 'Landmark (Optional)', prefixIcon: Icon(Icons.place_outlined)),
                ),
                const SizedBox(height: AppSpacing.s6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref.read(savedAddressesProvider.notifier).addAddress({
                          'name': nameCtrl.text.trim(),
                          'phone': phoneCtrl.text.trim(),
                          'address': addressCtrl.text.trim(),
                          'pincode': pincodeCtrl.text.trim(),
                          'landmark': landmarkCtrl.text.trim(),
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Save Address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
