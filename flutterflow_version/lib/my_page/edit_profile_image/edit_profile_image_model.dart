import '/buttons/add_button/add_button_widget.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_image_widget.dart' show EditProfileImageWidget;
import 'package:flutter/material.dart';

class EditProfileImageModel extends FlutterFlowModel<EditProfileImageWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_localimage = false;
  FFUploadedFile uploadedLocalFile_localimage =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // Model for add_button component.
  late AddButtonModel addButtonModel;
  bool isDataUploading_uploaded = false;
  FFUploadedFile uploadedLocalFile_uploaded =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploaded = '';

  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    addButtonModel = createModel(context, () => AddButtonModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    addButtonModel.dispose();
    isloadingModel.dispose();
  }
}
