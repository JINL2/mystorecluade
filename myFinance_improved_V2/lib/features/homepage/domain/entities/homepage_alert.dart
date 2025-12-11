import 'package:freezed_annotation/freezed_annotation.dart';

part 'homepage_alert.freezed.dart';

/// Homepage Alert domain entity
///
/// Represents an alert/notification to display on the homepage.
/// Used to show important announcements like maintenance notices.
@freezed
class HomepageAlert with _$HomepageAlert {
  const HomepageAlert._();

  const factory HomepageAlert({
    @Default(false) bool isShow,
    @Default(false) bool isChecked,
    String? content,
  }) = _HomepageAlert;

  /// Check if alert should be displayed (show if not checked by user)
  bool get shouldDisplay => isShow && !isChecked && content != null && content!.isNotEmpty;
}
