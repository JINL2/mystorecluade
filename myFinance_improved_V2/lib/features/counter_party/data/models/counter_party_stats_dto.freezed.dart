// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CounterPartyStatsDto _$CounterPartyStatsDtoFromJson(Map<String, dynamic> json) {
  return _CounterPartyStatsDto.fromJson(json);
}

/// @nodoc
mixin _$CounterPartyStatsDto {
  int get total => throw _privateConstructorUsedError;
  int get suppliers => throw _privateConstructorUsedError;
  int get customers => throw _privateConstructorUsedError;
  int get employees => throw _privateConstructorUsedError;
  int get teamMembers => throw _privateConstructorUsedError;
  int get myCompanies => throw _privateConstructorUsedError;
  int get others => throw _privateConstructorUsedError;
  int get activeCount => throw _privateConstructorUsedError;
  int get inactiveCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_additions')
  List<CounterPartyDto> get recentAdditions =>
      throw _privateConstructorUsedError;

  /// Serializes this CounterPartyStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyStatsDtoCopyWith<CounterPartyStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyStatsDtoCopyWith<$Res> {
  factory $CounterPartyStatsDtoCopyWith(CounterPartyStatsDto value,
          $Res Function(CounterPartyStatsDto) then) =
      _$CounterPartyStatsDtoCopyWithImpl<$Res, CounterPartyStatsDto>;
  @useResult
  $Res call(
      {int total,
      int suppliers,
      int customers,
      int employees,
      int teamMembers,
      int myCompanies,
      int others,
      int activeCount,
      int inactiveCount,
      @JsonKey(name: 'recent_additions')
      List<CounterPartyDto> recentAdditions});
}

/// @nodoc
class _$CounterPartyStatsDtoCopyWithImpl<$Res,
        $Val extends CounterPartyStatsDto>
    implements $CounterPartyStatsDtoCopyWith<$Res> {
  _$CounterPartyStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? suppliers = null,
    Object? customers = null,
    Object? employees = null,
    Object? teamMembers = null,
    Object? myCompanies = null,
    Object? others = null,
    Object? activeCount = null,
    Object? inactiveCount = null,
    Object? recentAdditions = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      suppliers: null == suppliers
          ? _value.suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as int,
      customers: null == customers
          ? _value.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as int,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as int,
      teamMembers: null == teamMembers
          ? _value.teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as int,
      myCompanies: null == myCompanies
          ? _value.myCompanies
          : myCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      others: null == others
          ? _value.others
          : others // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveCount: null == inactiveCount
          ? _value.inactiveCount
          : inactiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentAdditions: null == recentAdditions
          ? _value.recentAdditions
          : recentAdditions // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyStatsDtoImplCopyWith<$Res>
    implements $CounterPartyStatsDtoCopyWith<$Res> {
  factory _$$CounterPartyStatsDtoImplCopyWith(_$CounterPartyStatsDtoImpl value,
          $Res Function(_$CounterPartyStatsDtoImpl) then) =
      __$$CounterPartyStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int suppliers,
      int customers,
      int employees,
      int teamMembers,
      int myCompanies,
      int others,
      int activeCount,
      int inactiveCount,
      @JsonKey(name: 'recent_additions')
      List<CounterPartyDto> recentAdditions});
}

