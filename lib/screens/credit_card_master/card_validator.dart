import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CardValidator {
  String formatDate(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  List<TextInputFormatter> get cardNumberFormatters => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
      ];

  bool _validateLuhn(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cardNumber.length != 16) return false;
    int sum = 0;
    bool isEven = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (isEven) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isEven = !isEven;
    }
    return sum % 10 == 0;
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter account number';
    return null;
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter card number';
    if (!_validateLuhn(value)) return 'Invalid card number';
    return null;
  }

  String? validateAccountHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter account holder name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only letters and spaces allowed';
    }
    return null;
  }

  String? validateCvv(String? value) {
    if (value == null || value.isEmpty) return 'Please enter CVV';
    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) return 'Please select an expiry date';
    if (!RegExp(r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
        .hasMatch(value)) {
      return 'Format must be MMM YYYY';
    }
    try {
      final date = DateFormat('MMM yyyy').parseStrict(value);
      final now = DateTime.now();
      if (date.isBefore(DateTime(now.year, now.month, 1))) {
        return 'Card is expired';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  String? validateGenerationDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a generation date';
    }
    if (!RegExp(r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
        .hasMatch(value)) {
      return 'Format must be MMM YYYY';
    }
    return null;
  }

  String? validatePaymentFinalDate(String? value, String generationDate) {
    if (value == null || value.isEmpty) {
      return 'Please select a payment final date';
    }
    if (!RegExp(r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
        .hasMatch(value)) {
      return 'Format must be MMM YYYY';
    }
    try {
      final genDate = DateFormat('MMM yyyy').parseStrict(generationDate);
      final payDate = DateFormat('MMM yyyy').parseStrict(value);
      if (payDate.isBefore(genDate) ||
          (payDate.year == genDate.year && payDate.month == genDate.month)) {
        return 'Must be after generation date';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }
}
