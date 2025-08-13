import '/backend/supabase/supabase.dart';
import '/buttons/add_button/add_button_widget.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_image_model.dart';
export 'edit_profile_image_model.dart';

class EditProfileImageWidget extends StatefulWidget {
  const EditProfileImageWidget({super.key});

  @override
  State<EditProfileImageWidget> createState() => _EditProfileImageWidgetState();
}

class _EditProfileImageWidgetState extends State<EditProfileImageWidget> {
  late EditProfileImageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileImageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    final selectedMedia =
                        await selectMediaWithSourceBottomSheet(
                      context: context,
                      allowPhoto: true,
                    );
                    if (selectedMedia != null &&
                        selectedMedia.every((m) =>
                            validateFileFormat(m.storagePath, context))) {
                      safeSetState(
                          () => _model.isDataUploading_localimage = true);
                      var selectedUploadedFiles = <FFUploadedFile>[];

                      try {
                        selectedUploadedFiles = selectedMedia
                            .map((m) => FFUploadedFile(
                                  name: m.storagePath.split('/').last,
                                  bytes: m.bytes,
                                  height: m.dimensions?.height,
                                  width: m.dimensions?.width,
                                  blurHash: m.blurHash,
                                ))
                            .toList();
                      } finally {
                        _model.isDataUploading_localimage = false;
                      }
                      if (selectedUploadedFiles.length ==
                          selectedMedia.length) {
                        safeSetState(() {
                          _model.uploadedLocalFile_localimage =
                              selectedUploadedFiles.first;
                        });
                      } else {
                        safeSetState(() {});
                        return;
                      }
                    }
                  },
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(
                            _model.uploadedLocalFile_localimage.bytes ??
                                Uint8List.fromList([]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, 1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 32.0, 0.0),
                          child: Icon(
                            Icons.upload_sharp,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 48.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 20.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (FFAppState().isLoading2 == false) {
                        FFAppState().isLoading2 = true;
                        safeSetState(() {});
                        {
                          safeSetState(
                              () => _model.isDataUploading_uploaded = true);
                          var selectedUploadedFiles = <FFUploadedFile>[];
                          var selectedMedia = <SelectedFile>[];
                          var downloadUrls = <String>[];
                          try {
                            showUploadMessage(
                              context,
                              'Uploading file...',
                              showLoading: true,
                            );
                            selectedUploadedFiles = _model
                                    .uploadedLocalFile_localimage
                                    .bytes!
                                    .isNotEmpty
                                ? [_model.uploadedLocalFile_localimage]
                                : <FFUploadedFile>[];
                            selectedMedia = selectedFilesFromUploadedFiles(
                              selectedUploadedFiles,
                              storageFolderPath: 'profileimage',
                            );
                            downloadUrls = await uploadSupabaseStorageFiles(
                              bucketName: 'profileimage',
                              selectedFiles: selectedMedia,
                            );
                          } finally {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            _model.isDataUploading_uploaded = false;
                          }
                          if (selectedUploadedFiles.length ==
                                  selectedMedia.length &&
                              downloadUrls.length == selectedMedia.length) {
                            safeSetState(() {
                              _model.uploadedLocalFile_uploaded =
                                  selectedUploadedFiles.first;
                              _model.uploadedFileUrl_uploaded =
                                  downloadUrls.first;
                            });
                            showUploadMessage(context, 'Success!');
                          } else {
                            safeSetState(() {});
                            showUploadMessage(context, 'Failed to upload data');
                            return;
                          }
                        }

                        FFAppState().updateUserStruct(
                          (e) =>
                              e..profileImage = _model.uploadedFileUrl_uploaded,
                        );
                        safeSetState(() {});
                        await UsersTable().update(
                          data: {
                            'profile_image': _model.uploadedFileUrl_uploaded,
                          },
                          matchingRows: (rows) => rows.eqOrNull(
                            'user_id',
                            FFAppState().user.userId,
                          ),
                        );
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Update'),
                              content: Text('Success'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                        FFAppState().isLoading2 = false;
                        safeSetState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: wrapWithModel(
                      model: _model.addButtonModel,
                      updateCallback: () => safeSetState(() {}),
                      child: AddButtonWidget(
                        textParameter: 'Confirm',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if ((FFAppState().isLoading1 == true) ||
            FFAppState().isLoading2 ||
            FFAppState().isLoading3)
          wrapWithModel(
            model: _model.isloadingModel,
            updateCallback: () => safeSetState(() {}),
            child: IsloadingWidget(),
          ),
      ],
    );
  }
}
