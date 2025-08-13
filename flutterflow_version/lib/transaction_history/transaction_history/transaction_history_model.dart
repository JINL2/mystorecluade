import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'transaction_history_widget.dart' show TransactionHistoryWidget;
import 'package:flutter/material.dart';

class TransactionHistoryModel
    extends FlutterFlowModel<TransactionHistoryWidget> {
  ///  Local state fields for this page.

  List<String> journalEntriesId = [];
  void addToJournalEntriesId(String item) => journalEntriesId.add(item);
  void removeFromJournalEntriesId(String item) => journalEntriesId.remove(item);
  void removeAtIndexFromJournalEntriesId(int index) =>
      journalEntriesId.removeAt(index);
  void insertAtIndexInJournalEntriesId(int index, String item) =>
      journalEntriesId.insert(index, item);
  void updateJournalEntriesIdAtIndex(int index, Function(String) updateFn) =>
      journalEntriesId[index] = updateFn(journalEntriesId[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getjournalLine)] action in transactionHistory widget.
  ApiCallResponse? onlystore;
  // Stores action output result for [Backend Call - API (getjournalLine)] action in transactionHistory widget.
  ApiCallResponse? apiResulty0a;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (getjournalLine)] action in Icon widget.
  ApiCallResponse? getnewlistforStore;
  // Stores action output result for [Backend Call - API (getjournalLine)] action in Icon widget.
  ApiCallResponse? getnewlistforCompany;
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
