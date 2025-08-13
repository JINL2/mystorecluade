import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'store_shift_update_v1_widget.dart' show StoreShiftUpdateV1Widget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreShiftUpdateV1Model
    extends FlutterFlowModel<StoreShiftUpdateV1Widget> {
  ///  Local state fields for this component.

  DateTime? startingTime;

  DateTime? endingTime;

  ///  State fields for stateful widgets in this component.

  // State field(s) for ShiftName widget.
  FocusNode? shiftNameFocusNode;
  TextEditingController? shiftNameTextController;
  String? Function(BuildContext, String?)? shiftNameTextControllerValidator;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for MaxShift widget.
  int? maxShiftValue;
  FormFieldController<int>? maxShiftValueController;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<StoreShiftsRow>? fdsafdsa;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Button widget.
  List<StoreShiftsRow>? deleteShift1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    shiftNameFocusNode?.dispose();
    shiftNameTextController?.dispose();
  }
}
