import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import 'store_shift_create_widget.dart' show StoreShiftCreateWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreShiftCreateModel extends FlutterFlowModel<StoreShiftCreateWidget> {
  ///  Local state fields for this component.
  /// startingTime
  DateTime? startingTime;

  /// endingTIme
  DateTime? endingTime;

  ///  State fields for stateful widgets in this component.

  // State field(s) for ShiftName widget.
  FocusNode? shiftNameFocusNode;
  TextEditingController? shiftNameTextController;
  String? Function(BuildContext, String?)? shiftNameTextControllerValidator;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for numberofPeople widget.
  int? numberofPeopleValue;
  FormFieldController<int>? numberofPeopleValueController;
  // Model for add component.
  late AddModel addModel;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    shiftNameFocusNode?.dispose();
    shiftNameTextController?.dispose();

    addModel.dispose();
  }
}
