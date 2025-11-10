// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_shift_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyShiftStatusModel _$MonthlyShiftStatusModelFromJson(
    Map<String, dynamic> json) {
  return _MonthlyShiftStatusModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlyShiftStatusModel {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_registered')
  int get totalRegistered => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_registered_by_me')
  bool get isRegisteredByMe => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_request_id')
  String? get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_other_staffs')
  int get totalOtherStaffs => throw _privateConstructorUsedError;
  @JsonKey(name: 'other_staffs')
  List<Map<String, dynamic>> get otherStaffs =>
      throw _privateConstructorUsedError;

  /// Serializes this MonthlyShiftStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyShiftStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyShiftStatusModelCopyWith<MonthlyShiftStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyShiftStatusModelCopyWith<$Res> {
  factory $MonthlyShiftStatusModelCopyWith(MonthlyShiftStatusModel value,
          $Res Function(MonthlyShiftStatusModel) then) =
      _$MonthlyShiftStatusModelCopyWithImpl<$Res, MonthlyShiftStatusModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'total_registered') int totalRegistered,
      @JsonKey(name: 'is_registered_by_me') bool isRegisteredByMe,
      @JsonKey(name: 'shift_request_id') String? shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'total_other_staffs') int totalOtherStaffs,
      @JsonKey(name: 'other_staffs') List<Map<String, dynamic>> otherStaffs});
}

/// @nodoc
class _$MonthlyShiftStatusModelCopyWithImpl<$Res,
        $Val extends MonthlyShiftStatusModel>
    implements $MonthlyShiftStatusModelCopyWith<$Res> {
  _$MonthlyShiftStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyShiftStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftId = null,
    Object? requestDate = null,
    Object? totalRegistered = null,
    Object? isRegisteredByMe = null,
    Object? shiftRequestId = freezed,
    Object? isApproved = null,
    Object? totalOtherStaffs = null,
    Object? otherStaffs = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalRegistered: null == totalRegistered
          ? _value.totalRegistered
          : totalRegistered // ignore: cast_nullable_to_non_nullable
              as int,
      isRegisteredByMe: null == isRegisteredByMe
          ? _value.isRegisteredByMe
          : isRegisteredByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      totalOtherStaffs: null == totalOtherStaffs
          ? _value.totalOtherStaffs
          : totalOtherStaffs // ignore: cast_nullable_to_non_nullable
              as int,
      otherStaffs: null == otherStaffs
          ? _value.otherStaffs
          : otherStaffs // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyShiftStatusModelImplCopyWith<$Res>
    implements $MonthlyShiftStatusModelCopyWith<$Res> {
  factory _$$MonthlyShiftStatusModelImplCopyWith(
          _$MonthlyShiftStatusModelImpl value,
          $Res Function(_$MonthlyShiftStatusModelImpl) then) =
      __$$MonthlyShiftStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'total_registered') int totalRegistered,
      @JsonKey(name: 'is_registered_by_me') bool isRegisteredByMe,
      @JsonKey(name: 'shift_request_id') String? shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'total_other_staffs') int totalOtherStaffs,
      @JsonKey(name: 'other_staffs') List<Map<String, dynamic>> otherStaffs});
}

