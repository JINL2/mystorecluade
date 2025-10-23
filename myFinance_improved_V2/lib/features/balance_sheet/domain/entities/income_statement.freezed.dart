// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_statement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IncomeStatementSubcategory {
  String get subcategoryName => throw _privateConstructorUsedError;
  double get subcategoryTotal => throw _privateConstructorUsedError;
  List<IncomeStatementAccount> get accounts =>
      throw _privateConstructorUsedError;

  /// Create a copy of IncomeStatementSubcategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeStatementSubcategoryCopyWith<IncomeStatementSubcategory>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeStatementSubcategoryCopyWith<$Res> {
  factory $IncomeStatementSubcategoryCopyWith(IncomeStatementSubcategory value,
          $Res Function(IncomeStatementSubcategory) then) =
      _$IncomeStatementSubcategoryCopyWithImpl<$Res,
          IncomeStatementSubcategory>;
  @useResult
  $Res call(
      {String subcategoryName,
      double subcategoryTotal,
      List<IncomeStatementAccount> accounts});
}

/// @nodoc
class _$IncomeStatementSubcategoryCopyWithImpl<$Res,
        $Val extends IncomeStatementSubcategory>
    implements $IncomeStatementSubcategoryCopyWith<$Res> {
  _$IncomeStatementSubcategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeStatementSubcategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryName = null,
    Object? subcategoryTotal = null,
    Object? accounts = null,
  }) {
    return _then(_value.copyWith(
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryTotal: null == subcategoryTotal
          ? _value.subcategoryTotal
          : subcategoryTotal // ignore: cast_nullable_to_non_nullable
              as double,
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementAccount>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeStatementSubcategoryImplCopyWith<$Res>
    implements $IncomeStatementSubcategoryCopyWith<$Res> {
  factory _$$IncomeStatementSubcategoryImplCopyWith(
          _$IncomeStatementSubcategoryImpl value,
          $Res Function(_$IncomeStatementSubcategoryImpl) then) =
      __$$IncomeStatementSubcategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String subcategoryName,
      double subcategoryTotal,
      List<IncomeStatementAccount> accounts});
}

/// @nodoc
class __$$IncomeStatementSubcategoryImplCopyWithImpl<$Res>
    extends _$IncomeStatementSubcategoryCopyWithImpl<$Res,
        _$IncomeStatementSubcategoryImpl>
    implements _$$IncomeStatementSubcategoryImplCopyWith<$Res> {
  __$$IncomeStatementSubcategoryImplCopyWithImpl(
      _$IncomeStatementSubcategoryImpl _value,
      $Res Function(_$IncomeStatementSubcategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeStatementSubcategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryName = null,
    Object? subcategoryTotal = null,
    Object? accounts = null,
  }) {
    return _then(_$IncomeStatementSubcategoryImpl(
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryTotal: null == subcategoryTotal
          ? _value.subcategoryTotal
          : subcategoryTotal // ignore: cast_nullable_to_non_nullable
              as double,
      accounts: null == accounts
          ? _value._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementAccount>,
    ));
  }
}

/// @nodoc

class _$IncomeStatementSubcategoryImpl implements _IncomeStatementSubcategory {
  const _$IncomeStatementSubcategoryImpl(
      {required this.subcategoryName,
      required this.subcategoryTotal,
      required final List<IncomeStatementAccount> accounts})
      : _accounts = accounts;

  @override
  final String subcategoryName;
  @override
  final double subcategoryTotal;
  final List<IncomeStatementAccount> _accounts;
  @override
  List<IncomeStatementAccount> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  @override
  String toString() {
    return 'IncomeStatementSubcategory(subcategoryName: $subcategoryName, subcategoryTotal: $subcategoryTotal, accounts: $accounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeStatementSubcategoryImpl &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.subcategoryTotal, subcategoryTotal) ||
                other.subcategoryTotal == subcategoryTotal) &&
            const DeepCollectionEquality().equals(other._accounts, _accounts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subcategoryName,
      subcategoryTotal, const DeepCollectionEquality().hash(_accounts));

  /// Create a copy of IncomeStatementSubcategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeStatementSubcategoryImplCopyWith<_$IncomeStatementSubcategoryImpl>
      get copyWith => __$$IncomeStatementSubcategoryImplCopyWithImpl<
          _$IncomeStatementSubcategoryImpl>(this, _$identity);
}

abstract class _IncomeStatementSubcategory
    implements IncomeStatementSubcategory {
  const factory _IncomeStatementSubcategory(
          {required final String subcategoryName,
          required final double subcategoryTotal,
          required final List<IncomeStatementAccount> accounts}) =
      _$IncomeStatementSubcategoryImpl;

  @override
  String get subcategoryName;
  @override
  double get subcategoryTotal;
  @override
  List<IncomeStatementAccount> get accounts;

  /// Create a copy of IncomeStatementSubcategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeStatementSubcategoryImplCopyWith<_$IncomeStatementSubcategoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IncomeStatementSection {
  String get sectionName => throw _privateConstructorUsedError;
  dynamic get sectionTotal =>
      throw _privateConstructorUsedError; // Can be double or String (for margins)
  List<IncomeStatementSubcategory> get subcategories =>
      throw _privateConstructorUsedError;

  /// Create a copy of IncomeStatementSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeStatementSectionCopyWith<IncomeStatementSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeStatementSectionCopyWith<$Res> {
  factory $IncomeStatementSectionCopyWith(IncomeStatementSection value,
          $Res Function(IncomeStatementSection) then) =
      _$IncomeStatementSectionCopyWithImpl<$Res, IncomeStatementSection>;
  @useResult
  $Res call(
      {String sectionName,
      dynamic sectionTotal,
      List<IncomeStatementSubcategory> subcategories});
}

/// @nodoc
class _$IncomeStatementSectionCopyWithImpl<$Res,
        $Val extends IncomeStatementSection>
    implements $IncomeStatementSectionCopyWith<$Res> {
  _$IncomeStatementSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeStatementSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionName = null,
    Object? sectionTotal = freezed,
    Object? subcategories = null,
  }) {
    return _then(_value.copyWith(
      sectionName: null == sectionName
          ? _value.sectionName
          : sectionName // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTotal: freezed == sectionTotal
          ? _value.sectionTotal
          : sectionTotal // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subcategories: null == subcategories
          ? _value.subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementSubcategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeStatementSectionImplCopyWith<$Res>
    implements $IncomeStatementSectionCopyWith<$Res> {
  factory _$$IncomeStatementSectionImplCopyWith(
          _$IncomeStatementSectionImpl value,
          $Res Function(_$IncomeStatementSectionImpl) then) =
      __$$IncomeStatementSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sectionName,
      dynamic sectionTotal,
      List<IncomeStatementSubcategory> subcategories});
}

/// @nodoc
class __$$IncomeStatementSectionImplCopyWithImpl<$Res>
    extends _$IncomeStatementSectionCopyWithImpl<$Res,
        _$IncomeStatementSectionImpl>
    implements _$$IncomeStatementSectionImplCopyWith<$Res> {
  __$$IncomeStatementSectionImplCopyWithImpl(
      _$IncomeStatementSectionImpl _value,
      $Res Function(_$IncomeStatementSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeStatementSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionName = null,
    Object? sectionTotal = freezed,
    Object? subcategories = null,
  }) {
    return _then(_$IncomeStatementSectionImpl(
      sectionName: null == sectionName
          ? _value.sectionName
          : sectionName // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTotal: freezed == sectionTotal
          ? _value.sectionTotal
          : sectionTotal // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subcategories: null == subcategories
          ? _value._subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementSubcategory>,
    ));
  }
}

/// @nodoc

class _$IncomeStatementSectionImpl implements _IncomeStatementSection {
  const _$IncomeStatementSectionImpl(
      {required this.sectionName,
      required this.sectionTotal,
      required final List<IncomeStatementSubcategory> subcategories})
      : _subcategories = subcategories;

  @override
  final String sectionName;
  @override
  final dynamic sectionTotal;
// Can be double or String (for margins)
  final List<IncomeStatementSubcategory> _subcategories;
// Can be double or String (for margins)
  @override
  List<IncomeStatementSubcategory> get subcategories {
    if (_subcategories is EqualUnmodifiableListView) return _subcategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategories);
  }

  @override
  String toString() {
    return 'IncomeStatementSection(sectionName: $sectionName, sectionTotal: $sectionTotal, subcategories: $subcategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeStatementSectionImpl &&
            (identical(other.sectionName, sectionName) ||
                other.sectionName == sectionName) &&
            const DeepCollectionEquality()
                .equals(other.sectionTotal, sectionTotal) &&
            const DeepCollectionEquality()
                .equals(other._subcategories, _subcategories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sectionName,
      const DeepCollectionEquality().hash(sectionTotal),
      const DeepCollectionEquality().hash(_subcategories));

  /// Create a copy of IncomeStatementSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeStatementSectionImplCopyWith<_$IncomeStatementSectionImpl>
      get copyWith => __$$IncomeStatementSectionImplCopyWithImpl<
          _$IncomeStatementSectionImpl>(this, _$identity);
}

abstract class _IncomeStatementSection implements IncomeStatementSection {
  const factory _IncomeStatementSection(
          {required final String sectionName,
          required final dynamic sectionTotal,
          required final List<IncomeStatementSubcategory> subcategories}) =
      _$IncomeStatementSectionImpl;

  @override
  String get sectionName;
  @override
  dynamic get sectionTotal; // Can be double or String (for margins)
  @override
  List<IncomeStatementSubcategory> get subcategories;

  /// Create a copy of IncomeStatementSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeStatementSectionImplCopyWith<_$IncomeStatementSectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IncomeStatement {
  List<IncomeStatementSection> get sections =>
      throw _privateConstructorUsedError;
  DateRange get dateRange => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeStatementCopyWith<IncomeStatement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeStatementCopyWith<$Res> {
  factory $IncomeStatementCopyWith(
          IncomeStatement value, $Res Function(IncomeStatement) then) =
      _$IncomeStatementCopyWithImpl<$Res, IncomeStatement>;
  @useResult
  $Res call(
      {List<IncomeStatementSection> sections,
      DateRange dateRange,
      String companyId,
      String? storeId});

  $DateRangeCopyWith<$Res> get dateRange;
}

/// @nodoc
class _$IncomeStatementCopyWithImpl<$Res, $Val extends IncomeStatement>
    implements $IncomeStatementCopyWith<$Res> {
  _$IncomeStatementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sections = null,
    Object? dateRange = null,
    Object? companyId = null,
    Object? storeId = freezed,
  }) {
    return _then(_value.copyWith(
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementSection>,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRange,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DateRangeCopyWith<$Res> get dateRange {
    return $DateRangeCopyWith<$Res>(_value.dateRange, (value) {
      return _then(_value.copyWith(dateRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IncomeStatementImplCopyWith<$Res>
    implements $IncomeStatementCopyWith<$Res> {
  factory _$$IncomeStatementImplCopyWith(_$IncomeStatementImpl value,
          $Res Function(_$IncomeStatementImpl) then) =
      __$$IncomeStatementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<IncomeStatementSection> sections,
      DateRange dateRange,
      String companyId,
      String? storeId});

  @override
  $DateRangeCopyWith<$Res> get dateRange;
}

/// @nodoc
class __$$IncomeStatementImplCopyWithImpl<$Res>
    extends _$IncomeStatementCopyWithImpl<$Res, _$IncomeStatementImpl>
    implements _$$IncomeStatementImplCopyWith<$Res> {
  __$$IncomeStatementImplCopyWithImpl(
      _$IncomeStatementImpl _value, $Res Function(_$IncomeStatementImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sections = null,
    Object? dateRange = null,
    Object? companyId = null,
    Object? storeId = freezed,
  }) {
    return _then(_$IncomeStatementImpl(
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<IncomeStatementSection>,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateRange,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$IncomeStatementImpl extends _IncomeStatement {
  const _$IncomeStatementImpl(
      {required final List<IncomeStatementSection> sections,
      required this.dateRange,
      required this.companyId,
      this.storeId})
      : _sections = sections,
        super._();

  final List<IncomeStatementSection> _sections;
  @override
  List<IncomeStatementSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  final DateRange dateRange;
  @override
  final String companyId;
  @override
  final String? storeId;

  @override
  String toString() {
    return 'IncomeStatement(sections: $sections, dateRange: $dateRange, companyId: $companyId, storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeStatementImpl &&
            const DeepCollectionEquality().equals(other._sections, _sections) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sections),
      dateRange,
      companyId,
      storeId);

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeStatementImplCopyWith<_$IncomeStatementImpl> get copyWith =>
      __$$IncomeStatementImplCopyWithImpl<_$IncomeStatementImpl>(
          this, _$identity);
}

abstract class _IncomeStatement extends IncomeStatement {
  const factory _IncomeStatement(
      {required final List<IncomeStatementSection> sections,
      required final DateRange dateRange,
      required final String companyId,
      final String? storeId}) = _$IncomeStatementImpl;
  const _IncomeStatement._() : super._();

  @override
  List<IncomeStatementSection> get sections;
  @override
  DateRange get dateRange;
  @override
  String get companyId;
  @override
  String? get storeId;

  /// Create a copy of IncomeStatement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeStatementImplCopyWith<_$IncomeStatementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
