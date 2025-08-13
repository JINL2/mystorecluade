import '/flutter_flow/flutter_flow_util.dart';
import '/time_table/schdule_list/schdule_list_widget.dart';
import 'table_schdule_widget.dart' show TableSchduleWidget;
import 'package:flutter/material.dart';

class TableSchduleModel extends FlutterFlowModel<TableSchduleWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for schduleList dynamic component.
  late FlutterFlowDynamicModels<SchduleListModel> schduleListModels;

  @override
  void initState(BuildContext context) {
    schduleListModels = FlutterFlowDynamicModels(() => SchduleListModel());
  }

  @override
  void dispose() {
    schduleListModels.dispose();
  }
}
