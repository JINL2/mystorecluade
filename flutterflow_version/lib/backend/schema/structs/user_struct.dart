// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    String? userId,
    String? userFirstName,
    String? userLastName,
    int? companyCount,
    List<CompaniesStruct>? companies,
    String? profileImage,
  })  : _userId = userId,
        _userFirstName = userFirstName,
        _userLastName = userLastName,
        _companyCount = companyCount,
        _companies = companies,
        _profileImage = profileImage;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "user_first_name" field.
  String? _userFirstName;
  String get userFirstName => _userFirstName ?? '';
  set userFirstName(String? val) => _userFirstName = val;

  bool hasUserFirstName() => _userFirstName != null;

  // "user_last_name" field.
  String? _userLastName;
  String get userLastName => _userLastName ?? '';
  set userLastName(String? val) => _userLastName = val;

  bool hasUserLastName() => _userLastName != null;

  // "company_count" field.
  int? _companyCount;
  int get companyCount => _companyCount ?? 0;
  set companyCount(int? val) => _companyCount = val;

  void incrementCompanyCount(int amount) =>
      companyCount = companyCount + amount;

  bool hasCompanyCount() => _companyCount != null;

  // "companies" field.
  List<CompaniesStruct>? _companies;
  List<CompaniesStruct> get companies => _companies ?? const [];
  set companies(List<CompaniesStruct>? val) => _companies = val;

  void updateCompanies(Function(List<CompaniesStruct>) updateFn) {
    updateFn(_companies ??= []);
  }

  bool hasCompanies() => _companies != null;

  // "profile_image" field.
  String? _profileImage;
  String get profileImage => _profileImage ?? '';
  set profileImage(String? val) => _profileImage = val;

  bool hasProfileImage() => _profileImage != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        userId: data['user_id'] as String?,
        userFirstName: data['user_first_name'] as String?,
        userLastName: data['user_last_name'] as String?,
        companyCount: castToType<int>(data['company_count']),
        companies: getStructList(
          data['companies'],
          CompaniesStruct.fromMap,
        ),
        profileImage: data['profile_image'] as String?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'user_id': _userId,
        'user_first_name': _userFirstName,
        'user_last_name': _userLastName,
        'company_count': _companyCount,
        'companies': _companies?.map((e) => e.toMap()).toList(),
        'profile_image': _profileImage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'user_first_name': serializeParam(
          _userFirstName,
          ParamType.String,
        ),
        'user_last_name': serializeParam(
          _userLastName,
          ParamType.String,
        ),
        'company_count': serializeParam(
          _companyCount,
          ParamType.int,
        ),
        'companies': serializeParam(
          _companies,
          ParamType.DataStruct,
          isList: true,
        ),
        'profile_image': serializeParam(
          _profileImage,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        userFirstName: deserializeParam(
          data['user_first_name'],
          ParamType.String,
          false,
        ),
        userLastName: deserializeParam(
          data['user_last_name'],
          ParamType.String,
          false,
        ),
        companyCount: deserializeParam(
          data['company_count'],
          ParamType.int,
          false,
        ),
        companies: deserializeStructParam<CompaniesStruct>(
          data['companies'],
          ParamType.DataStruct,
          true,
          structBuilder: CompaniesStruct.fromSerializableMap,
        ),
        profileImage: deserializeParam(
          data['profile_image'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UserStruct &&
        userId == other.userId &&
        userFirstName == other.userFirstName &&
        userLastName == other.userLastName &&
        companyCount == other.companyCount &&
        listEquality.equals(companies, other.companies) &&
        profileImage == other.profileImage;
  }

  @override
  int get hashCode => const ListEquality().hash([
        userId,
        userFirstName,
        userLastName,
        companyCount,
        companies,
        profileImage
      ]);
}

UserStruct createUserStruct({
  String? userId,
  String? userFirstName,
  String? userLastName,
  int? companyCount,
  String? profileImage,
}) =>
    UserStruct(
      userId: userId,
      userFirstName: userFirstName,
      userLastName: userLastName,
      companyCount: companyCount,
      profileImage: profileImage,
    );
