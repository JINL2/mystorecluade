import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'manager_indi_component_widget.dart' show ManagerIndiComponentWidget;
import 'package:flutter/material.dart';

class ManagerIndiComponentModel
    extends FlutterFlowModel<ManagerIndiComponentWidget> {
  ///  Local state fields for this component.

  String? confirmStartTime;

  String? confirmEndTime;

  String? tagType;

  String? tagContent;

  String? tab;

  List<dynamic> noticeTags = [];
  void addToNoticeTags(dynamic item) => noticeTags.add(item);
  void removeFromNoticeTags(dynamic item) => noticeTags.remove(item);
  void removeAtIndexFromNoticeTags(int index) => noticeTags.removeAt(index);
  void insertAtIndexInNoticeTags(int index, dynamic item) =>
      noticeTags.insert(index, item);
  void updateNoticeTagsAtIndex(int index, Function(dynamic) updateFn) =>
      noticeTags[index] = updateFn(noticeTags[index]);

  bool? originIsProblemSolved;

  bool? afterIsProblemSolved;

  String? changeNotApproveRequestIdComState;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for tagType widget.
  String? tagTypeValue;
  FormFieldController<String>? tagTypeValueController;
  // State field(s) for tagContent widget.
  FocusNode? tagContentFocusNode;
  TextEditingController? tagContentTextController;
  String? Function(BuildContext, String?)? tagContentTextControllerValidator;
  // Stores action output result for [Backend Call - API (managershiftdeletetag)] action in Container widget.
  ApiCallResponse? managershiftdeleteTag;
  // State field(s) for problemSolve widget.
  bool? problemSolveValue;
  // Stores action output result for [Backend Call - API (managershiftinputcard)] action in Button widget.
  ApiCallResponse? managerShiftInputCard;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    tagContentFocusNode?.dispose();
    tagContentTextController?.dispose();

    isloadingModel.dispose();
  }
}
