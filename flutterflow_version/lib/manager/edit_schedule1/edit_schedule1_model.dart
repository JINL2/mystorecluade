import '/flutter_flow/flutter_flow_util.dart';
import 'edit_schedule1_widget.dart' show EditSchedule1Widget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditSchedule1Model extends FlutterFlowModel<EditSchedule1Widget> {
  ///  Local state fields for this component.

  String? shiftId;

  String? realStartTime;

  String? realEndTime;

  bool? isLateBoolean;

  bool? showEdit = false;

  String? overtimeAmount;

  DateTime? adjustedStartTime;

  DateTime? adjustedEndTime;

  DateTime? fixedStarttime;

  DateTime? fixedEndTime;

  ///  State fields for stateful widgets in this component.

  // State field(s) for main widget.
  ScrollController? main;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for incentiveTextField widget.
  FocusNode? incentiveTextFieldFocusNode;
  TextEditingController? incentiveTextFieldTextController;
  String? Function(BuildContext, String?)?
      incentiveTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    main = ScrollController();
  }

  @override
  void dispose() {
    main?.dispose();
    incentiveTextFieldFocusNode?.dispose();
    incentiveTextFieldTextController?.dispose();
  }
}
