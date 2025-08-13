import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'survey_dashboard_widget.dart' show SurveyDashboardWidget;
import 'package:flutter/material.dart';

class SurveyDashboardModel extends FlutterFlowModel<SurveyDashboardWidget> {
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
