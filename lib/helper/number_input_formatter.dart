import 'package:flutter/services.dart';

// Custom input formatter to allow negative numbers
class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.isEmpty || newText == '-' || double.tryParse(newText) != null) {
      return newValue;
    }
    return oldValue;
  }
}