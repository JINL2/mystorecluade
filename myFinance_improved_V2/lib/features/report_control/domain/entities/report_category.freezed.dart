// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportCategory {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String? get categoryIcon => throw _privateConstructorUsedError;
  int get templateCount => throw _privateConstructorUsedError;
  int get reportCount => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  DateTime? get latestReportDate => throw _privateConstructorUsedError;

  /// Create a copy of ReportCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCategoryCopyWith<ReportCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCategoryCopyWith<$Res> {
  factory $ReportCategoryCopyWith(
          ReportCategory value, $Res Function(ReportCategory) then) =
      _$ReportCategoryCopyWithImpl<$Res, ReportCategory>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      String? categoryIcon,
      int templateCount,
      int reportCount,
      int unreadCount,
      DateTime? latestReportDate});
}

/// @nodoc
class _$ReportCategoryCopyWithImpl<$Res, $Val extends ReportCategory>
    implements $ReportCategoryCopyWith<$Res> {
  _$ReportCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportCategory
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
abstract class _$$ReportCategoryImplCopyWith<$Res>
    implements $ReportCategoryCopyWith<$Res> {
  factory _$$ReportCategoryImplCopyWith(_$ReportCategoryImpl value,
          $Res Function(_$ReportCategoryImpl) then) =
      __$$ReportCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      String? categoryIcon,
      int templateCount,
      int reportCount,
      int unreadCount,
      DateTime? latestReportDate});
}

/// @nodoc
class __$$ReportCategoryImplCopyWithImpl<$Res>
    extends _$ReportCategoryCopyWithImpl<$Res, _$ReportCategoryImpl>
    implements _$$ReportCategoryImplCopyWith<$Res> {
  __$$ReportCategoryImplCopyWithImpl(
      _$ReportCategoryImpl _value, $Res Function(_$ReportCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportCategory
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
    return _then(_$ReportCategoryImpl(
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

class _$ReportCategoryImpl extends _ReportCategory {
  const _$ReportCategoryImpl(
      {required this.categoryId,
      required this.categoryName,
      this.categoryIcon,
      required this.templateCount,
      required this.reportCount,
      required this.unreadCount,
      this.latestReportDate})
      : super._();

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String? categoryIcon;
  @override
  final int templateCount;
  @override
  final int reportCount;
  @override
  final int unreadCount;
  @override
  final DateTime? latestReportDate;

  @override
  String toString() {
    return 'ReportCategory(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, templateCount: $templateCount, reportCount: $reportCount, unreadCount: $unreadCount, latestReportDate: $latestReportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportCategoryImpl &&
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

  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      categoryIcon, templateCount, reportCount, unreadCount, latestReportDate);

  /// Create a copy of ReportCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportCategoryImplCopyWith<_$ReportCategoryImpl> get copyWith =>
      __$$ReportCategoryImplCopyWithImpl<_$ReportCategoryImpl>(
          this, _$identity);
}

abstract class _ReportCategory extends ReportCategory {
  const factory _ReportCategory(
      {required final String categoryId,
      required final String categoryName,
      final String? categoryIcon,
      required final int templateCount,
      required final int reportCount,
      required final int unreadCount,
      final DateTime? latestReportDate}) = _$ReportCategoryImpl;
  const _ReportCategory._() : super._();

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String? get categoryIcon;
  @override
  int get templateCount;
  @override
  int get reportCount;
  @override
  int get unreadCount;
  @override
  DateTime? get latestReportDate;

  /// Create a copy of ReportCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportCategoryImplCopyWith<_$ReportCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
