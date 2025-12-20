// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_session_items_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdatedItem {
  String get itemId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get quantityRejected => throw _privateConstructorUsedError;
  String get action =>
      throw _privateConstructorUsedError; // 'updated' or 'inserted'
  int get consolidatedCount => throw _privateConstructorUsedError;

  /// Create a copy of UpdatedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatedItemCopyWith<UpdatedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatedItemCopyWith<$Res> {
  factory $UpdatedItemCopyWith(
          UpdatedItem value, $Res Function(UpdatedItem) then) =
      _$UpdatedItemCopyWithImpl<$Res, UpdatedItem>;
  @useResult
  $Res call(
      {String itemId,
      String productId,
      int quantity,
      int quantityRejected,
      String action,
      int consolidatedCount});
}

/// @nodoc
class _$UpdatedItemCopyWithImpl<$Res, $Val extends UpdatedItem>
    implements $UpdatedItemCopyWith<$Res> {
  _$UpdatedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = null,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? action = null,
    Object? consolidatedCount = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      consolidatedCount: null == consolidatedCount
          ? _value.consolidatedCount
          : consolidatedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatedItemImplCopyWith<$Res>
    implements $UpdatedItemCopyWith<$Res> {
  factory _$$UpdatedItemImplCopyWith(
          _$UpdatedItemImpl value, $Res Function(_$UpdatedItemImpl) then) =
      __$$UpdatedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String productId,
      int quantity,
      int quantityRejected,
      String action,
      int consolidatedCount});
}

