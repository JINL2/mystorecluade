import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'vault_currency_list_view_widget.dart' show VaultCurrencyListViewWidget;
import 'package:flutter/material.dart';

class VaultCurrencyListViewModel
    extends FlutterFlowModel<VaultCurrencyListViewWidget> {
  ///  Local state fields for this component.

  List<VaultAmountLineStruct> vaultAmountLine = [];
  void addToVaultAmountLine(VaultAmountLineStruct item) =>
      vaultAmountLine.add(item);
  void removeFromVaultAmountLine(VaultAmountLineStruct item) =>
      vaultAmountLine.remove(item);
  void removeAtIndexFromVaultAmountLine(int index) =>
      vaultAmountLine.removeAt(index);
  void insertAtIndexInVaultAmountLine(int index, VaultAmountLineStruct item) =>
      vaultAmountLine.insert(index, item);
  void updateVaultAmountLineAtIndex(
          int index, Function(VaultAmountLineStruct) updateFn) =>
      vaultAmountLine[index] = updateFn(vaultAmountLine[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
