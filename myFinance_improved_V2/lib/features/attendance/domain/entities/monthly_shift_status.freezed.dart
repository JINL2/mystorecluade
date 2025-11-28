// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_shift_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyShiftStatus {
  String get requestDate => throw _privateConstructorUsedError;
  int get totalPending => throw _privateConstructorUsedError;
  int get totalApproved => throw _privateConstructorUsedError;
  List<DailyShift> get shifts => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyShiftStatusCopyWith<MonthlyShiftStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyShiftStatusCopyWith<$Res> {
  factory $MonthlyShiftStatusCopyWith(
          MonthlyShiftStatus value, $Res Function(MonthlyShiftStatus) then) =
      _$MonthlyShiftStatusCopyWithImpl<$Res, MonthlyShiftStatus>;
  @useResult
  $Res call(
      {String requestDate,
      int totalPending,
      int totalApproved,
      List<DailyShift> shifts});
}

/// @nodoc
class _$MonthlyShiftStatusCopyWithImpl<$Res, $Val extends MonthlyShiftStatus>
    implements $MonthlyShiftStatusCopyWith<$Res> {
  _$MonthlyShiftStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? totalPending = null,
    Object? totalApproved = null,
    Object? shifts = null,
  }) {
    return _then(_value.copyWith(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      shifts: null == shifts
          ? _value.shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<DailyShift>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyShiftStatusImplCopyWith<$Res>
    implements $MonthlyShiftStatusCopyWith<$Res> {
  factory _$$MonthlyShiftStatusImplCopyWith(_$MonthlyShiftStatusImpl value,
          $Res Function(_$MonthlyShiftStatusImpl) then) =
      __$$MonthlyShiftStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestDate,
      int totalPending,
      int totalApproved,
      List<DailyShift> shifts});
}

/// @nodoc
class __$$MonthlyShiftStatusImplCopyWithImpl<$Res>
    extends _$MonthlyShiftStatusCopyWithImpl<$Res, _$MonthlyShiftStatusImpl>
    implements _$$MonthlyShiftStatusImplCopyWith<$Res> {
  __$$MonthlyShiftStatusImplCopyWithImpl(_$MonthlyShiftStatusImpl _value,
      $Res Function(_$MonthlyShiftStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? totalPending = null,
    Object? totalApproved = null,
    Object? shifts = null,
  }) {
    return _then(_$MonthlyShiftStatusImpl(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      shifts: null == shifts
          ? _value._shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<DailyShift>,
    ));
  }
}

/// @nodoc

class _$MonthlyShiftStatusImpl extends _MonthlyShiftStatus {
  const _$MonthlyShiftStatusImpl(
      {required this.requestDate,
      this.totalPending = 0,
      this.totalApproved = 0,
      final List<DailyShift> shifts = const []})
      : _shifts = shifts,
        super._();

  @override
  final String requestDate;
  @override
  @JsonKey()
  final int totalPending;
  @override
  @JsonKey()
  final int totalApproved;
  final List<DailyShift> _shifts;
  @override
  @JsonKey()
  List<DailyShift> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  @override
  String toString() {
    return 'MonthlyShiftStatus(requestDate: $requestDate, totalPending: $totalPending, totalApproved: $totalApproved, shifts: $shifts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyShiftStatusImpl &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            const DeepCollectionEquality().equals(other._shifts, _shifts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestDate, totalPending,
      totalApproved, const DeepCollectionEquality().hash(_shifts));

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyShiftStatusImplCopyWith<_$MonthlyShiftStatusImpl> get copyWith =>
      __$$MonthlyShiftStatusImplCopyWithImpl<_$MonthlyShiftStatusImpl>(
          this, _$identity);
}

abstract class _MonthlyShiftStatus extends MonthlyShiftStatus {
  const factory _MonthlyShiftStatus(
      {required final String requestDate,
      final int totalPending,
      final int totalApproved,
      final List<DailyShift> shifts}) = _$MonthlyShiftStatusImpl;
  const _MonthlyShiftStatus._() : super._();

  @override
  String get requestDate;
  @override
  int get totalPending;
  @override
  int get totalApproved;
  @override
  List<DailyShift> get shifts;

  /// Create a copy of MonthlyShiftStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyShiftStatusImplCopyWith<_$MonthlyShiftStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyShift {
  String get shiftId => throw _privateConstructorUsedError;
  String? get shiftName => throw _privateConstructorUsedError;
  String? get shiftType => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  List<EmployeeStatus> get pendingEmployees =>
      throw _privateConstructorUsedError;
  List<EmployeeStatus> get approvedEmployees =>
      throw _privateConstructorUsedError;

  /// Create a copy of DailyShift
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyShiftCopyWith<DailyShift> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyShiftCopyWith<$Res> {
  factory $DailyShiftCopyWith(
          DailyShift value, $Res Function(DailyShift) then) =
      _$DailyShiftCopyWithImpl<$Res, DailyShift>;
  @useResult
  $Res call(
      {String shiftId,
      String? shiftName,
      String? shiftType,
      String? startTime,
      String? endTime,
      List<EmployeeStatus> pendingEmployees,
      List<EmployeeStatus> approvedEmployees});
}

/// @nodoc
class _$DailyShiftCopyWithImpl<$Res, $Val extends DailyShift>
    implements $DailyShiftCopyWith<$Res> {
  _$DailyShiftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyShift
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = freezed,
    Object? shiftType = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? pendingEmployees = null,
    Object? approvedEmployees = null,
  }) {
    return _then(_value.copyWith(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftType: freezed == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingEmployees: null == pendingEmployees
          ? _value.pendingEmployees
          : pendingEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeStatus>,
      approvedEmployees: null == approvedEmployees
          ? _value.approvedEmployees
          : approvedEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeStatus>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyShiftImplCopyWith<$Res>
    implements $DailyShiftCopyWith<$Res> {
  factory _$$DailyShiftImplCopyWith(
          _$DailyShiftImpl value, $Res Function(_$DailyShiftImpl) then) =
      __$$DailyShiftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shiftId,
      String? shiftName,
      String? shiftType,
      String? startTime,
      String? endTime,
      List<EmployeeStatus> pendingEmployees,
      List<EmployeeStatus> approvedEmployees});
}

/// @nodoc
class __$$DailyShiftImplCopyWithImpl<$Res>
    extends _$DailyShiftCopyWithImpl<$Res, _$DailyShiftImpl>
    implements _$$DailyShiftImplCopyWith<$Res> {
  __$$DailyShiftImplCopyWithImpl(
      _$DailyShiftImpl _value, $Res Function(_$DailyShiftImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyShift
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = freezed,
    Object? shiftType = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? pendingEmployees = null,
    Object? approvedEmployees = null,
  }) {
    return _then(_$DailyShiftImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftType: freezed == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingEmployees: null == pendingEmployees
          ? _value._pendingEmployees
          : pendingEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeStatus>,
      approvedEmployees: null == approvedEmployees
          ? _value._approvedEmployees
          : approvedEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeStatus>,
    ));
  }
}

/// @nodoc

class _$DailyShiftImpl extends _DailyShift {
  const _$DailyShiftImpl(
      {required this.shiftId,
      this.shiftName,
      this.shiftType,
      this.startTime,
      this.endTime,
      final List<EmployeeStatus> pendingEmployees = const [],
      final List<EmployeeStatus> approvedEmployees = const []})
      : _pendingEmployees = pendingEmployees,
        _approvedEmployees = approvedEmployees,
        super._();

  @override
  final String shiftId;
  @override
  final String? shiftName;
  @override
  final String? shiftType;
  @override
  final String? startTime;
  @override
  final String? endTime;
  final List<EmployeeStatus> _pendingEmployees;
  @override
  @JsonKey()
  List<EmployeeStatus> get pendingEmployees {
    if (_pendingEmployees is EqualUnmodifiableListView)
      return _pendingEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingEmployees);
  }

  final List<EmployeeStatus> _approvedEmployees;
  @override
  @JsonKey()
  List<EmployeeStatus> get approvedEmployees {
    if (_approvedEmployees is EqualUnmodifiableListView)
      return _approvedEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_approvedEmployees);
  }

  @override
  String toString() {
    return 'DailyShift(shiftId: $shiftId, shiftName: $shiftName, shiftType: $shiftType, startTime: $startTime, endTime: $endTime, pendingEmployees: $pendingEmployees, approvedEmployees: $approvedEmployees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyShiftImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.shiftType, shiftType) ||
                other.shiftType == shiftType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality()
                .equals(other._pendingEmployees, _pendingEmployees) &&
            const DeepCollectionEquality()
                .equals(other._approvedEmployees, _approvedEmployees));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftId,
      shiftName,
      shiftType,
      startTime,
      endTime,
      const DeepCollectionEquality().hash(_pendingEmployees),
      const DeepCollectionEquality().hash(_approvedEmployees));

  /// Create a copy of DailyShift
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyShiftImplCopyWith<_$DailyShiftImpl> get copyWith =>
      __$$DailyShiftImplCopyWithImpl<_$DailyShiftImpl>(this, _$identity);
}

