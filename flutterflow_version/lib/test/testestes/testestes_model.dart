import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'testestes_widget.dart' show TestestesWidget;
import 'package:flutter/material.dart';

class TestestesModel extends FlutterFlowModel<TestestesWidget> {
  ///  Local state fields for this page.

  String? scanedStoreId;

  int? todayShiftCount;

  int? todayWorkStatus;

  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  var scanQR = '';
  // Stores action output result for [Backend Call - API (updateShiftRequests)] action in ScanQR widget.
  ApiCallResponse? buttonAPI1;
  // Stores action output result for [Backend Call - API (updateShiftRequests)] action in ScanQR widget.
  ApiCallResponse? buttonAPI2;
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
