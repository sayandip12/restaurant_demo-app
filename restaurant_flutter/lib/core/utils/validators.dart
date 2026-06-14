/// Form validation matching web validateForm() logic exactly
class AppValidators {
  /// Name: required, min 2 chars
  static String? validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  /// Phone: required, exactly 10 digits, starts with 6-9
  static String? validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d{10}$').hasMatch(v)) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!RegExp(r'^[6-9]').hasMatch(v)) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }
    return null;
  }

  /// Address: required, min 10 chars
  static String? validateAddress(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Delivery address is required';
    if (v.length < 10) {
      return 'Please enter a complete address (min 10 characters)';
    }
    return null;
  }
}

/// Currency formatting
String formatCurrency(int amount) => '₹$amount';

String formatCurrencyK(int val) {
  if (val >= 1000) return '₹${(val / 1000).toStringAsFixed(0)}k';
  return '₹$val';
}
