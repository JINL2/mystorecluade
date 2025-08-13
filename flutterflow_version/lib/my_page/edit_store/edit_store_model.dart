import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_store_widget.dart' show EditStoreWidget;
import 'package:flutter/material.dart';

class EditStoreModel extends FlutterFlowModel<EditStoreWidget> {
  ///  Local state fields for this component.

  int? huddleTime;

  int? paymentTime;

  int? allowedDistance;

  LatLng? storeLocation;

  ///  State fields for stateful widgets in this component.

  // State field(s) for CompanyDropdown widget.
  String? companyDropdownValue;
  FormFieldController<String>? companyDropdownValueController;
  // State field(s) for storeDropDown widget.
  String? storeDropDownValue;
  FormFieldController<String>? storeDropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for allowedDistance widget.
  FocusNode? allowedDistanceFocusNode;
  TextEditingController? allowedDistanceTextController;
  String? Function(BuildContext, String?)?
      allowedDistanceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    allowedDistanceFocusNode?.dispose();
    allowedDistanceTextController?.dispose();
  }
}
