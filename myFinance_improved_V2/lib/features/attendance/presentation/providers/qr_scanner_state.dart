import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_scanner_state.freezed.dart';
part 'qr_scanner_state.g.dart';

/// QR Scanner 상태를 안전하게 관리하는 Freezed State
@freezed
class QrScannerState with _$QrScannerState {
  const factory QrScannerState({
    /// 현재 스캔 처리 중인지 여부
    @Default(false) bool isProcessing,

    /// 이미 스캔이 완료되었는지 여부 (중복 스캔 방지)
    @Default(false) bool hasScanned,

    /// 다이얼로그가 현재 표시 중인지 여부
    @Default(false) bool isShowingDialog,

    /// 다이얼로그가 이미 닫혔는지 여부 (이중 pop 방지)
    @Default(false) bool dialogDismissed,

    /// 에러 메시지 (있을 경우)
    String? errorMessage,

    /// 성공 결과 데이터
    Map<String, dynamic>? successResult,

    /// 스캔 결과 상태
    @Default(QrScanResult.idle) QrScanResult scanResult,
  }) = _QrScannerState;
}

/// QR 스캔 결과 상태
enum QrScanResult {
  /// 대기 상태
  idle,

  /// 처리 중
  processing,

  /// 성공
  success,

  /// 에러
  error,

  /// 완료 (화면 닫기 준비)
  completed,
}

/// QR Scanner 상태를 관리하는 Notifier (@riverpod)
@riverpod
class QrScannerNotifier extends _$QrScannerNotifier {
  @override
  QrScannerState build() => const QrScannerState();

  /// 스캔 시작
  void startScanning() {
    if (state.isProcessing || state.hasScanned) return;

    state = state.copyWith(
      isProcessing: true,
      hasScanned: true,
      scanResult: QrScanResult.processing,
    );
  }

  /// 다이얼로그 표시 시작
  void showDialog() {
    state = state.copyWith(
      isShowingDialog: true,
      dialogDismissed: false,
    );
  }

  /// 다이얼로그 닫힘 처리 (한 번만 실행되도록 보장)
  /// Returns: true if this is the first dismiss call, false if already dismissed
  bool tryDismissDialog() {
    if (state.dialogDismissed) {
      // 이미 닫혔으면 false 반환 (이중 pop 방지)
      return false;
    }

    state = state.copyWith(
      isShowingDialog: false,
      dialogDismissed: true,
    );
    return true;
  }

  /// 성공 처리
  void setSuccess(Map<String, dynamic> resultData) {
    state = state.copyWith(
      isProcessing: false,
      scanResult: QrScanResult.success,
      successResult: resultData,
    );
  }

  /// 에러 처리
  void setError(String message) {
    state = state.copyWith(
      isProcessing: false,
      scanResult: QrScanResult.error,
      errorMessage: message,
    );
  }

  /// 완료 상태로 전환 (화면 닫기 준비)
  void markCompleted() {
    state = state.copyWith(
      scanResult: QrScanResult.completed,
    );
  }

  /// 상태 초기화
  void reset() {
    state = const QrScannerState();
  }

  /// 다이얼로그만 초기화 (에러 후 재시도용)
  void resetDialog() {
    state = state.copyWith(
      isShowingDialog: false,
      dialogDismissed: false,
      errorMessage: null,
    );
  }
}
