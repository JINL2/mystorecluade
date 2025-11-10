// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_shift_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyShiftData _$DailyShiftDataFromJson(Map<String, dynamic> json) {
  return _DailyShiftData.fromJson(json);
}

/// @nodoc
mixin _$DailyShiftData {
  /// Date in yyyy-MM-dd format
  String get date => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: <ShiftWithRequests>[])
  List<ShiftWithRequests> get shifts => throw _privateConstructorUsedError;

  /// Serializes this DailyShiftData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyShiftData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyShiftDataCopyWith<DailyShiftData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyShiftDataCopyWith<$Res> {
  factory $DailyShiftDataCopyWith(
          DailyShiftData value, $Res Function(DailyShiftData) then) =
      _$DailyShiftDataCopyWithImpl<$Res, DailyShiftData>;
  @useResult
  $Res call(
      {String date,
      @JsonKey(defaultValue: <ShiftWithRequests>[])
      List<ShiftWithRequests> shifts});
}

/// @nodoc
class _$DailyShiftDataCopyWithImpl<$Res, $Val extends DailyShiftData>
    implements $DailyShiftDataCopyWith<$Res> {
  _$DailyShiftDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyShiftData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shifts = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      shifts: null == shifts
          ? _value.shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftWithRequests>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyShiftDataImplCopyWith<$Res>
    implements $DailyShiftDataCopyWith<$Res> {
  factory _$$DailyShiftDataImplCopyWith(_$DailyShiftDataImpl value,
          $Res Function(_$DailyShiftDataImpl) then) =
      __$$DailyShiftDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      @JsonKey(defaultValue: <ShiftWithRequests>[])
      List<ShiftWithRequests> shifts});
}

