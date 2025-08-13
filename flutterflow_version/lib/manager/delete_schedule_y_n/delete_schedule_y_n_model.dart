import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'delete_schedule_y_n_widget.dart' show DeleteScheduleYNWidget;
import 'package:flutter/material.dart';

class DeleteScheduleYNModel extends FlutterFlowModel<DeleteScheduleYNWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - deleteUserIdByShiftRequestId] action in Button widget.
  List<ManagerShiftDetailStruct>? deletedmanagershift;
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
