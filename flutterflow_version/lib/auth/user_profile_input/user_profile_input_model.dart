import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'user_profile_input_widget.dart' show UserProfileInputWidget;
import 'package:flutter/material.dart';

class UserProfileInputModel extends FlutterFlowModel<UserProfileInputWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for last_name widget.
  FocusNode? lastNameFocusNode;
  TextEditingController? lastNameTextController;
  String? Function(BuildContext, String?)? lastNameTextControllerValidator;
  // State field(s) for given_name widget.
  FocusNode? givenNameFocusNode;
  TextEditingController? givenNameTextController;
  String? Function(BuildContext, String?)? givenNameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();

    givenNameFocusNode?.dispose();
    givenNameTextController?.dispose();
  }
}
