// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JournalEntryState {
  /// Current journal entry being edited
  JournalEntry? get currentEntry => throw _privateConstructorUsedError;

  /// Transaction lines for the journal entry
  List<TransactionLine> get transactionLines =>
      throw _privateConstructorUsedError;

  /// Pending attachments to be uploaded (local files)
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<JournalAttachment> get pendingAttachments =>
      throw _privateConstructorUsedError;

  /// Whether the page is currently loading data
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether currently submitting the journal entry
  bool get isSubmitting => throw _privateConstructorUsedError;

  /// Whether currently uploading attachments
  bool get isUploadingAttachments => throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Field-specific validation errors
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Entry date for the journal
  DateTime? get entryDate => throw _privateConstructorUsedError;

  /// Overall description for the journal entry
  String? get overallDescription => throw _privateConstructorUsedError;

  /// Selected company ID
  String? get selectedCompanyId => throw _privateConstructorUsedError;

  /// Selected store ID
  String? get selectedStoreId => throw _privateConstructorUsedError;

  /// Counterparty cash location ID
  String? get counterpartyCashLocationId => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryStateCopyWith<JournalEntryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryStateCopyWith<$Res> {
  factory $JournalEntryStateCopyWith(
          JournalEntryState value, $Res Function(JournalEntryState) then) =
      _$JournalEntryStateCopyWithImpl<$Res, JournalEntryState>;
  @useResult
  $Res call(
      {JournalEntry? currentEntry,
      List<TransactionLine> transactionLines,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<JournalAttachment> pendingAttachments,
      bool isLoading,
      bool isSubmitting,
      bool isUploadingAttachments,
      String? errorMessage,
      Map<String, String> fieldErrors,
      DateTime? entryDate,
      String? overallDescription,
      String? selectedCompanyId,
      String? selectedStoreId,
      String? counterpartyCashLocationId});

  $JournalEntryCopyWith<$Res>? get currentEntry;
}

