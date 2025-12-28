// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IncotermModel _$IncotermModelFromJson(Map<String, dynamic> json) {
  return _IncotermModel.fromJson(json);
}

/// @nodoc
mixin _$IncotermModel {
  @JsonKey(name: 'incoterm_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'transport_mode')
  String get transportMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_transfer_point')
  String? get riskTransferPoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_transfer_point')
  String? get costTransferPoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'seller_responsibilities')
  List<String> get sellerResponsibilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'buyer_responsibilities')
  List<String> get buyerResponsibilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this IncotermModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncotermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncotermModelCopyWith<IncotermModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncotermModelCopyWith<$Res> {
  factory $IncotermModelCopyWith(
          IncotermModel value, $Res Function(IncotermModel) then) =
      _$IncotermModelCopyWithImpl<$Res, IncotermModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'incoterm_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'transport_mode') String transportMode,
      @JsonKey(name: 'risk_transfer_point') String? riskTransferPoint,
      @JsonKey(name: 'cost_transfer_point') String? costTransferPoint,
      @JsonKey(name: 'seller_responsibilities')
      List<String> sellerResponsibilities,
      @JsonKey(name: 'buyer_responsibilities')
      List<String> buyerResponsibilities,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$IncotermModelCopyWithImpl<$Res, $Val extends IncotermModel>
    implements $IncotermModelCopyWith<$Res> {
  _$IncotermModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncotermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? transportMode = null,
    Object? riskTransferPoint = freezed,
    Object? costTransferPoint = freezed,
    Object? sellerResponsibilities = null,
    Object? buyerResponsibilities = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      transportMode: null == transportMode
          ? _value.transportMode
          : transportMode // ignore: cast_nullable_to_non_nullable
              as String,
      riskTransferPoint: freezed == riskTransferPoint
          ? _value.riskTransferPoint
          : riskTransferPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      costTransferPoint: freezed == costTransferPoint
          ? _value.costTransferPoint
          : costTransferPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerResponsibilities: null == sellerResponsibilities
          ? _value.sellerResponsibilities
          : sellerResponsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      buyerResponsibilities: null == buyerResponsibilities
          ? _value.buyerResponsibilities
          : buyerResponsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncotermModelImplCopyWith<$Res>
    implements $IncotermModelCopyWith<$Res> {
  factory _$$IncotermModelImplCopyWith(
          _$IncotermModelImpl value, $Res Function(_$IncotermModelImpl) then) =
      __$$IncotermModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'incoterm_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'transport_mode') String transportMode,
      @JsonKey(name: 'risk_transfer_point') String? riskTransferPoint,
      @JsonKey(name: 'cost_transfer_point') String? costTransferPoint,
      @JsonKey(name: 'seller_responsibilities')
      List<String> sellerResponsibilities,
      @JsonKey(name: 'buyer_responsibilities')
      List<String> buyerResponsibilities,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$IncotermModelImplCopyWithImpl<$Res>
    extends _$IncotermModelCopyWithImpl<$Res, _$IncotermModelImpl>
    implements _$$IncotermModelImplCopyWith<$Res> {
  __$$IncotermModelImplCopyWithImpl(
      _$IncotermModelImpl _value, $Res Function(_$IncotermModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncotermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? transportMode = null,
    Object? riskTransferPoint = freezed,
    Object? costTransferPoint = freezed,
    Object? sellerResponsibilities = null,
    Object? buyerResponsibilities = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$IncotermModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      transportMode: null == transportMode
          ? _value.transportMode
          : transportMode // ignore: cast_nullable_to_non_nullable
              as String,
      riskTransferPoint: freezed == riskTransferPoint
          ? _value.riskTransferPoint
          : riskTransferPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      costTransferPoint: freezed == costTransferPoint
          ? _value.costTransferPoint
          : costTransferPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerResponsibilities: null == sellerResponsibilities
          ? _value._sellerResponsibilities
          : sellerResponsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      buyerResponsibilities: null == buyerResponsibilities
          ? _value._buyerResponsibilities
          : buyerResponsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncotermModelImpl extends _IncotermModel {
  const _$IncotermModelImpl(
      {@JsonKey(name: 'incoterm_id') required this.id,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'transport_mode') this.transportMode = 'any',
      @JsonKey(name: 'risk_transfer_point') this.riskTransferPoint,
      @JsonKey(name: 'cost_transfer_point') this.costTransferPoint,
      @JsonKey(name: 'seller_responsibilities')
      final List<String> sellerResponsibilities = const [],
      @JsonKey(name: 'buyer_responsibilities')
      final List<String> buyerResponsibilities = const [],
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : _sellerResponsibilities = sellerResponsibilities,
        _buyerResponsibilities = buyerResponsibilities,
        super._();

  factory _$IncotermModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncotermModelImplFromJson(json);

  @override
  @JsonKey(name: 'incoterm_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'transport_mode')
  final String transportMode;
  @override
  @JsonKey(name: 'risk_transfer_point')
  final String? riskTransferPoint;
  @override
  @JsonKey(name: 'cost_transfer_point')
  final String? costTransferPoint;
  final List<String> _sellerResponsibilities;
  @override
  @JsonKey(name: 'seller_responsibilities')
  List<String> get sellerResponsibilities {
    if (_sellerResponsibilities is EqualUnmodifiableListView)
      return _sellerResponsibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sellerResponsibilities);
  }

  final List<String> _buyerResponsibilities;
  @override
  @JsonKey(name: 'buyer_responsibilities')
  List<String> get buyerResponsibilities {
    if (_buyerResponsibilities is EqualUnmodifiableListView)
      return _buyerResponsibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_buyerResponsibilities);
  }

  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'IncotermModel(id: $id, code: $code, name: $name, description: $description, transportMode: $transportMode, riskTransferPoint: $riskTransferPoint, costTransferPoint: $costTransferPoint, sellerResponsibilities: $sellerResponsibilities, buyerResponsibilities: $buyerResponsibilities, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncotermModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.transportMode, transportMode) ||
                other.transportMode == transportMode) &&
            (identical(other.riskTransferPoint, riskTransferPoint) ||
                other.riskTransferPoint == riskTransferPoint) &&
            (identical(other.costTransferPoint, costTransferPoint) ||
                other.costTransferPoint == costTransferPoint) &&
            const DeepCollectionEquality().equals(
                other._sellerResponsibilities, _sellerResponsibilities) &&
            const DeepCollectionEquality()
                .equals(other._buyerResponsibilities, _buyerResponsibilities) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      name,
      description,
      transportMode,
      riskTransferPoint,
      costTransferPoint,
      const DeepCollectionEquality().hash(_sellerResponsibilities),
      const DeepCollectionEquality().hash(_buyerResponsibilities),
      sortOrder,
      isActive);

  /// Create a copy of IncotermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncotermModelImplCopyWith<_$IncotermModelImpl> get copyWith =>
      __$$IncotermModelImplCopyWithImpl<_$IncotermModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncotermModelImplToJson(
      this,
    );
  }
}

abstract class _IncotermModel extends IncotermModel {
  const factory _IncotermModel(
      {@JsonKey(name: 'incoterm_id') required final String id,
      required final String code,
      required final String name,
      final String? description,
      @JsonKey(name: 'transport_mode') final String transportMode,
      @JsonKey(name: 'risk_transfer_point') final String? riskTransferPoint,
      @JsonKey(name: 'cost_transfer_point') final String? costTransferPoint,
      @JsonKey(name: 'seller_responsibilities')
      final List<String> sellerResponsibilities,
      @JsonKey(name: 'buyer_responsibilities')
      final List<String> buyerResponsibilities,
      @JsonKey(name: 'sort_order') final int sortOrder,
      @JsonKey(name: 'is_active') final bool isActive}) = _$IncotermModelImpl;
  const _IncotermModel._() : super._();

  factory _IncotermModel.fromJson(Map<String, dynamic> json) =
      _$IncotermModelImpl.fromJson;

  @override
  @JsonKey(name: 'incoterm_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'transport_mode')
  String get transportMode;
  @override
  @JsonKey(name: 'risk_transfer_point')
  String? get riskTransferPoint;
  @override
  @JsonKey(name: 'cost_transfer_point')
  String? get costTransferPoint;
  @override
  @JsonKey(name: 'seller_responsibilities')
  List<String> get sellerResponsibilities;
  @override
  @JsonKey(name: 'buyer_responsibilities')
  List<String> get buyerResponsibilities;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of IncotermModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncotermModelImplCopyWith<_$IncotermModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentTermModel _$PaymentTermModelFromJson(Map<String, dynamic> json) {
  return _PaymentTermModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentTermModel {
  @JsonKey(name: 'payment_term_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_timing')
  String get paymentTiming => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_after_shipment')
  int? get daysAfterShipment => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_lc')
  bool get requiresLC => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this PaymentTermModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentTermModelCopyWith<PaymentTermModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTermModelCopyWith<$Res> {
  factory $PaymentTermModelCopyWith(
          PaymentTermModel value, $Res Function(PaymentTermModel) then) =
      _$PaymentTermModelCopyWithImpl<$Res, PaymentTermModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_term_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'payment_timing') String paymentTiming,
      @JsonKey(name: 'days_after_shipment') int? daysAfterShipment,
      @JsonKey(name: 'requires_lc') bool requiresLC,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$PaymentTermModelCopyWithImpl<$Res, $Val extends PaymentTermModel>
    implements $PaymentTermModelCopyWith<$Res> {
  _$PaymentTermModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? paymentTiming = null,
    Object? daysAfterShipment = freezed,
    Object? requiresLC = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTiming: null == paymentTiming
          ? _value.paymentTiming
          : paymentTiming // ignore: cast_nullable_to_non_nullable
              as String,
      daysAfterShipment: freezed == daysAfterShipment
          ? _value.daysAfterShipment
          : daysAfterShipment // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresLC: null == requiresLC
          ? _value.requiresLC
          : requiresLC // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentTermModelImplCopyWith<$Res>
    implements $PaymentTermModelCopyWith<$Res> {
  factory _$$PaymentTermModelImplCopyWith(_$PaymentTermModelImpl value,
          $Res Function(_$PaymentTermModelImpl) then) =
      __$$PaymentTermModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_term_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'payment_timing') String paymentTiming,
      @JsonKey(name: 'days_after_shipment') int? daysAfterShipment,
      @JsonKey(name: 'requires_lc') bool requiresLC,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$PaymentTermModelImplCopyWithImpl<$Res>
    extends _$PaymentTermModelCopyWithImpl<$Res, _$PaymentTermModelImpl>
    implements _$$PaymentTermModelImplCopyWith<$Res> {
  __$$PaymentTermModelImplCopyWithImpl(_$PaymentTermModelImpl _value,
      $Res Function(_$PaymentTermModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? paymentTiming = null,
    Object? daysAfterShipment = freezed,
    Object? requiresLC = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$PaymentTermModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentTiming: null == paymentTiming
          ? _value.paymentTiming
          : paymentTiming // ignore: cast_nullable_to_non_nullable
              as String,
      daysAfterShipment: freezed == daysAfterShipment
          ? _value.daysAfterShipment
          : daysAfterShipment // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresLC: null == requiresLC
          ? _value.requiresLC
          : requiresLC // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentTermModelImpl extends _PaymentTermModel {
  const _$PaymentTermModelImpl(
      {@JsonKey(name: 'payment_term_id') required this.id,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'payment_timing') this.paymentTiming = 'immediate',
      @JsonKey(name: 'days_after_shipment') this.daysAfterShipment,
      @JsonKey(name: 'requires_lc') this.requiresLC = false,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$PaymentTermModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTermModelImplFromJson(json);

  @override
  @JsonKey(name: 'payment_term_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'payment_timing')
  final String paymentTiming;
  @override
  @JsonKey(name: 'days_after_shipment')
  final int? daysAfterShipment;
  @override
  @JsonKey(name: 'requires_lc')
  final bool requiresLC;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'PaymentTermModel(id: $id, code: $code, name: $name, description: $description, paymentTiming: $paymentTiming, daysAfterShipment: $daysAfterShipment, requiresLC: $requiresLC, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTermModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.paymentTiming, paymentTiming) ||
                other.paymentTiming == paymentTiming) &&
            (identical(other.daysAfterShipment, daysAfterShipment) ||
                other.daysAfterShipment == daysAfterShipment) &&
            (identical(other.requiresLC, requiresLC) ||
                other.requiresLC == requiresLC) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, description,
      paymentTiming, daysAfterShipment, requiresLC, sortOrder, isActive);

  /// Create a copy of PaymentTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTermModelImplCopyWith<_$PaymentTermModelImpl> get copyWith =>
      __$$PaymentTermModelImplCopyWithImpl<_$PaymentTermModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTermModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentTermModel extends PaymentTermModel {
  const factory _PaymentTermModel(
          {@JsonKey(name: 'payment_term_id') required final String id,
          required final String code,
          required final String name,
          final String? description,
          @JsonKey(name: 'payment_timing') final String paymentTiming,
          @JsonKey(name: 'days_after_shipment') final int? daysAfterShipment,
          @JsonKey(name: 'requires_lc') final bool requiresLC,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$PaymentTermModelImpl;
  const _PaymentTermModel._() : super._();

  factory _PaymentTermModel.fromJson(Map<String, dynamic> json) =
      _$PaymentTermModelImpl.fromJson;

  @override
  @JsonKey(name: 'payment_term_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'payment_timing')
  String get paymentTiming;
  @override
  @JsonKey(name: 'days_after_shipment')
  int? get daysAfterShipment;
  @override
  @JsonKey(name: 'requires_lc')
  bool get requiresLC;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of PaymentTermModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentTermModelImplCopyWith<_$PaymentTermModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LCTypeModel _$LCTypeModelFromJson(Map<String, dynamic> json) {
  return _LCTypeModel.fromJson(json);
}

/// @nodoc
mixin _$LCTypeModel {
  @JsonKey(name: 'lc_type_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_revocable')
  bool get isRevocable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_confirmed')
  bool get isConfirmed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_transferable')
  bool get isTransferable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_revolving')
  bool get isRevolving => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_standby')
  bool get isStandby => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this LCTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LCTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCTypeModelCopyWith<LCTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCTypeModelCopyWith<$Res> {
  factory $LCTypeModelCopyWith(
          LCTypeModel value, $Res Function(LCTypeModel) then) =
      _$LCTypeModelCopyWithImpl<$Res, LCTypeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lc_type_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'is_revocable') bool isRevocable,
      @JsonKey(name: 'is_confirmed') bool isConfirmed,
      @JsonKey(name: 'is_transferable') bool isTransferable,
      @JsonKey(name: 'is_revolving') bool isRevolving,
      @JsonKey(name: 'is_standby') bool isStandby,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$LCTypeModelCopyWithImpl<$Res, $Val extends LCTypeModel>
    implements $LCTypeModelCopyWith<$Res> {
  _$LCTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isRevocable = null,
    Object? isConfirmed = null,
    Object? isTransferable = null,
    Object? isRevolving = null,
    Object? isStandby = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRevocable: null == isRevocable
          ? _value.isRevocable
          : isRevocable // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      isTransferable: null == isTransferable
          ? _value.isTransferable
          : isTransferable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRevolving: null == isRevolving
          ? _value.isRevolving
          : isRevolving // ignore: cast_nullable_to_non_nullable
              as bool,
      isStandby: null == isStandby
          ? _value.isStandby
          : isStandby // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCTypeModelImplCopyWith<$Res>
    implements $LCTypeModelCopyWith<$Res> {
  factory _$$LCTypeModelImplCopyWith(
          _$LCTypeModelImpl value, $Res Function(_$LCTypeModelImpl) then) =
      __$$LCTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lc_type_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'is_revocable') bool isRevocable,
      @JsonKey(name: 'is_confirmed') bool isConfirmed,
      @JsonKey(name: 'is_transferable') bool isTransferable,
      @JsonKey(name: 'is_revolving') bool isRevolving,
      @JsonKey(name: 'is_standby') bool isStandby,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$LCTypeModelImplCopyWithImpl<$Res>
    extends _$LCTypeModelCopyWithImpl<$Res, _$LCTypeModelImpl>
    implements _$$LCTypeModelImplCopyWith<$Res> {
  __$$LCTypeModelImplCopyWithImpl(
      _$LCTypeModelImpl _value, $Res Function(_$LCTypeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isRevocable = null,
    Object? isConfirmed = null,
    Object? isTransferable = null,
    Object? isRevolving = null,
    Object? isStandby = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$LCTypeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRevocable: null == isRevocable
          ? _value.isRevocable
          : isRevocable // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      isTransferable: null == isTransferable
          ? _value.isTransferable
          : isTransferable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRevolving: null == isRevolving
          ? _value.isRevolving
          : isRevolving // ignore: cast_nullable_to_non_nullable
              as bool,
      isStandby: null == isStandby
          ? _value.isStandby
          : isStandby // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LCTypeModelImpl extends _LCTypeModel {
  const _$LCTypeModelImpl(
      {@JsonKey(name: 'lc_type_id') required this.id,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'is_revocable') this.isRevocable = false,
      @JsonKey(name: 'is_confirmed') this.isConfirmed = false,
      @JsonKey(name: 'is_transferable') this.isTransferable = false,
      @JsonKey(name: 'is_revolving') this.isRevolving = false,
      @JsonKey(name: 'is_standby') this.isStandby = false,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$LCTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LCTypeModelImplFromJson(json);

  @override
  @JsonKey(name: 'lc_type_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_revocable')
  final bool isRevocable;
  @override
  @JsonKey(name: 'is_confirmed')
  final bool isConfirmed;
  @override
  @JsonKey(name: 'is_transferable')
  final bool isTransferable;
  @override
  @JsonKey(name: 'is_revolving')
  final bool isRevolving;
  @override
  @JsonKey(name: 'is_standby')
  final bool isStandby;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'LCTypeModel(id: $id, code: $code, name: $name, description: $description, isRevocable: $isRevocable, isConfirmed: $isConfirmed, isTransferable: $isTransferable, isRevolving: $isRevolving, isStandby: $isStandby, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRevocable, isRevocable) ||
                other.isRevocable == isRevocable) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed) &&
            (identical(other.isTransferable, isTransferable) ||
                other.isTransferable == isTransferable) &&
            (identical(other.isRevolving, isRevolving) ||
                other.isRevolving == isRevolving) &&
            (identical(other.isStandby, isStandby) ||
                other.isStandby == isStandby) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      name,
      description,
      isRevocable,
      isConfirmed,
      isTransferable,
      isRevolving,
      isStandby,
      sortOrder,
      isActive);

  /// Create a copy of LCTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCTypeModelImplCopyWith<_$LCTypeModelImpl> get copyWith =>
      __$$LCTypeModelImplCopyWithImpl<_$LCTypeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LCTypeModelImplToJson(
      this,
    );
  }
}

abstract class _LCTypeModel extends LCTypeModel {
  const factory _LCTypeModel(
      {@JsonKey(name: 'lc_type_id') required final String id,
      required final String code,
      required final String name,
      final String? description,
      @JsonKey(name: 'is_revocable') final bool isRevocable,
      @JsonKey(name: 'is_confirmed') final bool isConfirmed,
      @JsonKey(name: 'is_transferable') final bool isTransferable,
      @JsonKey(name: 'is_revolving') final bool isRevolving,
      @JsonKey(name: 'is_standby') final bool isStandby,
      @JsonKey(name: 'sort_order') final int sortOrder,
      @JsonKey(name: 'is_active') final bool isActive}) = _$LCTypeModelImpl;
  const _LCTypeModel._() : super._();

  factory _LCTypeModel.fromJson(Map<String, dynamic> json) =
      _$LCTypeModelImpl.fromJson;

  @override
  @JsonKey(name: 'lc_type_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_revocable')
  bool get isRevocable;
  @override
  @JsonKey(name: 'is_confirmed')
  bool get isConfirmed;
  @override
  @JsonKey(name: 'is_transferable')
  bool get isTransferable;
  @override
  @JsonKey(name: 'is_revolving')
  bool get isRevolving;
  @override
  @JsonKey(name: 'is_standby')
  bool get isStandby;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of LCTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCTypeModelImplCopyWith<_$LCTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentTypeModel _$DocumentTypeModelFromJson(Map<String, dynamic> json) {
  return _DocumentTypeModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentTypeModel {
  @JsonKey(name: 'document_type_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_short')
  String? get nameShort => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'commonly_required')
  bool get commonlyRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this DocumentTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentTypeModelCopyWith<DocumentTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentTypeModelCopyWith<$Res> {
  factory $DocumentTypeModelCopyWith(
          DocumentTypeModel value, $Res Function(DocumentTypeModel) then) =
      _$DocumentTypeModelCopyWithImpl<$Res, DocumentTypeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type_id') String id,
      String code,
      String name,
      @JsonKey(name: 'name_short') String? nameShort,
      String? description,
      String category,
      @JsonKey(name: 'commonly_required') bool commonlyRequired,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$DocumentTypeModelCopyWithImpl<$Res, $Val extends DocumentTypeModel>
    implements $DocumentTypeModelCopyWith<$Res> {
  _$DocumentTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameShort = freezed,
    Object? description = freezed,
    Object? category = null,
    Object? commonlyRequired = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameShort: freezed == nameShort
          ? _value.nameShort
          : nameShort // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      commonlyRequired: null == commonlyRequired
          ? _value.commonlyRequired
          : commonlyRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentTypeModelImplCopyWith<$Res>
    implements $DocumentTypeModelCopyWith<$Res> {
  factory _$$DocumentTypeModelImplCopyWith(_$DocumentTypeModelImpl value,
          $Res Function(_$DocumentTypeModelImpl) then) =
      __$$DocumentTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'document_type_id') String id,
      String code,
      String name,
      @JsonKey(name: 'name_short') String? nameShort,
      String? description,
      String category,
      @JsonKey(name: 'commonly_required') bool commonlyRequired,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$DocumentTypeModelImplCopyWithImpl<$Res>
    extends _$DocumentTypeModelCopyWithImpl<$Res, _$DocumentTypeModelImpl>
    implements _$$DocumentTypeModelImplCopyWith<$Res> {
  __$$DocumentTypeModelImplCopyWithImpl(_$DocumentTypeModelImpl _value,
      $Res Function(_$DocumentTypeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DocumentTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameShort = freezed,
    Object? description = freezed,
    Object? category = null,
    Object? commonlyRequired = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$DocumentTypeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameShort: freezed == nameShort
          ? _value.nameShort
          : nameShort // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      commonlyRequired: null == commonlyRequired
          ? _value.commonlyRequired
          : commonlyRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentTypeModelImpl extends _DocumentTypeModel {
  const _$DocumentTypeModelImpl(
      {@JsonKey(name: 'document_type_id') required this.id,
      required this.code,
      required this.name,
      @JsonKey(name: 'name_short') this.nameShort,
      this.description,
      required this.category,
      @JsonKey(name: 'commonly_required') this.commonlyRequired = false,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$DocumentTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentTypeModelImplFromJson(json);

  @override
  @JsonKey(name: 'document_type_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_short')
  final String? nameShort;
  @override
  final String? description;
  @override
  final String category;
  @override
  @JsonKey(name: 'commonly_required')
  final bool commonlyRequired;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'DocumentTypeModel(id: $id, code: $code, name: $name, nameShort: $nameShort, description: $description, category: $category, commonlyRequired: $commonlyRequired, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameShort, nameShort) ||
                other.nameShort == nameShort) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.commonlyRequired, commonlyRequired) ||
                other.commonlyRequired == commonlyRequired) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, nameShort,
      description, category, commonlyRequired, sortOrder, isActive);

  /// Create a copy of DocumentTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentTypeModelImplCopyWith<_$DocumentTypeModelImpl> get copyWith =>
      __$$DocumentTypeModelImplCopyWithImpl<_$DocumentTypeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentTypeModelImplToJson(
      this,
    );
  }
}

abstract class _DocumentTypeModel extends DocumentTypeModel {
  const factory _DocumentTypeModel(
          {@JsonKey(name: 'document_type_id') required final String id,
          required final String code,
          required final String name,
          @JsonKey(name: 'name_short') final String? nameShort,
          final String? description,
          required final String category,
          @JsonKey(name: 'commonly_required') final bool commonlyRequired,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$DocumentTypeModelImpl;
  const _DocumentTypeModel._() : super._();

  factory _DocumentTypeModel.fromJson(Map<String, dynamic> json) =
      _$DocumentTypeModelImpl.fromJson;

  @override
  @JsonKey(name: 'document_type_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_short')
  String? get nameShort;
  @override
  String? get description;
  @override
  String get category;
  @override
  @JsonKey(name: 'commonly_required')
  bool get commonlyRequired;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of DocumentTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentTypeModelImplCopyWith<_$DocumentTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShippingMethodModel _$ShippingMethodModelFromJson(Map<String, dynamic> json) {
  return _ShippingMethodModel.fromJson(json);
}

/// @nodoc
mixin _$ShippingMethodModel {
  @JsonKey(name: 'shipping_method_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'transport_document_code')
  String? get transportDocumentCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ShippingMethodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingMethodModelCopyWith<ShippingMethodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingMethodModelCopyWith<$Res> {
  factory $ShippingMethodModelCopyWith(
          ShippingMethodModel value, $Res Function(ShippingMethodModel) then) =
      _$ShippingMethodModelCopyWithImpl<$Res, ShippingMethodModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shipping_method_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'transport_document_code') String? transportDocumentCode,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ShippingMethodModelCopyWithImpl<$Res, $Val extends ShippingMethodModel>
    implements $ShippingMethodModelCopyWith<$Res> {
  _$ShippingMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? transportDocumentCode = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      transportDocumentCode: freezed == transportDocumentCode
          ? _value.transportDocumentCode
          : transportDocumentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShippingMethodModelImplCopyWith<$Res>
    implements $ShippingMethodModelCopyWith<$Res> {
  factory _$$ShippingMethodModelImplCopyWith(_$ShippingMethodModelImpl value,
          $Res Function(_$ShippingMethodModelImpl) then) =
      __$$ShippingMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shipping_method_id') String id,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'transport_document_code') String? transportDocumentCode,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ShippingMethodModelImplCopyWithImpl<$Res>
    extends _$ShippingMethodModelCopyWithImpl<$Res, _$ShippingMethodModelImpl>
    implements _$$ShippingMethodModelImplCopyWith<$Res> {
  __$$ShippingMethodModelImplCopyWithImpl(_$ShippingMethodModelImpl _value,
      $Res Function(_$ShippingMethodModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? transportDocumentCode = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$ShippingMethodModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      transportDocumentCode: freezed == transportDocumentCode
          ? _value.transportDocumentCode
          : transportDocumentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShippingMethodModelImpl extends _ShippingMethodModel {
  const _$ShippingMethodModelImpl(
      {@JsonKey(name: 'shipping_method_id') required this.id,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'transport_document_code') this.transportDocumentCode,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$ShippingMethodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShippingMethodModelImplFromJson(json);

  @override
  @JsonKey(name: 'shipping_method_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'transport_document_code')
  final String? transportDocumentCode;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ShippingMethodModel(id: $id, code: $code, name: $name, description: $description, transportDocumentCode: $transportDocumentCode, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingMethodModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.transportDocumentCode, transportDocumentCode) ||
                other.transportDocumentCode == transportDocumentCode) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, description,
      transportDocumentCode, sortOrder, isActive);

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingMethodModelImplCopyWith<_$ShippingMethodModelImpl> get copyWith =>
      __$$ShippingMethodModelImplCopyWithImpl<_$ShippingMethodModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShippingMethodModelImplToJson(
      this,
    );
  }
}

abstract class _ShippingMethodModel extends ShippingMethodModel {
  const factory _ShippingMethodModel(
          {@JsonKey(name: 'shipping_method_id') required final String id,
          required final String code,
          required final String name,
          final String? description,
          @JsonKey(name: 'transport_document_code')
          final String? transportDocumentCode,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$ShippingMethodModelImpl;
  const _ShippingMethodModel._() : super._();

  factory _ShippingMethodModel.fromJson(Map<String, dynamic> json) =
      _$ShippingMethodModelImpl.fromJson;

  @override
  @JsonKey(name: 'shipping_method_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'transport_document_code')
  String? get transportDocumentCode;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingMethodModelImplCopyWith<_$ShippingMethodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FreightTermModel _$FreightTermModelFromJson(Map<String, dynamic> json) {
  return _FreightTermModel.fromJson(json);
}

/// @nodoc
mixin _$FreightTermModel {
  @JsonKey(name: 'freight_term_id')
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get payer => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this FreightTermModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FreightTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FreightTermModelCopyWith<FreightTermModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FreightTermModelCopyWith<$Res> {
  factory $FreightTermModelCopyWith(
          FreightTermModel value, $Res Function(FreightTermModel) then) =
      _$FreightTermModelCopyWithImpl<$Res, FreightTermModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'freight_term_id') String id,
      String code,
      String name,
      String? description,
      String payer,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$FreightTermModelCopyWithImpl<$Res, $Val extends FreightTermModel>
    implements $FreightTermModelCopyWith<$Res> {
  _$FreightTermModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FreightTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? payer = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: null == payer
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FreightTermModelImplCopyWith<$Res>
    implements $FreightTermModelCopyWith<$Res> {
  factory _$$FreightTermModelImplCopyWith(_$FreightTermModelImpl value,
          $Res Function(_$FreightTermModelImpl) then) =
      __$$FreightTermModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'freight_term_id') String id,
      String code,
      String name,
      String? description,
      String payer,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$FreightTermModelImplCopyWithImpl<$Res>
    extends _$FreightTermModelCopyWithImpl<$Res, _$FreightTermModelImpl>
    implements _$$FreightTermModelImplCopyWith<$Res> {
  __$$FreightTermModelImplCopyWithImpl(_$FreightTermModelImpl _value,
      $Res Function(_$FreightTermModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FreightTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? payer = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$FreightTermModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: null == payer
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FreightTermModelImpl extends _FreightTermModel {
  const _$FreightTermModelImpl(
      {@JsonKey(name: 'freight_term_id') required this.id,
      required this.code,
      required this.name,
      this.description,
      required this.payer,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$FreightTermModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FreightTermModelImplFromJson(json);

  @override
  @JsonKey(name: 'freight_term_id')
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String payer;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'FreightTermModel(id: $id, code: $code, name: $name, description: $description, payer: $payer, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FreightTermModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.payer, payer) || other.payer == payer) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, code, name, description, payer, sortOrder, isActive);

  /// Create a copy of FreightTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FreightTermModelImplCopyWith<_$FreightTermModelImpl> get copyWith =>
      __$$FreightTermModelImplCopyWithImpl<_$FreightTermModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FreightTermModelImplToJson(
      this,
    );
  }
}

abstract class _FreightTermModel extends FreightTermModel {
  const factory _FreightTermModel(
          {@JsonKey(name: 'freight_term_id') required final String id,
          required final String code,
          required final String name,
          final String? description,
          required final String payer,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$FreightTermModelImpl;
  const _FreightTermModel._() : super._();

  factory _FreightTermModel.fromJson(Map<String, dynamic> json) =
      _$FreightTermModelImpl.fromJson;

  @override
  @JsonKey(name: 'freight_term_id')
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get payer;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of FreightTermModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FreightTermModelImplCopyWith<_$FreightTermModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MasterDataResponse {
  List<IncotermModel> get incoterms => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_terms')
  List<PaymentTermModel> get paymentTerms => throw _privateConstructorUsedError;
  @JsonKey(name: 'lc_types')
  List<LCTypeModel> get lcTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_types')
  List<DocumentTypeModel> get documentTypes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_methods')
  List<ShippingMethodModel> get shippingMethods =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'freight_terms')
  List<FreightTermModel> get freightTerms => throw _privateConstructorUsedError;

  /// Create a copy of MasterDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterDataResponseCopyWith<MasterDataResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterDataResponseCopyWith<$Res> {
  factory $MasterDataResponseCopyWith(
          MasterDataResponse value, $Res Function(MasterDataResponse) then) =
      _$MasterDataResponseCopyWithImpl<$Res, MasterDataResponse>;
  @useResult
  $Res call(
      {List<IncotermModel> incoterms,
      @JsonKey(name: 'payment_terms') List<PaymentTermModel> paymentTerms,
      @JsonKey(name: 'lc_types') List<LCTypeModel> lcTypes,
      @JsonKey(name: 'document_types') List<DocumentTypeModel> documentTypes,
      @JsonKey(name: 'shipping_methods')
      List<ShippingMethodModel> shippingMethods,
      @JsonKey(name: 'freight_terms') List<FreightTermModel> freightTerms});
}

/// @nodoc
class _$MasterDataResponseCopyWithImpl<$Res, $Val extends MasterDataResponse>
    implements $MasterDataResponseCopyWith<$Res> {
  _$MasterDataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MasterDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incoterms = null,
    Object? paymentTerms = null,
    Object? lcTypes = null,
    Object? documentTypes = null,
    Object? shippingMethods = null,
    Object? freightTerms = null,
  }) {
    return _then(_value.copyWith(
      incoterms: null == incoterms
          ? _value.incoterms
          : incoterms // ignore: cast_nullable_to_non_nullable
              as List<IncotermModel>,
      paymentTerms: null == paymentTerms
          ? _value.paymentTerms
          : paymentTerms // ignore: cast_nullable_to_non_nullable
              as List<PaymentTermModel>,
      lcTypes: null == lcTypes
          ? _value.lcTypes
          : lcTypes // ignore: cast_nullable_to_non_nullable
              as List<LCTypeModel>,
      documentTypes: null == documentTypes
          ? _value.documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as List<DocumentTypeModel>,
      shippingMethods: null == shippingMethods
          ? _value.shippingMethods
          : shippingMethods // ignore: cast_nullable_to_non_nullable
              as List<ShippingMethodModel>,
      freightTerms: null == freightTerms
          ? _value.freightTerms
          : freightTerms // ignore: cast_nullable_to_non_nullable
              as List<FreightTermModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MasterDataResponseImplCopyWith<$Res>
    implements $MasterDataResponseCopyWith<$Res> {
  factory _$$MasterDataResponseImplCopyWith(_$MasterDataResponseImpl value,
          $Res Function(_$MasterDataResponseImpl) then) =
      __$$MasterDataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<IncotermModel> incoterms,
      @JsonKey(name: 'payment_terms') List<PaymentTermModel> paymentTerms,
      @JsonKey(name: 'lc_types') List<LCTypeModel> lcTypes,
      @JsonKey(name: 'document_types') List<DocumentTypeModel> documentTypes,
      @JsonKey(name: 'shipping_methods')
      List<ShippingMethodModel> shippingMethods,
      @JsonKey(name: 'freight_terms') List<FreightTermModel> freightTerms});
}

/// @nodoc
class __$$MasterDataResponseImplCopyWithImpl<$Res>
    extends _$MasterDataResponseCopyWithImpl<$Res, _$MasterDataResponseImpl>
    implements _$$MasterDataResponseImplCopyWith<$Res> {
  __$$MasterDataResponseImplCopyWithImpl(_$MasterDataResponseImpl _value,
      $Res Function(_$MasterDataResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MasterDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incoterms = null,
    Object? paymentTerms = null,
    Object? lcTypes = null,
    Object? documentTypes = null,
    Object? shippingMethods = null,
    Object? freightTerms = null,
  }) {
    return _then(_$MasterDataResponseImpl(
      incoterms: null == incoterms
          ? _value._incoterms
          : incoterms // ignore: cast_nullable_to_non_nullable
              as List<IncotermModel>,
      paymentTerms: null == paymentTerms
          ? _value._paymentTerms
          : paymentTerms // ignore: cast_nullable_to_non_nullable
              as List<PaymentTermModel>,
      lcTypes: null == lcTypes
          ? _value._lcTypes
          : lcTypes // ignore: cast_nullable_to_non_nullable
              as List<LCTypeModel>,
      documentTypes: null == documentTypes
          ? _value._documentTypes
          : documentTypes // ignore: cast_nullable_to_non_nullable
              as List<DocumentTypeModel>,
      shippingMethods: null == shippingMethods
          ? _value._shippingMethods
          : shippingMethods // ignore: cast_nullable_to_non_nullable
              as List<ShippingMethodModel>,
      freightTerms: null == freightTerms
          ? _value._freightTerms
          : freightTerms // ignore: cast_nullable_to_non_nullable
              as List<FreightTermModel>,
    ));
  }
}

/// @nodoc

class _$MasterDataResponseImpl extends _MasterDataResponse {
  const _$MasterDataResponseImpl(
      {final List<IncotermModel> incoterms = const [],
      @JsonKey(name: 'payment_terms')
      final List<PaymentTermModel> paymentTerms = const [],
      @JsonKey(name: 'lc_types') final List<LCTypeModel> lcTypes = const [],
      @JsonKey(name: 'document_types')
      final List<DocumentTypeModel> documentTypes = const [],
      @JsonKey(name: 'shipping_methods')
      final List<ShippingMethodModel> shippingMethods = const [],
      @JsonKey(name: 'freight_terms')
      final List<FreightTermModel> freightTerms = const []})
      : _incoterms = incoterms,
        _paymentTerms = paymentTerms,
        _lcTypes = lcTypes,
        _documentTypes = documentTypes,
        _shippingMethods = shippingMethods,
        _freightTerms = freightTerms,
        super._();

  final List<IncotermModel> _incoterms;
  @override
  @JsonKey()
  List<IncotermModel> get incoterms {
    if (_incoterms is EqualUnmodifiableListView) return _incoterms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incoterms);
  }

  final List<PaymentTermModel> _paymentTerms;
  @override
  @JsonKey(name: 'payment_terms')
  List<PaymentTermModel> get paymentTerms {
    if (_paymentTerms is EqualUnmodifiableListView) return _paymentTerms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentTerms);
  }

  final List<LCTypeModel> _lcTypes;
  @override
  @JsonKey(name: 'lc_types')
  List<LCTypeModel> get lcTypes {
    if (_lcTypes is EqualUnmodifiableListView) return _lcTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lcTypes);
  }

  final List<DocumentTypeModel> _documentTypes;
  @override
  @JsonKey(name: 'document_types')
  List<DocumentTypeModel> get documentTypes {
    if (_documentTypes is EqualUnmodifiableListView) return _documentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentTypes);
  }

  final List<ShippingMethodModel> _shippingMethods;
  @override
  @JsonKey(name: 'shipping_methods')
  List<ShippingMethodModel> get shippingMethods {
    if (_shippingMethods is EqualUnmodifiableListView) return _shippingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shippingMethods);
  }

  final List<FreightTermModel> _freightTerms;
  @override
  @JsonKey(name: 'freight_terms')
  List<FreightTermModel> get freightTerms {
    if (_freightTerms is EqualUnmodifiableListView) return _freightTerms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_freightTerms);
  }

  @override
  String toString() {
    return 'MasterDataResponse(incoterms: $incoterms, paymentTerms: $paymentTerms, lcTypes: $lcTypes, documentTypes: $documentTypes, shippingMethods: $shippingMethods, freightTerms: $freightTerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterDataResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._incoterms, _incoterms) &&
            const DeepCollectionEquality()
                .equals(other._paymentTerms, _paymentTerms) &&
            const DeepCollectionEquality().equals(other._lcTypes, _lcTypes) &&
            const DeepCollectionEquality()
                .equals(other._documentTypes, _documentTypes) &&
            const DeepCollectionEquality()
                .equals(other._shippingMethods, _shippingMethods) &&
            const DeepCollectionEquality()
                .equals(other._freightTerms, _freightTerms));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_incoterms),
      const DeepCollectionEquality().hash(_paymentTerms),
      const DeepCollectionEquality().hash(_lcTypes),
      const DeepCollectionEquality().hash(_documentTypes),
      const DeepCollectionEquality().hash(_shippingMethods),
      const DeepCollectionEquality().hash(_freightTerms));

  /// Create a copy of MasterDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterDataResponseImplCopyWith<_$MasterDataResponseImpl> get copyWith =>
      __$$MasterDataResponseImplCopyWithImpl<_$MasterDataResponseImpl>(
          this, _$identity);
}

abstract class _MasterDataResponse extends MasterDataResponse {
  const factory _MasterDataResponse(
      {final List<IncotermModel> incoterms,
      @JsonKey(name: 'payment_terms') final List<PaymentTermModel> paymentTerms,
      @JsonKey(name: 'lc_types') final List<LCTypeModel> lcTypes,
      @JsonKey(name: 'document_types')
      final List<DocumentTypeModel> documentTypes,
      @JsonKey(name: 'shipping_methods')
      final List<ShippingMethodModel> shippingMethods,
      @JsonKey(name: 'freight_terms')
      final List<FreightTermModel> freightTerms}) = _$MasterDataResponseImpl;
  const _MasterDataResponse._() : super._();

  @override
  List<IncotermModel> get incoterms;
  @override
  @JsonKey(name: 'payment_terms')
  List<PaymentTermModel> get paymentTerms;
  @override
  @JsonKey(name: 'lc_types')
  List<LCTypeModel> get lcTypes;
  @override
  @JsonKey(name: 'document_types')
  List<DocumentTypeModel> get documentTypes;
  @override
  @JsonKey(name: 'shipping_methods')
  List<ShippingMethodModel> get shippingMethods;
  @override
  @JsonKey(name: 'freight_terms')
  List<FreightTermModel> get freightTerms;

  /// Create a copy of MasterDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterDataResponseImplCopyWith<_$MasterDataResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
