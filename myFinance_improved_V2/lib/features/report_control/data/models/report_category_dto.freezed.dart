// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportCategoryDto _$ReportCategoryDtoFromJson(Map<String, dynamic> json) {
  return _ReportCategoryDto.fromJson(json);
}

/// @nodoc
mixin _$ReportCategoryDto {
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_icon')
  String? get categoryIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_count')
  int get templateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_count')
  int get reportCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_report_date')
  DateTime? get latestReportDate => throw _privateConstructorUsedError;

  /// Serializes this ReportCategoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCategoryDtoCopyWith<ReportCategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCategoryDtoCopyWith<$Res> {
  factory $ReportCategoryDtoCopyWith(
          ReportCategoryDto value, $Res Function(ReportCategoryDto) then) =
      _$ReportCategoryDtoCopyWithImpl<$Res, ReportCategoryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'category_icon') String? categoryIcon,
      @JsonKey(name: 'template_count') int templateCount,
      @JsonKey(name: 'report_count') int reportCount,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'latest_report_date') DateTime? latestReportDate});
}

/// @nodoc
class _$ReportCategoryDtoCopyWithImpl<$Res, $Val extends ReportCategoryDto>
    implements $ReportCategoryDtoCopyWith<$Res> {
  _$ReportCategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? templateCount = null,
    Object? reportCount = null,
    Object? unreadCount = null,
    Object? latestReportDate = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: freezed == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateCount: null == templateCount
          ? _value.templateCount
          : templateCount // ignore: cast_nullable_to_non_nullable
              as int,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      latestReportDate: freezed == latestReportDate
          ? _value.latestReportDate
          : latestReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportCategoryDtoImplCopyWith<$Res>
    implements $ReportCategoryDtoCopyWith<$Res> {
  factory _$$ReportCategoryDtoImplCopyWith(_$ReportCategoryDtoImpl value,
          $Res Function(_$ReportCategoryDtoImpl) then) =
      __$$ReportCategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'category_icon') String? categoryIcon,
      @JsonKey(name: 'template_count') int templateCount,
      @JsonKey(name: 'report_count') int reportCount,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'latest_report_date') DateTime? latestReportDate});
}

/// @nodoc
class __$$ReportCategoryDtoImplCopyWithImpl<$Res>
    extends _$ReportCategoryDtoCopyWithImpl<$Res, _$ReportCategoryDtoImpl>
    implements _$$ReportCategoryDtoImplCopyWith<$Res> {
  __$$ReportCategoryDtoImplCopyWithImpl(_$ReportCategoryDtoImpl _value,
      $Res Function(_$ReportCategoryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? templateCount = null,
    Object? reportCount = null,
    Object? unreadCount = null,
    Object? latestReportDate = freezed,
  }) {
    return _then(_$ReportCategoryDtoImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: freezed == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateCount: null == templateCount
          ? _value.templateCount
          : templateCount // ignore: cast_nullable_to_non_nullable
              as int,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      latestReportDate: freezed == latestReportDate
          ? _value.latestReportDate
          : latestReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportCategoryDtoImpl extends _ReportCategoryDto {
  const _$ReportCategoryDtoImpl(
      {@JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'category_name') required this.categoryName,
      @JsonKey(name: 'category_icon') this.categoryIcon,
      @JsonKey(name: 'template_count') required this.templateCount,
      @JsonKey(name: 'report_count') required this.reportCount,
      @JsonKey(name: 'unread_count') required this.unreadCount,
      @JsonKey(name: 'latest_report_date') this.latestReportDate})
      : super._();

  factory _$ReportCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportCategoryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'category_icon')
  final String? categoryIcon;
  @override
  @JsonKey(name: 'template_count')
  final int templateCount;
  @override
  @JsonKey(name: 'report_count')
  final int reportCount;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'latest_report_date')
  final DateTime? latestReportDate;

  @override
  String toString() {
    return 'ReportCategoryDto(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, templateCount: $templateCount, reportCount: $reportCount, unreadCount: $unreadCount, latestReportDate: $latestReportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportCategoryDtoImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.templateCount, templateCount) ||
                other.templateCount == templateCount) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.latestReportDate, latestReportDate) ||
                other.latestReportDate == latestReportDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      categoryIcon, templateCount, reportCount, unreadCount, latestReportDate);

  /// Create a copy of ReportCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportCategoryDtoImplCopyWith<_$ReportCategoryDtoImpl> get copyWith =>
      __$$ReportCategoryDtoImplCopyWithImpl<_$ReportCategoryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportCategoryDtoImplToJson(
      this,
    );
  }
}

abstract class _ReportCategoryDto extends ReportCategoryDto {
  const factory _ReportCategoryDto(
      {@JsonKey(name: 'category_id') required final String categoryId,
      @JsonKey(name: 'category_name') required final String categoryName,
      @JsonKey(name: 'category_icon') final String? categoryIcon,
      @JsonKey(name: 'template_count') required final int templateCount,
      @JsonKey(name: 'report_count') required final int reportCount,
      @JsonKey(name: 'unread_count') required final int unreadCount,
      @JsonKey(name: 'latest_report_date')
      final DateTime? latestReportDate}) = _$ReportCategoryDtoImpl;
  const _ReportCategoryDto._() : super._();

  factory _ReportCategoryDto.fromJson(Map<String, dynamic> json) =
      _$ReportCategoryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'category_icon')
  String? get categoryIcon;
  @override
  @JsonKey(name: 'template_count')
  int get templateCount;
  @override
  @JsonKey(name: 'report_count')
  int get reportCount;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'latest_report_date')
  DateTime? get latestReportDate;

  /// Create a copy of ReportCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportCategoryDtoImplCopyWith<_$ReportCategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
