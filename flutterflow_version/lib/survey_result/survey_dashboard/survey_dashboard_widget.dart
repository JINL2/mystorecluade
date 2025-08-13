import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'survey_dashboard_model.dart';
export 'survey_dashboard_model.dart';

class SurveyDashboardWidget extends StatefulWidget {
  const SurveyDashboardWidget({super.key});

  static String routeName = 'surveyDashboard';
  static String routePath = '/surveyDashboard';

  @override
  State<SurveyDashboardWidget> createState() => _SurveyDashboardWidgetState();
}

class _SurveyDashboardWidgetState extends State<SurveyDashboardWidget> {
  late SurveyDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SurveyDashboardModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await launchURL(
          'https://jinl2.github.io/cameraonSurvey/listen_customers_data_management/');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.menuBarModel,
                updateCallback: () => safeSetState(() {}),
                child: MenuBarWidget(
                  menuName: 'Survey Result',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
