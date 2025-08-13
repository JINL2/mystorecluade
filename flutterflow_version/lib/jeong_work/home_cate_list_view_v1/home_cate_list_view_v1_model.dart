import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/home_feature_v1/home_feature_v1_widget.dart';
import 'home_cate_list_view_v1_widget.dart' show HomeCateListViewV1Widget;
import 'package:flutter/material.dart';

class HomeCateListViewV1Model
    extends FlutterFlowModel<HomeCateListViewV1Widget> {
  ///  State fields for stateful widgets in this component.

  // Models for HomeFeatureV1 dynamic component.
  late FlutterFlowDynamicModels<HomeFeatureV1Model> homeFeatureV1Models;

  @override
  void initState(BuildContext context) {
    homeFeatureV1Models = FlutterFlowDynamicModels(() => HomeFeatureV1Model());
  }

  @override
  void dispose() {
    homeFeatureV1Models.dispose();
  }
}
