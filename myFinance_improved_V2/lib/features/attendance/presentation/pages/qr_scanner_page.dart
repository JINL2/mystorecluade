import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/attendance_location.dart';
import '../providers/attendance_providers.dart';
import '../providers/monthly_attendance_providers.dart';
import '../providers/qr_scanner_state.dart';
import '../widgets/check_in_out/utils/attendance_helper_methods.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class QRScannerPage extends ConsumerStatefulWidget {
  const QRScannerPage({super.key});

  @override
  ConsumerState<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends ConsumerState<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    returnImage: false,
  );

  /// Auto-close timer reference (취소 가능하게 관리)
  Timer? _autoCloseTimer;

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showErrorDialog(
          'Location services are disabled. Please enable location services.',
        );
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _showErrorDialog(
            'Location permissions are denied. Please allow location access.',
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _showErrorDialog(
          'Location permissions are permanently denied. Please enable in settings.',
        );
        return null;
      }

      // Get current location
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      await _showErrorDialog('Error getting location: $e');
      return null;
    }
  }

  /// 에러 다이얼로그 표시 (안전한 버전)
  Future<void> _showErrorDialog(String message) async {
    final notifier = ref.read(qrScannerNotifierProvider.notifier);
    final state = ref.read(qrScannerNotifierProvider);

    // 이미 다이얼로그가 표시 중이면 무시
    if (state.isShowingDialog) return;

    notifier.showDialog();
    notifier.setError(message);

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () {
          // 안전하게 한 번만 닫기
          _safeDismissAndPop(dialogContext);
        },
        dismissible: false,
      ),
    );
  }

  /// 성공 다이얼로그 표시 (안전한 버전 - 이중 pop 방지)
  void _showSuccessDialog(String message, Map<String, dynamic> resultData) {
    final notifier = ref.read(qrScannerNotifierProvider.notifier);

    notifier.showDialog();
    notifier.setSuccess(resultData);

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => TossDialog.success(
        title: message,
        subtitle: DateTimeUtils.format(DateTime.now()),
        primaryButtonText: 'OK',
        onPrimaryPressed: () {
          // 타이머 취소 후 안전하게 닫기
          _autoCloseTimer?.cancel();
          _safeDismissAndPop(dialogContext, resultData: resultData);
        },
        dismissible: false,
      ),
    );

    // Auto close after 2 seconds (타이머로 관리하여 취소 가능)
    _autoCloseTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        // 안전하게 한 번만 닫기 시도
        _safeDismissAndPop(context, resultData: resultData);
      }
    });
  }

  /// Monthly 직원 체크인/체크아웃 처리
  Future<void> _processMonthlyCheckIn({
    required String storeId,
    required String companyId,
    required String userId,
  }) async {
    // 오늘 출석 상태 확인
    final todayAttendance = await ref.read(todayMonthlyAttendanceProvider.future);

    final notifier = ref.read(monthlyCheckNotifierProvider.notifier);

    if (todayAttendance?.status == 'checked_in') {
      // 이미 체크인했으면 체크아웃
      final result = await notifier.checkOut();

      if (mounted) {
        if (result.success) {
          // ✅ Provider invalidate (UI 즉시 업데이트)
          _invalidateMonthlyProviders();

          final message = result.isEarlyLeave
              ? 'Check-out Complete (Early Leave)'
              : 'Check-out Complete';

          _showSuccessDialog(message, {
            'success': true,
            'message': message,
            'action': 'check_out',
            'is_early_leave': result.isEarlyLeave,
          });
        } else {
          await _showErrorDialog(result.message ?? 'Check-out failed');
        }
      }
    } else if (todayAttendance?.status == 'completed') {
      // 이미 완료됨
      await _showErrorDialog('You have already completed attendance for today.');
    } else {
      // 체크인
      final result = await notifier.checkIn(storeId: storeId);

      if (mounted) {
        if (result.success) {
          // ✅ Provider invalidate (UI 즉시 업데이트)
          _invalidateMonthlyProviders();

          final message = result.isLate
              ? 'Check-in Complete (Late)'
              : 'Check-in Complete';

          _showSuccessDialog(message, {
            'success': true,
            'message': message,
            'action': 'check_in',
            'is_late': result.isLate,
          });
        } else {
          // 에러 메시지에 따라 처리
          String errorMessage = result.message ?? 'Check-in failed';

          // RPC 에러 코드에 따른 친절한 메시지
          if (result.error == 'NOT_WORKDAY') {
            errorMessage = 'Today is not a workday.\nCheck your schedule template.';
          } else if (result.error == 'NO_TEMPLATE') {
            errorMessage = 'No work schedule assigned.\nPlease contact your manager.';
          } else if (result.error == 'ALREADY_CHECKED_IN') {
            errorMessage = 'You have already checked in today.';
          }

          await _showErrorDialog(errorMessage);
        }
      }
    }
  }

  /// Monthly provider들 invalidate (UI 즉시 업데이트)
  void _invalidateMonthlyProviders() {
    final now = DateTime.now();
    final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    ref.invalidate(todayMonthlyAttendanceProvider);
    ref.invalidate(monthlyAttendanceStatsProvider(yearMonth));
    ref.invalidate(monthlyAttendanceListProvider(yearMonth));
  }

  /// 안전하게 다이얼로그와 페이지를 닫는 메서드 (이중 pop 방지)
  void _safeDismissAndPop(
    BuildContext dialogContext, {
    Map<String, dynamic>? resultData,
  }) {
    final notifier = ref.read(qrScannerNotifierProvider.notifier);

    // tryDismissDialog가 false를 반환하면 이미 닫힌 것이므로 무시
    if (!notifier.tryDismissDialog()) {
      return;
    }

    // 완료 상태로 마킹
    notifier.markCompleted();

    // Navigator 유효성 확인 후 pop
    if (!mounted) return;

    // Dialog 닫기
    if (Navigator.of(dialogContext, rootNavigator: true).canPop()) {
      Navigator.of(dialogContext, rootNavigator: true).pop();
    }

    // QR Scanner Page 닫기 (결과 데이터와 함께)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        context.pop(resultData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(qrScannerNotifierProvider);

    return TossScaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              // Riverpod 상태로 중복 스캔 방지
              final state = ref.read(qrScannerNotifierProvider);
              if (state.isProcessing || state.hasScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;

              final String? code = barcodes.first.rawValue;
              if (code == null || code.isEmpty) return;

              // 스캔 시작 상태로 변경
              ref.read(qrScannerNotifierProvider.notifier).startScanning();

              // Stop the camera to prevent further scans
              await cameraController.stop();

              // Haptic feedback
              HapticFeedback.mediumImpact();

              // Get current location
              final Position? position = await _getCurrentLocation();
              if (position == null) {
                // Error dialog already shown in _getCurrentLocation
                // User will be returned to attendance page
                return;
              }

              // Process attendance
              final authStateAsync = ref.read(authStateProvider);
              final user = authStateAsync.value;
              if (user == null) {
                await _showErrorDialog('User not authenticated');
                // User will be returned to attendance page
                return;
              }
              final userId = user.id;

              try {
                // QR code contains only the store_id (e.g., "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff")
                final storeId = code.trim();

                // Validate store ID format (UUID)
                final uuidRegex = RegExp(
                  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                );

                if (!uuidRegex.hasMatch(storeId)) {
                  throw Exception('Invalid store ID format');
                }

                // Get current date and time with user's device timezone
                final now = DateTime.now();
                // Use local time with timezone offset (e.g., "2024-11-15T10:30:25+09:00")
                final currentTime = DateTimeUtils.toLocalWithOffset(now);
                // Get user's device timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
                final timezone = DateTimeUtils.getLocalTimezone();

                // Get app state for company/store info
                final appState = ref.read(appStateProvider);
                final companyId = appState.companyChoosen;
                final currentStoreId = appState.storeChoosen;

                // ========================================
                // 급여 타입에 따라 분기
                // ========================================
                final salaryType = await ref.read(userSalaryTypeProvider.future);

                if (salaryType == 'monthly') {
                  // ========================================
                  // Monthly 직원 처리
                  // Monthly는 스케줄 템플릿 기반이므로 store 검증 불필요
                  // QR에서 읽은 storeId를 그대로 전달 (기록용)
                  // ========================================
                  await _processMonthlyCheckIn(
                    storeId: storeId,
                    companyId: companyId,
                    userId: userId,
                  );
                  return;
                }

                // ========================================
                // Hourly 직원 처리 (기존 로직)
                // Hourly는 shift_request 기반이므로 store 검증 필요
                // ========================================

                // 현재 앱에서 선택된 store와 QR store가 다르면 에러
                if (storeId != currentStoreId) {
                  throw Exception(
                    'Wrong store QR code.\n'
                    'Please scan the QR code for your current store.',
                  );
                }

                // Fetch shift cards for the scanned store (QR store_id)
                // QR 스캔한 store_id로 필터링 - update_shift_requests_v8과 일관성 유지
                final getUserShiftCards = ref.read(getUserShiftCardsProvider);
                final shiftCardsResult = await getUserShiftCards(
                  requestTime: currentTime,
                  userId: userId,
                  companyId: companyId,
                  storeId: storeId,  // QR에서 읽은 store_id 사용
                  timezone: timezone,
                );

                // Either pattern: handle failure or extract data
                final shiftCards = shiftCardsResult.fold(
                  (failure) => throw Exception(failure.message),
                  (data) => data,
                );

                // Find the closest shift's request ID
                final shiftRequestId = AttendanceHelpers.findClosestShiftRequestId(
                  shiftCards,
                  now: now,
                );

                if (shiftRequestId == null) {
                  throw Exception(
                    'No approved shift found for today.\n'
                    'Please check your schedule.',
                  );
                }

                // Submit attendance using check in use case
                final checkInShift = ref.read(checkInShiftProvider);
                final checkInResult = await checkInShift(
                  shiftRequestId: shiftRequestId,
                  userId: userId,
                  storeId: storeId,
                  timestamp: currentTime,
                  location: AttendanceLocation(
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
                  timezone: timezone,
                );

                // Either pattern: handle failure or extract data
                final result = checkInResult.fold(
                  (failure) => throw Exception(failure.message),
                  (data) => data,
                );

                // Check if the RPC call was successful
                if (!result.success) {
                  throw Exception(result.message ?? 'Failed to update shift request');
                }

                // Add a small delay for UX
                await Future<void>.delayed(const Duration(milliseconds: 100));

                // Show success popup
                if (mounted) {
                  // Determine message based on action
                  String message = result.isCheckIn
                      ? 'Check-in Successful'
                      : 'Check-out Successful';

                  // Prepare data to pass back to attendance page
                  final checkInOutData = <String, dynamic>{
                    'success': true,
                    'message': message,
                    'action': result.action,
                    'request_date': result.requestDate,
                    'timestamp': result.timestamp,
                    'shift_request_id': result.shiftRequestId,
                  };

                  // Show the success dialog with result data
                  _showSuccessDialog(message, checkInOutData);
                }
              } catch (e) {
                // Show error and return to attendance page
                await _showErrorDialog('Failed to process QR code: ${e.toString()}');
                // No need to reset state or restart camera - user will be back at attendance page
              }
            },
          ),

          // Scanner overlay
          Container(
            decoration: BoxDecoration(
              color: TossColors.black.withValues(alpha: 0.5),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: TossColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    ),
                  ),
                ),

                // Instructions
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      if (scannerState.isProcessing)
                        const TossLoadingView()
                      else
                        Text(
                          'Scan QR Code',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        scannerState.isProcessing
                            ? 'Processing...'
                            : 'Position the QR code within the frame',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mask with cutout
          ClipPath(
            clipper: _ScannerOverlayClipper(),
            child: Container(
              color: TossColors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for scanner overlay with cutout
class _ScannerOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;

    // Add outer rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate center cutout position
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const cutoutSize = 280.0;
    const borderRadius = 16.0;

    // Add rounded rectangle cutout
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: cutoutSize,
          height: cutoutSize,
        ),
        const Radius.circular(borderRadius),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
