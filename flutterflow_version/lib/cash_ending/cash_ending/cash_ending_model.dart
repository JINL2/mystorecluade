import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'cash_ending_widget.dart' show CashEndingWidget;
import 'package:flutter/material.dart';

class CashEndingModel extends FlutterFlowModel<CashEndingWidget> {
  ///  Local state fields for this page.

  List<CompanyCurrencyRow> companyCurrency = [];
  void addToCompanyCurrency(CompanyCurrencyRow item) =>
      companyCurrency.add(item);
  void removeFromCompanyCurrency(CompanyCurrencyRow item) =>
      companyCurrency.remove(item);
  void removeAtIndexFromCompanyCurrency(int index) =>
      companyCurrency.removeAt(index);
  void insertAtIndexInCompanyCurrency(int index, CompanyCurrencyRow item) =>
      companyCurrency.insert(index, item);
  void updateCompanyCurrencyAtIndex(
          int index, Function(CompanyCurrencyRow) updateFn) =>
      companyCurrency[index] = updateFn(companyCurrency[index]);

  List<CurrencyDenominationsRow> currencyDenomination1 = [];
  void addToCurrencyDenomination1(CurrencyDenominationsRow item) =>
      currencyDenomination1.add(item);
  void removeFromCurrencyDenomination1(CurrencyDenominationsRow item) =>
      currencyDenomination1.remove(item);
  void removeAtIndexFromCurrencyDenomination1(int index) =>
      currencyDenomination1.removeAt(index);
  void insertAtIndexInCurrencyDenomination1(
          int index, CurrencyDenominationsRow item) =>
      currencyDenomination1.insert(index, item);
  void updateCurrencyDenomination1AtIndex(
          int index, Function(CurrencyDenominationsRow) updateFn) =>
      currencyDenomination1[index] = updateFn(currencyDenomination1[index]);

  int? textfield;

  CashEndingStruct? cashEnding;
  void updateCashEndingStruct(Function(CashEndingStruct) updateFn) {
    updateFn(cashEnding ??= CashEndingStruct());
  }

  List<CurrenciesStruct> currencies = [];
  void addToCurrencies(CurrenciesStruct item) => currencies.add(item);
  void removeFromCurrencies(CurrenciesStruct item) => currencies.remove(item);
  void removeAtIndexFromCurrencies(int index) => currencies.removeAt(index);
  void insertAtIndexInCurrencies(int index, CurrenciesStruct item) =>
      currencies.insert(index, item);
  void updateCurrenciesAtIndex(
          int index, Function(CurrenciesStruct) updateFn) =>
      currencies[index] = updateFn(currencies[index]);

  List<CashierAmountLinesRow> cashAmountLine = [];
  void addToCashAmountLine(CashierAmountLinesRow item) =>
      cashAmountLine.add(item);
  void removeFromCashAmountLine(CashierAmountLinesRow item) =>
      cashAmountLine.remove(item);
  void removeAtIndexFromCashAmountLine(int index) =>
      cashAmountLine.removeAt(index);
  void insertAtIndexInCashAmountLine(int index, CashierAmountLinesRow item) =>
      cashAmountLine.insert(index, item);
  void updateCashAmountLineAtIndex(
          int index, Function(CashierAmountLinesRow) updateFn) =>
      cashAmountLine[index] = updateFn(cashAmountLine[index]);

  String? selectedCashierLocation;

  bool yesterdayCheck = false;

  dynamic currecyCheck;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in cashEnding widget.
  List<CurrencyTypesRow>? currencyType;
  // Stores action output result for [Backend Call - Query Rows] action in cashEnding widget.
  List<CashLocationsRow>? oPLCashLocation;
  // Stores action output result for [Backend Call - Query Rows] action in cashEnding widget.
  List<CompanyCurrencyRow>? getCompanyCurrency;
  // Stores action output result for [Backend Call - Query Rows] action in cashEnding widget.
  List<CurrencyDenominationsRow>? currencyDenomination;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for cashlocationDropDown widget.
  String? cashlocationDropDownValue;
  FormFieldController<String>? cashlocationDropDownValueController;
  // Stores action output result for [Backend Call - API (insertCashLine)] action in Button widget.
  ApiCallResponse? apiResultl36;
  // Stores action output result for [Backend Call - API (insertCashLine)] action in Button widget.
  ApiCallResponse? apiResulttuy;
  // Stores action output result for [Backend Call - API (insertCashLine)] action in Button widget.
  ApiCallResponse? apiResultja0;
  // Stores action output result for [Backend Call - API (insertCashLine)] action in Button widget.
  ApiCallResponse? apiResult9hl;
  // State field(s) for FilterDropDown widget.
  String? filterDropDownValue;
  FormFieldController<String>? filterDropDownValueController;
  // Stores action output result for [Backend Call - API (getlatestcashieramountlines)] action in FilterDropDown widget.
  ApiCallResponse? calltoday;
  // Stores action output result for [Backend Call - API (getlatestcashieramountlines)] action in FilterDropDown widget.
  ApiCallResponse? callyesterday;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    isloadingModel.dispose();
  }
}
