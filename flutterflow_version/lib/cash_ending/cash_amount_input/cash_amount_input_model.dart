import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cash_amount_input_widget.dart' show CashAmountInputWidget;
import 'package:flutter/material.dart';

class CashAmountInputModel extends FlutterFlowModel<CashAmountInputWidget> {
  ///  Local state fields for this component.

  List<DenominationsStruct> denominations = [];
  void addToDenominations(DenominationsStruct item) => denominations.add(item);
  void removeFromDenominations(DenominationsStruct item) =>
      denominations.remove(item);
  void removeAtIndexFromDenominations(int index) =>
      denominations.removeAt(index);
  void insertAtIndexInDenominations(int index, DenominationsStruct item) =>
      denominations.insert(index, item);
  void updateDenominationsAtIndex(
          int index, Function(DenominationsStruct) updateFn) =>
      denominations[index] = updateFn(denominations[index]);

  ///  State fields for stateful widgets in this component.

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
