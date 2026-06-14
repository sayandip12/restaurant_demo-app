import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/price_summary_card.dart';
import 'widgets/step_indicator.dart';
import 'widgets/checkout_form.dart';
import 'widgets/confirmation_view.dart';

/// Cart screen — 3-step wizard: Cart → Checkout → Confirmation
/// Matches CartPage.jsx logic exactly
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  int _step = 0; // 0=Cart, 1=Checkout, 2=Confirmation

  // Checkout form state
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _landmarkCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final cartState = ref.read(cartProvider);
    final success = await ref.read(orderProvider.notifier).placeOrder(
          items: cartState.items,
          customerName: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          landmark: _landmarkCtrl.text.trim(),
          notes: _notesCtrl.text.trim(),
        );

    if (success) {
      ref.read(cartProvider.notifier).clear();
      HapticFeedback.mediumImpact();
      setState(() {
        _step = 2;
        _isSubmitting = false;
      });
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            if (_step == 1) {
              setState(() => _step = 0);
            } else if (_step == 0) {
              context.pop();
            }
            // On confirmation, back goes to menu
            if (_step == 2) {
              context.go('/menu');
            }
          },
        ),
        bottom: _step < 2
            ? PreferredSize(
                preferredSize: const Size.fromHeight(44),
                child: StepIndicator(currentStep: _step),
              )
            : null,
      ),
      body: () {
        if (_step == 0) {
          if (cartState.items.isEmpty) return _EmptyCart();
          return _CartStep(
            cartState: cartState,
            onProceed: () => setState(() => _step = 1),
          );
        }
        if (_step == 1) {
          return _CheckoutStep(
            formKey: _formKey,
            nameCtrl: _nameCtrl,
            phoneCtrl: _phoneCtrl,
            addressCtrl: _addressCtrl,
            landmarkCtrl: _landmarkCtrl,
            notesCtrl: _notesCtrl,
            cartState: cartState,
            isSubmitting: _isSubmitting,
            onSubmit: _placeOrder,
          );
        }
        // Step 2 — confirmation
        return ConfirmationView(
          order: orderState.order!,
          onNewOrder: () => context.go('/menu'),
        );
      }(),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.border),
          const SizedBox(height: AppSpacing.s4),
          Text('Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                  )),
          const SizedBox(height: AppSpacing.s3),
          const Text('Add some delicious items from our menu!',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: AppSpacing.s6),
          ElevatedButton.icon(
            onPressed: () => context.go('/menu'),
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Browse Menu'),
          ),
        ],
      ),
    );
  }
}

class _CartStep extends StatelessWidget {
  final CartState cartState;
  final VoidCallback onProceed;

  const _CartStep({required this.cartState, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              ...cartState.items.map((item) => CartItemTile(item: item)),
              const SizedBox(height: AppSpacing.s4),
              PriceSummaryCard(cartState: cartState),
            ],
          ),
        ),
        _ProceedButton(
          label: 'Proceed to Checkout',
          total: cartState.grandTotal,
          onTap: onProceed,
        ),
      ],
    );
  }
}

class _CheckoutStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController landmarkCtrl;
  final TextEditingController notesCtrl;
  final CartState cartState;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _CheckoutStep({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.landmarkCtrl,
    required this.notesCtrl,
    required this.cartState,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              CheckoutForm(
                formKey: formKey,
                nameCtrl: nameCtrl,
                phoneCtrl: phoneCtrl,
                addressCtrl: addressCtrl,
                landmarkCtrl: landmarkCtrl,
                notesCtrl: notesCtrl,
              ),
              const SizedBox(height: AppSpacing.s4),
              PriceSummaryCard(cartState: cartState),
            ],
          ),
        ),
        _ProceedButton(
          label: isSubmitting ? 'Placing Order...' : 'Place Order',
          total: cartState.grandTotal,
          onTap: isSubmitting ? null : onSubmit,
          loading: isSubmitting,
        ),
      ],
    );
  }
}

class _ProceedButton extends StatelessWidget {
  final String label;
  final int total;
  final VoidCallback? onTap;
  final bool loading;

  const _ProceedButton({
    required this.label,
    required this.total,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4, AppSpacing.s3, AppSpacing.s4, AppSpacing.s6),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          ),
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.white),
                )
              : Text(
                  '$label  |  ₹$total',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
