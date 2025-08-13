import '/buttons/add_button/add_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_name_widget.dart' show EditProfileNameWidget;
import 'package:flutter/material.dart';

class EditProfileNameModel extends FlutterFlowModel<EditProfileNameWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for UserLastName widget.
  FocusNode? userLastNameFocusNode;
  TextEditingController? userLastNameTextController;
  String? Function(BuildContext, String?)? userLastNameTextControllerValidator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // Model for add_button component.
  late AddButtonModel addButtonModel;

  @override
  void initState(BuildContext context) {
    addButtonModel = createModel(context, () => AddButtonModel());
  }

  @override
  void dispose() {
    userLastNameFocusNode?.dispose();
    userLastNameTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    addButtonModel.dispose();
  }
}
