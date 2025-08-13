import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _localMyCompanyCount =
          prefs.getInt('ff_localMyCompanyCount') ?? _localMyCompanyCount;
    });
    _safeInit(() {
      _categoryFeatures = prefs
              .getStringList('ff_categoryFeatures')
              ?.map((x) {
                try {
                  return CategoryFeaturesStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _categoryFeatures;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_user')) {
        try {
          final serializedData = prefs.getString('ff_user') ?? '{}';
          _user = UserStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _financeAccount = prefs
              .getStringList('ff_financeAccount')
              ?.map((x) {
                try {
                  return FinanceAccountStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _financeAccount;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_currencyData')) {
        try {
          final serializedData = prefs.getString('ff_currencyData') ?? '{}';
          _currencyData = CurrencyCompanyDataStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _accessToken = prefs.getString('ff_accessToken') ?? _accessToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// local_my_company
  int _localMyCompanyCount = 0;
  int get localMyCompanyCount => _localMyCompanyCount;
  set localMyCompanyCount(int value) {
    _localMyCompanyCount = value;
    prefs.setInt('ff_localMyCompanyCount', value);
  }

  /// current Company Choosen
  String _companyChoosen = '';
  String get companyChoosen => _companyChoosen;
  set companyChoosen(String value) {
    _companyChoosen = value;
  }

  String _storeChoosen = '';
  String get storeChoosen => _storeChoosen;
  set storeChoosen(String value) {
    _storeChoosen = value;
  }

  /// category_features
  List<CategoryFeaturesStruct> _categoryFeatures = [];
  List<CategoryFeaturesStruct> get categoryFeatures => _categoryFeatures;
  set categoryFeatures(List<CategoryFeaturesStruct> value) {
    _categoryFeatures = value;
    prefs.setStringList(
        'ff_categoryFeatures', value.map((x) => x.serialize()).toList());
  }

  void addToCategoryFeatures(CategoryFeaturesStruct value) {
    categoryFeatures.add(value);
    prefs.setStringList('ff_categoryFeatures',
        _categoryFeatures.map((x) => x.serialize()).toList());
  }

  void removeFromCategoryFeatures(CategoryFeaturesStruct value) {
    categoryFeatures.remove(value);
    prefs.setStringList('ff_categoryFeatures',
        _categoryFeatures.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCategoryFeatures(int index) {
    categoryFeatures.removeAt(index);
    prefs.setStringList('ff_categoryFeatures',
        _categoryFeatures.map((x) => x.serialize()).toList());
  }

  void updateCategoryFeaturesAtIndex(
    int index,
    CategoryFeaturesStruct Function(CategoryFeaturesStruct) updateFn,
  ) {
    categoryFeatures[index] = updateFn(_categoryFeatures[index]);
    prefs.setStringList('ff_categoryFeatures',
        _categoryFeatures.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCategoryFeatures(
      int index, CategoryFeaturesStruct value) {
    categoryFeatures.insert(index, value);
    prefs.setStringList('ff_categoryFeatures',
        _categoryFeatures.map((x) => x.serialize()).toList());
  }

  /// selectedFeatures when create a role
  List<String> _selectedFeatures = [];
  List<String> get selectedFeatures => _selectedFeatures;
  set selectedFeatures(List<String> value) {
    _selectedFeatures = value;
  }

  void addToSelectedFeatures(String value) {
    selectedFeatures.add(value);
  }

  void removeFromSelectedFeatures(String value) {
    selectedFeatures.remove(value);
  }

  void removeAtIndexFromSelectedFeatures(int index) {
    selectedFeatures.removeAt(index);
  }

  void updateSelectedFeaturesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedFeatures[index] = updateFn(_selectedFeatures[index]);
  }

  void insertAtIndexInSelectedFeatures(int index, String value) {
    selectedFeatures.insert(index, value);
  }

  UserStruct _user =
      UserStruct.fromSerializableMap(jsonDecode('{\"companies\":\"[]\"}'));
  UserStruct get user => _user;
  set user(UserStruct value) {
    _user = value;
    prefs.setString('ff_user', value.serialize());
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
    prefs.setString('ff_user', _user.serialize());
  }

  /// For UI/UX
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  set isExpanded(bool value) {
    _isExpanded = value;
  }

  bool _showboolean = false;
  bool get showboolean => _showboolean;
  set showboolean(bool value) {
    _showboolean = value;
  }

  List<ShiftStatusStruct> _shiftStatus = [];
  List<ShiftStatusStruct> get shiftStatus => _shiftStatus;
  set shiftStatus(List<ShiftStatusStruct> value) {
    _shiftStatus = value;
  }

  void addToShiftStatus(ShiftStatusStruct value) {
    shiftStatus.add(value);
  }

  void removeFromShiftStatus(ShiftStatusStruct value) {
    shiftStatus.remove(value);
  }

  void removeAtIndexFromShiftStatus(int index) {
    shiftStatus.removeAt(index);
  }

  void updateShiftStatusAtIndex(
    int index,
    ShiftStatusStruct Function(ShiftStatusStruct) updateFn,
  ) {
    shiftStatus[index] = updateFn(_shiftStatus[index]);
  }

  void insertAtIndexInShiftStatus(int index, ShiftStatusStruct value) {
    shiftStatus.insert(index, value);
  }

  List<FinanceAccountStruct> _financeAccount = [];
  List<FinanceAccountStruct> get financeAccount => _financeAccount;
  set financeAccount(List<FinanceAccountStruct> value) {
    _financeAccount = value;
    prefs.setStringList(
        'ff_financeAccount', value.map((x) => x.serialize()).toList());
  }

  void addToFinanceAccount(FinanceAccountStruct value) {
    financeAccount.add(value);
    prefs.setStringList('ff_financeAccount',
        _financeAccount.map((x) => x.serialize()).toList());
  }

  void removeFromFinanceAccount(FinanceAccountStruct value) {
    financeAccount.remove(value);
    prefs.setStringList('ff_financeAccount',
        _financeAccount.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromFinanceAccount(int index) {
    financeAccount.removeAt(index);
    prefs.setStringList('ff_financeAccount',
        _financeAccount.map((x) => x.serialize()).toList());
  }

  void updateFinanceAccountAtIndex(
    int index,
    FinanceAccountStruct Function(FinanceAccountStruct) updateFn,
  ) {
    financeAccount[index] = updateFn(_financeAccount[index]);
    prefs.setStringList('ff_financeAccount',
        _financeAccount.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInFinanceAccount(int index, FinanceAccountStruct value) {
    financeAccount.insert(index, value);
    prefs.setStringList('ff_financeAccount',
        _financeAccount.map((x) => x.serialize()).toList());
  }

  /// user device location
  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;
  set userLocation(LatLng? value) {
    _userLocation = value;
  }

  List<ShiftMetaDataStruct> _shiftMetaData = [];
  List<ShiftMetaDataStruct> get shiftMetaData => _shiftMetaData;
  set shiftMetaData(List<ShiftMetaDataStruct> value) {
    _shiftMetaData = value;
  }

  void addToShiftMetaData(ShiftMetaDataStruct value) {
    shiftMetaData.add(value);
  }

  void removeFromShiftMetaData(ShiftMetaDataStruct value) {
    shiftMetaData.remove(value);
  }

  void removeAtIndexFromShiftMetaData(int index) {
    shiftMetaData.removeAt(index);
  }

  void updateShiftMetaDataAtIndex(
    int index,
    ShiftMetaDataStruct Function(ShiftMetaDataStruct) updateFn,
  ) {
    shiftMetaData[index] = updateFn(_shiftMetaData[index]);
  }

  void insertAtIndexInShiftMetaData(int index, ShiftMetaDataStruct value) {
    shiftMetaData.insert(index, value);
  }

  List<ManagerShiftDetailStruct> _managerShiftDetail = [];
  List<ManagerShiftDetailStruct> get managerShiftDetail => _managerShiftDetail;
  set managerShiftDetail(List<ManagerShiftDetailStruct> value) {
    _managerShiftDetail = value;
  }

  void addToManagerShiftDetail(ManagerShiftDetailStruct value) {
    managerShiftDetail.add(value);
  }

  void removeFromManagerShiftDetail(ManagerShiftDetailStruct value) {
    managerShiftDetail.remove(value);
  }

  void removeAtIndexFromManagerShiftDetail(int index) {
    managerShiftDetail.removeAt(index);
  }

  void updateManagerShiftDetailAtIndex(
    int index,
    ManagerShiftDetailStruct Function(ManagerShiftDetailStruct) updateFn,
  ) {
    managerShiftDetail[index] = updateFn(_managerShiftDetail[index]);
  }

  void insertAtIndexInManagerShiftDetail(
      int index, ManagerShiftDetailStruct value) {
    managerShiftDetail.insert(index, value);
  }

  bool _isLoading1 = false;
  bool get isLoading1 => _isLoading1;
  set isLoading1(bool value) {
    _isLoading1 = value;
  }

  bool _isLoading2 = false;
  bool get isLoading2 => _isLoading2;
  set isLoading2(bool value) {
    _isLoading2 = value;
  }

  bool _isLoading3 = false;
  bool get isLoading3 => _isLoading3;
  set isLoading3(bool value) {
    _isLoading3 = value;
  }

  String _rangeHeader = '';
  String get rangeHeader => _rangeHeader;
  set rangeHeader(String value) {
    _rangeHeader = value;
  }

  /// lazyloading
  int _offest = 0;
  int get offest => _offest;
  set offest(int value) {
    _offest = value;
  }

  /// lazyloading
  int _limit = 10;
  int get limit => _limit;
  set limit(int value) {
    _limit = value;
  }

  CurrencyCompanyDataStruct _currencyData = CurrencyCompanyDataStruct();
  CurrencyCompanyDataStruct get currencyData => _currencyData;
  set currencyData(CurrencyCompanyDataStruct value) {
    _currencyData = value;
    prefs.setString('ff_currencyData', value.serialize());
  }

  void updateCurrencyDataStruct(Function(CurrencyCompanyDataStruct) updateFn) {
    updateFn(_currencyData);
    prefs.setString('ff_currencyData', _currencyData.serialize());
  }

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;
  set isUpdate(bool value) {
    _isUpdate = value;
  }

  dynamic _reUsableJson;
  dynamic get reUsableJson => _reUsableJson;
  set reUsableJson(dynamic value) {
    _reUsableJson = value;
  }

  String _isSelectedId = '';
  String get isSelectedId => _isSelectedId;
  set isSelectedId(String value) {
    _isSelectedId = value;
  }

  String _accessToken = '';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    prefs.setString('ff_accessToken', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
