import 'package:logger/logger.dart';

/// Homepage feature의 공통 Logger
///
/// 사용법:
/// ```dart
/// homepageLogger.d('Debug message');      // 🔵 Debug
/// homepageLogger.i('Info message');       // 💡 Info
/// homepageLogger.w('Warning message');    // ⚠️ Warning
/// homepageLogger.e('Error message');      // ❌ Error
/// ```
final homepageLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // 스택 트레이스 줄 수
    errorMethodCount: 5, // 에러 시 스택 트레이스
    lineLength: 80, // 한 줄 길이
    colors: true, // 콘솔 컬러
    printEmojis: true, // 이모지 출력
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 시간 포맷
  ),
  filter: DevelopmentFilter(), // Development 모드에서만 로그 출력
);
