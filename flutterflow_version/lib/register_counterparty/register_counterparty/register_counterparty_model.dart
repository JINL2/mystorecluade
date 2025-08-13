import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import '/register_counterparty/counterparty_list/counterparty_list_widget.dart';
import 'register_counterparty_widget.dart' show RegisterCounterpartyWidget;
import 'package:flutter/material.dart';

class RegisterCounterpartyModel
    extends FlutterFlowModel<RegisterCounterpartyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Model for addParty.
  late AddModel addPartyModel;
  // Models for counterpartyList dynamic component.
  late FlutterFlowDynamicModels<CounterpartyListModel> counterpartyListModels;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    addPartyModel = createModel(context, () => AddModel());
    counterpartyListModels =
        FlutterFlowDynamicModels(() => CounterpartyListModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    addPartyModel.dispose();
    counterpartyListModels.dispose();
  }
}