/// @nodoc
class __$$DailyShiftDataImplCopyWithImpl<$Res>
    extends _$DailyShiftDataCopyWithImpl<$Res, _$DailyShiftDataImpl>
    implements _$$DailyShiftDataImplCopyWith<$Res> {
  __$$DailyShiftDataImplCopyWithImpl(
      _$DailyShiftDataImpl _value, $Res Function(_$DailyShiftDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyShiftData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shifts = null,
  }) {
    return _then(_$DailyShiftDataImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      shifts: null == shifts
          ? _value._shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftWithRequests>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyShiftDataImpl extends _DailyShiftData {
  const _$DailyShiftDataImpl(
      {required this.date,
      @JsonKey(defaultValue: <ShiftWithRequests>[])
      required final List<ShiftWithRequests> shifts})
      : _shifts = shifts,
        super._();

  factory _$DailyShiftDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyShiftDataImplFromJson(json);

  /// Date in yyyy-MM-dd format
  @override
  final String date;
  final List<ShiftWithRequests> _shifts;
  @override
  @JsonKey(defaultValue: <ShiftWithRequests>[])
  List<ShiftWithRequests> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  @override
  String toString() {
    return 'DailyShiftData(date: $date, shifts: $shifts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyShiftDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._shifts, _shifts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_shifts));

  /// Create a copy of DailyShiftData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyShiftDataImplCopyWith<_$DailyShiftDataImpl> get copyWith =>
      __$$DailyShiftDataImplCopyWithImpl<_$DailyShiftDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyShiftDataImplToJson(
      this,
    );
  }
}

abstract class _DailyShiftData extends DailyShiftData {
  const factory _DailyShiftData(
      {required final String date,
      @JsonKey(defaultValue: <ShiftWithRequests>[])
      required final List<ShiftWithRequests> shifts}) = _$DailyShiftDataImpl;
  const _DailyShiftData._() : super._();

  factory _DailyShiftData.fromJson(Map<String, dynamic> json) =
      _$DailyShiftDataImpl.fromJson;

  /// Date in yyyy-MM-dd format
  @override
  String get date;
  @override
  @JsonKey(defaultValue: <ShiftWithRequests>[])
  List<ShiftWithRequests> get shifts;

  /// Create a copy of DailyShiftData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyShiftDataImplCopyWith<_$DailyShiftDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShiftWithRequests _$ShiftWithRequestsFromJson(Map<String, dynamic> json) {
  return _ShiftWithRequests.fromJson(json);
}

/// @nodoc
mixin _$ShiftWithRequests {
  Shift get shift => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get pendingRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get approvedRequests => throw _privateConstructorUsedError;

  /// Serializes this ShiftWithRequests to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftWithRequestsCopyWith<ShiftWithRequests> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftWithRequestsCopyWith<$Res> {
  factory $ShiftWithRequestsCopyWith(
          ShiftWithRequests value, $Res Function(ShiftWithRequests) then) =
      _$ShiftWithRequestsCopyWithImpl<$Res, ShiftWithRequests>;
  @useResult
  $Res call(
      {Shift shift,
      @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
      List<ShiftRequest> pendingRequests,
      @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
      List<ShiftRequest> approvedRequests});

  $ShiftCopyWith<$Res> get shift;
}

/// @nodoc
class _$ShiftWithRequestsCopyWithImpl<$Res, $Val extends ShiftWithRequests>
    implements $ShiftWithRequestsCopyWith<$Res> {
  _$ShiftWithRequestsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = null,
    Object? pendingRequests = null,
    Object? approvedRequests = null,
  }) {
    return _then(_value.copyWith(
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as Shift,
      pendingRequests: null == pendingRequests
          ? _value.pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as List<ShiftRequest>,
      approvedRequests: null == approvedRequests
          ? _value.approvedRequests
          : approvedRequests // ignore: cast_nullable_to_non_nullable
              as List<ShiftRequest>,
    ) as $Val);
  }

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftCopyWith<$Res> get shift {
    return $ShiftCopyWith<$Res>(_value.shift, (value) {
      return _then(_value.copyWith(shift: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftWithRequestsImplCopyWith<$Res>
    implements $ShiftWithRequestsCopyWith<$Res> {
  factory _$$ShiftWithRequestsImplCopyWith(_$ShiftWithRequestsImpl value,
          $Res Function(_$ShiftWithRequestsImpl) then) =
      __$$ShiftWithRequestsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Shift shift,
      @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
      List<ShiftRequest> pendingRequests,
      @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
      List<ShiftRequest> approvedRequests});

  @override
  $ShiftCopyWith<$Res> get shift;
}

/// @nodoc
class __$$ShiftWithRequestsImplCopyWithImpl<$Res>
    extends _$ShiftWithRequestsCopyWithImpl<$Res, _$ShiftWithRequestsImpl>
    implements _$$ShiftWithRequestsImplCopyWith<$Res> {
  __$$ShiftWithRequestsImplCopyWithImpl(_$ShiftWithRequestsImpl _value,
      $Res Function(_$ShiftWithRequestsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = null,
    Object? pendingRequests = null,
    Object? approvedRequests = null,
  }) {
    return _then(_$ShiftWithRequestsImpl(
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as Shift,
      pendingRequests: null == pendingRequests
          ? _value._pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as List<ShiftRequest>,
      approvedRequests: null == approvedRequests
          ? _value._approvedRequests
          : approvedRequests // ignore: cast_nullable_to_non_nullable
              as List<ShiftRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftWithRequestsImpl extends _ShiftWithRequests {
  const _$ShiftWithRequestsImpl(
      {required this.shift,
      @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
      required final List<ShiftRequest> pendingRequests,
      @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
      required final List<ShiftRequest> approvedRequests})
      : _pendingRequests = pendingRequests,
        _approvedRequests = approvedRequests,
        super._();

  factory _$ShiftWithRequestsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftWithRequestsImplFromJson(json);

  @override
  final Shift shift;
  final List<ShiftRequest> _pendingRequests;
  @override
  @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get pendingRequests {
    if (_pendingRequests is EqualUnmodifiableListView) return _pendingRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingRequests);
  }

  final List<ShiftRequest> _approvedRequests;
  @override
  @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get approvedRequests {
    if (_approvedRequests is EqualUnmodifiableListView)
      return _approvedRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_approvedRequests);
  }

  @override
  String toString() {
    return 'ShiftWithRequests(shift: $shift, pendingRequests: $pendingRequests, approvedRequests: $approvedRequests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftWithRequestsImpl &&
            (identical(other.shift, shift) || other.shift == shift) &&
            const DeepCollectionEquality()
                .equals(other._pendingRequests, _pendingRequests) &&
            const DeepCollectionEquality()
                .equals(other._approvedRequests, _approvedRequests));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shift,
      const DeepCollectionEquality().hash(_pendingRequests),
      const DeepCollectionEquality().hash(_approvedRequests));

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftWithRequestsImplCopyWith<_$ShiftWithRequestsImpl> get copyWith =>
      __$$ShiftWithRequestsImplCopyWithImpl<_$ShiftWithRequestsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftWithRequestsImplToJson(
      this,
    );
  }
}

abstract class _ShiftWithRequests extends ShiftWithRequests {
  const factory _ShiftWithRequests(
          {required final Shift shift,
          @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
          required final List<ShiftRequest> pendingRequests,
          @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
          required final List<ShiftRequest> approvedRequests}) =
      _$ShiftWithRequestsImpl;
  const _ShiftWithRequests._() : super._();

  factory _ShiftWithRequests.fromJson(Map<String, dynamic> json) =
      _$ShiftWithRequestsImpl.fromJson;

  @override
  Shift get shift;
  @override
  @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get pendingRequests;
  @override
  @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
  List<ShiftRequest> get approvedRequests;

  /// Create a copy of ShiftWithRequests
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftWithRequestsImplCopyWith<_$ShiftWithRequestsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
