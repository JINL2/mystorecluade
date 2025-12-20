// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scanner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrScannerState {
  /// 현재 스캔 처리 중인지 여부
  bool get isProcessing => throw _privateConstructorUsedError;

  /// 이미 스캔이 완료되었는지 여부 (중복 스캔 방지)
  bool get hasScanned => throw _privateConstructorUsedError;

  /// 다이얼로그가 현재 표시 중인지 여부
  bool get isShowingDialog => throw _privateConstructorUsedError;

  /// 다이얼로그가 이미 닫혔는지 여부 (이중 pop 방지)
  bool get dialogDismissed => throw _privateConstructorUsedError;

  /// 에러 메시지 (있을 경우)
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 성공 결과 데이터
  Map<String, dynamic>? get successResult => throw _privateConstructorUsedError;

  /// 스캔 결과 상태
  QrScanResult get scanResult => throw _privateConstructorUsedError;

  /// Create a copy of QrScannerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrScannerStateCopyWith<QrScannerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrScannerStateCopyWith<$Res> {
  factory $QrScannerStateCopyWith(
          QrScannerState value, $Res Function(QrScannerState) then) =
      _$QrScannerStateCopyWithImpl<$Res, QrScannerState>;
  @useResult
  $Res call(
      {bool isProcessing,
      bool hasScanned,
      bool isShowingDialog,
      bool dialogDismissed,
      String? errorMessage,
      Map<String, dynamic>? successResult,
      QrScanResult scanResult});
}

