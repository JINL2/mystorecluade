import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bank_account.freezed.dart';
part 'user_bank_account.g.dart';

@freezed
class UserBankAccount with _$UserBankAccount {
  const factory UserBankAccount({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'user_bank_name') String? userBankName,
    @JsonKey(name: 'user_account_number') String? userAccountNumber,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserBankAccount;

  factory UserBankAccount.fromJson(Map<String, dynamic> json) =>
      _$UserBankAccountFromJson(json);
      
  const UserBankAccount._();
  
  bool get hasBankInfo => userBankName != null && 
                          userBankName!.isNotEmpty && 
                          userAccountNumber != null && 
                          userAccountNumber!.isNotEmpty;
  
  String get displayBankName => userBankName ?? '';
  
  String get displayAccountNumber => userAccountNumber ?? '';
  
  String get displayDescription => description ?? '';
}