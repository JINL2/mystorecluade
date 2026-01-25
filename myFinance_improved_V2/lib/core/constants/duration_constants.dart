/// Duration 상수 정의
///
/// SnackBar, 애니메이션 등에서 사용되는 Duration 값을 중앙 관리
/// 하드코딩된 Duration 값 대신 이 상수를 사용할 것
class DurationConstants {
  DurationConstants._();

  // ==================== SNACKBAR DURATIONS ====================

  /// 로딩 상태 SnackBar - 장시간 표시 (작업 완료 시 수동으로 닫음)
  static const snackBarLoading = Duration(seconds: 30);

  /// 에러 SnackBar - 사용자가 읽을 수 있도록 충분한 시간
  static const snackBarError = Duration(seconds: 4);

  /// 성공 SnackBar - 간단한 확인 메시지
  static const snackBarSuccess = Duration(seconds: 3);

  /// 정보 SnackBar - 일반 알림
  static const snackBarInfo = Duration(seconds: 3);

  // ==================== ANIMATION DURATIONS ====================

  /// 빠른 애니메이션 (버튼 피드백, 작은 전환)
  static const animationFast = Duration(milliseconds: 150);

  /// 일반 애니메이션 (대부분의 UI 전환)
  static const animationNormal = Duration(milliseconds: 300);

  /// 느린 애니메이션 (복잡한 전환, 모달)
  static const animationSlow = Duration(milliseconds: 500);

  // ==================== DEBOUNCE / THROTTLE ====================

  /// 검색 입력 디바운스
  static const debounceSearch = Duration(milliseconds: 300);

  /// 버튼 클릭 쓰로틀
  static const throttleButton = Duration(milliseconds: 500);

  // ==================== TIMEOUT DURATIONS ====================

  /// API 요청 타임아웃
  static const apiTimeout = Duration(seconds: 30);

  /// 캐시 만료 시간 (짧은)
  static const cacheShort = Duration(minutes: 5);

  /// 캐시 만료 시간 (일반)
  static const cacheNormal = Duration(hours: 1);
}