/// @nodoc
class _$QrScannerStateCopyWithImpl<$Res, $Val extends QrScannerState>
    implements $QrScannerStateCopyWith<$Res> {
  _$QrScannerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrScannerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? hasScanned = null,
    Object? isShowingDialog = null,
    Object? dialogDismissed = null,
    Object? errorMessage = freezed,
    Object? successResult = freezed,
    Object? scanResult = null,
  }) {
    return _then(_value.copyWith(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasScanned: null == hasScanned
          ? _value.hasScanned
          : hasScanned // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowingDialog: null == isShowingDialog
          ? _value.isShowingDialog
          : isShowingDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      dialogDismissed: null == dialogDismissed
          ? _value.dialogDismissed
          : dialogDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successResult: freezed == successResult
          ? _value.successResult
          : successResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      scanResult: null == scanResult
          ? _value.scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as QrScanResult,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrScannerStateImplCopyWith<$Res>
    implements $QrScannerStateCopyWith<$Res> {
  factory _$$QrScannerStateImplCopyWith(_$QrScannerStateImpl value,
          $Res Function(_$QrScannerStateImpl) then) =
      __$$QrScannerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isProcessing,
      bool hasScanned,
      bool isShowingDialog,
      bool dialogDismissed,
      String? errorMessage,
      Map<String, dynamic>? successResult,
      QrScanResult scanResult});
}

/// @nodoc
class __$$QrScannerStateImplCopyWithImpl<$Res>
    extends _$QrScannerStateCopyWithImpl<$Res, _$QrScannerStateImpl>
    implements _$$QrScannerStateImplCopyWith<$Res> {
  __$$QrScannerStateImplCopyWithImpl(
      _$QrScannerStateImpl _value, $Res Function(_$QrScannerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of QrScannerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? hasScanned = null,
    Object? isShowingDialog = null,
    Object? dialogDismissed = null,
    Object? errorMessage = freezed,
    Object? successResult = freezed,
    Object? scanResult = null,
  }) {
    return _then(_$QrScannerStateImpl(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasScanned: null == hasScanned
          ? _value.hasScanned
          : hasScanned // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowingDialog: null == isShowingDialog
          ? _value.isShowingDialog
          : isShowingDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      dialogDismissed: null == dialogDismissed
          ? _value.dialogDismissed
          : dialogDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successResult: freezed == successResult
          ? _value._successResult
          : successResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      scanResult: null == scanResult
          ? _value.scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as QrScanResult,
    ));
  }
}

/// @nodoc

class _$QrScannerStateImpl implements _QrScannerState {
  const _$QrScannerStateImpl(
      {this.isProcessing = false,
      this.hasScanned = false,
      this.isShowingDialog = false,
      this.dialogDismissed = false,
      this.errorMessage,
      final Map<String, dynamic>? successResult,
      this.scanResult = QrScanResult.idle})
      : _successResult = successResult;

  /// 현재 스캔 처리 중인지 여부
  @override
  @JsonKey()
  final bool isProcessing;

  /// 이미 스캔이 완료되었는지 여부 (중복 스캔 방지)
  @override
  @JsonKey()
  final bool hasScanned;

  /// 다이얼로그가 현재 표시 중인지 여부
  @override
  @JsonKey()
  final bool isShowingDialog;

  /// 다이얼로그가 이미 닫혔는지 여부 (이중 pop 방지)
  @override
  @JsonKey()
  final bool dialogDismissed;

  /// 에러 메시지 (있을 경우)
  @override
  final String? errorMessage;

  /// 성공 결과 데이터
  final Map<String, dynamic>? _successResult;

  /// 성공 결과 데이터
  @override
  Map<String, dynamic>? get successResult {
    final value = _successResult;
    if (value == null) return null;
    if (_successResult is EqualUnmodifiableMapView) return _successResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 스캔 결과 상태
  @override
  @JsonKey()
  final QrScanResult scanResult;

  @override
  String toString() {
    return 'QrScannerState(isProcessing: $isProcessing, hasScanned: $hasScanned, isShowingDialog: $isShowingDialog, dialogDismissed: $dialogDismissed, errorMessage: $errorMessage, successResult: $successResult, scanResult: $scanResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrScannerStateImpl &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.hasScanned, hasScanned) ||
                other.hasScanned == hasScanned) &&
            (identical(other.isShowingDialog, isShowingDialog) ||
                other.isShowingDialog == isShowingDialog) &&
            (identical(other.dialogDismissed, dialogDismissed) ||
                other.dialogDismissed == dialogDismissed) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._successResult, _successResult) &&
            (identical(other.scanResult, scanResult) ||
                other.scanResult == scanResult));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isProcessing,
      hasScanned,
      isShowingDialog,
      dialogDismissed,
      errorMessage,
      const DeepCollectionEquality().hash(_successResult),
      scanResult);

  /// Create a copy of QrScannerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrScannerStateImplCopyWith<_$QrScannerStateImpl> get copyWith =>
      __$$QrScannerStateImplCopyWithImpl<_$QrScannerStateImpl>(
          this, _$identity);
}

abstract class _QrScannerState implements QrScannerState {
  const factory _QrScannerState(
      {final bool isProcessing,
      final bool hasScanned,
      final bool isShowingDialog,
      final bool dialogDismissed,
      final String? errorMessage,
      final Map<String, dynamic>? successResult,
      final QrScanResult scanResult}) = _$QrScannerStateImpl;

  /// 현재 스캔 처리 중인지 여부
  @override
  bool get isProcessing;

  /// 이미 스캔이 완료되었는지 여부 (중복 스캔 방지)
  @override
  bool get hasScanned;

  /// 다이얼로그가 현재 표시 중인지 여부
  @override
  bool get isShowingDialog;

  /// 다이얼로그가 이미 닫혔는지 여부 (이중 pop 방지)
  @override
  bool get dialogDismissed;

  /// 에러 메시지 (있을 경우)
  @override
  String? get errorMessage;

  /// 성공 결과 데이터
  @override
  Map<String, dynamic>? get successResult;

  /// 스캔 결과 상태
  @override
  QrScanResult get scanResult;

  /// Create a copy of QrScannerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrScannerStateImplCopyWith<_$QrScannerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
