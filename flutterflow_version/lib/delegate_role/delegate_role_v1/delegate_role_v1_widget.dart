import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'delegate_role_v1_model.dart';
export 'delegate_role_v1_model.dart';

class DelegateRoleV1Widget extends StatefulWidget {
  const DelegateRoleV1Widget({
    super.key,
    required this.roleInformation,
  });

  final VUserRoleInfoRow? roleInformation;

  @override
  State<DelegateRoleV1Widget> createState() => _DelegateRoleV1WidgetState();
}

class _DelegateRoleV1WidgetState extends State<DelegateRoleV1Widget> {
  late DelegateRoleV1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DelegateRoleV1Model());

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

    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<RolesRow>>(
              future: RolesTable().queryRows(
                queryFn: (q) => q
                    .eqOrNull(
                      'company_id',
                      widget.roleInformation?.companyId,
                    )
                    .neqOrNull(
                      'role_type',
                      'owner',
                    )
                    .order('created_at'),
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<RolesRow> newRoleRolesRowList = snapshot.data!;

                return FlutterFlowDropDown<String>(
                  controller: _model.newRoleValueController ??=
                      FormFieldController<String>(
                    _model.newRoleValue ??= '',
                  ),
                  options: List<String>.from(
                      newRoleRolesRowList.map((e) => e.roleId).toList()),
                  optionLabels: newRoleRolesRowList
                      .map((e) => e.roleName)
                      .withoutNulls
                      .toList(),
                  onChanged: (val) =>
                      safeSetState(() => _model.newRoleValue = val),
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 40.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.notoSansJp(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  hintText: 'Select...',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  elevation: 2.0,
                  borderColor: FlutterFlowTheme.of(context).primary,
                  borderWidth: 1.0,
                  borderRadius: 12.0,
                  margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  hidesUnderline: true,
                  isOverButton: false,
                  isSearchable: false,
                  isMultiSelect: false,
                );
              },
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 80.0, 24.0, 40.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().isLoading2 == false) {
                    FFAppState().isLoading2 = true;
                    safeSetState(() {});
                    _model.updateRole = await UserRolesTable().update(
                      data: {
                        'role_id': _model.newRoleValue,
                        'user_role_id': widget.roleInformation?.userRoleId,
                      },
                      matchingRows: (rows) => rows.eqOrNull(
                        'user_role_id',
                        widget.roleInformation?.userRoleId,
                      ),
                      returnRows: true,
                    );
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          content: Text('done'),
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

                  safeSetState(() {});
                },
                child: wrapWithModel(
                  model: _model.addModel,
                  updateCallback: () => safeSetState(() {}),
                  child: AddWidget(
                    name: 'Save',
                    height: 48,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
