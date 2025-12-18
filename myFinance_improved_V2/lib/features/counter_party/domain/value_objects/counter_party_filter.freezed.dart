// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CounterPartyFilter _$CounterPartyFilterFromJson(Map<String, dynamic> json) {
  return _CounterPartyFilter.fromJson(json);
}

/// @nodoc
mixin _$CounterPartyFilter {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<CounterPartyType>? get types => throw _privateConstructorUsedError;
  CounterPartySortOption get sortBy => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;
  bool? get isInternal => throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  bool get includeDeleted => throw _privateConstructorUsedError;

  /// Serializes this CounterPartyFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyFilterCopyWith<CounterPartyFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyFilterCopyWith<$Res> {
  factory $CounterPartyFilterCopyWith(
          CounterPartyFilter value, $Res Function(CounterPartyFilter) then) =
      _$CounterPartyFilterCopyWithImpl<$Res, CounterPartyFilter>;
  @useResult
  $Res call(
      {String? searchQuery,
      List<CounterPartyType>? types,
      CounterPartySortOption sortBy,
      bool ascending,
      bool? isInternal,
      DateTime? createdAfter,
      DateTime? createdBefore,
      bool includeDeleted});
}

/// @nodoc
class _$CounterPartyFilterCopyWithImpl<$Res, $Val extends CounterPartyFilter>
    implements $CounterPartyFilterCopyWith<$Res> {
  _$CounterPartyFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? types = freezed,
    Object? sortBy = null,
    Object? ascending = null,
    Object? isInternal = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? includeDeleted = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyType>?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as CounterPartySortOption,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      includeDeleted: null == includeDeleted
          ? _value.includeDeleted
          : includeDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyFilterImplCopyWith<$Res>
    implements $CounterPartyFilterCopyWith<$Res> {
  factory _$$CounterPartyFilterImplCopyWith(_$CounterPartyFilterImpl value,
          $Res Function(_$CounterPartyFilterImpl) then) =
      __$$CounterPartyFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? searchQuery,
      List<CounterPartyType>? types,
      CounterPartySortOption sortBy,
      bool ascending,
      bool? isInternal,
      DateTime? createdAfter,
      DateTime? createdBefore,
      bool includeDeleted});
}

/// @nodoc
class __$$CounterPartyFilterImplCopyWithImpl<$Res>
    extends _$CounterPartyFilterCopyWithImpl<$Res, _$CounterPartyFilterImpl>
    implements _$$CounterPartyFilterImplCopyWith<$Res> {
  __$$CounterPartyFilterImplCopyWithImpl(_$CounterPartyFilterImpl _value,
      $Res Function(_$CounterPartyFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? types = freezed,
    Object? sortBy = null,
    Object? ascending = null,
    Object? isInternal = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? includeDeleted = null,
  }) {
    return _then(_$CounterPartyFilterImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyType>?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as CounterPartySortOption,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      includeDeleted: null == includeDeleted
          ? _value.includeDeleted
          : includeDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyFilterImpl implements _CounterPartyFilter {
  const _$CounterPartyFilterImpl(
      {this.searchQuery,
      final List<CounterPartyType>? types,
      this.sortBy = CounterPartySortOption.isInternal,
      this.ascending = false,
      this.isInternal,
      this.createdAfter,
      this.createdBefore,
      this.includeDeleted = true})
      : _types = types;

  factory _$CounterPartyFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyFilterImplFromJson(json);

  @override
  final String? searchQuery;
  final List<CounterPartyType>? _types;
  @override
  List<CounterPartyType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final CounterPartySortOption sortBy;
  @override
  @JsonKey()
  final bool ascending;
  @override
  final bool? isInternal;
  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  @JsonKey()
  final bool includeDeleted;

  @override
  String toString() {
    return 'CounterPartyFilter(searchQuery: $searchQuery, types: $types, sortBy: $sortBy, ascending: $ascending, isInternal: $isInternal, createdAfter: $createdAfter, createdBefore: $createdBefore, includeDeleted: $includeDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyFilterImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.includeDeleted, includeDeleted) ||
                other.includeDeleted == includeDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_types),
      sortBy,
      ascending,
      isInternal,
      createdAfter,
      createdBefore,
      includeDeleted);

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyFilterImplCopyWith<_$CounterPartyFilterImpl> get copyWith =>
      __$$CounterPartyFilterImplCopyWithImpl<_$CounterPartyFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyFilterImplToJson(
      this,
    );
  }
}

abstract class _CounterPartyFilter implements CounterPartyFilter {
  const factory _CounterPartyFilter(
      {final String? searchQuery,
      final List<CounterPartyType>? types,
      final CounterPartySortOption sortBy,
      final bool ascending,
      final bool? isInternal,
      final DateTime? createdAfter,
      final DateTime? createdBefore,
      final bool includeDeleted}) = _$CounterPartyFilterImpl;

  factory _CounterPartyFilter.fromJson(Map<String, dynamic> json) =
      _$CounterPartyFilterImpl.fromJson;

  @override
  String? get searchQuery;
  @override
  List<CounterPartyType>? get types;
  @override
  CounterPartySortOption get sortBy;
  @override
  bool get ascending;
  @override
  bool? get isInternal;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  bool get includeDeleted;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyFilterImplCopyWith<_$CounterPartyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
