/// Text processing utilities for consistent string manipulation
/// Provides optimized text cleaning and formatting functions
class TextUtils {
  // Cached regex patterns for performance optimization
  static final RegExp _trailingDatePattern = RegExp(r'\s+\d{4}-\d{2}-\d{2}$');
  static final RegExp _whitespacePattern = RegExp(r'\s+');
  
  /// Removes trailing dates in YYYY-MM-DD format from text
  /// Example: "Foreign Currency Translation 2025-08-25" → "Foreign Currency Translation"
  /// Example: "Make error 2024-12-31" → "Make error"
  /// 
  /// Preserves dates that appear elsewhere in the string:
  /// Example: "Order for 2025-08-25 delivery confirmed" → unchanged
  static String removeTrailingDate(String text) {
    if (text.isEmpty) return text;
    return text.replaceAll(_trailingDatePattern, '').trim();
  }
  
  /// Normalizes whitespace by replacing multiple spaces with single spaces
  /// Example: "Hello    world   !" → "Hello world !"
  static String normalizeWhitespace(String text) {
    if (text.isEmpty) return text;
    return text.replaceAll(_whitespacePattern, ' ').trim();
  }
  
  /// Truncates text to specified length with ellipsis
  /// Example: truncateWithEllipsis("Long text here", 8) → "Long tex..."
  static String truncateWithEllipsis(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    if (maxLength <= ellipsis.length) return ellipsis;
    
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }
  
  /// Capitalizes the first letter of each word
  /// Example: "hello world" → "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Removes special characters while preserving spaces and alphanumeric
  /// Example: "Hello@#$% World!" → "Hello World"
  static String sanitizeText(String text, {bool preserveSpaces = true}) {
    if (text.isEmpty) return text;
    
    final pattern = preserveSpaces 
        ? RegExp(r'[^a-zA-Z0-9\s]') 
        : RegExp(r'[^a-zA-Z0-9]');
    
    return text.replaceAll(pattern, '').trim();
  }
  
  /// Extracts numbers from text as a list of strings
  /// Example: "Amount: $1,234.56 for order #789" → ["1", "234", "56", "789"]
  static List<String> extractNumbers(String text) {
    if (text.isEmpty) return [];
    
    final numberPattern = RegExp(r'\d+');
    return numberPattern.allMatches(text).map((match) => match.group(0)!).toList();
  }
  
  /// Checks if text contains only whitespace or is empty
  /// Returns true for "", "   ", "\t\n", etc.
  static bool isBlankOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  /// Safe substring that handles edge cases and null values
  /// Returns empty string if text is null or indices are invalid
  static String safeSubstring(String? text, int start, [int? end]) {
    if (text == null || text.isEmpty || start < 0 || start >= text.length) {
      return '';
    }
    
    final actualEnd = end ?? text.length;
    if (actualEnd < start || actualEnd < 0) {
      return '';
    }
    
    final safeEnd = actualEnd > text.length ? text.length : actualEnd;
    return text.substring(start, safeEnd);
  }
}

/// Extension methods for String to provide convenient text utilities
extension StringTextUtils on String {
  /// Removes trailing dates using TextUtils
  String get withoutTrailingDate => TextUtils.removeTrailingDate(this);
  
  /// Normalizes whitespace using TextUtils
  String get normalizedWhitespace => TextUtils.normalizeWhitespace(this);
  
  /// Converts to title case using TextUtils
  String get titleCase => TextUtils.toTitleCase(this);
  
  /// Checks if string is blank or empty using TextUtils
  bool get isBlankOrEmpty => TextUtils.isBlankOrEmpty(this);
  
  /// Truncates with ellipsis using TextUtils
  String truncate(int maxLength, {String ellipsis = '...'}) {
    return TextUtils.truncateWithEllipsis(this, maxLength, ellipsis: ellipsis);
  }
  
  /// Sanitizes text using TextUtils
  String sanitize({bool preserveSpaces = true}) {
    return TextUtils.sanitizeText(this, preserveSpaces: preserveSpaces);
  }
  
  /// Extracts numbers using TextUtils
  List<String> get extractedNumbers => TextUtils.extractNumbers(this);
}