// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TemplateState {
  List<TransactionTemplate> get templates => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  String get selectedFilter => throw _privateConstructorUsedError;

  /// Create a copy of TemplateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateStateCopyWith<TemplateState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateStateCopyWith<$Res> {
  factory $TemplateStateCopyWith(
          TemplateState value, $Res Function(TemplateState) then) =
      _$TemplateStateCopyWithImpl<$Res, TemplateState>;
  @useResult
  $Res call(
      {List<TransactionTemplate> templates,
      bool isLoading,
      bool isCreating,
      String? errorMessage,
      String? searchQuery,
      String selectedFilter});
}

/// @nodoc
class _$TemplateStateCopyWithImpl<$Res, $Val extends TemplateState>
    implements $TemplateStateCopyWith<$Res> {
  _$TemplateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templates = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? errorMessage = freezed,
    Object? searchQuery = freezed,
    Object? selectedFilter = null,
  }) {
    return _then(_value.copyWith(
      templates: null == templates
          ? _value.templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<TransactionTemplate>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFilter: null == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateStateImplCopyWith<$Res>
    implements $TemplateStateCopyWith<$Res> {
  factory _$$TemplateStateImplCopyWith(
          _$TemplateStateImpl value, $Res Function(_$TemplateStateImpl) then) =
      __$$TemplateStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransactionTemplate> templates,
      bool isLoading,
      bool isCreating,
      String? errorMessage,
      String? searchQuery,
      String selectedFilter});
}

/// @nodoc
class __$$TemplateStateImplCopyWithImpl<$Res>
    extends _$TemplateStateCopyWithImpl<$Res, _$TemplateStateImpl>
    implements _$$TemplateStateImplCopyWith<$Res> {
  __$$TemplateStateImplCopyWithImpl(
      _$TemplateStateImpl _value, $Res Function(_$TemplateStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templates = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? errorMessage = freezed,
    Object? searchQuery = freezed,
    Object? selectedFilter = null,
  }) {
    return _then(_$TemplateStateImpl(
      templates: null == templates
          ? _value._templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<TransactionTemplate>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFilter: null == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TemplateStateImpl implements _TemplateState {
  const _$TemplateStateImpl(
      {final List<TransactionTemplate> templates = const [],
      this.isLoading = false,
      this.isCreating = false,
      this.errorMessage,
      this.searchQuery,
      this.selectedFilter = 'all'})
      : _templates = templates;

  final List<TransactionTemplate> _templates;
  @override
  @JsonKey()
  List<TransactionTemplate> get templates {
    if (_templates is EqualUnmodifiableListView) return _templates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templates);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  final String? errorMessage;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final String selectedFilter;

  @override
  String toString() {
    return 'TemplateState(templates: $templates, isLoading: $isLoading, isCreating: $isCreating, errorMessage: $errorMessage, searchQuery: $searchQuery, selectedFilter: $selectedFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateStateImpl &&
            const DeepCollectionEquality()
                .equals(other._templates, _templates) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedFilter, selectedFilter) ||
                other.selectedFilter == selectedFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_templates),
      isLoading,
      isCreating,
      errorMessage,
      searchQuery,
      selectedFilter);

  /// Create a copy of TemplateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateStateImplCopyWith<_$TemplateStateImpl> get copyWith =>
      __$$TemplateStateImplCopyWithImpl<_$TemplateStateImpl>(this, _$identity);
}

abstract class _TemplateState implements TemplateState {
  const factory _TemplateState(
      {final List<TransactionTemplate> templates,
      final bool isLoading,
      final bool isCreating,
      final String? errorMessage,
      final String? searchQuery,
      final String selectedFilter}) = _$TemplateStateImpl;

  @override
  List<TransactionTemplate> get templates;
  @override
  bool get isLoading;
  @override
  bool get isCreating;
  @override
  String? get errorMessage;
  @override
  String? get searchQuery;
  @override
  String get selectedFilter;

  /// Create a copy of TemplateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateStateImplCopyWith<_$TemplateStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TemplateCreationState {
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isValidating => throw _privateConstructorUsedError;
  TransactionTemplate? get createdTemplate =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;

  /// Create a copy of TemplateCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateCreationStateCopyWith<TemplateCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateCreationStateCopyWith<$Res> {
  factory $TemplateCreationStateCopyWith(TemplateCreationState value,
          $Res Function(TemplateCreationState) then) =
      _$TemplateCreationStateCopyWithImpl<$Res, TemplateCreationState>;
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      TransactionTemplate? createdTemplate,
      String? errorMessage,
      Map<String, String> fieldErrors});
}

/// @nodoc
class _$TemplateCreationStateCopyWithImpl<$Res,
        $Val extends TemplateCreationState>
    implements $TemplateCreationStateCopyWith<$Res> {
  _$TemplateCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? createdTemplate = freezed,
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
      createdTemplate: freezed == createdTemplate
          ? _value.createdTemplate
          : createdTemplate // ignore: cast_nullable_to_non_nullable
              as TransactionTemplate?,
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
}

/// @nodoc
abstract class _$$TemplateCreationStateImplCopyWith<$Res>
    implements $TemplateCreationStateCopyWith<$Res> {
  factory _$$TemplateCreationStateImplCopyWith(
          _$TemplateCreationStateImpl value,
          $Res Function(_$TemplateCreationStateImpl) then) =
      __$$TemplateCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCreating,
      bool isValidating,
      TransactionTemplate? createdTemplate,
      String? errorMessage,
      Map<String, String> fieldErrors});
}

