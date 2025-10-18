/// Tag validation utility for role tags functionality
/// Provides validation rules and error handling for role tags
class TagValidator {
  // Tag constraints following Toss design guidelines
  static const int MAX_TAGS = 5;
  static const int MAX_TAG_LENGTH = 20;
  static const int MIN_TAG_LENGTH = 2;
  
  // Forbidden characters in tags
  static const Set<String> _forbiddenChars = {',', '"', "'", ';', ':', '\\', '/', '<', '>', '{', '}', '[', ']'};
  
  /// Validates a single tag
  /// Returns null if valid, error message if invalid
  static String? validateTag(String tag) {
    final trimmedTag = tag.trim();
    
    if (trimmedTag.isEmpty) {
      return 'Tag cannot be empty';
    }
    
    if (trimmedTag.length < MIN_TAG_LENGTH) {
      return 'Tag must be at least $MIN_TAG_LENGTH characters';
    }
    
    if (trimmedTag.length > MAX_TAG_LENGTH) {
      return 'Tag cannot exceed $MAX_TAG_LENGTH characters';
    }
    
    // Check for forbidden characters
    for (final char in _forbiddenChars) {
      if (trimmedTag.contains(char)) {
        return 'Tag cannot contain: $char';
      }
    }
    
    // Check for only whitespace
    if (trimmedTag.trim().isEmpty) {
      return 'Tag cannot contain only whitespace';
    }
    
    // Check for leading/trailing whitespace
    if (trimmedTag != tag) {
      return 'Tag cannot have leading or trailing spaces';
    }
    
    return null;
  }
  
  /// Validates a list of tags
  /// Returns validation result with errors and warnings
  static TagValidationResult validateTags(List<String> tags) {
    final errors = <String>[];
    final warnings = <String>[];
    final duplicates = <String>[];
    final seen = <String>{};
    
    // Check overall tag count
    if (tags.length > MAX_TAGS) {
      errors.add('Cannot have more than $MAX_TAGS tags');
    }
    
    // Validate each tag
    for (int i = 0; i < tags.length; i++) {
      final tag = tags[i];
      final normalizedTag = tag.toLowerCase().trim();
      
      // Check for duplicates (case-insensitive)
      if (seen.contains(normalizedTag)) {
        duplicates.add(tag);
        continue;
      }
      seen.add(normalizedTag);
      
      // Validate individual tag
      final tagError = validateTag(tag);
      if (tagError != null) {
        errors.add('Tag ${i + 1}: $tagError');
      }
      
      // Add warnings for long tags (approaching limit)
      if (tag.length > MAX_TAG_LENGTH * 0.8) {
        warnings.add('Tag "$tag" is getting long (${tag.length}/$MAX_TAG_LENGTH chars)');
      }
    }
    
    // Add duplicate errors
    if (duplicates.isNotEmpty) {
      errors.add('Duplicate tags found: ${duplicates.join(', ')}');
    }
    
    return TagValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      duplicates: duplicates,
    );
  }
  
  /// Quick validation check for a single tag
  /// Returns true if valid, false otherwise
  static bool isValid(String tag) {
    return validateTag(tag) == null;
  }
  
  /// Sanitizes a tag by removing forbidden characters and trimming
  /// Returns sanitized tag or null if it becomes invalid
  static String? sanitizeTag(String tag) {
    String sanitized = tag.trim();
    
    // Remove forbidden characters
    for (final char in _forbiddenChars) {
      sanitized = sanitized.replaceAll(char, '');
    }
    
    // Trim again after character removal
    sanitized = sanitized.trim();
    
    // Check if still valid after sanitization
    if (sanitized.isEmpty || sanitized.length < MIN_TAG_LENGTH) {
      return null;
    }
    
    // Truncate if too long
    if (sanitized.length > MAX_TAG_LENGTH) {
      sanitized = sanitized.substring(0, MAX_TAG_LENGTH).trim();
    }
    
    return isValid(sanitized) ? sanitized : null;
  }
  
  /// Gets suggested tags that are valid and not already selected
  static List<String> getValidSuggestions(
    List<String> suggestions, 
    List<String> currentTags
  ) {
    final currentNormalized = currentTags.map((tag) => tag.toLowerCase()).toSet();
    
    return suggestions
        .where((suggestion) => 
            isValid(suggestion) && 
            !currentNormalized.contains(suggestion.toLowerCase()) &&
            currentTags.length < MAX_TAGS)
        .take(8) // Limit suggestions to prevent UI overflow
        .toList();
  }
}

/// Result of tag validation containing errors and warnings
class TagValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> duplicates;
  
  const TagValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.duplicates,
  });
  
  /// Returns true if there are any issues (errors or warnings)
  bool get hasIssues => errors.isNotEmpty || warnings.isNotEmpty;
  
  /// Returns the first error message, or null if no errors
  String? get firstError => errors.isEmpty ? null : errors.first;
  
  /// Returns a formatted summary of all issues
  String get summary {
    final issues = <String>[];
    if (errors.isNotEmpty) {
      issues.addAll(errors);
    }
    if (warnings.isNotEmpty) {
      issues.addAll(warnings);
    }
    return issues.join('\n');
  }
  
  /// Creates a copy with additional errors
  TagValidationResult copyWith({
    bool? isValid,
    List<String>? errors,
    List<String>? warnings,
    List<String>? duplicates,
  }) {
    return TagValidationResult(
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
      duplicates: duplicates ?? this.duplicates,
    );
  }
  
  @override
  String toString() {
    return 'TagValidationResult(isValid: $isValid, errors: ${errors.length}, warnings: ${warnings.length})';
  }
}

/// Extension to provide validation methods for List<String>
extension TagListValidation on List<String> {
  /// Validates this list of tags
  TagValidationResult validate() => TagValidator.validateTags(this);
  
  /// Returns true if all tags in this list are valid
  bool get areValid => TagValidator.validateTags(this).isValid;
  
  /// Returns a new list with only valid tags
  List<String> get validOnly => where((tag) => TagValidator.isValid(tag)).toList();
  
  /// Returns a new list with sanitized tags (null entries removed)
  List<String> get sanitized => 
      map((tag) => TagValidator.sanitizeTag(tag))
          .where((tag) => tag != null)
          .cast<String>()
          .toList();
}