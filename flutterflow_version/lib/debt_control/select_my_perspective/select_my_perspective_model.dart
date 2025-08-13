import '/debt_control/viewpoint_component/viewpoint_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_my_perspective_widget.dart' show SelectMyPerspectiveWidget;
import 'package:flutter/material.dart';

class SelectMyPerspectiveModel
    extends FlutterFlowModel<SelectMyPerspectiveWidget> {
  ///  Local state fields for this component.

  String selectedViewPoint = 'Company';

  ///  State fields for stateful widgets in this component.

  // Model for viewpointComponent component.
  late ViewpointComponentModel viewpointComponentModel1;
  // Model for viewpointComponent component.
  late ViewpointComponentModel viewpointComponentModel2;
  // Model for viewpointComponent component.
  late ViewpointComponentModel viewpointComponentModel3;

  @override
  void initState(BuildContext context) {
    viewpointComponentModel1 =
        createModel(context, () => ViewpointComponentModel());
    viewpointComponentModel2 =
        createModel(context, () => ViewpointComponentModel());
    viewpointComponentModel3 =
        createModel(context, () => ViewpointComponentModel());
  }

  @override
  void dispose() {
    viewpointComponentModel1.dispose();
    viewpointComponentModel2.dispose();
    viewpointComponentModel3.dispose();
  }
}
