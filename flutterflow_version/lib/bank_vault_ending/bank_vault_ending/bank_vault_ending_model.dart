import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bank_vault_ending_widget.dart' show BankVaultEndingWidget;
import 'package:flutter/material.dart';

class BankVaultEndingModel extends FlutterFlowModel<BankVaultEndingWidget> {
  ///  Local state fields for this page.

  String? selectedLocationId;

  List<CurrenciesStruct> currencies = [];
  void addToCurrencies(CurrenciesStruct item) => currencies.add(item);
  void removeFromCurrencies(CurrenciesStruct item) => currencies.remove(item);
  void removeAtIndexFromCurrencies(int index) => currencies.removeAt(index);
  void insertAtIndexInCurrencies(int index, CurrenciesStruct item) =>
      currencies.insert(index, item);
  void updateCurrenciesAtIndex(
          int index, Function(CurrenciesStruct) updateFn) =>
      currencies[index] = updateFn(currencies[index]);

  bool yesterdayCheck = false;

  List<VaultAmountLineStruct> valutAmountLine = [];
  void addToValutAmountLine(VaultAmountLineStruct item) =>
      valutAmountLine.add(item);
  void removeFromValutAmountLine(VaultAmountLineStruct item) =>
      valutAmountLine.remove(item);
  void removeAtIndexFromValutAmountLine(int index) =>
      valutAmountLine.removeAt(index);
  void insertAtIndexInValutAmountLine(int index, VaultAmountLineStruct item) =>
      valutAmountLine.insert(index, item);
  void updateValutAmountLineAtIndex(
          int index, Function(VaultAmountLineStruct) updateFn) =>
      valutAmountLine[index] = updateFn(valutAmountLine[index]);

  bool? callback = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in bankVaultEnding widget.
  List<CashLocationsRow>? oPLCashLocation;
  // Stores action output result for [Backend Call - Query Rows] action in bankVaultEnding widget.
  List<CurrencyTypesRow>? oPLCurrencyType;
  // Stores action output result for [Backend Call - Query Rows] action in bankVaultEnding widget.
  List<CompanyCurrencyRow>? oPLCompanyCurrency;
  // Stores action output result for [Backend Call - Query Rows] action in bankVaultEnding widget.
  List<VBankAmountRow>? oPLBankAmount;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for cashlocationDropDown widget.
  String? cashlocationDropDownValue;
  FormFieldController<String>? cashlocationDropDownValueController;
  // State field(s) for currencyDropdownVault widget.
  String? currencyDropdownVaultValue;
  FormFieldController<String>? currencyDropdownVaultValueController;
  // State field(s) for debitcredit widget.
  bool? debitcreditValue;
  // Stores action output result for [Backend Call - API (vaultAmountInsert)] action in Button widget.
  ApiCallResponse? debitAPI;
  // Stores action output result for [Backend Call - API (vaultAmountInsert)] action in Button widget.
  ApiCallResponse? creditAPI;
  // State field(s) for currencyDropDownBank widget.
  String? currencyDropDownBankValue;
  FormFieldController<String>? currencyDropDownBankValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (bankAmountInsert)] action in Button widget.
  ApiCallResponse? bankamountAPI;
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
    textFieldFocusNode?.dispose();
    textController?.dispose();

    isloadingModel.dispose();
  }
}
