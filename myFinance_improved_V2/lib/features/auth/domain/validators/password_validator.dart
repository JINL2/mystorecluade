// lib/features/auth/domain/validators/password_validator.dart

/// Password strength levels
enum PasswordStrength {
  weak(0, 'Weak'),
  fair(1, 'Fair'),
  good(2, 'Good'),
  strong(3, 'Strong'),
  veryStrong(4, 'Very Strong');

  final int value;
  final String label;

  const PasswordStrength(this.value, this.label);
}

/// Password validation result with detailed feedback
class PasswordValidationResult {
  final bool isValid;
  final List<String> errors;
  final PasswordStrength strength;
  final List<String> suggestions;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
    required this.strength,
    required this.suggestions,
  });

  factory PasswordValidationResult.valid(PasswordStrength strength) {
    return PasswordValidationResult(
      isValid: true,
      errors: const [],
      strength: strength,
      suggestions: const [],
    );
  }

  factory PasswordValidationResult.invalid({
    required List<String> errors,
    required PasswordStrength strength,
    List<String>? suggestions,
  }) {
    return PasswordValidationResult(
      isValid: false,
      errors: errors,
      strength: strength,
      suggestions: suggestions ?? [],
    );
  }

  String get firstError => errors.isNotEmpty ? errors.first : '';
  String get allErrors => errors.join(', ');

  @override
  String toString() {
    if (isValid) return 'Valid (Strength: ${strength.label})';
    return 'Invalid: ${errors.join(', ')} (Strength: ${strength.label})';
  }
}

/// Password validator with strength calculation
class PasswordValidator {
  static const int minLength = 6; // Lowered for testing
  static const int strongLength = 12;
  static const int maxLength = 128; // Prevent extremely long passwords

  /// Calculate password strength (0-4)
  ///
  /// Strength is determined by:
  /// - Length >= 12: +1
  /// - Has uppercase: +1
  /// - Has lowercase: +1
  /// - Has numbers: +1
  /// - Has special chars: +1
  static PasswordStrength calculateStrength(String password) {
    int score = 0;

    // Length check
    if (password.length >= strongLength) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return PasswordStrength.values[score];
  }

  /// Comprehensive password validation
  ///
  /// Returns [PasswordValidationResult] with detailed feedback.
  static PasswordValidationResult validate(String password) {
    final errors = <String>[];
    final suggestions = <String>[];

    // Empty check
    if (password.isEmpty) {
      return PasswordValidationResult.invalid(
        errors: ['Password is required'],
        strength: PasswordStrength.weak,
      );
    }

    // Length validation
    if (password.length < minLength) {
      errors.add('Password must be at least $minLength characters');
    }

    if (password.length > maxLength) {
      errors.add('Password must be less than $maxLength characters');
    }

    // Character requirements (suggestions, not hard errors)
    if (!password.contains(RegExp(r'[A-Z]'))) {
      suggestions.add('Add uppercase letters for stronger security');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      suggestions.add('Add lowercase letters');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      suggestions.add('Add numbers');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      suggestions.add('Add special characters (!@#\$%^&*)');
    }

    // Check for common weak patterns (DISABLED FOR TESTING)
    // if (_isCommonPassword(password)) {
    //   errors.add('This password is too common. Please choose a stronger password.');
    // }

    if (_hasRepeatingCharacters(password)) {
      suggestions.add('Avoid repeating characters');
    }

    if (_hasSequentialCharacters(password)) {
      suggestions.add('Avoid sequential characters (e.g., 123, abc)');
    }

    // Calculate strength
    final strength = calculateStrength(password);

    // If minimum requirements are met, it's valid
    if (errors.isEmpty) {
      return PasswordValidationResult.valid(strength);
    } else {
      return PasswordValidationResult.invalid(
        errors: errors,
        strength: strength,
        suggestions: suggestions,
      );
    }
  }

  /// Validate password match (for confirmation field)
  static String? validateMatch(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null; // Valid
  }

  /// Check if password is in common password list
  ///
  /// NOTE: Currently not used, but kept for future enhancement
  // ignore: unused_element
  static bool _isCommonPassword(String password) {
    // List of most common passwords
    const commonPasswords = [
      'password',
      '12345678',
      'password123',
      'qwerty',
      'abc123',
      'password1',
      '12345',
      '1234567890',
    ];

    final lower = password.toLowerCase();
    return commonPasswords.contains(lower);
  }

  /// Check if password has repeating characters (e.g., "aaaa", "1111")
  static bool _hasRepeatingCharacters(String password) {
    if (password.length < 4) return false;

    for (int i = 0; i <= password.length - 4; i++) {
      final char = password[i];
      if (password[i + 1] == char &&
          password[i + 2] == char &&
          password[i + 3] == char) {
        return true;
      }
    }
    return false;
  }

  /// Check if password has sequential characters (e.g., "1234", "abcd")
  static bool _hasSequentialCharacters(String password) {
    if (password.length < 4) return false;

    for (int i = 0; i <= password.length - 4; i++) {
      final char1 = password.codeUnitAt(i);
      final char2 = password.codeUnitAt(i + 1);
      final char3 = password.codeUnitAt(i + 2);
      final char4 = password.codeUnitAt(i + 3);

      if (char2 == char1 + 1 && char3 == char2 + 1 && char4 == char3 + 1) {
        return true; // Ascending sequence
      }
      if (char2 == char1 - 1 && char3 == char2 - 1 && char4 == char3 - 1) {
        return true; // Descending sequence
      }
    }
    return false;
  }
}
