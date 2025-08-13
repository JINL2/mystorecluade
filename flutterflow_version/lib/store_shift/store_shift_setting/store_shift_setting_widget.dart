import '/backend/supabase/supabase.dart';
import '/buttons/add_button/add_button_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/popup/popup_widget.dart';
import '/store_shift/store_shift_component/store_shift_component_widget.dart';
import '/store_shift/store_shift_create/store_shift_create_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'store_shift_setting_model.dart';
export 'store_shift_setting_model.dart';

class StoreShiftSettingWidget extends StatefulWidget {
  const StoreShiftSettingWidget({super.key});

  static String routeName = 'storeShiftSetting';
  static String routePath = '/storeShiftSetting';

  @override
  State<StoreShiftSettingWidget> createState() =>
      _StoreShiftSettingWidgetState();
}

class _StoreShiftSettingWidgetState extends State<StoreShiftSettingWidget> {
  late StoreShiftSettingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoreShiftSettingModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                wrapWithModel(
                  model: _model.menuBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MenuBarWidget(
                    menuName: 'Store Shift Setting',
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                          _model.chooseStoreValueController ??=
                                              FormFieldController<String>(
                                        _model.chooseStoreValue ??=
                                            FFAppState().storeChoosen,
                                      ),
                                      options: List<String>.from(FFAppState()
                                          .user
                                          .companies
                                          .where((e) =>
                                              FFAppState().companyChoosen ==
                                              e.companyId)
                                          .toList()
                                          .firstOrNull!
                                          .stores
                                          .map((e) => e.storeId)
                                          .toList()),
                                      optionLabels: FFAppState()
                                          .user
                                          .companies
                                          .where((e) =>
                                              FFAppState().companyChoosen ==
                                              e.companyId)
                                          .toList()
                                          .firstOrNull!
                                          .stores
                                          .map((e) => e.storeName)
                                          .toList(),
                                      onChanged: (val) async {
                                        safeSetState(() =>
                                            _model.chooseStoreValue = val);
                                        FFAppState().storeChoosen =
                                            _model.chooseStoreValue!;
                                        safeSetState(() {});
                                      },
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      height: 60.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      hintText: 'Choose Store',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 2.0,
                                      borderColor:
                                          FlutterFlowTheme.of(context).primary,
                                      borderWidth: 1.0,
                                      borderRadius: 40.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      hidesUnderline: true,
                                      isOverButton: false,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        1.0, 0.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (FFAppState().storeChoosen != '') {
                                          if (FFAppState().isLoading1 ==
                                              false) {
                                            FFAppState().isLoading1 = true;
                                            safeSetState(() {});
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child: PopupWidget(
                                                      popupTitle:
                                                          'Create Shift',
                                                      widgetBuilder: () =>
                                                          StoreShiftCreateWidget(
                                                        storeId: _model
                                                            .chooseStoreValue!,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));

                                            FFAppState().isLoading1 = false;
                                            safeSetState(() {});
                                          }
                                        }
                                      },
                                      child: wrapWithModel(
                                        model: _model.addButtonModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: AddButtonWidget(
                                          textParameter: '+ Add shift',
                                          colorParameter: FFAppState().storeChoosen !=
                                                      ''
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder<List<StoreShiftsRow>>(
                              future: StoreShiftsTable().queryRows(
                                queryFn: (q) => q.eqOrNull(
                                  'store_id',
                                  _model.chooseStoreValue,
                                ),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 80.0,
                                      height: 80.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<StoreShiftsRow>
                                    listViewStoreShiftsRowList = snapshot.data!;

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: listViewStoreShiftsRowList.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 12.0),
                                  itemBuilder: (context, listViewIndex) {
                                    final listViewStoreShiftsRow =
                                        listViewStoreShiftsRowList[
                                            listViewIndex];
                                    return wrapWithModel(
                                      model: _model.storeShiftComponentModels
                                          .getModel(
                                        listViewStoreShiftsRow.shiftId,
                                        listViewIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: StoreShiftComponentWidget(
                                        key: Key(
                                          'Keyzsh_${listViewStoreShiftsRow.shiftId}',
                                        ),
                                        storeShift: listViewStoreShiftsRow,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
