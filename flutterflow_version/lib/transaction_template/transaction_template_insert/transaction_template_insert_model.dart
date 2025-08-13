import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'transaction_template_insert_widget.dart'
    show TransactionTemplateInsertWidget;
import 'package:flutter/material.dart';

class TransactionTemplateInsertModel
    extends FlutterFlowModel<TransactionTemplateInsertWidget> {
  ///  Local state fields for this component.

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

  ///  State fields for stateful widgets in this component.

  // State field(s) for cashLocationName widget.
  FocusNode? cashLocationNameFocusNode;
  TextEditingController? cashLocationNameTextController;
  String? Function(BuildContext, String?)?
      cashLocationNameTextControllerValidator;
  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  // Stores action output result for [Backend Call - API (insertjournalwitheverything)] action in Button widget.
  ApiCallResponse? apiResult5ze;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    cashLocationNameFocusNode?.dispose();
    cashLocationNameTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
