import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Bank account entity
@freezed
class BankAccount with _$BankAccount {
  const factory BankAccount({
    required String companyId,
    String? bankName,
    String? accountNumber,
    String? description,
  }) = _BankAccount;
}

/// Language entity
@freezed
class Language with _$Language {
  const factory Language({
    required String languageId,
    required String languageCode,
    required String languageName,
  }) = _Language;
}

/// User profile entity
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    required String email,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<BankAccount> bankAccounts,
    Language? language,
    @Default([]) List<Language> availableLanguages,
  }) = _UserProfile;

  const UserProfile._();

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim().isEmpty ? email : '$first $last'.trim();
  }

  String get initials {
    if (firstName != null && firstName!.isNotEmpty && lastName != null && lastName!.isNotEmpty) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    } else {
      return email[0].toUpperCase();
    }
  }

  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  String? get languageCode => language?.languageCode;

  String? get languageId => language?.languageId;

  /// Get bank account for specific company
  BankAccount? getBankAccountForCompany(String companyId) {
    try {
      return bankAccounts.firstWhere((b) => b.companyId == companyId);
    } catch (_) {
      return null;
    }
  }
}