/// @nodoc
class __$$MonthlyShiftStatusModelImplCopyWithImpl<$Res>
    extends _$MonthlyShiftStatusModelCopyWithImpl<$Res,
        _$MonthlyShiftStatusModelImpl>
    implements _$$MonthlyShiftStatusModelImplCopyWith<$Res> {
  __$$MonthlyShiftStatusModelImplCopyWithImpl(
      _$MonthlyShiftStatusModelImpl _value,
      $Res Function(_$MonthlyShiftStatusModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyShiftStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftId = null,
    Object? requestDate = null,
    Object? totalRegistered = null,
    Object? isRegisteredByMe = null,
    Object? shiftRequestId = freezed,
    Object? isApproved = null,
    Object? totalOtherStaffs = null,
    Object? otherStaffs = null,
  }) {
    return _then(_$MonthlyShiftStatusModelImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalRegistered: null == totalRegistered
          ? _value.totalRegistered
          : totalRegistered // ignore: cast_nullable_to_non_nullable
              as int,
      isRegisteredByMe: null == isRegisteredByMe
          ? _value.isRegisteredByMe
          : isRegisteredByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      totalOtherStaffs: null == totalOtherStaffs
          ? _value.totalOtherStaffs
          : totalOtherStaffs // ignore: cast_nullable_to_non_nullable
              as int,
      otherStaffs: null == otherStaffs
          ? _value._otherStaffs
          : otherStaffs // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyShiftStatusModelImpl extends _MonthlyShiftStatusModel {
  const _$MonthlyShiftStatusModelImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'shift_id') required this.shiftId,
      @JsonKey(name: 'request_date') required this.requestDate,
      @JsonKey(name: 'total_registered') required this.totalRegistered,
      @JsonKey(name: 'is_registered_by_me') required this.isRegisteredByMe,
      @JsonKey(name: 'shift_request_id') this.shiftRequestId,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'total_other_staffs') required this.totalOtherStaffs,
      @JsonKey(name: 'other_staffs')
      required final List<Map<String, dynamic>> otherStaffs})
      : _otherStaffs = otherStaffs,
        super._();

  factory _$MonthlyShiftStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyShiftStatusModelImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;
  @override
  @JsonKey(name: 'total_registered')
  final int totalRegistered;
  @override
  @JsonKey(name: 'is_registered_by_me')
  final bool isRegisteredByMe;
  @override
  @JsonKey(name: 'shift_request_id')
  final String? shiftRequestId;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'total_other_staffs')
  final int totalOtherStaffs;
  final List<Map<String, dynamic>> _otherStaffs;
  @override
  @JsonKey(name: 'other_staffs')
  List<Map<String, dynamic>> get otherStaffs {
    if (_otherStaffs is EqualUnmodifiableListView) return _otherStaffs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_otherStaffs);
  }

  @override
  String toString() {
    return 'MonthlyShiftStatusModel(storeId: $storeId, shiftId: $shiftId, requestDate: $requestDate, totalRegistered: $totalRegistered, isRegisteredByMe: $isRegisteredByMe, shiftRequestId: $shiftRequestId, isApproved: $isApproved, totalOtherStaffs: $totalOtherStaffs, otherStaffs: $otherStaffs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyShiftStatusModelImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.totalRegistered, totalRegistered) ||
                other.totalRegistered == totalRegistered) &&
            (identical(other.isRegisteredByMe, isRegisteredByMe) ||
                other.isRegisteredByMe == isRegisteredByMe) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.totalOtherStaffs, totalOtherStaffs) ||
                other.totalOtherStaffs == totalOtherStaffs) &&
            const DeepCollectionEquality()
                .equals(other._otherStaffs, _otherStaffs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      shiftId,
      requestDate,
      totalRegistered,
      isRegisteredByMe,
      shiftRequestId,
      isApproved,
      totalOtherStaffs,
      const DeepCollectionEquality().hash(_otherStaffs));

  /// Create a copy of MonthlyShiftStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyShiftStatusModelImplCopyWith<_$MonthlyShiftStatusModelImpl>
      get copyWith => __$$MonthlyShiftStatusModelImplCopyWithImpl<
          _$MonthlyShiftStatusModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyShiftStatusModelImplToJson(
      this,
    );
  }
}

abstract class _MonthlyShiftStatusModel extends MonthlyShiftStatusModel {
  const factory _MonthlyShiftStatusModel(
      {@JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'shift_id') required final String shiftId,
      @JsonKey(name: 'request_date') required final String requestDate,
      @JsonKey(name: 'total_registered') required final int totalRegistered,
      @JsonKey(name: 'is_registered_by_me')
      required final bool isRegisteredByMe,
      @JsonKey(name: 'shift_request_id') final String? shiftRequestId,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'total_other_staffs') required final int totalOtherStaffs,
      @JsonKey(name: 'other_staffs')
      required final List<Map<String, dynamic>>
          otherStaffs}) = _$MonthlyShiftStatusModelImpl;
  const _MonthlyShiftStatusModel._() : super._();

  factory _MonthlyShiftStatusModel.fromJson(Map<String, dynamic> json) =
      _$MonthlyShiftStatusModelImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;
  @override
  @JsonKey(name: 'total_registered')
  int get totalRegistered;
  @override
  @JsonKey(name: 'is_registered_by_me')
  bool get isRegisteredByMe;
  @override
  @JsonKey(name: 'shift_request_id')
  String? get shiftRequestId;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'total_other_staffs')
  int get totalOtherStaffs;
  @override
  @JsonKey(name: 'other_staffs')
  List<Map<String, dynamic>> get otherStaffs;

  /// Create a copy of MonthlyShiftStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyShiftStatusModelImplCopyWith<_$MonthlyShiftStatusModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
