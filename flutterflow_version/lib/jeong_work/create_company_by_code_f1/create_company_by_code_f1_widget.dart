import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'create_company_by_code_f1_model.dart';
export 'create_company_by_code_f1_model.dart';

class CreateCompanyByCodeF1Widget extends StatefulWidget {
  const CreateCompanyByCodeF1Widget({super.key});

  @override
  State<CreateCompanyByCodeF1Widget> createState() =>
      _CreateCompanyByCodeF1WidgetState();
}

class _CreateCompanyByCodeF1WidgetState
    extends State<CreateCompanyByCodeF1Widget> {
  late CreateCompanyByCodeF1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateCompanyByCodeF1Model());

    _model.companyCodeTextController ??= TextEditingController();
    _model.companyCodeFocusNode ??= FocusNode();

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  child: TextFormField(
                    controller: _model.companyCodeTextController,
                    focusNode: _model.companyCodeFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.companyCodeTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.finishWork = false;
                        safeSetState(() {});
                      },
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Put Your Code Here',
                      labelStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: Color(0xFF57636C),
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE0E3E7),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF101213),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(0xFF4B39EF),
                    validator: _model.companyCodeTextControllerValidator
                        .asValidator(context),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 16.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (FFAppState().isLoading2 == false) {
                          FFAppState().isLoading2 = true;
                          safeSetState(() {});
                          if (_model.companyCodeTextController.text != '') {
                            _model.searchCompany =
                                await CompaniesTable().queryRows(
                              queryFn: (q) => q.eqOrNull(
                                'company_code',
                                _model.companyCodeTextController.text,
                              ),
                            );
                            if ((_model.searchCompany != null &&
                                    (_model.searchCompany)!.isNotEmpty) ==
                                true) {
                              FFAppState().companyChoosen =
                                  _model.searchCompany!.firstOrNull!.companyId;
                              safeSetState(() {});
                              _model.finishWork = true;
                              safeSetState(() {});
                            } else {
                              _model.storeChoosen =
                                  await StoresTable().queryRows(
                                queryFn: (q) => q.eqOrNull(
                                  'store_code',
                                  _model.companyCodeTextController.text,
                                ),
                              );
                              if (_model.storeChoosen?.firstOrNull?.storeId !=
                                      null &&
                                  _model.storeChoosen?.firstOrNull?.storeId !=
                                      '') {
                                FFAppState().storeChoosen =
                                    _model.storeChoosen!.firstOrNull!.storeId;
                                safeSetState(() {});
                                _model.finishWork = true;
                                safeSetState(() {});
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Wrong Code'),
                                      content: Text('Check Code Again'),
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
                                _model.finishWork = false;
                                safeSetState(() {});
                              }

                              // Finish1
                              FFAppState().isLoading2 = false;
                              safeSetState(() {});
                            }

                            // Finish1
                            FFAppState().isLoading2 = false;
                            safeSetState(() {});
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('Put Information'),
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
                          }

                          // Finish1
                          FFAppState().isLoading2 = false;
                          safeSetState(() {});
                        }

                        safeSetState(() {});
                      },
                      child: Icon(
                        Icons.search,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 42.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_model.finishWork ?? true)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(52.0, 20.0, 52.0, 20.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().isLoading3 == false) {
                    FFAppState().isLoading3 = true;
                    safeSetState(() {});
                    _model.joinByCodeCopy = await JoinUserByCodeCall.call(
                      pUserId: currentUserUid,
                      pCode: _model.companyCodeTextController.text,
                    );

                    if ((_model.joinByCodeCopy?.succeeded ?? true)) {
                      _model.apiResultd5q = await GetUserCompaniesCall.call(
                        pUserId: FFAppState().user.userId,
                      );

                      if ((_model.apiResultd5q?.succeeded ?? true)) {
                        FFAppState().user = UserStruct.maybeFromMap(
                            (_model.apiResultd5q?.jsonBody ?? ''))!;
                        safeSetState(() {});
                        FFAppState().companyChoosen =
                            FFAppState().user.companies.lastOrNull!.companyId;
                        FFAppState().storeChoosen = FFAppState()
                            .user
                            .companies
                            .lastOrNull!
                            .stores
                            .firstOrNull!
                            .storeId;
                        safeSetState(() {});
                      }
                      FFAppState().isLoading3 = false;
                      safeSetState(() {});
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Register by Code Sucess'),
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
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Register by code'),
                            content: Text(
                                (_model.joinByCodeCopy?.jsonBody ?? '')
                                    .toString()),
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
                      FFAppState().isLoading3 = false;
                      safeSetState(() {});
                    }

                    context.pushNamed(
                      HomepageWidget.routeName,
                      queryParameters: {
                        'firstLogin': serializeParam(
                          true,
                          ParamType.bool,
                        ),
                      }.withoutNulls,
                    );
                  }

                  safeSetState(() {});
                },
                child: wrapWithModel(
                  model: _model.addModel,
                  updateCallback: () => safeSetState(() {}),
                  child: AddWidget(
                    name: 'Confirm',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
