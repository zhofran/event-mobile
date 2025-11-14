// import 'package:flutter/material.dart';
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FabFunction {
  static String formatRupiah({required double currency, String symbol = 'Rp'}) {
    var rupiahFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: symbol, decimalDigits: 0);
    String formattedRupiah = rupiahFormat.format(currency);
    return formattedRupiah;
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  ThousandsSeparatorInputFormatter({this.separator = '.'});

  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika text kosong, return as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Jika tidak ada digit, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format dengan thousand separator
    String formatted = _formatWithSeparator(digitsOnly);

    // Calculate new cursor position
    int cursorPosition = formatted.length;

    // Jika user menghapus character, adjust cursor position
    if (oldValue.text.length > newValue.text.length) {
      // User is deleting
      String oldDigits = oldValue.text.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length < oldDigits.length) {
        // Recalculate cursor position based on digit count
        int oldCursorPos = oldValue.selection.baseOffset;
        int digitsBeforeCursor = oldValue.text
            .substring(0, oldCursorPos)
            .replaceAll(RegExp(r'[^\d]'), '')
            .length;
        
        // Find position in new formatted string
        int newDigitCount = 0;
        for (int i = 0; i < formatted.length; i++) {
          if (RegExp(r'\d').hasMatch(formatted[i])) {
            newDigitCount++;
          }
          if (newDigitCount >= digitsBeforeCursor) {
            cursorPosition = i + 1;
            break;
          }
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _formatWithSeparator(String digits) {
    if (digits.isEmpty) return '';

    // Reverse the string untuk memudahkan grouping
    String reversed = digits.split('').reversed.join('');
    
    // Group by 3 digits
    List<String> groups = [];
    for (int i = 0; i < reversed.length; i += 3) {
      int end = i + 3;
      if (end > reversed.length) end = reversed.length;
      groups.add(reversed.substring(i, end));
    }

    // Join with separator and reverse back
    String formatted = groups.join(separator).split('').reversed.join('');
    
    return formatted;
  }

  /// Helper method to convert formatted string back to integer
  static int? parseFormattedNumber(String formattedNumber) {
    if (formattedNumber.isEmpty) return null;
    String digitsOnly = formattedNumber.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(digitsOnly);
  }

  /// Helper method to format integer to string with separator
  static String formatNumber(int number, {String separator = '.'}) {
    if (number == 0) return '0';
    
    String numStr = number.toString();
    String reversed = numStr.split('').reversed.join('');
    
    List<String> groups = [];
    for (int i = 0; i < reversed.length; i += 3) {
      int end = i + 3;
      if (end > reversed.length) end = reversed.length;
      groups.add(reversed.substring(i, end));
    }
    
    return groups.join(separator).split('').reversed.join('');
  }
}