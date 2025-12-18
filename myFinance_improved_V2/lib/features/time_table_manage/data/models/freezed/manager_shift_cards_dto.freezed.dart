// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_shift_cards_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagerShiftCardsDto _$ManagerShiftCardsDtoFromJson(Map<String, dynamic> json) {
  return _ManagerShiftCardsDto.fromJson(json);
}

/// @nodoc
mixin _$ManagerShiftCardsDto {
  @JsonKey(name: 'available_contents')
  List<AvailableContentDto> get availableContents =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'stores')
  List<StoreCardsDto> get stores => throw _privateConstructorUsedError;

  /// Serializes this ManagerShiftCardsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerShiftCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerShiftCardsDtoCopyWith<ManagerShiftCardsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerShiftCardsDtoCopyWith<$Res> {
  factory $ManagerShiftCardsDtoCopyWith(ManagerShiftCardsDto value,
          $Res Function(ManagerShiftCardsDto) then) =
      _$ManagerShiftCardsDtoCopyWithImpl<$Res, ManagerShiftCardsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'available_contents')
      List<AvailableContentDto> availableContents,
      @JsonKey(name: 'stores') List<StoreCardsDto> stores});
}

/// @nodoc
class _$ManagerShiftCardsDtoCopyWithImpl<$Res,
        $Val extends ManagerShiftCardsDto>
    implements $ManagerShiftCardsDtoCopyWith<$Res> {
  _$ManagerShiftCardsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerShiftCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableContents = null,
    Object? stores = null,
  }) {
    return _then(_value.copyWith(
      availableContents: null == availableContents
          ? _value.availableContents
          : availableContents // ignore: cast_nullable_to_non_nullable
              as List<AvailableContentDto>,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StoreCardsDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerShiftCardsDtoImplCopyWith<$Res>
    implements $ManagerShiftCardsDtoCopyWith<$Res> {
  factory _$$ManagerShiftCardsDtoImplCopyWith(_$ManagerShiftCardsDtoImpl value,
          $Res Function(_$ManagerShiftCardsDtoImpl) then) =
      __$$ManagerShiftCardsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'available_contents')
      List<AvailableContentDto> availableContents,
      @JsonKey(name: 'stores') List<StoreCardsDto> stores});
}

/// @nodoc
class __$$ManagerShiftCardsDtoImplCopyWithImpl<$Res>
    extends _$ManagerShiftCardsDtoCopyWithImpl<$Res, _$ManagerShiftCardsDtoImpl>
    implements _$$ManagerShiftCardsDtoImplCopyWith<$Res> {
  __$$ManagerShiftCardsDtoImplCopyWithImpl(_$ManagerShiftCardsDtoImpl _value,
      $Res Function(_$ManagerShiftCardsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerShiftCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableContents = null,
    Object? stores = null,
  }) {
    return _then(_$ManagerShiftCardsDtoImpl(
      availableContents: null == availableContents
          ? _value._availableContents
          : availableContents // ignore: cast_nullable_to_non_nullable
              as List<AvailableContentDto>,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StoreCardsDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerShiftCardsDtoImpl implements _ManagerShiftCardsDto {
  const _$ManagerShiftCardsDtoImpl(
      {@JsonKey(name: 'available_contents')
      final List<AvailableContentDto> availableContents = const [],
      @JsonKey(name: 'stores') final List<StoreCardsDto> stores = const []})
      : _availableContents = availableContents,
        _stores = stores;

  factory _$ManagerShiftCardsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerShiftCardsDtoImplFromJson(json);

  final List<AvailableContentDto> _availableContents;
  @override
  @JsonKey(name: 'available_contents')
  List<AvailableContentDto> get availableContents {
    if (_availableContents is EqualUnmodifiableListView)
      return _availableContents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableContents);
  }

  final List<StoreCardsDto> _stores;
  @override
  @JsonKey(name: 'stores')
  List<StoreCardsDto> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @override
  String toString() {
    return 'ManagerShiftCardsDto(availableContents: $availableContents, stores: $stores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerShiftCardsDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._availableContents, _availableContents) &&
            const DeepCollectionEquality().equals(other._stores, _stores));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availableContents),
      const DeepCollectionEquality().hash(_stores));

  /// Create a copy of ManagerShiftCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerShiftCardsDtoImplCopyWith<_$ManagerShiftCardsDtoImpl>
      get copyWith =>
          __$$ManagerShiftCardsDtoImplCopyWithImpl<_$ManagerShiftCardsDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerShiftCardsDtoImplToJson(
      this,
    );
  }
}

abstract class _ManagerShiftCardsDto implements ManagerShiftCardsDto {
  const factory _ManagerShiftCardsDto(
          {@JsonKey(name: 'available_contents')
          final List<AvailableContentDto> availableContents,
          @JsonKey(name: 'stores') final List<StoreCardsDto> stores}) =
      _$ManagerShiftCardsDtoImpl;

  factory _ManagerShiftCardsDto.fromJson(Map<String, dynamic> json) =
      _$ManagerShiftCardsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'available_contents')
  List<AvailableContentDto> get availableContents;
  @override
  @JsonKey(name: 'stores')
  List<StoreCardsDto> get stores;

  /// Create a copy of ManagerShiftCardsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerShiftCardsDtoImplCopyWith<_$ManagerShiftCardsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
