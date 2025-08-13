import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_debt_transaction_widget.dart' show CreateDebtTransactionWidget;
import 'package:flutter/material.dart';

class CreateDebtTransactionModel
    extends FlutterFlowModel<CreateDebtTransactionWidget> {
  ///  Local state fields for this component.

  DateTime? chooseTime;

  bool isBorrowMoney = true;

  int amount = 0;

  String? counterpartyStoreId;

  String? myCashLocationId;

  String? counterpartyCashLocation;

  String? myCashLocationName;

  String? counterPartyCashLocationName;

  String? counterpartyStoreName;

  List<dynamic> pLine = [];
  void addToPLine(dynamic item) => pLine.add(item);
  void removeFromPLine(dynamic item) => pLine.remove(item);
  void removeAtIndexFromPLine(int index) => pLine.removeAt(index);
  void insertAtIndexInPLine(int index, dynamic item) =>
      pLine.insert(index, item);
  void updatePLineAtIndex(int index, Function(dynamic) updateFn) =>
      pLine[index] = updateFn(pLine[index]);

  bool isNote = true;

  String? myStoreChoosen;

  ///  State fields for stateful widgets in this component.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for Switch widget.
  bool? switchValue;
  DateTime? datePicked;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (insertjournalwitheverything)] action in Button widget.
  ApiCallResponse? insertJournal;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
