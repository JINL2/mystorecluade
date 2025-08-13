import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_timetable_scheduletestes_widget.dart'
    show UserTimetableScheduletestesWidget;
import 'package:flutter/material.dart';

class UserTimetableScheduletestesModel
    extends FlutterFlowModel<UserTimetableScheduletestesWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    isloadingModel.dispose();
  }
}
