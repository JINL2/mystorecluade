import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_currency_widget.dart' show AddCurrencyWidget;
import 'package:flutter/material.dart';

class AddCurrencyModel extends FlutterFlowModel<AddCurrencyWidget> {
  ///  Local state fields for this component.

  List<CompanyCurrencyRow> currencyQuery = [];
  void addToCurrencyQuery(CompanyCurrencyRow item) => currencyQuery.add(item);
  void removeFromCurrencyQuery(CompanyCurrencyRow item) =>
      currencyQuery.remove(item);
  void removeAtIndexFromCurrencyQuery(int index) =>
      currencyQuery.removeAt(index);
  void insertAtIndexInCurrencyQuery(int index, CompanyCurrencyRow item) =>
      currencyQuery.insert(index, item);
  void updateCurrencyQueryAtIndex(
          int index, Function(CompanyCurrencyRow) updateFn) =>
      currencyQuery[index] = updateFn(currencyQuery[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in addCurrency widget.
  List<CompanyCurrencyRow>? companyCurrencyQuery;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    isloadingModel.dispose();
  }
}
