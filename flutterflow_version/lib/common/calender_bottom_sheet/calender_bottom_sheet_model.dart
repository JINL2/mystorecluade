import '/flutter_flow/flutter_flow_util.dart';
import '/time_table/day_text/day_text_widget.dart';
import 'calender_bottom_sheet_widget.dart' show CalenderBottomSheetWidget;
import 'package:flutter/material.dart';

class CalenderBottomSheetModel
    extends FlutterFlowModel<CalenderBottomSheetWidget> {
  ///  Local state fields for this component.

  DateTime? inputDate;

  DateTime? selectedDate;

  ///  State fields for stateful widgets in this component.

  // Model for DayText component.
  late DayTextModel dayTextModel1;
  // Model for DayText component.
  late DayTextModel dayTextModel2;
  // Model for DayText component.
  late DayTextModel dayTextModel3;
  // Model for DayText component.
  late DayTextModel dayTextModel4;
  // Model for DayText component.
  late DayTextModel dayTextModel5;
  // Model for DayText component.
  late DayTextModel dayTextModel6;
  // Model for DayText component.
  late DayTextModel dayTextModel7;

  @override
  void initState(BuildContext context) {
    dayTextModel1 = createModel(context, () => DayTextModel());
    dayTextModel2 = createModel(context, () => DayTextModel());
    dayTextModel3 = createModel(context, () => DayTextModel());
    dayTextModel4 = createModel(context, () => DayTextModel());
    dayTextModel5 = createModel(context, () => DayTextModel());
    dayTextModel6 = createModel(context, () => DayTextModel());
    dayTextModel7 = createModel(context, () => DayTextModel());
  }

  @override
  void dispose() {
    dayTextModel1.dispose();
    dayTextModel2.dispose();
    dayTextModel3.dispose();
    dayTextModel4.dispose();
    dayTextModel5.dispose();
    dayTextModel6.dispose();
    dayTextModel7.dispose();
  }
}
