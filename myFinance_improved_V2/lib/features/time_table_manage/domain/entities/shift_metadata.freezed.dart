// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftMetadata _$ShiftMetadataFromJson(Map<String, dynamic> json) {
  return _ShiftMetadata.fromJson(json);
}

/// @nodoc
mixin _$ShiftMetadata {
  @JsonKey(name: 'available_tags', defaultValue: <String>[])
  List<String> get availableTags => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this ShiftMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftMetadataCopyWith<ShiftMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftMetadataCopyWith<$Res> {
  factory $ShiftMetadataCopyWith(
          ShiftMetadata value, $Res Function(ShiftMetadata) then) =
      _$ShiftMetadataCopyWithImpl<$Res, ShiftMetadata>;
  @useResult
  $Res call(
      {@JsonKey(name: 'available_tags', defaultValue: <String>[])
      List<String> availableTags,
      @JsonKey(defaultValue: <String, dynamic>{}) Map<String, dynamic> settings,
      @JsonKey(name: 'last_updated') DateTime? lastUpdated});
}

/// @nodoc
class _$ShiftMetadataCopyWithImpl<$Res, $Val extends ShiftMetadata>
    implements $ShiftMetadataCopyWith<$Res> {
  _$ShiftMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableTags = null,
    Object? settings = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      availableTags: null == availableTags
          ? _value.availableTags
          : availableTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftMetadataImplCopyWith<$Res>
    implements $ShiftMetadataCopyWith<$Res> {
  factory _$$ShiftMetadataImplCopyWith(
          _$ShiftMetadataImpl value, $Res Function(_$ShiftMetadataImpl) then) =
      __$$ShiftMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'available_tags', defaultValue: <String>[])
      List<String> availableTags,
      @JsonKey(defaultValue: <String, dynamic>{}) Map<String, dynamic> settings,
      @JsonKey(name: 'last_updated') DateTime? lastUpdated});
}

/// @nodoc
class __$$ShiftMetadataImplCopyWithImpl<$Res>
    extends _$ShiftMetadataCopyWithImpl<$Res, _$ShiftMetadataImpl>
    implements _$$ShiftMetadataImplCopyWith<$Res> {
  __$$ShiftMetadataImplCopyWithImpl(
      _$ShiftMetadataImpl _value, $Res Function(_$ShiftMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableTags = null,
    Object? settings = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$ShiftMetadataImpl(
      availableTags: null == availableTags
          ? _value._availableTags
          : availableTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftMetadataImpl extends _ShiftMetadata {
  const _$ShiftMetadataImpl(
      {@JsonKey(name: 'available_tags', defaultValue: <String>[])
      required final List<String> availableTags,
      @JsonKey(defaultValue: <String, dynamic>{})
      required final Map<String, dynamic> settings,
      @JsonKey(name: 'last_updated') this.lastUpdated})
      : _availableTags = availableTags,
        _settings = settings,
        super._();

  factory _$ShiftMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftMetadataImplFromJson(json);

  final List<String> _availableTags;
  @override
  @JsonKey(name: 'available_tags', defaultValue: <String>[])
  List<String> get availableTags {
    if (_availableTags is EqualUnmodifiableListView) return _availableTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTags);
  }

  final Map<String, dynamic> _settings;
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'ShiftMetadata(availableTags: $availableTags, settings: $settings, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftMetadataImpl &&
            const DeepCollectionEquality()
                .equals(other._availableTags, _availableTags) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availableTags),
      const DeepCollectionEquality().hash(_settings),
      lastUpdated);

  /// Create a copy of ShiftMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftMetadataImplCopyWith<_$ShiftMetadataImpl> get copyWith =>
      __$$ShiftMetadataImplCopyWithImpl<_$ShiftMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftMetadataImplToJson(
      this,
    );
  }
}

abstract class _ShiftMetadata extends ShiftMetadata {
  const factory _ShiftMetadata(
          {@JsonKey(name: 'available_tags', defaultValue: <String>[])
          required final List<String> availableTags,
          @JsonKey(defaultValue: <String, dynamic>{})
          required final Map<String, dynamic> settings,
          @JsonKey(name: 'last_updated') final DateTime? lastUpdated}) =
      _$ShiftMetadataImpl;
  const _ShiftMetadata._() : super._();

  factory _ShiftMetadata.fromJson(Map<String, dynamic> json) =
      _$ShiftMetadataImpl.fromJson;

  @override
  @JsonKey(name: 'available_tags', defaultValue: <String>[])
  List<String> get availableTags;
  @override
  @JsonKey(defaultValue: <String, dynamic>{})
  Map<String, dynamic> get settings;
  @override
  @JsonKey(name: 'last_updated')
  DateTime? get lastUpdated;

  /// Create a copy of ShiftMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftMetadataImplCopyWith<_$ShiftMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