/// @nodoc
class _$JournalEntryStateCopyWithImpl<$Res, $Val extends JournalEntryState>
    implements $JournalEntryStateCopyWith<$Res> {
  _$JournalEntryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentEntry = freezed,
    Object? transactionLines = null,
    Object? pendingAttachments = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isUploadingAttachments = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? entryDate = freezed,
    Object? overallDescription = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedStoreId = freezed,
    Object? counterpartyCashLocationId = freezed,
  }) {
    return _then(_value.copyWith(
      currentEntry: freezed == currentEntry
          ? _value.currentEntry
          : currentEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry?,
      transactionLines: null == transactionLines
          ? _value.transactionLines
          : transactionLines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      pendingAttachments: null == pendingAttachments
          ? _value.pendingAttachments
          : pendingAttachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingAttachments: null == isUploadingAttachments
          ? _value.isUploadingAttachments
          : isUploadingAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      entryDate: freezed == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      overallDescription: freezed == overallDescription
          ? _value.overallDescription
          : overallDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _value.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JournalEntryCopyWith<$Res>? get currentEntry {
    if (_value.currentEntry == null) {
      return null;
    }

    return $JournalEntryCopyWith<$Res>(_value.currentEntry!, (value) {
      return _then(_value.copyWith(currentEntry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalEntryStateImplCopyWith<$Res>
    implements $JournalEntryStateCopyWith<$Res> {
  factory _$$JournalEntryStateImplCopyWith(_$JournalEntryStateImpl value,
          $Res Function(_$JournalEntryStateImpl) then) =
      __$$JournalEntryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {JournalEntry? currentEntry,
      List<TransactionLine> transactionLines,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<JournalAttachment> pendingAttachments,
      bool isLoading,
      bool isSubmitting,
      bool isUploadingAttachments,
      String? errorMessage,
      Map<String, String> fieldErrors,
      DateTime? entryDate,
      String? overallDescription,
      String? selectedCompanyId,
      String? selectedStoreId,
      String? counterpartyCashLocationId});

  @override
  $JournalEntryCopyWith<$Res>? get currentEntry;
}

/// @nodoc
class __$$JournalEntryStateImplCopyWithImpl<$Res>
    extends _$JournalEntryStateCopyWithImpl<$Res, _$JournalEntryStateImpl>
    implements _$$JournalEntryStateImplCopyWith<$Res> {
  __$$JournalEntryStateImplCopyWithImpl(_$JournalEntryStateImpl _value,
      $Res Function(_$JournalEntryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentEntry = freezed,
    Object? transactionLines = null,
    Object? pendingAttachments = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isUploadingAttachments = null,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? entryDate = freezed,
    Object? overallDescription = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedStoreId = freezed,
    Object? counterpartyCashLocationId = freezed,
  }) {
    return _then(_$JournalEntryStateImpl(
      currentEntry: freezed == currentEntry
          ? _value.currentEntry
          : currentEntry // ignore: cast_nullable_to_non_nullable
              as JournalEntry?,
      transactionLines: null == transactionLines
          ? _value._transactionLines
          : transactionLines // ignore: cast_nullable_to_non_nullable
              as List<TransactionLine>,
      pendingAttachments: null == pendingAttachments
          ? _value._pendingAttachments
          : pendingAttachments // ignore: cast_nullable_to_non_nullable
              as List<JournalAttachment>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingAttachments: null == isUploadingAttachments
          ? _value.isUploadingAttachments
          : isUploadingAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      entryDate: freezed == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      overallDescription: freezed == overallDescription
          ? _value.overallDescription
          : overallDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _value.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$JournalEntryStateImpl extends _JournalEntryState {
  const _$JournalEntryStateImpl(
      {this.currentEntry,
      final List<TransactionLine> transactionLines = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<JournalAttachment> pendingAttachments = const [],
      this.isLoading = false,
      this.isSubmitting = false,
      this.isUploadingAttachments = false,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {},
      this.entryDate,
      this.overallDescription,
      this.selectedCompanyId,
      this.selectedStoreId,
      this.counterpartyCashLocationId})
      : _transactionLines = transactionLines,
        _pendingAttachments = pendingAttachments,
        _fieldErrors = fieldErrors,
        super._();

  /// Current journal entry being edited
  @override
  final JournalEntry? currentEntry;

  /// Transaction lines for the journal entry
  final List<TransactionLine> _transactionLines;

  /// Transaction lines for the journal entry
  @override
  @JsonKey()
  List<TransactionLine> get transactionLines {
    if (_transactionLines is EqualUnmodifiableListView)
      return _transactionLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactionLines);
  }

  /// Pending attachments to be uploaded (local files)
  final List<JournalAttachment> _pendingAttachments;

  /// Pending attachments to be uploaded (local files)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<JournalAttachment> get pendingAttachments {
    if (_pendingAttachments is EqualUnmodifiableListView)
      return _pendingAttachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingAttachments);
  }

  /// Whether the page is currently loading data
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether currently submitting the journal entry
  @override
  @JsonKey()
  final bool isSubmitting;

  /// Whether currently uploading attachments
  @override
  @JsonKey()
  final bool isUploadingAttachments;

  /// Error message if any error occurred
  @override
  final String? errorMessage;

  /// Field-specific validation errors
  final Map<String, String> _fieldErrors;

  /// Field-specific validation errors
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  /// Entry date for the journal
  @override
  final DateTime? entryDate;

  /// Overall description for the journal entry
  @override
  final String? overallDescription;

  /// Selected company ID
  @override
  final String? selectedCompanyId;

  /// Selected store ID
  @override
  final String? selectedStoreId;

  /// Counterparty cash location ID
  @override
  final String? counterpartyCashLocationId;

  @override
  String toString() {
    return 'JournalEntryState(currentEntry: $currentEntry, transactionLines: $transactionLines, pendingAttachments: $pendingAttachments, isLoading: $isLoading, isSubmitting: $isSubmitting, isUploadingAttachments: $isUploadingAttachments, errorMessage: $errorMessage, fieldErrors: $fieldErrors, entryDate: $entryDate, overallDescription: $overallDescription, selectedCompanyId: $selectedCompanyId, selectedStoreId: $selectedStoreId, counterpartyCashLocationId: $counterpartyCashLocationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryStateImpl &&
            (identical(other.currentEntry, currentEntry) ||
                other.currentEntry == currentEntry) &&
            const DeepCollectionEquality()
                .equals(other._transactionLines, _transactionLines) &&
            const DeepCollectionEquality()
                .equals(other._pendingAttachments, _pendingAttachments) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isUploadingAttachments, isUploadingAttachments) ||
                other.isUploadingAttachments == isUploadingAttachments) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.overallDescription, overallDescription) ||
                other.overallDescription == overallDescription) &&
            (identical(other.selectedCompanyId, selectedCompanyId) ||
                other.selectedCompanyId == selectedCompanyId) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            (identical(other.counterpartyCashLocationId,
                    counterpartyCashLocationId) ||
                other.counterpartyCashLocationId ==
                    counterpartyCashLocationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentEntry,
      const DeepCollectionEquality().hash(_transactionLines),
      const DeepCollectionEquality().hash(_pendingAttachments),
      isLoading,
      isSubmitting,
      isUploadingAttachments,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      entryDate,
      overallDescription,
      selectedCompanyId,
      selectedStoreId,
      counterpartyCashLocationId);

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryStateImplCopyWith<_$JournalEntryStateImpl> get copyWith =>
      __$$JournalEntryStateImplCopyWithImpl<_$JournalEntryStateImpl>(
          this, _$identity);
}

abstract class _JournalEntryState extends JournalEntryState {
  const factory _JournalEntryState(
      {final JournalEntry? currentEntry,
      final List<TransactionLine> transactionLines,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<JournalAttachment> pendingAttachments,
      final bool isLoading,
      final bool isSubmitting,
      final bool isUploadingAttachments,
      final String? errorMessage,
      final Map<String, String> fieldErrors,
      final DateTime? entryDate,
      final String? overallDescription,
      final String? selectedCompanyId,
      final String? selectedStoreId,
      final String? counterpartyCashLocationId}) = _$JournalEntryStateImpl;
  const _JournalEntryState._() : super._();

  /// Current journal entry being edited
  @override
  JournalEntry? get currentEntry;

  /// Transaction lines for the journal entry
  @override
  List<TransactionLine> get transactionLines;

  /// Pending attachments to be uploaded (local files)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<JournalAttachment> get pendingAttachments;

  /// Whether the page is currently loading data
  @override
  bool get isLoading;

  /// Whether currently submitting the journal entry
  @override
  bool get isSubmitting;

  /// Whether currently uploading attachments
  @override
  bool get isUploadingAttachments;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Field-specific validation errors
  @override
  Map<String, String> get fieldErrors;

  /// Entry date for the journal
  @override
  DateTime? get entryDate;

  /// Overall description for the journal entry
  @override
  String? get overallDescription;

  /// Selected company ID
  @override
  String? get selectedCompanyId;

  /// Selected store ID
  @override
  String? get selectedStoreId;

  /// Counterparty cash location ID
  @override
  String? get counterpartyCashLocationId;

  /// Create a copy of JournalEntryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryStateImplCopyWith<_$JournalEntryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionLineCreationState {
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isValidating => throw _privateConstructorUsedError;
  TransactionLine? get editingLine => throw _privateConstructorUsedError;
  int? get editingIndex => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionLineCreationStateCopyWith<TransactionLineCreationState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionLineCreationStateCopyWith<$Res> {
  factory $TransactionLineCreationStateCopyWith(
          TransactionLineCreationState value,
          $Res Function(TransactionLineCreationState) then) =
      _$TransactionLineCreationStateCopyWithImpl<$Res,
          TransactionLineCreationState>;
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      TransactionLine? editingLine,
      int? editingIndex,
      String? errorMessage,
      Map<String, String> fieldErrors});

  $TransactionLineCopyWith<$Res>? get editingLine;
}

/// @nodoc
class _$TransactionLineCreationStateCopyWithImpl<$Res,
        $Val extends TransactionLineCreationState>
    implements $TransactionLineCreationStateCopyWith<$Res> {
  _$TransactionLineCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? editingLine = freezed,
    Object? editingIndex = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_value.copyWith(
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      editingLine: freezed == editingLine
          ? _value.editingLine
          : editingLine // ignore: cast_nullable_to_non_nullable
              as TransactionLine?,
      editingIndex: freezed == editingIndex
          ? _value.editingIndex
          : editingIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionLineCopyWith<$Res>? get editingLine {
    if (_value.editingLine == null) {
      return null;
    }

    return $TransactionLineCopyWith<$Res>(_value.editingLine!, (value) {
      return _then(_value.copyWith(editingLine: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionLineCreationStateImplCopyWith<$Res>
    implements $TransactionLineCreationStateCopyWith<$Res> {
  factory _$$TransactionLineCreationStateImplCopyWith(
          _$TransactionLineCreationStateImpl value,
          $Res Function(_$TransactionLineCreationStateImpl) then) =
      __$$TransactionLineCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      TransactionLine? editingLine,
      int? editingIndex,
      String? errorMessage,
      Map<String, String> fieldErrors});

  @override
  $TransactionLineCopyWith<$Res>? get editingLine;
}

/// @nodoc
class __$$TransactionLineCreationStateImplCopyWithImpl<$Res>
    extends _$TransactionLineCreationStateCopyWithImpl<$Res,
        _$TransactionLineCreationStateImpl>
    implements _$$TransactionLineCreationStateImplCopyWith<$Res> {
  __$$TransactionLineCreationStateImplCopyWithImpl(
      _$TransactionLineCreationStateImpl _value,
      $Res Function(_$TransactionLineCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? editingLine = freezed,
    Object? editingIndex = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_$TransactionLineCreationStateImpl(
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      editingLine: freezed == editingLine
          ? _value.editingLine
          : editingLine // ignore: cast_nullable_to_non_nullable
              as TransactionLine?,
      editingIndex: freezed == editingIndex
          ? _value.editingIndex
          : editingIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$TransactionLineCreationStateImpl
    implements _TransactionLineCreationState {
  const _$TransactionLineCreationStateImpl(
      {this.isCreating = false,
      this.isValidating = false,
      this.editingLine,
      this.editingIndex,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {}})
      : _fieldErrors = fieldErrors;

  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isValidating;
  @override
  final TransactionLine? editingLine;
  @override
  final int? editingIndex;
  @override
  final String? errorMessage;
  final Map<String, String> _fieldErrors;
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  String toString() {
    return 'TransactionLineCreationState(isCreating: $isCreating, isValidating: $isValidating, editingLine: $editingLine, editingIndex: $editingIndex, errorMessage: $errorMessage, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLineCreationStateImpl &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.editingLine, editingLine) ||
                other.editingLine == editingLine) &&
            (identical(other.editingIndex, editingIndex) ||
                other.editingIndex == editingIndex) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCreating,
      isValidating,
      editingLine,
      editingIndex,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLineCreationStateImplCopyWith<
          _$TransactionLineCreationStateImpl>
      get copyWith => __$$TransactionLineCreationStateImplCopyWithImpl<
          _$TransactionLineCreationStateImpl>(this, _$identity);
}

abstract class _TransactionLineCreationState
    implements TransactionLineCreationState {
  const factory _TransactionLineCreationState(
          {final bool isCreating,
          final bool isValidating,
          final TransactionLine? editingLine,
          final int? editingIndex,
          final String? errorMessage,
          final Map<String, String> fieldErrors}) =
      _$TransactionLineCreationStateImpl;

  @override
  bool get isCreating;
  @override
  bool get isValidating;
  @override
  TransactionLine? get editingLine;
  @override
  int? get editingIndex;
  @override
  String? get errorMessage;
  @override
  Map<String, String> get fieldErrors;

  /// Create a copy of TransactionLineCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionLineCreationStateImplCopyWith<
          _$TransactionLineCreationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