/// @nodoc
class __$$CounterPartyStatsDtoImplCopyWithImpl<$Res>
    extends _$CounterPartyStatsDtoCopyWithImpl<$Res, _$CounterPartyStatsDtoImpl>
    implements _$$CounterPartyStatsDtoImplCopyWith<$Res> {
  __$$CounterPartyStatsDtoImplCopyWithImpl(_$CounterPartyStatsDtoImpl _value,
      $Res Function(_$CounterPartyStatsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? suppliers = null,
    Object? customers = null,
    Object? employees = null,
    Object? teamMembers = null,
    Object? myCompanies = null,
    Object? others = null,
    Object? activeCount = null,
    Object? inactiveCount = null,
    Object? recentAdditions = null,
  }) {
    return _then(_$CounterPartyStatsDtoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      suppliers: null == suppliers
          ? _value.suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as int,
      customers: null == customers
          ? _value.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as int,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as int,
      teamMembers: null == teamMembers
          ? _value.teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as int,
      myCompanies: null == myCompanies
          ? _value.myCompanies
          : myCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      others: null == others
          ? _value.others
          : others // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveCount: null == inactiveCount
          ? _value.inactiveCount
          : inactiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentAdditions: null == recentAdditions
          ? _value._recentAdditions
          : recentAdditions // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyStatsDtoImpl extends _CounterPartyStatsDto {
  const _$CounterPartyStatsDtoImpl(
      {required this.total,
      required this.suppliers,
      required this.customers,
      required this.employees,
      required this.teamMembers,
      required this.myCompanies,
      required this.others,
      required this.activeCount,
      required this.inactiveCount,
      @JsonKey(name: 'recent_additions')
      required final List<CounterPartyDto> recentAdditions})
      : _recentAdditions = recentAdditions,
        super._();

  factory _$CounterPartyStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyStatsDtoImplFromJson(json);

  @override
  final int total;
  @override
  final int suppliers;
  @override
  final int customers;
  @override
  final int employees;
  @override
  final int teamMembers;
  @override
  final int myCompanies;
  @override
  final int others;
  @override
  final int activeCount;
  @override
  final int inactiveCount;
  final List<CounterPartyDto> _recentAdditions;
  @override
  @JsonKey(name: 'recent_additions')
  List<CounterPartyDto> get recentAdditions {
    if (_recentAdditions is EqualUnmodifiableListView) return _recentAdditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAdditions);
  }

  @override
  String toString() {
    return 'CounterPartyStatsDto(total: $total, suppliers: $suppliers, customers: $customers, employees: $employees, teamMembers: $teamMembers, myCompanies: $myCompanies, others: $others, activeCount: $activeCount, inactiveCount: $inactiveCount, recentAdditions: $recentAdditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyStatsDtoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.suppliers, suppliers) ||
                other.suppliers == suppliers) &&
            (identical(other.customers, customers) ||
                other.customers == customers) &&
            (identical(other.employees, employees) ||
                other.employees == employees) &&
            (identical(other.teamMembers, teamMembers) ||
                other.teamMembers == teamMembers) &&
            (identical(other.myCompanies, myCompanies) ||
                other.myCompanies == myCompanies) &&
            (identical(other.others, others) || other.others == others) &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount) &&
            (identical(other.inactiveCount, inactiveCount) ||
                other.inactiveCount == inactiveCount) &&
            const DeepCollectionEquality()
                .equals(other._recentAdditions, _recentAdditions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      suppliers,
      customers,
      employees,
      teamMembers,
      myCompanies,
      others,
      activeCount,
      inactiveCount,
      const DeepCollectionEquality().hash(_recentAdditions));

  /// Create a copy of CounterPartyStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyStatsDtoImplCopyWith<_$CounterPartyStatsDtoImpl>
      get copyWith =>
          __$$CounterPartyStatsDtoImplCopyWithImpl<_$CounterPartyStatsDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _CounterPartyStatsDto extends CounterPartyStatsDto {
  const factory _CounterPartyStatsDto(
          {required final int total,
          required final int suppliers,
          required final int customers,
          required final int employees,
          required final int teamMembers,
          required final int myCompanies,
          required final int others,
          required final int activeCount,
          required final int inactiveCount,
          @JsonKey(name: 'recent_additions')
          required final List<CounterPartyDto> recentAdditions}) =
      _$CounterPartyStatsDtoImpl;
  const _CounterPartyStatsDto._() : super._();

  factory _CounterPartyStatsDto.fromJson(Map<String, dynamic> json) =
      _$CounterPartyStatsDtoImpl.fromJson;

  @override
  int get total;
  @override
  int get suppliers;
  @override
  int get customers;
  @override
  int get employees;
  @override
  int get teamMembers;
  @override
  int get myCompanies;
  @override
  int get others;
  @override
  int get activeCount;
  @override
  int get inactiveCount;
  @override
  @JsonKey(name: 'recent_additions')
  List<CounterPartyDto> get recentAdditions;

  /// Create a copy of CounterPartyStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyStatsDtoImplCopyWith<_$CounterPartyStatsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