/// @nodoc
class __$$UpdatedItemImplCopyWithImpl<$Res>
    extends _$UpdatedItemCopyWithImpl<$Res, _$UpdatedItemImpl>
    implements _$$UpdatedItemImplCopyWith<$Res> {
  __$$UpdatedItemImplCopyWithImpl(
      _$UpdatedItemImpl _value, $Res Function(_$UpdatedItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? productId = null,
    Object? quantity = null,
    Object? quantityRejected = null,
    Object? action = null,
    Object? consolidatedCount = null,
  }) {
    return _then(_$UpdatedItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityRejected: null == quantityRejected
          ? _value.quantityRejected
          : quantityRejected // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      consolidatedCount: null == consolidatedCount
          ? _value.consolidatedCount
          : consolidatedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UpdatedItemImpl extends _UpdatedItem {
  const _$UpdatedItemImpl(
      {required this.itemId,
      required this.productId,
      required this.quantity,
      required this.quantityRejected,
      required this.action,
      required this.consolidatedCount})
      : super._();

  @override
  final String itemId;
  @override
  final String productId;
  @override
  final int quantity;
  @override
  final int quantityRejected;
  @override
  final String action;
// 'updated' or 'inserted'
  @override
  final int consolidatedCount;

  @override
  String toString() {
    return 'UpdatedItem(itemId: $itemId, productId: $productId, quantity: $quantity, quantityRejected: $quantityRejected, action: $action, consolidatedCount: $consolidatedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatedItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityRejected, quantityRejected) ||
                other.quantityRejected == quantityRejected) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.consolidatedCount, consolidatedCount) ||
                other.consolidatedCount == consolidatedCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, itemId, productId, quantity,
      quantityRejected, action, consolidatedCount);

  /// Create a copy of UpdatedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatedItemImplCopyWith<_$UpdatedItemImpl> get copyWith =>
      __$$UpdatedItemImplCopyWithImpl<_$UpdatedItemImpl>(this, _$identity);
}

abstract class _UpdatedItem extends UpdatedItem {
  const factory _UpdatedItem(
      {required final String itemId,
      required final String productId,
      required final int quantity,
      required final int quantityRejected,
      required final String action,
      required final int consolidatedCount}) = _$UpdatedItemImpl;
  const _UpdatedItem._() : super._();

  @override
  String get itemId;
  @override
  String get productId;
  @override
  int get quantity;
  @override
  int get quantityRejected;
  @override
  String get action; // 'updated' or 'inserted'
  @override
  int get consolidatedCount;

  /// Create a copy of UpdatedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatedItemImplCopyWith<_$UpdatedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateSummary {
  int get totalUpdated => throw _privateConstructorUsedError;
  int get totalInserted => throw _privateConstructorUsedError;
  int get totalConsolidated => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSummaryCopyWith<UpdateSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSummaryCopyWith<$Res> {
  factory $UpdateSummaryCopyWith(
          UpdateSummary value, $Res Function(UpdateSummary) then) =
      _$UpdateSummaryCopyWithImpl<$Res, UpdateSummary>;
  @useResult
  $Res call({int totalUpdated, int totalInserted, int totalConsolidated});
}

/// @nodoc
class _$UpdateSummaryCopyWithImpl<$Res, $Val extends UpdateSummary>
    implements $UpdateSummaryCopyWith<$Res> {
  _$UpdateSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUpdated = null,
    Object? totalInserted = null,
    Object? totalConsolidated = null,
  }) {
    return _then(_value.copyWith(
      totalUpdated: null == totalUpdated
          ? _value.totalUpdated
          : totalUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      totalInserted: null == totalInserted
          ? _value.totalInserted
          : totalInserted // ignore: cast_nullable_to_non_nullable
              as int,
      totalConsolidated: null == totalConsolidated
          ? _value.totalConsolidated
          : totalConsolidated // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateSummaryImplCopyWith<$Res>
    implements $UpdateSummaryCopyWith<$Res> {
  factory _$$UpdateSummaryImplCopyWith(
          _$UpdateSummaryImpl value, $Res Function(_$UpdateSummaryImpl) then) =
      __$$UpdateSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalUpdated, int totalInserted, int totalConsolidated});
}

/// @nodoc
class __$$UpdateSummaryImplCopyWithImpl<$Res>
    extends _$UpdateSummaryCopyWithImpl<$Res, _$UpdateSummaryImpl>
    implements _$$UpdateSummaryImplCopyWith<$Res> {
  __$$UpdateSummaryImplCopyWithImpl(
      _$UpdateSummaryImpl _value, $Res Function(_$UpdateSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUpdated = null,
    Object? totalInserted = null,
    Object? totalConsolidated = null,
  }) {
    return _then(_$UpdateSummaryImpl(
      totalUpdated: null == totalUpdated
          ? _value.totalUpdated
          : totalUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      totalInserted: null == totalInserted
          ? _value.totalInserted
          : totalInserted // ignore: cast_nullable_to_non_nullable
              as int,
      totalConsolidated: null == totalConsolidated
          ? _value.totalConsolidated
          : totalConsolidated // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UpdateSummaryImpl extends _UpdateSummary {
  const _$UpdateSummaryImpl(
      {required this.totalUpdated,
      required this.totalInserted,
      required this.totalConsolidated})
      : super._();

  @override
  final int totalUpdated;
  @override
  final int totalInserted;
  @override
  final int totalConsolidated;

  @override
  String toString() {
    return 'UpdateSummary(totalUpdated: $totalUpdated, totalInserted: $totalInserted, totalConsolidated: $totalConsolidated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSummaryImpl &&
            (identical(other.totalUpdated, totalUpdated) ||
                other.totalUpdated == totalUpdated) &&
            (identical(other.totalInserted, totalInserted) ||
                other.totalInserted == totalInserted) &&
            (identical(other.totalConsolidated, totalConsolidated) ||
                other.totalConsolidated == totalConsolidated));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, totalUpdated, totalInserted, totalConsolidated);

  /// Create a copy of UpdateSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSummaryImplCopyWith<_$UpdateSummaryImpl> get copyWith =>
      __$$UpdateSummaryImplCopyWithImpl<_$UpdateSummaryImpl>(this, _$identity);
}

abstract class _UpdateSummary extends UpdateSummary {
  const factory _UpdateSummary(
      {required final int totalUpdated,
      required final int totalInserted,
      required final int totalConsolidated}) = _$UpdateSummaryImpl;
  const _UpdateSummary._() : super._();

  @override
  int get totalUpdated;
  @override
  int get totalInserted;
  @override
  int get totalConsolidated;

  /// Create a copy of UpdateSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSummaryImplCopyWith<_$UpdateSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateSessionItemsResponse {
  bool get success => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<UpdatedItem> get updated => throw _privateConstructorUsedError;
  UpdateSummary get summary => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSessionItemsResponseCopyWith<UpdateSessionItemsResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSessionItemsResponseCopyWith<$Res> {
  factory $UpdateSessionItemsResponseCopyWith(UpdateSessionItemsResponse value,
          $Res Function(UpdateSessionItemsResponse) then) =
      _$UpdateSessionItemsResponseCopyWithImpl<$Res,
          UpdateSessionItemsResponse>;
  @useResult
  $Res call(
      {bool success,
      String sessionId,
      String userId,
      List<UpdatedItem> updated,
      UpdateSummary summary,
      String? message});

  $UpdateSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$UpdateSessionItemsResponseCopyWithImpl<$Res,
        $Val extends UpdateSessionItemsResponse>
    implements $UpdateSessionItemsResponseCopyWith<$Res> {
  _$UpdateSessionItemsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? updated = null,
    Object? summary = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as List<UpdatedItem>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as UpdateSummary,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateSummaryCopyWith<$Res> get summary {
    return $UpdateSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateSessionItemsResponseImplCopyWith<$Res>
    implements $UpdateSessionItemsResponseCopyWith<$Res> {
  factory _$$UpdateSessionItemsResponseImplCopyWith(
          _$UpdateSessionItemsResponseImpl value,
          $Res Function(_$UpdateSessionItemsResponseImpl) then) =
      __$$UpdateSessionItemsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String sessionId,
      String userId,
      List<UpdatedItem> updated,
      UpdateSummary summary,
      String? message});

  @override
  $UpdateSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$UpdateSessionItemsResponseImplCopyWithImpl<$Res>
    extends _$UpdateSessionItemsResponseCopyWithImpl<$Res,
        _$UpdateSessionItemsResponseImpl>
    implements _$$UpdateSessionItemsResponseImplCopyWith<$Res> {
  __$$UpdateSessionItemsResponseImplCopyWithImpl(
      _$UpdateSessionItemsResponseImpl _value,
      $Res Function(_$UpdateSessionItemsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? updated = null,
    Object? summary = null,
    Object? message = freezed,
  }) {
    return _then(_$UpdateSessionItemsResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      updated: null == updated
          ? _value._updated
          : updated // ignore: cast_nullable_to_non_nullable
              as List<UpdatedItem>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as UpdateSummary,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UpdateSessionItemsResponseImpl extends _UpdateSessionItemsResponse {
  const _$UpdateSessionItemsResponseImpl(
      {required this.success,
      required this.sessionId,
      required this.userId,
      required final List<UpdatedItem> updated,
      required this.summary,
      this.message})
      : _updated = updated,
        super._();

  @override
  final bool success;
  @override
  final String sessionId;
  @override
  final String userId;
  final List<UpdatedItem> _updated;
  @override
  List<UpdatedItem> get updated {
    if (_updated is EqualUnmodifiableListView) return _updated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updated);
  }

  @override
  final UpdateSummary summary;
  @override
  final String? message;

  @override
  String toString() {
    return 'UpdateSessionItemsResponse(success: $success, sessionId: $sessionId, userId: $userId, updated: $updated, summary: $summary, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSessionItemsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._updated, _updated) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success, sessionId, userId,
      const DeepCollectionEquality().hash(_updated), summary, message);

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSessionItemsResponseImplCopyWith<_$UpdateSessionItemsResponseImpl>
      get copyWith => __$$UpdateSessionItemsResponseImplCopyWithImpl<
          _$UpdateSessionItemsResponseImpl>(this, _$identity);
}

abstract class _UpdateSessionItemsResponse extends UpdateSessionItemsResponse {
  const factory _UpdateSessionItemsResponse(
      {required final bool success,
      required final String sessionId,
      required final String userId,
      required final List<UpdatedItem> updated,
      required final UpdateSummary summary,
      final String? message}) = _$UpdateSessionItemsResponseImpl;
  const _UpdateSessionItemsResponse._() : super._();

  @override
  bool get success;
  @override
  String get sessionId;
  @override
  String get userId;
  @override
  List<UpdatedItem> get updated;
  @override
  UpdateSummary get summary;
  @override
  String? get message;

  /// Create a copy of UpdateSessionItemsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSessionItemsResponseImplCopyWith<_$UpdateSessionItemsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
