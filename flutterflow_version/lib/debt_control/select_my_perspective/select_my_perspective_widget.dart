import '/debt_control/viewpoint_component/viewpoint_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'select_my_perspective_model.dart';
export 'select_my_perspective_model.dart';

class SelectMyPerspectiveWidget extends StatefulWidget {
  const SelectMyPerspectiveWidget({
    super.key,
    this.selectedVietPoint,
  });

  final Future Function(String selectedVietpoint)? selectedVietPoint;

  @override
  State<SelectMyPerspectiveWidget> createState() =>
      _SelectMyPerspectiveWidgetState();
}

class _SelectMyPerspectiveWidgetState extends State<SelectMyPerspectiveWidget> {
  late SelectMyPerspectiveModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectMyPerspectiveModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  _model.selectedViewPoint = 'Company';
                  safeSetState(() {});
                  await widget.selectedVietPoint?.call(
                    'company',
                  );
                },
                child: wrapWithModel(
                  model: _model.viewpointComponentModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: ViewpointComponentWidget(
                    name: 'Company',
                    selectedViewpoint: valueOrDefault<String>(
                      _model.selectedViewPoint,
                      'Company',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  _model.selectedViewPoint = 'HQ';
                  safeSetState(() {});
                  await widget.selectedVietPoint?.call(
                    'headquarters',
                  );
                },
                child: wrapWithModel(
                  model: _model.viewpointComponentModel2,
                  updateCallback: () => safeSetState(() {}),
                  child: ViewpointComponentWidget(
                    name: 'HQ',
                    selectedViewpoint: _model.selectedViewPoint,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  _model.selectedViewPoint = 'Store';
                  safeSetState(() {});
                  await widget.selectedVietPoint?.call(
                    'store',
                  );
                },
                child: wrapWithModel(
                  model: _model.viewpointComponentModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: ViewpointComponentWidget(
                    name: 'Store',
                    selectedViewpoint: _model.selectedViewPoint,
                  ),
                ),
              ),
            ),
          ].divide(SizedBox(width: 8.0)),
        ),
      ),
    );
  }
}
