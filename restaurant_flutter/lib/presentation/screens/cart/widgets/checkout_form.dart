import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/validators.dart';

class CheckoutForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController landmarkCtrl;
  final TextEditingController notesCtrl;

  const CheckoutForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.landmarkCtrl,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Details',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s4),
          _Field(
            controller: nameCtrl,
            label: 'Full Name *',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            validator: AppValidators.validateName,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.s3),
          _PhoneField(controller: phoneCtrl),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: addressCtrl,
            label: 'Delivery Address *',
            hint: 'House/Flat no., Street, Colony...',
            icon: Icons.location_on_outlined,
            validator: AppValidators.validateAddress,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: landmarkCtrl,
            label: 'Landmark (Optional)',
            hint: 'Near school, bus stop...',
            icon: Icons.place_outlined,
          ),
          const SizedBox(height: AppSpacing.s3),
          _Field(
            controller: notesCtrl,
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