abstract class _DailyShift extends DailyShift {
  const factory _DailyShift(
      {required final String shiftId,
      final String? shiftName,
      final String? shiftType,
      final String? startTime,
      final String? endTime,
      final List<EmployeeStatus> pendingEmployees,
      final List<EmployeeStatus> approvedEmployees}) = _$DailyShiftImpl;
  const _DailyShift._() : super._();

  @override
  String get shiftId;
  @override
  String? get shiftName;
  @override
  String? get shiftType;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override
  List<EmployeeStatus> get pendingEmployees;
  @override
  List<EmployeeStatus> get approvedEmployees;

  /// Create a copy of DailyShift
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyShiftImplCopyWith<_$DailyShiftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EmployeeStatus {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String? get shiftRequestId => throw _privateConstructorUsedError;
  DateTime? get requestTime => throw _privateConstructorUsedError;
  bool? get isApproved => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeStatusCopyWith<EmployeeStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeStatusCopyWith<$Res> {
  factory $EmployeeStatusCopyWith(
          EmployeeStatus value, $Res Function(EmployeeStatus) then) =
      _$EmployeeStatusCopyWithImpl<$Res, EmployeeStatus>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userEmail,
      String? userPhone,
      String? profileImage,
      String? shiftRequestId,
      DateTime? requestTime,
      bool? isApproved,
      String? approvedBy});
}

