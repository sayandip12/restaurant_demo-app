import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class CheckoutForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController landmarkCtrl;
  final TextEditingController notesCtrl;
  final List<Map<String, dynamic>> addresses;

  const CheckoutForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.pincodeCtrl,
    required this.landmarkCtrl,
    required this.notesCtrl,
    this.addresses = const [],
  });

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    print('DEBUG: Number of addresses loaded: ${widget.addresses.length}');

    if (widget.addresses.isNotEmpty) {
      final firstAddr = widget.addresses.first;
      print('DEBUG: Contents of first address: $firstAddr');

      _selectedAddressId = firstAddr['id']?.toString();
      _applyAddress(firstAddr);
    }
  }

  @override
  void didUpdateWidget(CheckoutForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
        'DEBUG [CheckoutForm]: didUpdateWidget called. Old len: ${oldWidget.addresses.length}, New len: ${widget.addresses.length}');

    // If addresses arrived asynchronously after the widget was already built
    if (widget.addresses.isNotEmpty && oldWidget.addresses.isEmpty) {
      final firstAddr = widget.addresses.first;
      print(
          'DEBUG [CheckoutForm]: Addresses arrived async, applying first address: $firstAddr');

      _selectedAddressId = firstAddr['id']?.toString();
      _applyAddress(firstAddr);
    }
  }

  void _applyAddress(Map<String, dynamic> addr) {
    print('DEBUG: _applyAddress called with: $addr');
    widget.nameCtrl.text = addr['name'] ?? '';
    widget.phoneCtrl.text = addr['phone'] ?? '';
    widget.addressCtrl.text = addr['address'] ?? '';
    widget.pincodeCtrl.text = addr['pincode'] ?? '';
    widget.landmarkCtrl.text = addr['landmark'] ?? '';
    print('DEBUG: Controller Name after apply: ${widget.nameCtrl.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Details',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          if (widget.addresses.length > 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedAddressId,
                  hint: const Text('Select a saved address'),
                  items: widget.addresses.map((addr) {
                    final id = addr['id']?.toString();
                    final label = '${addr['name']} - ${addr['address']}';
                    return DropdownMenuItem(
                      value: id,
                      child: Text(label,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _selectedAddressId = val);
                    final addr = widget.addresses
                        .firstWhere((a) => a['id'].toString() == val);
                    _applyAddress(addr);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
          ],
          _Field(
            controller: widget.nameCtrl,
            label: 'Full Name *',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            validator: AppValidators.validateName,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.s3),
          _PhoneField(controller: widget.phoneCtrl),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: widget.addressCtrl,
            label: 'Delivery Address *',
            hint: 'House/Flat no., Street, Colony...',
            icon: Icons.location_on_outlined,
            validator: AppValidators.validateAddress,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: widget.pincodeCtrl,
            label: 'Pincode *',
            hint: '6-digit pincode',
            icon: Icons.pin_drop_outlined,
            validator: AppValidators.validatePincode,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: widget.landmarkCtrl,
            label: 'Landmark (Optional)',
            hint: 'Near school, bus stop...',
            icon: Icons.place_outlined,
          ),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: widget.notesCtrl,
            label: 'Special Instructions (Optional)',
            hint: 'Less spice, extra sauce...',
            icon: Icons.note_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: AppValidators.validatePhone,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: const InputDecoration(
        labelText: 'Phone Number *',
        hintText: '10-digit mobile number',
        prefixIcon: Icon(Icons.phone_outlined, size: 18),
        prefixText: '+91 ',
        counterText: '',
      ),
    );
  }
}