/// @nodoc
class __$$TemplateCreationStateImplCopyWithImpl<$Res>
    extends _$TemplateCreationStateCopyWithImpl<$Res,
        _$TemplateCreationStateImpl>
    implements _$$TemplateCreationStateImplCopyWith<$Res> {
  __$$TemplateCreationStateImplCopyWithImpl(_$TemplateCreationStateImpl _value,
      $Res Function(_$TemplateCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreating = null,
    Object? isValidating = null,
    Object? createdTemplate = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
  }) {
    return _then(_$TemplateCreationStateImpl(
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      createdTemplate: freezed == createdTemplate
          ? _value.createdTemplate
          : createdTemplate // ignore: cast_nullable_to_non_nullable
              as TransactionTemplate?,
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

class _$TemplateCreationStateImpl implements _TemplateCreationState {
  const _$TemplateCreationStateImpl(
      {this.isCreating = false,
      this.isValidating = false,
      this.createdTemplate,
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
  final TransactionTemplate? createdTemplate;
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
    return 'TemplateCreationState(isCreating: $isCreating, isValidating: $isValidating, createdTemplate: $createdTemplate, errorMessage: $errorMessage, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateCreationStateImpl &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.createdTemplate, createdTemplate) ||
                other.createdTemplate == createdTemplate) &&
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
      createdTemplate,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of TemplateCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateCreationStateImplCopyWith<_$TemplateCreationStateImpl>
      get copyWith => __$$TemplateCreationStateImplCopyWithImpl<
          _$TemplateCreationStateImpl>(this, _$identity);
}

abstract class _TemplateCreationState implements TemplateCreationState {
  const factory _TemplateCreationState(
      {final bool isCreating,
      final bool isValidating,
      final TransactionTemplate? createdTemplate,
      final String? errorMessage,
      final Map<String, String> fieldErrors}) = _$TemplateCreationStateImpl;

  @override
  bool get isCreating;
  @override
  bool get isValidating;
  @override
  TransactionTemplate? get createdTemplate;
  @override
  String? get errorMessage;
  @override
  Map<String, String> get fieldErrors;

  /// Create a copy of TemplateCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateCreationStateImplCopyWith<_$TemplateCreationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TemplateFilterState {
  String get visibilityFilter =>
      throw _privateConstructorUsedError; // all, public, private
  String get statusFilter =>
      throw _privateConstructorUsedError; // all, active, inactive
  String get searchText => throw _privateConstructorUsedError;
  bool get showMyTemplatesOnly => throw _privateConstructorUsedError;
  List<String>? get accountIds =>
      throw _privateConstructorUsedError; // Filter by account IDs
  String? get counterpartyId =>
      throw _privateConstructorUsedError; // Filter by counterparty ID
  String? get cashLocationId => throw _privateConstructorUsedError;

  /// Create a copy of TemplateFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateFilterStateCopyWith<TemplateFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateFilterStateCopyWith<$Res> {
  factory $TemplateFilterStateCopyWith(
          TemplateFilterState value, $Res Function(TemplateFilterState) then) =
      _$TemplateFilterStateCopyWithImpl<$Res, TemplateFilterState>;
  @useResult
  $Res call(
      {String visibilityFilter,
      String statusFilter,
      String searchText,
      bool showMyTemplatesOnly,
      List<String>? accountIds,
      String? counterpartyId,
      String? cashLocationId});
}

/// @nodoc
class _$TemplateFilterStateCopyWithImpl<$Res, $Val extends TemplateFilterState>
    implements $TemplateFilterStateCopyWith<$Res> {
  _$TemplateFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visibilityFilter = null,
    Object? statusFilter = null,
    Object? searchText = null,
    Object? showMyTemplatesOnly = null,
    Object? accountIds = freezed,
    Object? counterpartyId = freezed,
    Object? cashLocationId = freezed,
  }) {
    return _then(_value.copyWith(
      visibilityFilter: null == visibilityFilter
          ? _value.visibilityFilter
          : visibilityFilter // ignore: cast_nullable_to_non_nullable
              as String,
      statusFilter: null == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      showMyTemplatesOnly: null == showMyTemplatesOnly
          ? _value.showMyTemplatesOnly
          : showMyTemplatesOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      accountIds: freezed == accountIds
          ? _value.accountIds
          : accountIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateFilterStateImplCopyWith<$Res>
    implements $TemplateFilterStateCopyWith<$Res> {
  factory _$$TemplateFilterStateImplCopyWith(_$TemplateFilterStateImpl value,
          $Res Function(_$TemplateFilterStateImpl) then) =
      __$$TemplateFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String visibilityFilter,
      String statusFilter,
      String searchText,
      bool showMyTemplatesOnly,
      List<String>? accountIds,
      String? counterpartyId,
      String? cashLocationId});
}

/// @nodoc
class __$$TemplateFilterStateImplCopyWithImpl<$Res>
    extends _$TemplateFilterStateCopyWithImpl<$Res, _$TemplateFilterStateImpl>
    implements _$$TemplateFilterStateImplCopyWith<$Res> {
  __$$TemplateFilterStateImplCopyWithImpl(_$TemplateFilterStateImpl _value,
      $Res Function(_$TemplateFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visibilityFilter = null,
    Object? statusFilter = null,
    Object? searchText = null,
    Object? showMyTemplatesOnly = null,
    Object? accountIds = freezed,
    Object? counterpartyId = freezed,
    Object? cashLocationId = freezed,
  }) {
    return _then(_$TemplateFilterStateImpl(
      visibilityFilter: null == visibilityFilter
          ? _value.visibilityFilter
          : visibilityFilter // ignore: cast_nullable_to_non_nullable
              as String,
      statusFilter: null == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      showMyTemplatesOnly: null == showMyTemplatesOnly
          ? _value.showMyTemplatesOnly
          : showMyTemplatesOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      accountIds: freezed == accountIds
          ? _value._accountIds
          : accountIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TemplateFilterStateImpl extends _TemplateFilterState {
  const _$TemplateFilterStateImpl(
      {this.visibilityFilter = 'all',
      this.statusFilter = 'all',
      this.searchText = '',
      this.showMyTemplatesOnly = false,
      final List<String>? accountIds,
      this.counterpartyId,
      this.cashLocationId})
      : _accountIds = accountIds,
        super._();

  @override
  @JsonKey()
  final String visibilityFilter;
// all, public, private
  @override
  @JsonKey()
  final String statusFilter;
// all, active, inactive
  @override
  @JsonKey()
  final String searchText;
  @override
  @JsonKey()
  final bool showMyTemplatesOnly;
  final List<String>? _accountIds;
  @override
  List<String>? get accountIds {
    final value = _accountIds;
    if (value == null) return null;
    if (_accountIds is EqualUnmodifiableListView) return _accountIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Filter by account IDs
  @override
  final String? counterpartyId;
// Filter by counterparty ID
  @override
  final String? cashLocationId;

  @override
  String toString() {
    return 'TemplateFilterState(visibilityFilter: $visibilityFilter, statusFilter: $statusFilter, searchText: $searchText, showMyTemplatesOnly: $showMyTemplatesOnly, accountIds: $accountIds, counterpartyId: $counterpartyId, cashLocationId: $cashLocationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateFilterStateImpl &&
            (identical(other.visibilityFilter, visibilityFilter) ||
                other.visibilityFilter == visibilityFilter) &&
            (identical(other.statusFilter, statusFilter) ||
                other.statusFilter == statusFilter) &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.showMyTemplatesOnly, showMyTemplatesOnly) ||
                other.showMyTemplatesOnly == showMyTemplatesOnly) &&
            const DeepCollectionEquality()
                .equals(other._accountIds, _accountIds) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      visibilityFilter,
      statusFilter,
      searchText,
      showMyTemplatesOnly,
      const DeepCollectionEquality().hash(_accountIds),
      counterpartyId,
      cashLocationId);

  /// Create a copy of TemplateFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateFilterStateImplCopyWith<_$TemplateFilterStateImpl> get copyWith =>
      __$$TemplateFilterStateImplCopyWithImpl<_$TemplateFilterStateImpl>(
          this, _$identity);
}

abstract class _TemplateFilterState extends TemplateFilterState {
  const factory _TemplateFilterState(
      {final String visibilityFilter,
      final String statusFilter,
      final String searchText,
      final bool showMyTemplatesOnly,
      final List<String>? accountIds,
      final String? counterpartyId,
      final String? cashLocationId}) = _$TemplateFilterStateImpl;
  const _TemplateFilterState._() : super._();

  @override
  String get visibilityFilter; // all, public, private
  @override
  String get statusFilter; // all, active, inactive
  @override
  String get searchText;
  @override
  bool get showMyTemplatesOnly;
  @override
  List<String>? get accountIds; // Filter by account IDs
  @override
  String? get counterpartyId; // Filter by counterparty ID
  @override
  String? get cashLocationId;

  /// Create a copy of TemplateFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateFilterStateImplCopyWith<_$TemplateFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
