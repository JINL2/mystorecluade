import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'insert_schedule_widget.dart' show InsertScheduleWidget;
import 'package:flutter/material.dart';

class InsertScheduleModel extends FlutterFlowModel<InsertScheduleWidget> {
  ///  Local state fields for this component.

  DateTime? selectedDate;

  String? selectedEmployee;

  String? selectedShift;

  String? selectedEmployeeName;

  String? selectedShiftName;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (managershiftgetschedule)] action in InsertSchedule widget.
  ApiCallResponse? oPLGetSchedule;
  // Stores action output result for [Backend Call - API (managershiftinsertschedule)] action in Button widget.
  ApiCallResponse? apiResulti09;
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
