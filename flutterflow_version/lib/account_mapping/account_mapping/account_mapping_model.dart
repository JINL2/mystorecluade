import '/backend/schema/structs/index.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'account_mapping_widget.dart' show AccountMappingWidget;
import 'package:flutter/material.dart';

class AccountMappingModel extends FlutterFlowModel<AccountMappingWidget> {
  ///  Local state fields for this page.

  List<AccountMappingStruct> accountMapping = [];
  void addToAccountMapping(AccountMappingStruct item) =>
      accountMapping.add(item);
  void removeFromAccountMapping(AccountMappingStruct item) =>
      accountMapping.remove(item);
  void removeAtIndexFromAccountMapping(int index) =>
      accountMapping.removeAt(index);
  void insertAtIndexInAccountMapping(int index, AccountMappingStruct item) =>
      accountMapping.insert(index, item);
  void updateAccountMappingAtIndex(
          int index, Function(AccountMappingStruct) updateFn) =>
      accountMapping[index] = updateFn(accountMapping[index]);

  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
  }
}
