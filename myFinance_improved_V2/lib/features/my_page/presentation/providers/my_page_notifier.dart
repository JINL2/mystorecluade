import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'states/my_page_state.dart';
import 'user_profile_providers.dart';

part 'my_page_notifier.g.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// My Page Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
@riverpod
class MyPageNotifier extends _$MyPageNotifier {
  late final UserProfileRepository _repository;

  @override
  MyPageState build() {
    _repository = ref.watch(userProfileRepositoryProvider);
    return const MyPageState();
  }

  /// 현재 사용자 ID 가져오기 (Auth Provider 통해)
  String? get _currentUserId => ref.read(currentUserIdProvider);

  /// 사용자 프로필 및 비즈니스 대시보드 로드 (직접 Repository 호출)
  Future<void> loadUserData(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Flutter 표준: Repository 직접 호출 (Controller 없음)
      final userProfile = await _repository.getUserProfile(userId);
      final businessDashboard = await _repository.getBusinessDashboard(userId);

      state = state.copyWith(
        isLoading: false,
        userProfile: userProfile,
        businessDashboard: businessDashboard,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 프로필 업데이트 (직접 Repository 호출)
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
  }) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Flutter 표준: Repository 직접 호출
      await _repository.updateUserProfile(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
      );

      // 프로필 재로드
      await loadUserData(userId);

      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 은행 계좌 정보 저장 (직접 Repository 호출)
  Future<bool> saveBankAccount({
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  }) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _repository.saveUserBankAccount(
        userId: userId,
        companyId: companyId,
        bankName: bankName,
        accountNumber: accountNumber,
        description: description,
      );

      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 은행 계좌 정보 조회
  Future<Map<String, dynamic>?> getBankAccount(String companyId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return null;

      return await _repository.getUserBankAccount(
        userId: userId,
        companyId: companyId,
      );
    } catch (e) {
      return null;
    }
  }

  /// 프로필 이미지 업로드 (직접 Repository 호출)
  Future<String?> uploadProfileImage(String filePath) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Flutter 표준: Repository 직접 호출
      final publicUrl = await _repository.uploadProfileImage(userId, filePath);

      state = state.copyWith(isUpdating: false);
      return publicUrl;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// 프로필 이미지 제거 (직접 Repository 호출)
  Future<bool> removeProfileImage() async {
    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Flutter 표준: Repository 직접 호출
      await _repository.removeProfileImage(userId);

      // 프로필 재로드
      await loadUserData(userId);

      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 초기화
  void reset() {
    state = const MyPageState();
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Profile Edit Notifier - 프로필 편집 전용 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
@riverpod
class ProfileEditNotifier extends _$ProfileEditNotifier {
  late final UserProfileRepository _repository;

  @override
  ProfileEditState build() {
    _repository = ref.watch(userProfileRepositoryProvider);
    return const ProfileEditState();
  }

  /// 편집 모드 시작
  void startEditing() {
    state = state.copyWith(isEditing: true);
  }

  /// 편집 모드 종료
  void stopEditing() {
    state = state.copyWith(isEditing: false, fieldErrors: {});
  }

  /// 프로필 저장
  Future<bool> saveProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      fieldErrors: {},
    );

    try {
      // Flutter 표준: Repository 직접 호출
      await _repository.updateUserProfile(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
      );

      state = state.copyWith(
        isSaving: false,
        isEditing: false,
        errorMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 은행 계좌 정보 저장
  Future<bool> saveBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _repository.saveUserBankAccount(
        userId: userId,
        companyId: companyId,
        bankName: bankName,
        accountNumber: accountNumber,
        description: description,
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 프로필 이미지 업로드
  Future<String?> uploadImage(String userId, String filePath) async {
    state = state.copyWith(isUploadingImage: true, errorMessage: null);

    try {
      // Flutter 표준: Repository 직접 호출
      final publicUrl = await _repository.uploadProfileImage(userId, filePath);

      state = state.copyWith(isUploadingImage: false);
      return publicUrl;
    } catch (e) {
      state = state.copyWith(
        isUploadingImage: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// 필드 에러 설정
  void setFieldError(String fieldName, String error) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors[fieldName] = error;
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 필드 에러 지우기
  void clearFieldError(String fieldName) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors.remove(fieldName);
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 모든 에러 지우기
  void clearError() {
    state = state.copyWith(errorMessage: null, fieldErrors: {});
  }

  /// 상태 초기화
  void reset() {
    state = const ProfileEditState();
  }
}
