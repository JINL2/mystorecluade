// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_control_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DebtControlState {
  DebtOverview? get overview => throw _privateConstructorUsedError;
  List<PrioritizedDebt> get debts => throw _privateConstructorUsedError;
  bool get isLoadingOverview => throw _privateConstructorUsedError;
  bool get isLoadingDebts => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DebtFilter get filter => throw _privateConstructorUsedError;
  String get viewpoint =>
      throw _privateConstructorUsedError; // 'company', 'store', 'headquarters'
  String? get selectedStoreId => throw _privateConstructorUsedError;

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtControlStateCopyWith<DebtControlState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtControlStateCopyWith<$Res> {
  factory $DebtControlStateCopyWith(
          DebtControlState value, $Res Function(DebtControlState) then) =
      _$DebtControlStateCopyWithImpl<$Res, DebtControlState>;
  @useResult
  $Res call(
      {DebtOverview? overview,
      List<PrioritizedDebt> debts,
      bool isLoadingOverview,
      bool isLoadingDebts,
      bool isRefreshing,
      String? errorMessage,
      DebtFilter filter,
      String viewpoint,
      String? selectedStoreId});

  $DebtOverviewCopyWith<$Res>? get overview;
  $DebtFilterCopyWith<$Res> get filter;
}

/// @nodoc
class _$DebtControlStateCopyWithImpl<$Res, $Val extends DebtControlState>
    implements $DebtControlStateCopyWith<$Res> {
  _$DebtControlStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = freezed,
    Object? debts = null,
    Object? isLoadingOverview = null,
    Object? isLoadingDebts = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? filter = null,
    Object? viewpoint = null,
    Object? selectedStoreId = freezed,
  }) {
    return _then(_value.copyWith(
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as DebtOverview?,
      debts: null == debts
          ? _value.debts
          : debts // ignore: cast_nullable_to_non_nullable
              as List<PrioritizedDebt>,
      isLoadingOverview: null == isLoadingOverview
          ? _value.isLoadingOverview
          : isLoadingOverview // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingDebts: null == isLoadingDebts
          ? _value.isLoadingDebts
          : isLoadingDebts // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as DebtFilter,
      viewpoint: null == viewpoint
          ? _value.viewpoint
          : viewpoint // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DebtOverviewCopyWith<$Res>? get overview {
    if (_value.overview == null) {
      return null;
    }

    return $DebtOverviewCopyWith<$Res>(_value.overview!, (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DebtFilterCopyWith<$Res> get filter {
    return $DebtFilterCopyWith<$Res>(_value.filter, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebtControlStateImplCopyWith<$Res>
    implements $DebtControlStateCopyWith<$Res> {
  factory _$$DebtControlStateImplCopyWith(_$DebtControlStateImpl value,
          $Res Function(_$DebtControlStateImpl) then) =
      __$$DebtControlStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DebtOverview? overview,
      List<PrioritizedDebt> debts,
      bool isLoadingOverview,
      bool isLoadingDebts,
      bool isRefreshing,
      String? errorMessage,
      DebtFilter filter,
      String viewpoint,
      String? selectedStoreId});

  @override
  $DebtOverviewCopyWith<$Res>? get overview;
  @override
  $DebtFilterCopyWith<$Res> get filter;
}

/// @nodoc
class __$$DebtControlStateImplCopyWithImpl<$Res>
    extends _$DebtControlStateCopyWithImpl<$Res, _$DebtControlStateImpl>
    implements _$$DebtControlStateImplCopyWith<$Res> {
  __$$DebtControlStateImplCopyWithImpl(_$DebtControlStateImpl _value,
      $Res Function(_$DebtControlStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = freezed,
    Object? debts = null,
    Object? isLoadingOverview = null,
    Object? isLoadingDebts = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? filter = null,
    Object? viewpoint = null,
    Object? selectedStoreId = freezed,
  }) {
    return _then(_$DebtControlStateImpl(
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as DebtOverview?,
      debts: null == debts
          ? _value._debts
          : debts // ignore: cast_nullable_to_non_nullable
              as List<PrioritizedDebt>,
      isLoadingOverview: null == isLoadingOverview
          ? _value.isLoadingOverview
          : isLoadingOverview // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingDebts: null == isLoadingDebts
          ? _value.isLoadingDebts
          : isLoadingDebts // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as DebtFilter,
      viewpoint: null == viewpoint
          ? _value.viewpoint
          : viewpoint // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DebtControlStateImpl extends _DebtControlState {
  const _$DebtControlStateImpl(
      {this.overview,
      final List<PrioritizedDebt> debts = const [],
      this.isLoadingOverview = false,
      this.isLoadingDebts = false,
      this.isRefreshing = false,
      this.errorMessage,
      this.filter = const DebtFilter(),
      this.viewpoint = 'company',
      this.selectedStoreId})
      : _debts = debts,
        super._();

  @override
  final DebtOverview? overview;
  final List<PrioritizedDebt> _debts;
  @override
  @JsonKey()
  List<PrioritizedDebt> get debts {
    if (_debts is EqualUnmodifiableListView) return _debts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_debts);
  }

  @override
  @JsonKey()
  final bool isLoadingOverview;
  @override
  @JsonKey()
  final bool isLoadingDebts;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final DebtFilter filter;
  @override
  @JsonKey()
  final String viewpoint;
// 'company', 'store', 'headquarters'
  @override
  final String? selectedStoreId;

  @override
  String toString() {
    return 'DebtControlState(overview: $overview, debts: $debts, isLoadingOverview: $isLoadingOverview, isLoadingDebts: $isLoadingDebts, isRefreshing: $isRefreshing, errorMessage: $errorMessage, filter: $filter, viewpoint: $viewpoint, selectedStoreId: $selectedStoreId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtControlStateImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            const DeepCollectionEquality().equals(other._debts, _debts) &&
            (identical(other.isLoadingOverview, isLoadingOverview) ||
                other.isLoadingOverview == isLoadingOverview) &&
            (identical(other.isLoadingDebts, isLoadingDebts) ||
                other.isLoadingDebts == isLoadingDebts) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.viewpoint, viewpoint) ||
                other.viewpoint == viewpoint) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      overview,
      const DeepCollectionEquality().hash(_debts),
      isLoadingOverview,
      isLoadingDebts,
      isRefreshing,
      errorMessage,
      filter,
      viewpoint,
      selectedStoreId);

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtControlStateImplCopyWith<_$DebtControlStateImpl> get copyWith =>
      __$$DebtControlStateImplCopyWithImpl<_$DebtControlStateImpl>(
          this, _$identity);
}

abstract class _DebtControlState extends DebtControlState {
  const factory _DebtControlState(
      {final DebtOverview? overview,
      final List<PrioritizedDebt> debts,
      final bool isLoadingOverview,
      final bool isLoadingDebts,
      final bool isRefreshing,
      final String? errorMessage,
      final DebtFilter filter,
      final String viewpoint,
      final String? selectedStoreId}) = _$DebtControlStateImpl;
  const _DebtControlState._() : super._();

  @override
  DebtOverview? get overview;
  @override
  List<PrioritizedDebt> get debts;
  @override
  bool get isLoadingOverview;
  @override
  bool get isLoadingDebts;
  @override
  bool get isRefreshing;
  @override
  String? get errorMessage;
  @override
  DebtFilter get filter;
  @override
  String get viewpoint; // 'company', 'store', 'headquarters'
  @override
  String? get selectedStoreId;

  /// Create a copy of DebtControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtControlStateImplCopyWith<_$DebtControlStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DebtDetailState {
  PrioritizedDebt? get debt => throw _privateConstructorUsedError;
  List<dynamic> get communications => throw _privateConstructorUsedError;
  List<dynamic> get paymentPlans => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingCommunications => throw _privateConstructorUsedError;
  bool get isLoadingPaymentPlans => throw _privateConstructorUsedError;
  bool get isPerformingAction => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get actionInProgress => throw _privateConstructorUsedError;

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtDetailStateCopyWith<DebtDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtDetailStateCopyWith<$Res> {
  factory $DebtDetailStateCopyWith(
          DebtDetailState value, $Res Function(DebtDetailState) then) =
      _$DebtDetailStateCopyWithImpl<$Res, DebtDetailState>;
  @useResult
  $Res call(
      {PrioritizedDebt? debt,
      List<dynamic> communications,
      List<dynamic> paymentPlans,
      bool isLoading,
      bool isLoadingCommunications,
      bool isLoadingPaymentPlans,
      bool isPerformingAction,
      String? errorMessage,
      String? actionInProgress});

  $PrioritizedDebtCopyWith<$Res>? get debt;
}

/// @nodoc
class _$DebtDetailStateCopyWithImpl<$Res, $Val extends DebtDetailState>
    implements $DebtDetailStateCopyWith<$Res> {
  _$DebtDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debt = freezed,
    Object? communications = null,
    Object? paymentPlans = null,
    Object? isLoading = null,
    Object? isLoadingCommunications = null,
    Object? isLoadingPaymentPlans = null,
    Object? isPerformingAction = null,
    Object? errorMessage = freezed,
    Object? actionInProgress = freezed,
  }) {
    return _then(_value.copyWith(
      debt: freezed == debt
          ? _value.debt
          : debt // ignore: cast_nullable_to_non_nullable
              as PrioritizedDebt?,
      communications: null == communications
          ? _value.communications
          : communications // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentPlans: null == paymentPlans
          ? _value.paymentPlans
          : paymentPlans // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCommunications: null == isLoadingCommunications
          ? _value.isLoadingCommunications
          : isLoadingCommunications // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingPaymentPlans: null == isLoadingPaymentPlans
          ? _value.isLoadingPaymentPlans
          : isLoadingPaymentPlans // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerformingAction: null == isPerformingAction
          ? _value.isPerformingAction
          : isPerformingAction // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      actionInProgress: freezed == actionInProgress
          ? _value.actionInProgress
          : actionInProgress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrioritizedDebtCopyWith<$Res>? get debt {
    if (_value.debt == null) {
      return null;
    }

    return $PrioritizedDebtCopyWith<$Res>(_value.debt!, (value) {
      return _then(_value.copyWith(debt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DebtDetailStateImplCopyWith<$Res>
    implements $DebtDetailStateCopyWith<$Res> {
  factory _$$DebtDetailStateImplCopyWith(_$DebtDetailStateImpl value,
          $Res Function(_$DebtDetailStateImpl) then) =
      __$$DebtDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PrioritizedDebt? debt,
      List<dynamic> communications,
      List<dynamic> paymentPlans,
      bool isLoading,
      bool isLoadingCommunications,
      bool isLoadingPaymentPlans,
      bool isPerformingAction,
      String? errorMessage,
      String? actionInProgress});

  @override
  $PrioritizedDebtCopyWith<$Res>? get debt;
}

/// @nodoc
class __$$DebtDetailStateImplCopyWithImpl<$Res>
    extends _$DebtDetailStateCopyWithImpl<$Res, _$DebtDetailStateImpl>
    implements _$$DebtDetailStateImplCopyWith<$Res> {
  __$$DebtDetailStateImplCopyWithImpl(
      _$DebtDetailStateImpl _value, $Res Function(_$DebtDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debt = freezed,
    Object? communications = null,
    Object? paymentPlans = null,
    Object? isLoading = null,
    Object? isLoadingCommunications = null,
    Object? isLoadingPaymentPlans = null,
    Object? isPerformingAction = null,
    Object? errorMessage = freezed,
    Object? actionInProgress = freezed,
  }) {
    return _then(_$DebtDetailStateImpl(
      debt: freezed == debt
          ? _value.debt
          : debt // ignore: cast_nullable_to_non_nullable
              as PrioritizedDebt?,
      communications: null == communications
          ? _value._communications
          : communications // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      paymentPlans: null == paymentPlans
          ? _value._paymentPlans
          : paymentPlans // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCommunications: null == isLoadingCommunications
          ? _value.isLoadingCommunications
          : isLoadingCommunications // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingPaymentPlans: null == isLoadingPaymentPlans
          ? _value.isLoadingPaymentPlans
          : isLoadingPaymentPlans // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerformingAction: null == isPerformingAction
          ? _value.isPerformingAction
          : isPerformingAction // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      actionInProgress: freezed == actionInProgress
          ? _value.actionInProgress
          : actionInProgress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DebtDetailStateImpl extends _DebtDetailState {
  const _$DebtDetailStateImpl(
      {this.debt,
      final List<dynamic> communications = const [],
      final List<dynamic> paymentPlans = const [],
      this.isLoading = false,
      this.isLoadingCommunications = false,
      this.isLoadingPaymentPlans = false,
      this.isPerformingAction = false,
      this.errorMessage,
      this.actionInProgress})
      : _communications = communications,
        _paymentPlans = paymentPlans,
        super._();

  @override
  final PrioritizedDebt? debt;
  final List<dynamic> _communications;
  @override
  @JsonKey()
  List<dynamic> get communications {
    if (_communications is EqualUnmodifiableListView) return _communications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_communications);
  }

  final List<dynamic> _paymentPlans;
  @override
  @JsonKey()
  List<dynamic> get paymentPlans {
    if (_paymentPlans is EqualUnmodifiableListView) return _paymentPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentPlans);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingCommunications;
  @override
  @JsonKey()
  final bool isLoadingPaymentPlans;
  @override
  @JsonKey()
  final bool isPerformingAction;
  @override
  final String? errorMessage;
  @override
  final String? actionInProgress;

  @override
  String toString() {
    return 'DebtDetailState(debt: $debt, communications: $communications, paymentPlans: $paymentPlans, isLoading: $isLoading, isLoadingCommunications: $isLoadingCommunications, isLoadingPaymentPlans: $isLoadingPaymentPlans, isPerformingAction: $isPerformingAction, errorMessage: $errorMessage, actionInProgress: $actionInProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtDetailStateImpl &&
            (identical(other.debt, debt) || other.debt == debt) &&
            const DeepCollectionEquality()
                .equals(other._communications, _communications) &&
            const DeepCollectionEquality()
                .equals(other._paymentPlans, _paymentPlans) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(
                    other.isLoadingCommunications, isLoadingCommunications) ||
                other.isLoadingCommunications == isLoadingCommunications) &&
            (identical(other.isLoadingPaymentPlans, isLoadingPaymentPlans) ||
                other.isLoadingPaymentPlans == isLoadingPaymentPlans) &&
            (identical(other.isPerformingAction, isPerformingAction) ||
                other.isPerformingAction == isPerformingAction) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.actionInProgress, actionInProgress) ||
                other.actionInProgress == actionInProgress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      debt,
      const DeepCollectionEquality().hash(_communications),
      const DeepCollectionEquality().hash(_paymentPlans),
      isLoading,
      isLoadingCommunications,
      isLoadingPaymentPlans,
      isPerformingAction,
      errorMessage,
      actionInProgress);

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtDetailStateImplCopyWith<_$DebtDetailStateImpl> get copyWith =>
      __$$DebtDetailStateImplCopyWithImpl<_$DebtDetailStateImpl>(
          this, _$identity);
}

abstract class _DebtDetailState extends DebtDetailState {
  const factory _DebtDetailState(
      {final PrioritizedDebt? debt,
      final List<dynamic> communications,
      final List<dynamic> paymentPlans,
      final bool isLoading,
      final bool isLoadingCommunications,
      final bool isLoadingPaymentPlans,
      final bool isPerformingAction,
      final String? errorMessage,
      final String? actionInProgress}) = _$DebtDetailStateImpl;
  const _DebtDetailState._() : super._();

  @override
  PrioritizedDebt? get debt;
  @override
  List<dynamic> get communications;
  @override
  List<dynamic> get paymentPlans;
  @override
  bool get isLoading;
  @override
  bool get isLoadingCommunications;
  @override
  bool get isLoadingPaymentPlans;
  @override
  bool get isPerformingAction;
  @override
  String? get errorMessage;
  @override
  String? get actionInProgress;

  /// Create a copy of DebtDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtDetailStateImplCopyWith<_$DebtDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PerspectiveState {
  String get selectedPerspective => throw _privateConstructorUsedError;
  String? get selectedStoreId => throw _privateConstructorUsedError;
  String? get selectedStoreName => throw _privateConstructorUsedError;
  List<Map<String, String>> get availableStores =>
      throw _privateConstructorUsedError;
  bool get isChangingPerspective => throw _privateConstructorUsedError;

  /// Create a copy of PerspectiveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerspectiveStateCopyWith<PerspectiveState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerspectiveStateCopyWith<$Res> {
  factory $PerspectiveStateCopyWith(
          PerspectiveState value, $Res Function(PerspectiveState) then) =
      _$PerspectiveStateCopyWithImpl<$Res, PerspectiveState>;
  @useResult
  $Res call(
      {String selectedPerspective,
      String? selectedStoreId,
      String? selectedStoreName,
      List<Map<String, String>> availableStores,
      bool isChangingPerspective});
}

/// @nodoc
class _$PerspectiveStateCopyWithImpl<$Res, $Val extends PerspectiveState>
    implements $PerspectiveStateCopyWith<$Res> {
  _$PerspectiveStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerspectiveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedPerspective = null,
    Object? selectedStoreId = freezed,
    Object? selectedStoreName = freezed,
    Object? availableStores = null,
    Object? isChangingPerspective = null,
  }) {
    return _then(_value.copyWith(
      selectedPerspective: null == selectedPerspective
          ? _value.selectedPerspective
          : selectedPerspective // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreName: freezed == selectedStoreName
          ? _value.selectedStoreName
          : selectedStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      availableStores: null == availableStores
          ? _value.availableStores
          : availableStores // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      isChangingPerspective: null == isChangingPerspective
          ? _value.isChangingPerspective
          : isChangingPerspective // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerspectiveStateImplCopyWith<$Res>
    implements $PerspectiveStateCopyWith<$Res> {
  factory _$$PerspectiveStateImplCopyWith(_$PerspectiveStateImpl value,
          $Res Function(_$PerspectiveStateImpl) then) =
      __$$PerspectiveStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String selectedPerspective,
      String? selectedStoreId,
      String? selectedStoreName,
      List<Map<String, String>> availableStores,
      bool isChangingPerspective});
}

/// @nodoc
class __$$PerspectiveStateImplCopyWithImpl<$Res>
    extends _$PerspectiveStateCopyWithImpl<$Res, _$PerspectiveStateImpl>
    implements _$$PerspectiveStateImplCopyWith<$Res> {
  __$$PerspectiveStateImplCopyWithImpl(_$PerspectiveStateImpl _value,
      $Res Function(_$PerspectiveStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerspectiveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedPerspective = null,
    Object? selectedStoreId = freezed,
    Object? selectedStoreName = freezed,
    Object? availableStores = null,
    Object? isChangingPerspective = null,
  }) {
    return _then(_$PerspectiveStateImpl(
      selectedPerspective: null == selectedPerspective
          ? _value.selectedPerspective
          : selectedPerspective // ignore: cast_nullable_to_non_nullable
              as String,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreName: freezed == selectedStoreName
          ? _value.selectedStoreName
          : selectedStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      availableStores: null == availableStores
          ? _value._availableStores
          : availableStores // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      isChangingPerspective: null == isChangingPerspective
          ? _value.isChangingPerspective
          : isChangingPerspective // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PerspectiveStateImpl extends _PerspectiveState {
  const _$PerspectiveStateImpl(
      {this.selectedPerspective = 'company',
      this.selectedStoreId,
      this.selectedStoreName,
      final List<Map<String, String>> availableStores = const [],
      this.isChangingPerspective = false})
      : _availableStores = availableStores,
        super._();

  @override
  @JsonKey()
  final String selectedPerspective;
  @override
  final String? selectedStoreId;
  @override
  final String? selectedStoreName;
  final List<Map<String, String>> _availableStores;
  @override
  @JsonKey()
  List<Map<String, String>> get availableStores {
    if (_availableStores is EqualUnmodifiableListView) return _availableStores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableStores);
  }

  @override
  @JsonKey()
  final bool isChangingPerspective;

  @override
  String toString() {
    return 'PerspectiveState(selectedPerspective: $selectedPerspective, selectedStoreId: $selectedStoreId, selectedStoreName: $selectedStoreName, availableStores: $availableStores, isChangingPerspective: $isChangingPerspective)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerspectiveStateImpl &&
            (identical(other.selectedPerspective, selectedPerspective) ||
                other.selectedPerspective == selectedPerspective) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            (identical(other.selectedStoreName, selectedStoreName) ||
                other.selectedStoreName == selectedStoreName) &&
            const DeepCollectionEquality()
                .equals(other._availableStores, _availableStores) &&
            (identical(other.isChangingPerspective, isChangingPerspective) ||
                other.isChangingPerspective == isChangingPerspective));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedPerspective,
      selectedStoreId,
      selectedStoreName,
      const DeepCollectionEquality().hash(_availableStores),
      isChangingPerspective);

  /// Create a copy of PerspectiveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerspectiveStateImplCopyWith<_$PerspectiveStateImpl> get copyWith =>
      __$$PerspectiveStateImplCopyWithImpl<_$PerspectiveStateImpl>(
          this, _$identity);
}

abstract class _PerspectiveState extends PerspectiveState {
  const factory _PerspectiveState(
      {final String selectedPerspective,
      final String? selectedStoreId,
      final String? selectedStoreName,
      final List<Map<String, String>> availableStores,
      final bool isChangingPerspective}) = _$PerspectiveStateImpl;
  const _PerspectiveState._() : super._();

  @override
  String get selectedPerspective;
  @override
  String? get selectedStoreId;
  @override
  String? get selectedStoreName;
  @override
  List<Map<String, String>> get availableStores;
  @override
  bool get isChangingPerspective;

  /// Create a copy of PerspectiveState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerspectiveStateImplCopyWith<_$PerspectiveStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AlertActionState {
  Set<String> get processingAlerts => throw _privateConstructorUsedError;
  Map<String, String> get alertErrors => throw _privateConstructorUsedError;

  /// Create a copy of AlertActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertActionStateCopyWith<AlertActionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertActionStateCopyWith<$Res> {
  factory $AlertActionStateCopyWith(
          AlertActionState value, $Res Function(AlertActionState) then) =
      _$AlertActionStateCopyWithImpl<$Res, AlertActionState>;
  @useResult
  $Res call({Set<String> processingAlerts, Map<String, String> alertErrors});
}

/// @nodoc
class _$AlertActionStateCopyWithImpl<$Res, $Val extends AlertActionState>
    implements $AlertActionStateCopyWith<$Res> {
  _$AlertActionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingAlerts = null,
    Object? alertErrors = null,
  }) {
    return _then(_value.copyWith(
      processingAlerts: null == processingAlerts
          ? _value.processingAlerts
          : processingAlerts // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      alertErrors: null == alertErrors
          ? _value.alertErrors
          : alertErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertActionStateImplCopyWith<$Res>
    implements $AlertActionStateCopyWith<$Res> {
  factory _$$AlertActionStateImplCopyWith(_$AlertActionStateImpl value,
          $Res Function(_$AlertActionStateImpl) then) =
      __$$AlertActionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> processingAlerts, Map<String, String> alertErrors});
}

/// @nodoc
class __$$AlertActionStateImplCopyWithImpl<$Res>
    extends _$AlertActionStateCopyWithImpl<$Res, _$AlertActionStateImpl>
    implements _$$AlertActionStateImplCopyWith<$Res> {
  __$$AlertActionStateImplCopyWithImpl(_$AlertActionStateImpl _value,
      $Res Function(_$AlertActionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingAlerts = null,
    Object? alertErrors = null,
  }) {
    return _then(_$AlertActionStateImpl(
      processingAlerts: null == processingAlerts
          ? _value._processingAlerts
          : processingAlerts // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      alertErrors: null == alertErrors
          ? _value._alertErrors
          : alertErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$AlertActionStateImpl extends _AlertActionState {
  const _$AlertActionStateImpl(
      {final Set<String> processingAlerts = const <String>{},
      final Map<String, String> alertErrors = const <String, String>{}})
      : _processingAlerts = processingAlerts,
        _alertErrors = alertErrors,
        super._();

  final Set<String> _processingAlerts;
  @override
  @JsonKey()
  Set<String> get processingAlerts {
    if (_processingAlerts is EqualUnmodifiableSetView) return _processingAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_processingAlerts);
  }

  final Map<String, String> _alertErrors;
  @override
  @JsonKey()
  Map<String, String> get alertErrors {
    if (_alertErrors is EqualUnmodifiableMapView) return _alertErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_alertErrors);
  }

  @override
  String toString() {
    return 'AlertActionState(processingAlerts: $processingAlerts, alertErrors: $alertErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertActionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._processingAlerts, _processingAlerts) &&
            const DeepCollectionEquality()
                .equals(other._alertErrors, _alertErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_processingAlerts),
      const DeepCollectionEquality().hash(_alertErrors));

  /// Create a copy of AlertActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertActionStateImplCopyWith<_$AlertActionStateImpl> get copyWith =>
      __$$AlertActionStateImplCopyWithImpl<_$AlertActionStateImpl>(
          this, _$identity);
}

abstract class _AlertActionState extends AlertActionState {
  const factory _AlertActionState(
      {final Set<String> processingAlerts,
      final Map<String, String> alertErrors}) = _$AlertActionStateImpl;
  const _AlertActionState._() : super._();

  @override
  Set<String> get processingAlerts;
  @override
  Map<String, String> get alertErrors;

  /// Create a copy of AlertActionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertActionStateImplCopyWith<_$AlertActionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
