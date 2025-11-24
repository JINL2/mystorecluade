// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportState {
// Received reports tab data
  List<ReportNotification> get receivedReports =>
      throw _privateConstructorUsedError;
  bool get isLoadingReceivedReports => throw _privateConstructorUsedError;
  String? get receivedReportsError =>
      throw _privateConstructorUsedError; // Available templates tab data
  List<TemplateWithSubscription> get availableTemplates =>
      throw _privateConstructorUsedError;
  bool get isLoadingTemplates => throw _privateConstructorUsedError;
  String? get templatesError =>
      throw _privateConstructorUsedError; // Categories data
  List<ReportCategory> get categories => throw _privateConstructorUsedError;
  bool get isLoadingCategories => throw _privateConstructorUsedError;
  String? get categoriesError =>
      throw _privateConstructorUsedError; // Selected tab index
  int get selectedTabIndex =>
      throw _privateConstructorUsedError; // Filters for received reports
  String? get categoryFilter =>
      throw _privateConstructorUsedError; // Filter by category_id
  String? get templateFilter =>
      throw _privateConstructorUsedError; // Filter by template_id
  bool get showUnreadOnly => throw _privateConstructorUsedError;
  DateTime? get startDate =>
      throw _privateConstructorUsedError; // Date range filter start
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of ReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportStateCopyWith<ReportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportStateCopyWith<$Res> {
  factory $ReportStateCopyWith(
          ReportState value, $Res Function(ReportState) then) =
      _$ReportStateCopyWithImpl<$Res, ReportState>;
  @useResult
  $Res call(
      {List<ReportNotification> receivedReports,
      bool isLoadingReceivedReports,
      String? receivedReportsError,
      List<TemplateWithSubscription> availableTemplates,
      bool isLoadingTemplates,
      String? templatesError,
      List<ReportCategory> categories,
      bool isLoadingCategories,
      String? categoriesError,
      int selectedTabIndex,
      String? categoryFilter,
      String? templateFilter,
      bool showUnreadOnly,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class _$ReportStateCopyWithImpl<$Res, $Val extends ReportState>
    implements $ReportStateCopyWith<$Res> {
  _$ReportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receivedReports = null,
    Object? isLoadingReceivedReports = null,
    Object? receivedReportsError = freezed,
    Object? availableTemplates = null,
    Object? isLoadingTemplates = null,
    Object? templatesError = freezed,
    Object? categories = null,
    Object? isLoadingCategories = null,
    Object? categoriesError = freezed,
    Object? selectedTabIndex = null,
    Object? categoryFilter = freezed,
    Object? templateFilter = freezed,
    Object? showUnreadOnly = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_value.copyWith(
      receivedReports: null == receivedReports
          ? _value.receivedReports
          : receivedReports // ignore: cast_nullable_to_non_nullable
              as List<ReportNotification>,
      isLoadingReceivedReports: null == isLoadingReceivedReports
          ? _value.isLoadingReceivedReports
          : isLoadingReceivedReports // ignore: cast_nullable_to_non_nullable
              as bool,
      receivedReportsError: freezed == receivedReportsError
          ? _value.receivedReportsError
          : receivedReportsError // ignore: cast_nullable_to_non_nullable
              as String?,
      availableTemplates: null == availableTemplates
          ? _value.availableTemplates
          : availableTemplates // ignore: cast_nullable_to_non_nullable
              as List<TemplateWithSubscription>,
      isLoadingTemplates: null == isLoadingTemplates
          ? _value.isLoadingTemplates
          : isLoadingTemplates // ignore: cast_nullable_to_non_nullable
              as bool,
      templatesError: freezed == templatesError
          ? _value.templatesError
          : templatesError // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<ReportCategory>,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      categoriesError: freezed == categoriesError
          ? _value.categoriesError
          : categoriesError // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      categoryFilter: freezed == categoryFilter
          ? _value.categoryFilter
          : categoryFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFilter: freezed == templateFilter
          ? _value.templateFilter
          : templateFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      showUnreadOnly: null == showUnreadOnly
          ? _value.showUnreadOnly
          : showUnreadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportStateImplCopyWith<$Res>
    implements $ReportStateCopyWith<$Res> {
  factory _$$ReportStateImplCopyWith(
          _$ReportStateImpl value, $Res Function(_$ReportStateImpl) then) =
      __$$ReportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ReportNotification> receivedReports,
      bool isLoadingReceivedReports,
      String? receivedReportsError,
      List<TemplateWithSubscription> availableTemplates,
      bool isLoadingTemplates,
      String? templatesError,
      List<ReportCategory> categories,
      bool isLoadingCategories,
      String? categoriesError,
      int selectedTabIndex,
      String? categoryFilter,
      String? templateFilter,
      bool showUnreadOnly,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class __$$ReportStateImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$ReportStateImpl>
    implements _$$ReportStateImplCopyWith<$Res> {
  __$$ReportStateImplCopyWithImpl(
      _$ReportStateImpl _value, $Res Function(_$ReportStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receivedReports = null,
    Object? isLoadingReceivedReports = null,
    Object? receivedReportsError = freezed,
    Object? availableTemplates = null,
    Object? isLoadingTemplates = null,
    Object? templatesError = freezed,
    Object? categories = null,
    Object? isLoadingCategories = null,
    Object? categoriesError = freezed,
    Object? selectedTabIndex = null,
    Object? categoryFilter = freezed,
    Object? templateFilter = freezed,
    Object? showUnreadOnly = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_$ReportStateImpl(
      receivedReports: null == receivedReports
          ? _value._receivedReports
          : receivedReports // ignore: cast_nullable_to_non_nullable
              as List<ReportNotification>,
      isLoadingReceivedReports: null == isLoadingReceivedReports
          ? _value.isLoadingReceivedReports
          : isLoadingReceivedReports // ignore: cast_nullable_to_non_nullable
              as bool,
      receivedReportsError: freezed == receivedReportsError
          ? _value.receivedReportsError
          : receivedReportsError // ignore: cast_nullable_to_non_nullable
              as String?,
      availableTemplates: null == availableTemplates
          ? _value._availableTemplates
          : availableTemplates // ignore: cast_nullable_to_non_nullable
              as List<TemplateWithSubscription>,
      isLoadingTemplates: null == isLoadingTemplates
          ? _value.isLoadingTemplates
          : isLoadingTemplates // ignore: cast_nullable_to_non_nullable
              as bool,
      templatesError: freezed == templatesError
          ? _value.templatesError
          : templatesError // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<ReportCategory>,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      categoriesError: freezed == categoriesError
          ? _value.categoriesError
          : categoriesError // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      categoryFilter: freezed == categoryFilter
          ? _value.categoryFilter
          : categoryFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFilter: freezed == templateFilter
          ? _value.templateFilter
          : templateFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      showUnreadOnly: null == showUnreadOnly
          ? _value.showUnreadOnly
          : showUnreadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ReportStateImpl extends _ReportState {
  const _$ReportStateImpl(
      {final List<ReportNotification> receivedReports = const [],
      this.isLoadingReceivedReports = false,
      this.receivedReportsError,
      final List<TemplateWithSubscription> availableTemplates = const [],
      this.isLoadingTemplates = false,
      this.templatesError,
      final List<ReportCategory> categories = const [],
      this.isLoadingCategories = false,
      this.categoriesError,
      this.selectedTabIndex = 0,
      this.categoryFilter = null,
      this.templateFilter = null,
      this.showUnreadOnly = false,
      this.startDate,
      this.endDate})
      : _receivedReports = receivedReports,
        _availableTemplates = availableTemplates,
        _categories = categories,
        super._();

// Received reports tab data
  final List<ReportNotification> _receivedReports;
// Received reports tab data
  @override
  @JsonKey()
  List<ReportNotification> get receivedReports {
    if (_receivedReports is EqualUnmodifiableListView) return _receivedReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivedReports);
  }

  @override
  @JsonKey()
  final bool isLoadingReceivedReports;
  @override
  final String? receivedReportsError;
// Available templates tab data
  final List<TemplateWithSubscription> _availableTemplates;
// Available templates tab data
  @override
  @JsonKey()
  List<TemplateWithSubscription> get availableTemplates {
    if (_availableTemplates is EqualUnmodifiableListView)
      return _availableTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTemplates);
  }

  @override
  @JsonKey()
  final bool isLoadingTemplates;
  @override
  final String? templatesError;
// Categories data
  final List<ReportCategory> _categories;
// Categories data
  @override
  @JsonKey()
  List<ReportCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final bool isLoadingCategories;
  @override
  final String? categoriesError;
// Selected tab index
  @override
  @JsonKey()
  final int selectedTabIndex;
// Filters for received reports
  @override
  @JsonKey()
  final String? categoryFilter;
// Filter by category_id
  @override
  @JsonKey()
  final String? templateFilter;
// Filter by template_id
  @override
  @JsonKey()
  final bool showUnreadOnly;
  @override
  final DateTime? startDate;
// Date range filter start
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'ReportState(receivedReports: $receivedReports, isLoadingReceivedReports: $isLoadingReceivedReports, receivedReportsError: $receivedReportsError, availableTemplates: $availableTemplates, isLoadingTemplates: $isLoadingTemplates, templatesError: $templatesError, categories: $categories, isLoadingCategories: $isLoadingCategories, categoriesError: $categoriesError, selectedTabIndex: $selectedTabIndex, categoryFilter: $categoryFilter, templateFilter: $templateFilter, showUnreadOnly: $showUnreadOnly, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportStateImpl &&
            const DeepCollectionEquality()
                .equals(other._receivedReports, _receivedReports) &&
            (identical(
                    other.isLoadingReceivedReports, isLoadingReceivedReports) ||
                other.isLoadingReceivedReports == isLoadingReceivedReports) &&
            (identical(other.receivedReportsError, receivedReportsError) ||
                other.receivedReportsError == receivedReportsError) &&
            const DeepCollectionEquality()
                .equals(other._availableTemplates, _availableTemplates) &&
            (identical(other.isLoadingTemplates, isLoadingTemplates) ||
                other.isLoadingTemplates == isLoadingTemplates) &&
            (identical(other.templatesError, templatesError) ||
                other.templatesError == templatesError) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.categoriesError, categoriesError) ||
                other.categoriesError == categoriesError) &&
            (identical(other.selectedTabIndex, selectedTabIndex) ||
                other.selectedTabIndex == selectedTabIndex) &&
            (identical(other.categoryFilter, categoryFilter) ||
                other.categoryFilter == categoryFilter) &&
            (identical(other.templateFilter, templateFilter) ||
                other.templateFilter == templateFilter) &&
            (identical(other.showUnreadOnly, showUnreadOnly) ||
                other.showUnreadOnly == showUnreadOnly) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_receivedReports),
      isLoadingReceivedReports,
      receivedReportsError,
      const DeepCollectionEquality().hash(_availableTemplates),
      isLoadingTemplates,
      templatesError,
      const DeepCollectionEquality().hash(_categories),
      isLoadingCategories,
      categoriesError,
      selectedTabIndex,
      categoryFilter,
      templateFilter,
      showUnreadOnly,
      startDate,
      endDate);

  /// Create a copy of ReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportStateImplCopyWith<_$ReportStateImpl> get copyWith =>
      __$$ReportStateImplCopyWithImpl<_$ReportStateImpl>(this, _$identity);
}

abstract class _ReportState extends ReportState {
  const factory _ReportState(
      {final List<ReportNotification> receivedReports,
      final bool isLoadingReceivedReports,
      final String? receivedReportsError,
      final List<TemplateWithSubscription> availableTemplates,
      final bool isLoadingTemplates,
      final String? templatesError,
      final List<ReportCategory> categories,
      final bool isLoadingCategories,
      final String? categoriesError,
      final int selectedTabIndex,
      final String? categoryFilter,
      final String? templateFilter,
      final bool showUnreadOnly,
      final DateTime? startDate,
      final DateTime? endDate}) = _$ReportStateImpl;
  const _ReportState._() : super._();

// Received reports tab data
  @override
  List<ReportNotification> get receivedReports;
  @override
  bool get isLoadingReceivedReports;
  @override
  String? get receivedReportsError; // Available templates tab data
  @override
  List<TemplateWithSubscription> get availableTemplates;
  @override
  bool get isLoadingTemplates;
  @override
  String? get templatesError; // Categories data
  @override
  List<ReportCategory> get categories;
  @override
  bool get isLoadingCategories;
  @override
  String? get categoriesError; // Selected tab index
  @override
  int get selectedTabIndex; // Filters for received reports
  @override
  String? get categoryFilter; // Filter by category_id
  @override
  String? get templateFilter; // Filter by template_id
  @override
  bool get showUnreadOnly;
  @override
  DateTime? get startDate; // Date range filter start
  @override
  DateTime? get endDate;

  /// Create a copy of ReportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportStateImplCopyWith<_$ReportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
