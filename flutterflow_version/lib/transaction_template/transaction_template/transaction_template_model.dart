import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'transaction_template_widget.dart' show TransactionTemplateWidget;
import 'package:flutter/material.dart';

class TransactionTemplateModel
    extends FlutterFlowModel<TransactionTemplateWidget> {
  ///  Local state fields for this page.

  List<TransactionDetailStruct> transactionDetail = [];
  void addToTransactionDetail(TransactionDetailStruct item) =>
      transactionDetail.add(item);
  void removeFromTransactionDetail(TransactionDetailStruct item) =>
      transactionDetail.remove(item);
  void removeAtIndexFromTransactionDetail(int index) =>
      transactionDetail.removeAt(index);
  void insertAtIndexInTransactionDetail(
          int index, TransactionDetailStruct item) =>
      transactionDetail.insert(index, item);
  void updateTransactionDetailAtIndex(
          int index, Function(TransactionDetailStruct) updateFn) =>
      transactionDetail[index] = updateFn(transactionDetail[index]);

  int? indexNumber;

  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
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
