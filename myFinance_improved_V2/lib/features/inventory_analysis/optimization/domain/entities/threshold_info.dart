import 'package:freezed_annotation/freezed_annotation.dart';

part 'threshold_info.freezed.dart';

/// 임계값 정보 Entity
/// P10/P25 자동 계산 또는 기본값
@freezed
class ThresholdInfo with _$ThresholdInfo {
  const ThresholdInfo._();

  const factory ThresholdInfo({
    /// 긴급 임계값 (P10 일수)
    required double criticalDays,

    /// 주의 임계값 (P25 일수)
    required double warningDays,

    /// 임계값 소스 ('calculated' 또는 'default')
    required String source,

    /// 샘플 크기 (통계 계산에 사용된 상품 수)
    required int sampleSize,
  }) = _ThresholdInfo;

  /// 통계 계산으로 산출되었는지
  bool get isCalculated => source == 'calculated';

  /// 기본값 사용 중인지
  bool get isDefault => source == 'default';

  /// 샘플이 충분한지 (30개 이상)
  bool get hasSufficientSamples => sampleSize >= 30;

  /// 표시용 텍스트 (한글)
  String get sourceText => isCalculated ? '통계 계산' : '기본값';

  /// 표시용 텍스트 (영문)
  String get sourceTextEn => isCalculated ? 'Calculated' : 'Default';

  /// Mock 데이터 (스켈레톤용)
  static ThresholdInfo mock() => const ThresholdInfo(
        criticalDays: 7.0,
        warningDays: 14.0,
        source: 'default',
        sampleSize: 0,
      );
}
