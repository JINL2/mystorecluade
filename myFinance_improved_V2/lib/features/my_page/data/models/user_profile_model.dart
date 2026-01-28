import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/user_profile.dart';

/// Bank account model for user profile
class BankAccountModel {
  final String companyId;
  final String? bankName;
  final String? accountNumber;
  final String? description;

  const BankAccountModel({
    required this.companyId,
    this.bankName,
    this.accountNumber,
    this.description,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      companyId: json['company_id']?.toString() ?? '',
      bankName: json['user_bank_name']?.toString(),
      accountNumber: json['user_account_number']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'user_bank_name': bankName,
      'user_account_number': accountNumber,
      'description': description,
    };
  }

  BankAccount toEntity() {
    return BankAccount(
      companyId: companyId,
      bankName: bankName,
      accountNumber: accountNumber,
      description: description,
    );
  }
}

/// Language model for user profile
class LanguageModel {
  final String languageId;
  final String languageCode;
  final String languageName;

  const LanguageModel({
    required this.languageId,
    required this.languageCode,
    required this.languageName,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      languageId: json['language_id']?.toString() ?? '',
      languageCode: json['language_code']?.toString() ?? '',
      languageName: json['language_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_id': languageId,
      'language_code': languageCode,
      'language_name': languageName,
    };
  }

  Language toEntity() {
    return Language(
      languageId: languageId,
      languageCode: languageCode,
      languageName: languageName,
    );
  }
}

/// User profile model - maps RPC response to domain entity
class UserProfileModel {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BankAccountModel> bankAccounts;
  final LanguageModel? language;
  final List<LanguageModel> availableLanguages;

  const UserProfileModel({
    required this.userId,
    this.firstName,
    this.lastName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.bankAccounts = const [],
    this.language,
    this.availableLanguages = const [],
  });

  /// Parse from RPC response (my_page_get_user_profile)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse bank accounts array
    final bankAccountsJson = json['bank_accounts'];
    final bankAccounts = <BankAccountModel>[];
    if (bankAccountsJson != null && bankAccountsJson is List) {
      for (final item in bankAccountsJson) {
        if (item is Map<String, dynamic>) {
          bankAccounts.add(BankAccountModel.fromJson(item));
        }
      }
    }

    // Parse current language
    LanguageModel? language;
    final languageJson = json['language'];
    if (languageJson != null && languageJson is Map<String, dynamic>) {
      language = LanguageModel.fromJson(languageJson);
    }

    // Parse available languages
    final availableLanguagesJson = json['available_languages'];
    final availableLanguages = <LanguageModel>[];
    if (availableLanguagesJson != null && availableLanguagesJson is List) {
      for (final item in availableLanguagesJson) {
        if (item is Map<String, dynamic>) {
          availableLanguages.add(LanguageModel.fromJson(item));
        }
      }
    }

    return UserProfileModel(
      userId: json['user_id']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString() ?? '',
      phoneNumber: json['user_phone_number']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      profileImage: json['profile_image']?.toString(),
      createdAt: DateTimeUtils.toLocalSafe(json['created_at'] as String?),
      updatedAt: DateTimeUtils.toLocalSafe(json['updated_at'] as String?),
      bankAccounts: bankAccounts,
      language: language,
      availableLanguages: availableLanguages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'profile_image': profileImage,
      'created_at': createdAt != null ? DateTimeUtils.toUtc(createdAt!) : null,
      'updated_at': updatedAt != null ? DateTimeUtils.toUtc(updatedAt!) : null,
      'bank_accounts': bankAccounts.map((e) => e.toJson()).toList(),
      'language': language?.toJson(),
      'available_languages': availableLanguages.map((e) => e.toJson()).toList(),
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
      bankAccounts: bankAccounts.map((e) => e.toEntity()).toList(),
      language: language?.toEntity(),
      availableLanguages: availableLanguages.map((e) => e.toEntity()).toList(),
    );
  }

  /// Get bank account for specific company
  BankAccountModel? getBankAccountForCompany(String companyId) {
    try {
      return bankAccounts.firstWhere((b) => b.companyId == companyId);
    } catch (_) {
      return null;
    }
  }
}
