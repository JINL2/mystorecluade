import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_mapping_widget.dart' show SelectMappingWidget;
import 'package:flutter/material.dart';

class SelectMappingModel extends FlutterFlowModel<SelectMappingWidget> {
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

  double? diff;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (insertjournalwitheverything)] action in Button widget.
  ApiCallResponse? errorAPImoreCash;
  // Stores action output result for [Backend Call - API (insertjournalwitheverything)] action in Button widget.
  ApiCallResponse? errorAPIlessCash;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
