import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'journal_input_widget.dart' show JournalInputWidget;
import 'package:flutter/material.dart';

class JournalInputModel extends FlutterFlowModel<JournalInputWidget> {
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

  double? debitValue = 0.0;

  double? creditValue = 0.0;

  double? differences = 0.0;

  int? debitItemNumber;

  int? creditItemNubmer;

  int? selectedIndex;

  String? storeJournal;

  bool? isDebt;

  bool? isCash;

  String? counterpartyCompanyId;

  bool? isInternal;

  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (bringFinanceAccountInfo)] action in Icon widget.
  ApiCallResponse? apiResultlf0;
  // State field(s) for companyChoosen widget.
  String? companyChoosenValue;
  FormFieldController<String>? companyChoosenValueController;
  // State field(s) for storeChoosen widget.
  String? storeChoosenValue;
  FormFieldController<String>? storeChoosenValueController;
  // State field(s) for counterCash widget.
  String? counterCashValue;
  FormFieldController<String>? counterCashValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (insertjournalwitheverything)] action in Button widget.
  ApiCallResponse? insertJournal;
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