/// @nodoc
class _$EmployeeStatusCopyWithImpl<$Res, $Val extends EmployeeStatus>
    implements $EmployeeStatusCopyWith<$Res> {
  _$EmployeeStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? profileImage = freezed,
    Object? shiftRequestId = freezed,
    Object? requestTime = freezed,
    Object? isApproved = freezed,
    Object? approvedBy = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestTime: freezed == requestTime
          ? _value.requestTime
          : requestTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isApproved: freezed == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeStatusImplCopyWith<$Res>
    implements $EmployeeStatusCopyWith<$Res> {
  factory _$$EmployeeStatusImplCopyWith(_$EmployeeStatusImpl value,
          $Res Function(_$EmployeeStatusImpl) then) =
      __$$EmployeeStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userEmail,
      String? userPhone,
      String? profileImage,
      String? shiftRequestId,
      DateTime? requestTime,
      bool? isApproved,
      String? approvedBy});
}

/// @nodoc
class __$$EmployeeStatusImplCopyWithImpl<$Res>
    extends _$EmployeeStatusCopyWithImpl<$Res, _$EmployeeStatusImpl>
    implements _$$EmployeeStatusImplCopyWith<$Res> {
  __$$EmployeeStatusImplCopyWithImpl(
      _$EmployeeStatusImpl _value, $Res Function(_$EmployeeStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? profileImage = freezed,
    Object? shiftRequestId = freezed,
    Object? requestTime = freezed,
    Object? isApproved = freezed,
    Object? approvedBy = freezed,
  }) {
    return _then(_$EmployeeStatusImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftRequestId: freezed == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestTime: freezed == requestTime
          ? _value.requestTime
          : requestTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isApproved: freezed == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EmployeeStatusImpl implements _EmployeeStatus {
  const _$EmployeeStatusImpl(
      {required this.userId,
      required this.userName,
      this.userEmail,
      this.userPhone,
      this.profileImage,
      this.shiftRequestId,
      this.requestTime,
      this.isApproved,
      this.approvedBy});

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userEmail;
  @override
  final String? userPhone;
  @override
  final String? profileImage;
  @override
  final String? shiftRequestId;
  @override
  final DateTime? requestTime;
  @override
  final bool? isApproved;
  @override
  final String? approvedBy;

  @override
  String toString() {
    return 'EmployeeStatus(userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, profileImage: $profileImage, shiftRequestId: $shiftRequestId, requestTime: $requestTime, isApproved: $isApproved, approvedBy: $approvedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeStatusImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.requestTime, requestTime) ||
                other.requestTime == requestTime) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      userName,
      userEmail,
      userPhone,
      profileImage,
      shiftRequestId,
      requestTime,
      isApproved,
      approvedBy);

  /// Create a copy of EmployeeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeStatusImplCopyWith<_$EmployeeStatusImpl> get copyWith =>
      __$$EmployeeStatusImplCopyWithImpl<_$EmployeeStatusImpl>(
          this, _$identity);
}

abstract class _EmployeeStatus implements EmployeeStatus {
  const factory _EmployeeStatus(
      {required final String userId,
      required final String userName,
      final String? userEmail,
      final String? userPhone,
      final String? profileImage,
      final String? shiftRequestId,
      final DateTime? requestTime,
      final bool? isApproved,
      final String? approvedBy}) = _$EmployeeStatusImpl;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userEmail;
  @override
  String? get userPhone;
  @override
  String? get profileImage;
  @override
  String? get shiftRequestId;
  @override
  DateTime? get requestTime;
  @override
  bool? get isApproved;
  @override
  String? get approvedBy;

  /// Create a copy of EmployeeStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeStatusImplCopyWith<_$EmployeeStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
