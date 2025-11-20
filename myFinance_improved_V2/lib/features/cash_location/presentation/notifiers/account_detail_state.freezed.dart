// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountDetailState {
  List<JournalFlow> get journalFlows => throw _privateConstructorUsedError;
  List<ActualFlow> get actualFlows => throw _privateConstructorUsedError;
  LocationSummary? get locationSummary =>
      throw _privateConstructorUsedError; // Pagination
  int get journalOffset => throw _privateConstructorUsedError;
  int get actualOffset => throw _privateConstructorUsedError;
  bool get isLoadingJournal => throw _privateConstructorUsedError;
  bool get isLoadingActual => throw _privateConstructorUsedError;
  bool get hasMoreJournal => throw _privateConstructorUsedError;
  bool get hasMoreActual =>
      throw _privateConstructorUsedError; // Updated balances (from refresh)
  int? get updatedTotalJournal => throw _privateConstructorUsedError;
  int? get updatedTotalReal => throw _privateConstructorUsedError;
  int? get updatedCashDifference => throw _privateConstructorUsedError;

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountDetailStateCopyWith<AccountDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountDetailStateCopyWith<$Res> {
  factory $AccountDetailStateCopyWith(
          AccountDetailState value, $Res Function(AccountDetailState) then) =
      _$AccountDetailStateCopyWithImpl<$Res, AccountDetailState>;
  @useResult
  $Res call(
      {List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows,
      LocationSummary? locationSummary,
      int journalOffset,
      int actualOffset,
      bool isLoadingJournal,
      bool isLoadingActual,
      bool hasMoreJournal,
      bool hasMoreActual,
      int? updatedTotalJournal,
      int? updatedTotalReal,
      int? updatedCashDifference});

  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class _$AccountDetailStateCopyWithImpl<$Res, $Val extends AccountDetailState>
    implements $AccountDetailStateCopyWith<$Res> {
  _$AccountDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalFlows = null,
    Object? actualFlows = null,
    Object? locationSummary = freezed,
    Object? journalOffset = null,
    Object? actualOffset = null,
    Object? isLoadingJournal = null,
    Object? isLoadingActual = null,
    Object? hasMoreJournal = null,
    Object? hasMoreActual = null,
    Object? updatedTotalJournal = freezed,
    Object? updatedTotalReal = freezed,
    Object? updatedCashDifference = freezed,
  }) {
    return _then(_value.copyWith(
      journalFlows: null == journalFlows
          ? _value.journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value.actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalOffset: null == journalOffset
          ? _value.journalOffset
          : journalOffset // ignore: cast_nullable_to_non_nullable
              as int,
      actualOffset: null == actualOffset
          ? _value.actualOffset
          : actualOffset // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingJournal: null == isLoadingJournal
          ? _value.isLoadingJournal
          : isLoadingJournal // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingActual: null == isLoadingActual
          ? _value.isLoadingActual
          : isLoadingActual // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreJournal: null == hasMoreJournal
          ? _value.hasMoreJournal
          : hasMoreJournal // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreActual: null == hasMoreActual
          ? _value.hasMoreActual
          : hasMoreActual // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedTotalJournal: freezed == updatedTotalJournal
          ? _value.updatedTotalJournal
          : updatedTotalJournal // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedTotalReal: freezed == updatedTotalReal
          ? _value.updatedTotalReal
          : updatedTotalReal // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedCashDifference: freezed == updatedCashDifference
          ? _value.updatedCashDifference
          : updatedCashDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationSummaryCopyWith<$Res>? get locationSummary {
    if (_value.locationSummary == null) {
      return null;
    }

    return $LocationSummaryCopyWith<$Res>(_value.locationSummary!, (value) {
      return _then(_value.copyWith(locationSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountDetailStateImplCopyWith<$Res>
    implements $AccountDetailStateCopyWith<$Res> {
  factory _$$AccountDetailStateImplCopyWith(_$AccountDetailStateImpl value,
          $Res Function(_$AccountDetailStateImpl) then) =
      __$$AccountDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<JournalFlow> journalFlows,
      List<ActualFlow> actualFlows,
      LocationSummary? locationSummary,
      int journalOffset,
      int actualOffset,
      bool isLoadingJournal,
      bool isLoadingActual,
      bool hasMoreJournal,
      bool hasMoreActual,
      int? updatedTotalJournal,
      int? updatedTotalReal,
      int? updatedCashDifference});

  @override
  $LocationSummaryCopyWith<$Res>? get locationSummary;
}

/// @nodoc
class __$$AccountDetailStateImplCopyWithImpl<$Res>
    extends _$AccountDetailStateCopyWithImpl<$Res, _$AccountDetailStateImpl>
    implements _$$AccountDetailStateImplCopyWith<$Res> {
  __$$AccountDetailStateImplCopyWithImpl(_$AccountDetailStateImpl _value,
      $Res Function(_$AccountDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalFlows = null,
    Object? actualFlows = null,
    Object? locationSummary = freezed,
    Object? journalOffset = null,
    Object? actualOffset = null,
    Object? isLoadingJournal = null,
    Object? isLoadingActual = null,
    Object? hasMoreJournal = null,
    Object? hasMoreActual = null,
    Object? updatedTotalJournal = freezed,
    Object? updatedTotalReal = freezed,
    Object? updatedCashDifference = freezed,
  }) {
    return _then(_$AccountDetailStateImpl(
      journalFlows: null == journalFlows
          ? _value._journalFlows
          : journalFlows // ignore: cast_nullable_to_non_nullable
              as List<JournalFlow>,
      actualFlows: null == actualFlows
          ? _value._actualFlows
          : actualFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      journalOffset: null == journalOffset
          ? _value.journalOffset
          : journalOffset // ignore: cast_nullable_to_non_nullable
              as int,
      actualOffset: null == actualOffset
          ? _value.actualOffset
          : actualOffset // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingJournal: null == isLoadingJournal
          ? _value.isLoadingJournal
          : isLoadingJournal // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingActual: null == isLoadingActual
          ? _value.isLoadingActual
          : isLoadingActual // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreJournal: null == hasMoreJournal
          ? _value.hasMoreJournal
          : hasMoreJournal // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMoreActual: null == hasMoreActual
          ? _value.hasMoreActual
          : hasMoreActual // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedTotalJournal: freezed == updatedTotalJournal
          ? _value.updatedTotalJournal
          : updatedTotalJournal // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedTotalReal: freezed == updatedTotalReal
          ? _value.updatedTotalReal
          : updatedTotalReal // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedCashDifference: freezed == updatedCashDifference
          ? _value.updatedCashDifference
          : updatedCashDifference // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$AccountDetailStateImpl implements _AccountDetailState {
  const _$AccountDetailStateImpl(
      {final List<JournalFlow> journalFlows = const [],
      final List<ActualFlow> actualFlows = const [],
      this.locationSummary,
      this.journalOffset = 0,
      this.actualOffset = 0,
      this.isLoadingJournal = false,
      this.isLoadingActual = false,
      this.hasMoreJournal = true,
      this.hasMoreActual = true,
      this.updatedTotalJournal,
      this.updatedTotalReal,
      this.updatedCashDifference})
      : _journalFlows = journalFlows,
        _actualFlows = actualFlows;

  final List<JournalFlow> _journalFlows;
  @override
  @JsonKey()
  List<JournalFlow> get journalFlows {
    if (_journalFlows is EqualUnmodifiableListView) return _journalFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_journalFlows);
  }

  final List<ActualFlow> _actualFlows;
  @override
  @JsonKey()
  List<ActualFlow> get actualFlows {
    if (_actualFlows is EqualUnmodifiableListView) return _actualFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actualFlows);
  }

  @override
  final LocationSummary? locationSummary;
// Pagination
  @override
  @JsonKey()
  final int journalOffset;
  @override
  @JsonKey()
  final int actualOffset;
  @override
  @JsonKey()
  final bool isLoadingJournal;
  @override
  @JsonKey()
  final bool isLoadingActual;
  @override
  @JsonKey()
  final bool hasMoreJournal;
  @override
  @JsonKey()
  final bool hasMoreActual;
// Updated balances (from refresh)
  @override
  final int? updatedTotalJournal;
  @override
  final int? updatedTotalReal;
  @override
  final int? updatedCashDifference;

  @override
  String toString() {
    return 'AccountDetailState(journalFlows: $journalFlows, actualFlows: $actualFlows, locationSummary: $locationSummary, journalOffset: $journalOffset, actualOffset: $actualOffset, isLoadingJournal: $isLoadingJournal, isLoadingActual: $isLoadingActual, hasMoreJournal: $hasMoreJournal, hasMoreActual: $hasMoreActual, updatedTotalJournal: $updatedTotalJournal, updatedTotalReal: $updatedTotalReal, updatedCashDifference: $updatedCashDifference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountDetailStateImpl &&
            const DeepCollectionEquality()
                .equals(other._journalFlows, _journalFlows) &&
            const DeepCollectionEquality()
                .equals(other._actualFlows, _actualFlows) &&
            (identical(other.locationSummary, locationSummary) ||
                other.locationSummary == locationSummary) &&
            (identical(other.journalOffset, journalOffset) ||
                other.journalOffset == journalOffset) &&
            (identical(other.actualOffset, actualOffset) ||
                other.actualOffset == actualOffset) &&
            (identical(other.isLoadingJournal, isLoadingJournal) ||
                other.isLoadingJournal == isLoadingJournal) &&
            (identical(other.isLoadingActual, isLoadingActual) ||
                other.isLoadingActual == isLoadingActual) &&
            (identical(other.hasMoreJournal, hasMoreJournal) ||
                other.hasMoreJournal == hasMoreJournal) &&
            (identical(other.hasMoreActual, hasMoreActual) ||
                other.hasMoreActual == hasMoreActual) &&
            (identical(other.updatedTotalJournal, updatedTotalJournal) ||
                other.updatedTotalJournal == updatedTotalJournal) &&
            (identical(other.updatedTotalReal, updatedTotalReal) ||
                other.updatedTotalReal == updatedTotalReal) &&
            (identical(other.updatedCashDifference, updatedCashDifference) ||
                other.updatedCashDifference == updatedCashDifference));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_journalFlows),
      const DeepCollectionEquality().hash(_actualFlows),
      locationSummary,
      journalOffset,
      actualOffset,
      isLoadingJournal,
      isLoadingActual,
      hasMoreJournal,
      hasMoreActual,
      updatedTotalJournal,
      updatedTotalReal,
      updatedCashDifference);

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountDetailStateImplCopyWith<_$AccountDetailStateImpl> get copyWith =>
      __$$AccountDetailStateImplCopyWithImpl<_$AccountDetailStateImpl>(
          this, _$identity);
}

abstract class _AccountDetailState implements AccountDetailState {
  const factory _AccountDetailState(
      {final List<JournalFlow> journalFlows,
      final List<ActualFlow> actualFlows,
      final LocationSummary? locationSummary,
      final int journalOffset,
      final int actualOffset,
      final bool isLoadingJournal,
      final bool isLoadingActual,
      final bool hasMoreJournal,
      final bool hasMoreActual,
      final int? updatedTotalJournal,
      final int? updatedTotalReal,
      final int? updatedCashDifference}) = _$AccountDetailStateImpl;

  @override
  List<JournalFlow> get journalFlows;
  @override
  List<ActualFlow> get actualFlows;
  @override
  LocationSummary? get locationSummary; // Pagination
  @override
  int get journalOffset;
  @override
  int get actualOffset;
  @override
  bool get isLoadingJournal;
  @override
  bool get isLoadingActual;
  @override
  bool get hasMoreJournal;
  @override
  bool get hasMoreActual; // Updated balances (from refresh)
  @override
  int? get updatedTotalJournal;
  @override
  int? get updatedTotalReal;
  @override
  int? get updatedCashDifference;

  /// Create a copy of AccountDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountDetailStateImplCopyWith<_$AccountDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
