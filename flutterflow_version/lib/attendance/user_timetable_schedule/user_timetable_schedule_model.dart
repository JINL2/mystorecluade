import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_timetable_schedule_widget.dart' show UserTimetableScheduleWidget;
import 'package:flutter/material.dart';

class UserTimetableScheduleModel
    extends FlutterFlowModel<UserTimetableScheduleWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ShiftRequestsRow>? updateRow;
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
