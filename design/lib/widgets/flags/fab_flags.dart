// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Utility class for converting ISO country codes to flag emojis
/// 
/// This class provides methods to convert ISO 3166-1 alpha-2 country codes
/// to their corresponding flag emojis using Unicode Regional Indicator Symbols.
class FabFlags {
  FabFlags._(); // Private constructor to prevent instantiation

  /// Convert ISO 3166-1 alpha-2 country code to flag emoji
  /// 
  /// Automatically converts any valid 2-letter country code to its flag emoji.
  /// 
  /// **Examples:**
  /// ```dart
  /// FabFlags.getFlag('ID') // Returns: 🇮🇩 (Indonesia)
  /// FabFlags.getFlag('US') // Returns: 🇺🇸 (United States)
  /// CountryFlagUtil.getFlag('JP') // Returns: 🇯🇵 (Japan)
  /// CountryFlagUtil.getFlag('GB') // Returns: 🇬🇧 (United Kingdom)
  /// CountryFlagUtil.getFlag('FR') // Returns: 🇫🇷 (France)
  /// CountryFlagUtil.getFlag('DE') // Returns: 🇩🇪 (Germany)
  /// CountryFlagUtil.getFlag('invalid') // Returns: 🌐 (Globe fallback)
  /// ```
  /// 
  /// **How it works:**
  /// 
  /// Flag emojis are composed of two "Regional Indicator Symbol" characters.
  /// Each letter A-Z has a corresponding Regional Indicator Symbol in Unicode:
  /// - 🇦 (U+1F1E6) for 'A'
  /// - 🇧 (U+1F1E7) for 'B'
  /// - 🇨 (U+1F1E8) for 'C'
  /// - ... and so on to...
  /// - 🇿 (U+1F1FF) for 'Z'
  /// 
  /// So "ID" becomes 🇮🇩 by combining:
  /// - 🇮 (Regional Indicator I: U+1F1EE)
  /// - 🇩 (Regional Indicator D: U+1F1E9)
  /// 
  /// **Parameters:**
  /// - [code] - ISO 3166-1 alpha-2 country code (2 letters)
  /// 
  /// **Returns:**
  /// - Flag emoji string if valid code
  /// - 🌐 (globe emoji) if invalid code or empty
  /// 
  /// **Supported codes:**
  /// All ISO 3166-1 alpha-2 country codes (AF, AL, DZ, AS, AD, AO, etc.)
  static String getFlag(String code) {
    // Validate input
    if (code.isEmpty || code.length != 2) {
      return '🌐'; // Return globe emoji for invalid codes
    }
    
    // Convert to uppercase to handle both lowercase and uppercase input
    final upperCode = code.toUpperCase();
    
    // Get ASCII values of both letters
    final firstLetter = upperCode.codeUnitAt(0);
    final secondLetter = upperCode.codeUnitAt(1);
    
    // Validate that both characters are letters (A-Z)
    if (!_isValidLetter(firstLetter) || !_isValidLetter(secondLetter)) {
      return '🌐'; // Return globe emoji for non-letter characters
    }
    
    // Regional Indicator Symbol Letter A starts at 0x1F1E6 (127462 in decimal)
    const flagOffset = 0x1F1E6;
    // ASCII code for 'A' is 0x41 (65 in decimal)
    const aOffset = 0x41;
    
    // Calculate the Regional Indicator Symbol for each letter
    // Formula: FLAG_CHAR = FLAG_OFFSET + (LETTER_ASCII - 'A'_ASCII)
    final firstFlag = flagOffset + (firstLetter - aOffset);
    final secondFlag = flagOffset + (secondLetter - aOffset);
    
    // Combine the two Regional Indicator Symbols to form the flag emoji
    return String.fromCharCode(firstFlag) + String.fromCharCode(secondFlag);
  }

  /// Check if a character code represents a valid uppercase letter (A-Z)
  static bool _isValidLetter(int charCode) {
    return charCode >= 0x41 && charCode <= 0x5A; // A-Z in ASCII
  }

  /// Get flag emoji with country name formatted for display
  /// 
  /// **Examples:**
  /// ```dart
  /// CountryFlagUtil.getFlagWithName('ID', 'Indonesia')
  /// // Returns: "🇮🇩 Indonesia"
  /// 
  /// CountryFlagUtil.getFlagWithName('US', 'United States')
  /// // Returns: "🇺🇸 United States"
  /// ```
  static String getFlagWithName(String code, String countryName) {
    final flag = getFlag(code);
    return '$flag $countryName';
  }

  /// Batch convert multiple country codes to flags
  /// 
  /// **Example:**
  /// ```dart
  /// final codes = ['ID', 'US', 'JP', 'GB'];
  /// final flags = CountryFlagUtil.getFlags(codes);
  /// // Returns: ['🇮🇩', '🇺🇸', '🇯🇵', '🇬🇧']
  /// ```
  static List<String> getFlags(List<String> codes) {
    return codes.map((code) => getFlag(code)).toList();
  }

  /// Check if a country code is valid (2 letters A-Z)
  /// 
  /// **Examples:**
  /// ```dart
  /// CountryFlagUtil.isValidCode('ID') // Returns: true
  /// CountryFlagUtil.isValidCode('USA') // Returns: false (3 letters)
  /// CountryFlagUtil.isValidCode('12') // Returns: false (not letters)
  /// CountryFlagUtil.isValidCode('') // Returns: false (empty)
  /// ```
  static bool isValidCode(String code) {
    if (code.length != 2) return false;
    
    final upperCode = code.toUpperCase();
    final firstLetter = upperCode.codeUnitAt(0);
    final secondLetter = upperCode.codeUnitAt(1);
    
    return _isValidLetter(firstLetter) && _isValidLetter(secondLetter);
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

// Example 1: Basic usage in a widget
/*
Text(
  CountryFlagUtil.getFlag('ID'), // 🇮🇩
  style: TextStyle(fontSize: 32),
),
*/

// Example 2: In a dropdown/select option
/*
SelectOption<String>(
  value: 'ID',
  label: 'Indonesia',
  icon: Text(CountryFlagUtil.getFlag('ID')), // 🇮🇩
)
*/

// Example 3: Display flag with country name
/*
Text(
  CountryFlagUtil.getFlagWithName('ID', 'Indonesia'), // 🇮🇩 Indonesia
  style: TextStyle(fontSize: 16),
),
*/

// Example 4: List of countries with flags
/*
ListView.builder(
  itemCount: countries.length,
  itemBuilder: (context, index) {
    final country = countries[index];
    return ListTile(
      leading: Text(
        CountryFlagUtil.getFlag(country.code),
        style: TextStyle(fontSize: 24),
      ),
      title: Text(country.name),
    );
  },
)
*/

// Example 5: Validate country code before using
/*
final code = 'ID';
if (CountryFlagUtil.isValidCode(code)) {
  print('Valid code: ${CountryFlagUtil.getFlag(code)}');
} else {
  print('Invalid country code');
}
*/

// Example 6: Map country data with flags
/*
final countriesWithFlags = countries.map((country) {
  return {
    'code': country.code,
    'name': country.name,
    'flag': CountryFlagUtil.getFlag(country.code),
    'displayName': CountryFlagUtil.getFlagWithName(country.code, country.name),
  };
}).toList();
*/

// Example 7: Search functionality with flags
/*
String searchQuery = 'indo';
final filteredCountries = countries.where((country) {
  return country.name.toLowerCase().contains(searchQuery.toLowerCase());
}).map((country) {
  return CountryFlagUtil.getFlagWithName(country.code, country.name);
}).toList();
*/