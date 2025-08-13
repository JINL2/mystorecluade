import '/attendance/datetestes/datetestes_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/common/calender_bottom_sheet/calender_bottom_sheet_widget.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/manager/calnder_comp/calnder_comp_widget.dart';
import '/manager_schedule_test/insert_schedule/insert_schedule_widget.dart';
import '/manager_schedule_test/manager_indi_component/manager_indi_component_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'timetable_manage_model.dart';
export 'timetable_manage_model.dart';

class TimetableManageWidget extends StatefulWidget {
  const TimetableManageWidget({super.key});

  static String routeName = 'timetableManage';
  static String routePath = '/timetableManage';

  @override
  State<TimetableManageWidget> createState() => _TimetableManageWidgetState();
}

class _TimetableManageWidgetState extends State<TimetableManageWidget>
    with TickerProviderStateMixin {
  late TimetableManageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TimetableManageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().shiftMetaData = [];
      FFAppState().managerShiftDetail = [];
      safeSetState(() {});
      _model.selectedDate = functions.getTodayPlusMinus(getCurrentTimestamp, 0);
      _model.selectedStoreId = FFAppState().storeChoosen;
      _model.clickedMonthStatus = 'total_approved';
      _model.addToMonthFilter(
          dateTimeFormat("yyyy-MM", _model.selectedDate!.date0!));
      safeSetState(() {});
      if (FFAppState().isLoading1 == false) {
        FFAppState().isLoading1 = true;
        safeSetState(() {});
        _model.oPLgetShiftMetaData = await GetshiftmetadataCall.call(
          pStoreId: _model.selectedStoreId,
        );

        if ((_model.oPLgetShiftMetaData?.succeeded ?? true)) {
          _model.oPLgetShiftMetaDataCustom =
              await actions.mergeAndRemoveDuplicatesShiftMeta(
            FFAppState().shiftMetaData.toList(),
            ((_model.oPLgetShiftMetaData?.jsonBody ?? '')
                    .toList()
                    .map<ShiftMetaDataStruct?>(ShiftMetaDataStruct.maybeFromMap)
                    .toList() as Iterable<ShiftMetaDataStruct?>)
                .withoutNulls
                .toList(),
          );
          FFAppState().shiftMetaData = _model.oPLgetShiftMetaDataCustom!
              .toList()
              .cast<ShiftMetaDataStruct>();
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Error'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          FFAppState().isLoading1 = false;
          safeSetState(() {});
        }

        _model.oPLGetManagerShift = await GetManagerShiftCall.call(
          pStoreId: _model.selectedStoreId,
          pRequestDate: _model.selectedDate?.date0?.toString(),
        );

        if ((_model.oPLGetManagerShift?.succeeded ?? true)) {
          _model.oPLGetManagerShiftCustom =
              await actions.mergeAndRemoveDuplicatesManagerShift(
            FFAppState().managerShiftDetail.toList(),
            ((_model.oPLGetManagerShift?.jsonBody ?? '')
                    .toList()
                    .map<ManagerShiftDetailStruct?>(
                        ManagerShiftDetailStruct.maybeFromMap)
                    .toList() as Iterable<ManagerShiftDetailStruct?>)
                .withoutNulls
                .toList(),
          );
          FFAppState().managerShiftDetail = _model.oPLGetManagerShiftCustom!
              .toList()
              .cast<ManagerShiftDetailStruct>();
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Error2'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
          FFAppState().isLoading1 = false;
          safeSetState(() {});
        }

        _model.oPLOverview =
            await ManagerShiftGroup.managershiftgetoverviewCall.call(
          pStartDate: functions
              .getMonthFirstLast(
                  dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp), true)
              ?.toString(),
          pEndDate: functions
              .getMonthFirstLast(
                  dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp), false)
              ?.toString(),
          pStoreId: _model.selectedStoreId,
          pCompanyId: FFAppState().companyChoosen,
        );

        if ((_model.oPLOverview?.succeeded ?? true)) {
          _model.overviewStore = getJsonField(
            (_model.oPLOverview?.jsonBody ?? ''),
            r'''$.stores''',
            true,
          )!
              .toList()
              .cast<dynamic>();
          _model.montlystat = getJsonField(
            _model.overviewStore
                .where((e) =>
                    functions.convertJsonToString(getJsonField(
                      e,
                      r'''$.store_id''',
                    )) ==
                    _model.selectedStoreId)
                .toList()
                .firstOrNull,
            r'''$.monthly_stats''',
            true,
          )!
              .toList()
              .cast<dynamic>();
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Fail Overview API'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }

        _model.oPLManagerCard =
            await ManagerShiftGroup.managershiftgetcardsCall.call(
          pStartDate: functions
              .getMonthFirstLast(
                  dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp), true)
              ?.toString(),
          pEndDate: functions
              .getMonthFirstLast(
                  dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp), false)
              ?.toString(),
          pStoreId: _model.selectedStoreId,
          pCompanyId: FFAppState().companyChoosen,
        );

        if ((_model.oPLManagerCard?.succeeded ?? true)) {
          _model.storeData = getJsonField(
            (_model.oPLManagerCard?.jsonBody ?? ''),
            r'''$.stores''',
            true,
          )!
              .toList()
              .cast<dynamic>();
          _model.cardsdata = getJsonField(
            _model.storeData
                .where((e) =>
                    functions.convertJsonToString(getJsonField(
                      e,
                      r'''$.store_id''',
                    )) ==
                    _model.selectedStoreId)
                .toList()
                .firstOrNull,
            r'''$.cards''',
            true,
          )!
              .toList()
              .cast<dynamic>();
          _model.tagFilter = getJsonField(
            (_model.oPLManagerCard?.jsonBody ?? ''),
            r'''$.available_contents''',
            true,
          )!
              .toList()
              .cast<dynamic>();
          _model.clickedTagFilter = 'all';
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Fail Card API'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        FFAppState().isLoading1 = false;
        safeSetState(() {});
      }

      FFAppState().isLoading1 = false;
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  wrapWithModel(
                    model: _model.menuBarModel,
                    updateCallback: () => safeSetState(() {}),
                    child: MenuBarWidget(
                      menuName: 'Time Table Management',
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final storeList = FFAppState()
                                      .user
                                      .companies
                                      .where((e) =>
                                          e.companyId ==
                                          FFAppState().companyChoosen)
                                      .toList()
                                      .firstOrNull
                                      ?.stores
                                      .toList() ??
                                  [];

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(storeList.length,
                                      (storeListIndex) {
                                    final storeListItem =
                                        storeList[storeListIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        _model.selectedStoreId =
                                            storeListItem.storeId;
                                        _model.monthFilter = [];
                                        _model.cardsdata = [];
                                        safeSetState(() {});
                                        _model.addToMonthFilter(dateTimeFormat(
                                            "yyyy-MM",
                                            _model.selectedDate!.date0!));
                                        safeSetState(() {});
                                        if (FFAppState().isLoading2 == false) {
                                          FFAppState().isLoading2 = true;
                                          safeSetState(() {});
                                          if (functions.isListHaveDatatypeList(
                                              storeListItem.storeId,
                                              FFAppState()
                                                  .shiftMetaData
                                                  .toList())!) {
                                            _model.overviewOverview =
                                                await ManagerShiftGroup
                                                    .managershiftgetoverviewCall
                                                    .call(
                                              pStartDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      true)
                                                  ?.toString(),
                                              pEndDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      false)
                                                  ?.toString(),
                                              pStoreId: _model.selectedStoreId,
                                              pCompanyId:
                                                  FFAppState().companyChoosen,
                                            );

                                            if ((_model.overviewOverview
                                                    ?.succeeded ??
                                                true)) {
                                              _model.overviewStore =
                                                  getJsonField(
                                                (_model.overviewOverview
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.stores''',
                                                true,
                                              )!
                                                      .toList()
                                                      .cast<dynamic>();
                                              _model.montlystat = getJsonField(
                                                _model.overviewStore
                                                    .where((e) =>
                                                        functions
                                                            .convertJsonToString(
                                                                getJsonField(
                                                          e,
                                                          r'''$.store_id''',
                                                        )) ==
                                                        _model.selectedStoreId)
                                                    .toList()
                                                    .firstOrNull,
                                                r'''$.monthly_stats''',
                                                true,
                                              )!
                                                  .toList()
                                                  .cast<dynamic>();
                                              safeSetState(() {});
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Fail API'),
                                                    content: Text((_model
                                                                .overviewOverview
                                                                ?.jsonBody ??
                                                            '')
                                                        .toString()),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }

                                            _model.cardCard =
                                                await ManagerShiftGroup
                                                    .managershiftgetcardsCall
                                                    .call(
                                              pStartDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      true)
                                                  ?.toString(),
                                              pEndDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      false)
                                                  ?.toString(),
                                              pStoreId: _model.selectedStoreId,
                                              pCompanyId:
                                                  FFAppState().companyChoosen,
                                            );

                                            if ((_model.cardCard?.succeeded ??
                                                true)) {
                                              _model.storeData = getJsonField(
                                                (_model.cardCard?.jsonBody ??
                                                    ''),
                                                r'''$.stores''',
                                                true,
                                              )!
                                                  .toList()
                                                  .cast<dynamic>();
                                              safeSetState(() {});
                                              if (_model
                                                      .storeData.firstOrNull !=
                                                  null) {
                                                _model.cardsdata = getJsonField(
                                                  _model.storeData.firstOrNull,
                                                  r'''$.cards''',
                                                  true,
                                                )!
                                                    .toList()
                                                    .cast<dynamic>();
                                                safeSetState(() {});
                                              }
                                            }
                                          } else {
                                            _model.storeMetaData =
                                                await GetshiftmetadataCall.call(
                                              pStoreId: storeListItem.storeId,
                                            );

                                            if ((_model
                                                    .storeMetaData?.succeeded ??
                                                true)) {
                                              _model.storeMetaData2 = await actions
                                                  .mergeAndRemoveDuplicatesShiftMeta(
                                                FFAppState()
                                                    .shiftMetaData
                                                    .toList(),
                                                ((_model.storeMetaData
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toList()
                                                            .map<ShiftMetaDataStruct?>(
                                                                ShiftMetaDataStruct
                                                                    .maybeFromMap)
                                                            .toList()
                                                        as Iterable<
                                                            ShiftMetaDataStruct?>)
                                                    .withoutNulls
                                                    .toList(),
                                              );
                                              FFAppState().shiftMetaData = _model
                                                  .storeMetaData2!
                                                  .toList()
                                                  .cast<ShiftMetaDataStruct>();
                                              safeSetState(() {});
                                            } else {
                                              FFAppState().isLoading2 = false;
                                              safeSetState(() {});
                                            }

                                            _model.storeManager =
                                                await GetManagerShiftCall.call(
                                              pStoreId: storeListItem.storeId,
                                              pRequestDate: dateTimeFormat(
                                                  "yyyy-MM-dd",
                                                  _model.selectedDate?.date0),
                                            );

                                            if ((_model
                                                    .storeManager?.succeeded ??
                                                true)) {
                                              _model.storeManager2 = await actions
                                                  .mergeAndRemoveDuplicatesManagerShift(
                                                FFAppState()
                                                    .managerShiftDetail
                                                    .toList(),
                                                ((_model.storeManager
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toList()
                                                            .map<ManagerShiftDetailStruct?>(
                                                                ManagerShiftDetailStruct
                                                                    .maybeFromMap)
                                                            .toList()
                                                        as Iterable<
                                                            ManagerShiftDetailStruct?>)
                                                    .withoutNulls
                                                    .toList(),
                                              );
                                              FFAppState().managerShiftDetail =
                                                  _model.storeManager2!
                                                      .toList()
                                                      .cast<
                                                          ManagerShiftDetailStruct>();
                                              safeSetState(() {});
                                            } else {
                                              FFAppState().isLoading2 = false;
                                              safeSetState(() {});
                                            }

                                            _model.storeClickOverview =
                                                await ManagerShiftGroup
                                                    .managershiftgetoverviewCall
                                                    .call(
                                              pStartDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      true)
                                                  ?.toString(),
                                              pEndDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      false)
                                                  ?.toString(),
                                              pStoreId: _model.selectedStoreId,
                                              pCompanyId:
                                                  FFAppState().companyChoosen,
                                            );

                                            if ((_model.storeClickOverview
                                                    ?.succeeded ??
                                                true)) {
                                              _model.overviewStore =
                                                  getJsonField(
                                                (_model.storeClickOverview
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.stores''',
                                                true,
                                              )!
                                                      .toList()
                                                      .cast<dynamic>();
                                              _model.montlystat = getJsonField(
                                                _model.overviewStore
                                                    .where((e) =>
                                                        functions
                                                            .convertJsonToString(
                                                                getJsonField(
                                                          e,
                                                          r'''$.store_id''',
                                                        )) ==
                                                        _model.selectedStoreId)
                                                    .toList()
                                                    .firstOrNull,
                                                r'''$.monthly_stats''',
                                                true,
                                              )!
                                                  .toList()
                                                  .cast<dynamic>();
                                              safeSetState(() {});
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'API overview Fail'),
                                                    content: Text((_model
                                                                .storeClickOverview
                                                                ?.jsonBody ??
                                                            '')
                                                        .toString()),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }

                                            _model.storeClickManagerCard =
                                                await ManagerShiftGroup
                                                    .managershiftgetcardsCall
                                                    .call(
                                              pStartDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      true)
                                                  ?.toString(),
                                              pEndDate: functions
                                                  .getMonthFirstLast(
                                                      dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.selectedDate
                                                              ?.date0),
                                                      false)
                                                  ?.toString(),
                                              pStoreId: _model.selectedStoreId,
                                              pCompanyId:
                                                  FFAppState().companyChoosen,
                                            );

                                            if ((_model.storeClickManagerCard
                                                    ?.succeeded ??
                                                true)) {
                                              _model.storeData = getJsonField(
                                                (_model.storeClickManagerCard
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.stores''',
                                                true,
                                              )!
                                                  .toList()
                                                  .cast<dynamic>();
                                              safeSetState(() {});
                                              if (_model
                                                      .storeData.firstOrNull !=
                                                  null) {
                                                _model.cardsdata = getJsonField(
                                                  _model.storeData.firstOrNull,
                                                  r'''$.cards''',
                                                  true,
                                                )!
                                                    .toList()
                                                    .cast<dynamic>();
                                                safeSetState(() {});
                                              }
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'API manager Card Fail'),
                                                    content: Text((_model
                                                                .storeClickManagerCard
                                                                ?.jsonBody ??
                                                            '')
                                                        .toString()),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        } else {
                                          FFAppState().isLoading2 = false;
                                          safeSetState(() {});
                                        }

                                        FFAppState().isLoading2 = false;
                                        safeSetState(() {});

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                          color: valueOrDefault<Color>(
                                            storeListItem.storeId ==
                                                    _model.selectedStoreId
                                                ? Color(0xFF3B82F6)
                                                : Color(0xFFF3F4F6),
                                            Color(0xFFF3F4F6),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 8.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              functions.getStoreNameByIdFromList(
                                                  FFAppState()
                                                      .user
                                                      .companies
                                                      .where((e) =>
                                                          e.companyId ==
                                                          FFAppState()
                                                              .companyChoosen)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.stores
                                                      .toList(),
                                                  storeListItem.storeId),
                                              'store',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.notoSansJp(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: storeListItem
                                                              .storeId ==
                                                          _model.selectedStoreId
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).divide(SizedBox(width: 8.0)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor:
                                FlutterFlowTheme.of(context).primaryText,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.notoSansJp(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            unselectedLabelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.notoSansJp(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            indicatorColor:
                                FlutterFlowTheme.of(context).primary,
                            tabs: [
                              Tab(
                                text: 'Show',
                              ),
                              Tab(
                                text: 'Manage',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (FFAppState()
                                                            .isLoading3 ==
                                                        false) {
                                                      FFAppState().isLoading3 =
                                                          true;
                                                      safeSetState(() {});
                                                      _model.getManagerShiftRefresh1 =
                                                          await GetManagerShiftCall
                                                              .call(
                                                        pStoreId: _model
                                                            .selectedStoreId,
                                                        pRequestDate:
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .selectedDate
                                                                    ?.date0),
                                                      );

                                                      if ((_model
                                                              .getManagerShiftRefresh1
                                                              ?.succeeded ??
                                                          true)) {
                                                        FFAppState()
                                                            .managerShiftDetail = ((_model
                                                                        .getManagerShiftRefresh1
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toList()
                                                                .map<ManagerShiftDetailStruct?>(
                                                                    ManagerShiftDetailStruct
                                                                        .maybeFromMap)
                                                                .toList() as Iterable<ManagerShiftDetailStruct?>)
                                                            .withoutNulls
                                                            .toList()
                                                            .cast<ManagerShiftDetailStruct>();
                                                        safeSetState(() {});
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Error2'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        FFAppState()
                                                            .isLoading3 = false;
                                                        safeSetState(() {});
                                                      }

                                                      FFAppState().isLoading1 =
                                                          false;
                                                      FFAppState().isLoading2 =
                                                          false;
                                                      FFAppState().isLoading3 =
                                                          false;
                                                      safeSetState(() {});
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.refresh_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                            wrapWithModel(
                                              model: _model.calnderCompModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: CalnderCompWidget(
                                                inputDateComPara:
                                                    getCurrentTimestamp,
                                                initialSelectedDate:
                                                    getCurrentTimestamp,
                                                storeId: _model.selectedStoreId,
                                                onSelectDateAction:
                                                    (selectedDate) async {
                                                  _model.selectedDate =
                                                      functions
                                                          .getTodayPlusMinus(
                                                              selectedDate, 0);
                                                  safeSetState(() {});
                                                },
                                                selectedShift:
                                                    (selectedShift) async {
                                                  _model.selectedShiftRequestId =
                                                      selectedShift
                                                          .toList()
                                                          .cast<String>();
                                                  safeSetState(() {});
                                                },
                                              ),
                                            ),
                                            Builder(
                                              builder: (context) {
                                                final managerShiftDetail = FFAppState()
                                                        .managerShiftDetail
                                                        .where((e) =>
                                                            (e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .selectedDate
                                                                        ?.date0)) &&
                                                            (e.storeId ==
                                                                _model
                                                                    .selectedStoreId))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.shifts
                                                        .toList() ??
                                                    [];

                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      managerShiftDetail.length,
                                                  itemBuilder: (context,
                                                      managerShiftDetailIndex) {
                                                    final managerShiftDetailItem =
                                                        managerShiftDetail[
                                                            managerShiftDetailIndex];
                                                    return Visibility(
                                                      visible:
                                                          managerShiftDetailItem
                                                                  .pendingCount !=
                                                              0,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    12.0,
                                                                    0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            managerShiftDetailItem.shiftName,
                                                                            'Shift Name',
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          maxLines:
                                                                              1,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .override(
                                                                                font: GoogleFonts.notoSansJp(
                                                                                  fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 20.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final pendingEmployee =
                                                                    managerShiftDetailItem
                                                                        .pendingEmployees
                                                                        .toList();

                                                                return ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  primary:
                                                                      false,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemCount:
                                                                      pendingEmployee
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          pendingEmployeeIndex) {
                                                                    final pendingEmployeeItem =
                                                                        pendingEmployee[
                                                                            pendingEmployeeIndex];
                                                                    return Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                9,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      pendingEmployeeItem.userName,
                                                                                      'userName',
                                                                                    ),
                                                                                    maxLines: 1,
                                                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                          font: GoogleFonts.notoSansJp(
                                                                                            fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Theme(
                                                                              data: ThemeData(
                                                                                checkboxTheme: CheckboxThemeData(
                                                                                  visualDensity: VisualDensity.compact,
                                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                                  ),
                                                                                ),
                                                                                unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                                                                              ),
                                                                              child: Checkbox(
                                                                                value: _model.checkboxValueMap[pendingEmployeeItem] ??= false,
                                                                                onChanged: (newValue) async {
                                                                                  safeSetState(() => _model.checkboxValueMap[pendingEmployeeItem] = newValue!);
                                                                                  if (newValue!) {
                                                                                    _model.addToSelectedShiftRequestId(pendingEmployeeItem.shiftRequestId);
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    _model.removeFromSelectedShiftRequestId(pendingEmployeeItem.shiftRequestId);
                                                                                    safeSetState(() {});
                                                                                  }
                                                                                },
                                                                                side: (FlutterFlowTheme.of(context).alternate != null)
                                                                                    ? BorderSide(
                                                                                        width: 2,
                                                                                        color: FlutterFlowTheme.of(context).alternate,
                                                                                      )
                                                                                    : null,
                                                                                activeColor: FlutterFlowTheme.of(context).primary,
                                                                                checkColor: FlutterFlowTheme.of(context).info,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            FFButtonWidget(
                                              onPressed: (_model
                                                              .selectedShiftRequestId
                                                              .firstOrNull ==
                                                          null ||
                                                      _model.selectedShiftRequestId
                                                              .firstOrNull ==
                                                          '')
                                                  ? null
                                                  : () async {
                                                      if (FFAppState()
                                                              .isLoading2 ==
                                                          false) {
                                                        FFAppState()
                                                            .isLoading2 = true;
                                                        safeSetState(() {});
                                                        _model.changeSupaBaseApprove1 =
                                                            await ToggleshiftapprovalCall
                                                                .call(
                                                          pShiftRequestIdsList:
                                                              _model
                                                                  .selectedShiftRequestId,
                                                          pUserId: FFAppState()
                                                              .user
                                                              .userId,
                                                        );

                                                        if ((_model
                                                                .changeSupaBaseApprove1
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.newShiftDetail1 =
                                                              await actions
                                                                  .changeManagerShiftList(
                                                            _model
                                                                .selectedShiftRequestId
                                                                .toList(),
                                                            FFAppState()
                                                                .managerShiftDetail
                                                                .toList(),
                                                          );
                                                          FFAppState()
                                                                  .managerShiftDetail =
                                                              _model
                                                                  .newShiftDetail1!
                                                                  .toList()
                                                                  .cast<
                                                                      ManagerShiftDetailStruct>();
                                                          safeSetState(() {});
                                                        } else {
                                                          FFAppState()
                                                                  .isLoading2 =
                                                              false;
                                                          safeSetState(() {});
                                                        }

                                                        _model.updateManagerShiftGetOverview =
                                                            await ManagerShiftGroup
                                                                .managershiftgetoverviewCall
                                                                .call(
                                                          pStartDate: functions
                                                              .getMonthFirstLast(
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  true)
                                                              ?.toString(),
                                                          pEndDate: functions
                                                              .getMonthFirstLast(
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  false)
                                                              ?.toString(),
                                                          pStoreId: _model
                                                              .selectedStoreId,
                                                          pCompanyId: FFAppState()
                                                              .companyChoosen,
                                                        );

                                                        if ((_model
                                                                .updateManagerShiftGetOverview
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.overviewStore =
                                                              getJsonField(
                                                            (_model.updateManagerShiftGetOverview
                                                                    ?.jsonBody ??
                                                                ''),
                                                            r'''$.stores''',
                                                            true,
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.montlystat =
                                                              getJsonField(
                                                            _model.overviewStore
                                                                .where((e) =>
                                                                    functions
                                                                        .convertJsonToString(
                                                                            getJsonField(
                                                                      e,
                                                                      r'''$.store_id''',
                                                                    )) ==
                                                                    _model
                                                                        .selectedStoreId)
                                                                .toList()
                                                                .firstOrNull,
                                                            r'''$.monthly_stats''',
                                                            true,
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.monthFilter =
                                                              [];
                                                          safeSetState(() {});
                                                          _model.addToMonthFilter(
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .selectedDate!
                                                                      .date0!));
                                                          safeSetState(() {});
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Fail'),
                                                                content: Text((_model
                                                                            .updateManagerShiftGetOverview
                                                                            ?.jsonBody ??
                                                                        '')
                                                                    .toString()),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }

                                                        _model.updateManagerShiftGetCards =
                                                            await ManagerShiftGroup
                                                                .managershiftgetcardsCall
                                                                .call(
                                                          pStartDate: functions
                                                              .getMonthFirstLast(
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  true)
                                                              ?.toString(),
                                                          pEndDate: functions
                                                              .getMonthFirstLast(
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  false)
                                                              ?.toString(),
                                                          pStoreId: _model
                                                              .selectedStoreId,
                                                          pCompanyId: FFAppState()
                                                              .companyChoosen,
                                                        );

                                                        if ((_model
                                                                .updateManagerShiftGetCards
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.storeData =
                                                              getJsonField(
                                                            (_model.updateManagerShiftGetCards
                                                                    ?.jsonBody ??
                                                                ''),
                                                            r'''$.stores''',
                                                            true,
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.cardsdata =
                                                              getJsonField(
                                                            _model.storeData
                                                                .where((e) =>
                                                                    functions
                                                                        .convertJsonToString(
                                                                            getJsonField(
                                                                      e,
                                                                      r'''$.store_id''',
                                                                    )) ==
                                                                    _model
                                                                        .selectedStoreId)
                                                                .toList()
                                                                .firstOrNull,
                                                            r'''$.cards''',
                                                            true,
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.tagFilter =
                                                              getJsonField(
                                                            (_model.updateManagerShiftGetCards
                                                                    ?.jsonBody ??
                                                                ''),
                                                            r'''$.available_contents''',
                                                            true,
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.clickedTagFilter =
                                                              'all';
                                                          safeSetState(() {});
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Fail'),
                                                                content: Text((_model
                                                                            .updateManagerShiftGetCards
                                                                            ?.jsonBody ??
                                                                        '')
                                                                    .toString()),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }

                                                        FFAppState()
                                                            .isLoading2 = false;
                                                        safeSetState(() {});
                                                        _model.selectedShiftRequestId =
                                                            [];
                                                        safeSetState(() {});
                                                      } else {
                                                        FFAppState()
                                                            .isLoading2 = false;
                                                        safeSetState(() {});
                                                      }

                                                      safeSetState(() {});
                                                    },
                                              text: 'Confirm',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: _model
                                                        .selectedShiftRequestId
                                                        .isNotEmpty
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .notoSansJp(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                elevation: 0.0,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ]
                                              .divide(SizedBox(height: 12.0))
                                              .addToStart(
                                                  SizedBox(height: 16.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 16.0, 16.0, 16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            '${valueOrDefault<String>(
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .selectedDate
                                                                      ?.date0),
                                                              '2025-06 Status',
                                                            )} Status',
                                                            'yyyy-MM Status',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .notoSansJp(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          _model.clickedMonthStatus =
                                                                              'total_requests';
                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              _model.clickedMonthStatus == 'total_requests' ? FlutterFlowTheme.of(context).primary : Color(0xFFF8F9FC),
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(16.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      _model.montlystat
                                                                                          .where((e) =>
                                                                                              functions.convertJsonToString(getJsonField(
                                                                                                e,
                                                                                                r'''$.month''',
                                                                                              )) ==
                                                                                              dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))
                                                                                          .toList()
                                                                                          .firstOrNull,
                                                                                      r'''$.total_requests''',
                                                                                    )?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_requests' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        fontSize: 24.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'Total Request',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_requests' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(height: 4.0)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          _model.clickedMonthStatus =
                                                                              'total_problems';
                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              _model.clickedMonthStatus == 'total_problems' ? FlutterFlowTheme.of(context).primary : Color(0xFFF8F9FC),
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(16.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      _model.montlystat
                                                                                          .where((e) =>
                                                                                              functions.convertJsonToString(getJsonField(
                                                                                                e,
                                                                                                r'''$.month''',
                                                                                              )) ==
                                                                                              dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))
                                                                                          .toList()
                                                                                          .firstOrNull,
                                                                                      r'''$.total_problems''',
                                                                                    )?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_problems' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        fontSize: 24.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'Problem',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_problems' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(height: 4.0)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          8.0)),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          _model.clickedMonthStatus =
                                                                              'total_approved';
                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              _model.clickedMonthStatus == 'total_approved' ? FlutterFlowTheme.of(context).primary : Color(0xFFF8F9FC),
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(16.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      _model.montlystat
                                                                                          .where((e) =>
                                                                                              functions.convertJsonToString(getJsonField(
                                                                                                e,
                                                                                                r'''$.month''',
                                                                                              )) ==
                                                                                              dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))
                                                                                          .toList()
                                                                                          .firstOrNull,
                                                                                      r'''$.total_approved''',
                                                                                    )?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_approved' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        fontSize: 24.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'Total Approved',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_approved' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(height: 4.0)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          _model.clickedMonthStatus =
                                                                              'total_pending';
                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              _model.clickedMonthStatus == 'total_pending' ? FlutterFlowTheme.of(context).primary : Color(0xFFF8F9FC),
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(16.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      _model.montlystat
                                                                                          .where((e) =>
                                                                                              functions.convertJsonToString(getJsonField(
                                                                                                e,
                                                                                                r'''$.month''',
                                                                                              )) ==
                                                                                              dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))
                                                                                          .toList()
                                                                                          .firstOrNull,
                                                                                      r'''$.total_pending''',
                                                                                    )?.toString(),
                                                                                    '0',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_pending' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        fontSize: 24.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  'Pending',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                        color: valueOrDefault<Color>(
                                                                                          _model.clickedMonthStatus == 'total_pending' ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).primaryText,
                                                                                          FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(height: 4.0)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          8.0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 16.0)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    24.0,
                                                                    12.0,
                                                                    24.0,
                                                                    12.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        -1);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverviewb =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverviewb
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverviewb?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCardb =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.datetmw),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCardb
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCardb?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCardb?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                FFAppState()
                                                                        .isLoading1 =
                                                                    false;
                                                                safeSetState(
                                                                    () {});

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_back_ios,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 36.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .selectedDate
                                                                        ?.date0),
                                                                'yyyy-MM-dd',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .notoSansJp(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF111827),
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                MediaQuery.sizeOf(context).height * 0.8,
                                                                            child:
                                                                                CalenderBottomSheetWidget(
                                                                              inputDateComPara: _model.selectedDate?.date0,
                                                                              initialSelectedDate: _model.selectedDate?.date0,
                                                                              onSelectDateAction: (selectedDate) async {
                                                                                if (functions.getDateEarlyLate(selectedDate, _model.selectedDate?.date0)!) {
                                                                                  _model.selectedDate = functions.getTodayPlusMinus(selectedDate, 0);
                                                                                  safeSetState(() {});
                                                                                  if (!_model.monthFilter.contains(dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))) {
                                                                                    _model.addToMonthFilter(dateTimeFormat("yyyy-MM", _model.selectedDate!.date0!));
                                                                                    safeSetState(() {});
                                                                                    FFAppState().isLoading1 = true;
                                                                                    safeSetState(() {});
                                                                                    _model.dateClickOverviewG = await ManagerShiftGroup.managershiftgetoverviewCall.call(
                                                                                      pStartDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), true)?.toString(),
                                                                                      pEndDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), false)?.toString(),
                                                                                      pStoreId: _model.selectedStoreId,
                                                                                      pCompanyId: FFAppState().companyChoosen,
                                                                                    );

                                                                                    if ((_model.dateClickOverviewG?.succeeded ?? true)) {
                                                                                      _model.montlystat = functions.overviewMonthlyStat((_model.dateClickOverviewG?.jsonBody ?? ''), _model.montlystat.toList())!.toList().cast<dynamic>();
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      await showDialog(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('Fail API Call'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                child: Text('Ok'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }

                                                                                    _model.dateClickCardG = await ManagerShiftGroup.managershiftgetcardsCall.call(
                                                                                      pStartDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", selectedDate), true)?.toString(),
                                                                                      pEndDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), false)?.toString(),
                                                                                      pStoreId: _model.selectedStoreId,
                                                                                      pCompanyId: FFAppState().companyChoosen,
                                                                                    );

                                                                                    if ((_model.dateClickCardG?.succeeded ?? true)) {
                                                                                      _model.storeData = functions.managerCard((_model.dateClickCardG?.jsonBody ?? ''), _model.storeData.toList())!.toList().cast<dynamic>();
                                                                                      _model.cardsdata = getJsonField(
                                                                                        _model.storeData
                                                                                            .where((e) =>
                                                                                                functions.convertJsonToString(getJsonField(
                                                                                                  e,
                                                                                                  r'''$.store_id''',
                                                                                                )) ==
                                                                                                _model.selectedStoreId)
                                                                                            .toList()
                                                                                            .firstOrNull,
                                                                                        r'''$.cards''',
                                                                                        true,
                                                                                      )!
                                                                                          .toList()
                                                                                          .cast<dynamic>();
                                                                                      _model.tagFilter = functions.managerTagFilter((_model.dateClickCardG?.jsonBody ?? ''), _model.tagFilter.toList())!.toList().cast<dynamic>();
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      await showDialog(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('API Card Fail'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                child: Text('Ok'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  _model.selectedDate = functions.getTodayPlusMinus(selectedDate, 0);
                                                                                  safeSetState(() {});
                                                                                  if (!_model.monthFilter.contains(dateTimeFormat("yyyy-MM", _model.selectedDate?.date0))) {
                                                                                    _model.addToMonthFilter(dateTimeFormat("yyyy-MM", _model.selectedDate!.date0!));
                                                                                    safeSetState(() {});
                                                                                    FFAppState().isLoading1 = true;
                                                                                    safeSetState(() {});
                                                                                    _model.dateClickOverviewH = await ManagerShiftGroup.managershiftgetoverviewCall.call(
                                                                                      pStartDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), true)?.toString(),
                                                                                      pEndDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), false)?.toString(),
                                                                                      pStoreId: _model.selectedStoreId,
                                                                                      pCompanyId: FFAppState().companyChoosen,
                                                                                    );

                                                                                    if ((_model.dateClickOverviewH?.succeeded ?? true)) {
                                                                                      _model.montlystat = functions.overviewMonthlyStat((_model.dateClickOverviewH?.jsonBody ?? ''), _model.montlystat.toList())!.toList().cast<dynamic>();
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      await showDialog(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('Fail API Call'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                child: Text('Ok'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }

                                                                                    _model.dateClickCardH = await ManagerShiftGroup.managershiftgetcardsCall.call(
                                                                                      pStartDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0), true)?.toString(),
                                                                                      pEndDate: functions.getMonthFirstLast(dateTimeFormat("yyyy-MM-dd", selectedDate), false)?.toString(),
                                                                                      pStoreId: _model.selectedStoreId,
                                                                                      pCompanyId: FFAppState().companyChoosen,
                                                                                    );

                                                                                    if ((_model.dateClickCardH?.succeeded ?? true)) {
                                                                                      _model.storeData = functions.managerCard((_model.dateClickCardH?.jsonBody ?? ''), _model.storeData.toList())!.toList().cast<dynamic>();
                                                                                      _model.cardsdata = getJsonField(
                                                                                        _model.storeData
                                                                                            .where((e) =>
                                                                                                functions.convertJsonToString(getJsonField(
                                                                                                  e,
                                                                                                  r'''$.store_id''',
                                                                                                )) ==
                                                                                                _model.selectedStoreId)
                                                                                            .toList()
                                                                                            .firstOrNull,
                                                                                        r'''$.cards''',
                                                                                        true,
                                                                                      )!
                                                                                          .toList()
                                                                                          .cast<dynamic>();
                                                                                      _model.tagFilter = functions.managerTagFilter((_model.dateClickCardH?.jsonBody ?? ''), _model.tagFilter.toList())!.toList().cast<dynamic>();
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      await showDialog(
                                                                                        context: context,
                                                                                        builder: (alertDialogContext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('API Card Fail'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                child: Text('Ok'),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }

                                                                                FFAppState().isLoading1 = false;
                                                                                safeSetState(() {});
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            8.0,
                                                                            16.0,
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children:
                                                                          [
                                                                        Icon(
                                                                          Icons
                                                                              .calendar_month,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 4.0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        1);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverview =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverview
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverview?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCard =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCard
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCard?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCard?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                FFAppState()
                                                                        .isLoading1 =
                                                                    false;
                                                                safeSetState(
                                                                    () {});

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 36.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        -2);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverviewc =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverviewc
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverviewc?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCardc =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.datetmw2),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCardc
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCardc?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCardc?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      false;
                                                                  safeSetState(
                                                                      () {});
                                                                }

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .m2Model,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    DatetestesWidget(
                                                                  day: _model
                                                                      .selectedDate
                                                                      ?.dayM2,
                                                                  clickedDate: dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  colorTrueFalse: _model
                                                                          .cardsdata
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.request_date''',
                                                                              )) ==
                                                                              dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.dateM2))
                                                                          .toList()
                                                                          .firstOrNull !=
                                                                      null,
                                                                  date: _model
                                                                      .selectedDate
                                                                      ?.dateM2,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        -1);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverviewD =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverviewD
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverviewD?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCardD =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.datetmw),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCardD
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCardD?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCardD?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                FFAppState()
                                                                        .isLoading1 =
                                                                    false;
                                                                safeSetState(
                                                                    () {});

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .m1Model,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    DatetestesWidget(
                                                                  day: _model
                                                                      .selectedDate
                                                                      ?.dayM1,
                                                                  clickedDate: dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  colorTrueFalse: _model
                                                                          .cardsdata
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.request_date''',
                                                                              )) ==
                                                                              dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.dateM1))
                                                                          .toList()
                                                                          .firstOrNull !=
                                                                      null,
                                                                  date: _model
                                                                      .selectedDate
                                                                      ?.dateM1,
                                                                ),
                                                              ),
                                                            ),
                                                            wrapWithModel(
                                                              model: _model
                                                                  .d0Model,
                                                              updateCallback: () =>
                                                                  safeSetState(
                                                                      () {}),
                                                              child:
                                                                  DatetestesWidget(
                                                                day: _model
                                                                    .selectedDate
                                                                    ?.day0,
                                                                clickedDate: dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .selectedDate
                                                                        ?.date0),
                                                                colorTrueFalse: _model
                                                                        .cardsdata
                                                                        .where((e) =>
                                                                            functions.convertJsonToString(getJsonField(
                                                                              e,
                                                                              r'''$.request_date''',
                                                                            )) ==
                                                                            dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.date0))
                                                                        .toList()
                                                                        .firstOrNull !=
                                                                    null,
                                                                date: _model
                                                                    .selectedDate
                                                                    ?.date0,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        1);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverviewE =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.dateM1),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverviewE
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverviewE?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCardE =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCardE
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCardE?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCardE?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                FFAppState()
                                                                        .isLoading1 =
                                                                    false;
                                                                safeSetState(
                                                                    () {});

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .dp1Model,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    DatetestesWidget(
                                                                  day: _model
                                                                      .selectedDate
                                                                      ?.daytmw,
                                                                  clickedDate: dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  colorTrueFalse: _model
                                                                          .cardsdata
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.request_date''',
                                                                              )) ==
                                                                              dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.datetmw))
                                                                          .toList()
                                                                          .firstOrNull !=
                                                                      null,
                                                                  date: _model
                                                                      .selectedDate
                                                                      ?.datetmw,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.selectedDate =
                                                                    functions.getTodayPlusMinus(
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0,
                                                                        2);
                                                                safeSetState(
                                                                    () {});
                                                                if (!_model
                                                                    .monthFilter
                                                                    .contains(dateTimeFormat(
                                                                        "yyyy-MM",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0))) {
                                                                  _model.addToMonthFilter(dateTimeFormat(
                                                                      "yyyy-MM",
                                                                      _model
                                                                          .selectedDate!
                                                                          .date0!));
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                          .isLoading1 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.dateClickOverviewF =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetoverviewCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickOverviewF
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.montlystat = functions
                                                                        .overviewMonthlyStat(
                                                                            (_model.dateClickOverviewF?.jsonBody ??
                                                                                ''),
                                                                            _model.montlystat
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Fail API Call'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  _model.dateClickCardF =
                                                                      await ManagerShiftGroup
                                                                          .managershiftgetcardsCall
                                                                          .call(
                                                                    pStartDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.dateM2),
                                                                            true)
                                                                        ?.toString(),
                                                                    pEndDate: functions
                                                                        .getMonthFirstLast(
                                                                            dateTimeFormat("yyyy-MM-dd",
                                                                                _model.selectedDate?.date0),
                                                                            false)
                                                                        ?.toString(),
                                                                    pStoreId: _model
                                                                        .selectedStoreId,
                                                                    pCompanyId:
                                                                        FFAppState()
                                                                            .companyChoosen,
                                                                  );

                                                                  if ((_model
                                                                          .dateClickCardF
                                                                          ?.succeeded ??
                                                                      true)) {
                                                                    _model.storeData = functions
                                                                        .managerCard(
                                                                            (_model.dateClickCardF?.jsonBody ??
                                                                                ''),
                                                                            _model.storeData
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    _model
                                                                        .cardsdata = getJsonField(
                                                                      _model
                                                                          .storeData
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.store_id''',
                                                                              )) ==
                                                                              _model.selectedStoreId)
                                                                          .toList()
                                                                          .firstOrNull,
                                                                      r'''$.cards''',
                                                                      true,
                                                                    )!
                                                                        .toList()
                                                                        .cast<dynamic>();
                                                                    _model.tagFilter = functions
                                                                        .managerTagFilter(
                                                                            (_model.dateClickCardF?.jsonBody ??
                                                                                ''),
                                                                            _model.tagFilter
                                                                                .toList())!
                                                                        .toList()
                                                                        .cast<
                                                                            dynamic>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('API Card Fail'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                                FFAppState()
                                                                        .isLoading1 =
                                                                    false;
                                                                safeSetState(
                                                                    () {});

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .dp2Model,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    DatetestesWidget(
                                                                  day: _model
                                                                      .selectedDate
                                                                      ?.daytmw2,
                                                                  clickedDate: dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDate
                                                                          ?.date0),
                                                                  colorTrueFalse: _model
                                                                          .cardsdata
                                                                          .where((e) =>
                                                                              functions.convertJsonToString(getJsonField(
                                                                                e,
                                                                                r'''$.request_date''',
                                                                              )) ==
                                                                              dateTimeFormat("yyyy-MM-dd", _model.selectedDate?.datetmw2))
                                                                          .toList()
                                                                          .firstOrNull !=
                                                                      null,
                                                                  date: _model
                                                                      .selectedDate
                                                                      ?.datetmw2,
                                                                ),
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model.clickedTagFilter =
                                                            'all';
                                                        safeSetState(() {});
                                                      },
                                                      child: Container(
                                                        height: 32.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _model
                                                                      .clickedTagFilter ==
                                                                  'all'
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primary
                                                              : Color(
                                                                  0xFFF3F4F6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      6.0,
                                                                      12.0,
                                                                      6.0),
                                                          child: Text(
                                                            'All',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .notoSansJp(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: _model
                                                                              .clickedTagFilter ==
                                                                          'all'
                                                                      ? Colors
                                                                          .white
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Builder(
                                                        builder: (context) {
                                                          final tagFilters =
                                                              _model.tagFilter
                                                                  .toList();

                                                          return SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: List.generate(
                                                                  tagFilters
                                                                      .length,
                                                                  (tagFiltersIndex) {
                                                                final tagFiltersItem =
                                                                    tagFilters[
                                                                        tagFiltersIndex];
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    _model.clickedTagFilter =
                                                                        getJsonField(
                                                                      tagFiltersItem,
                                                                      r'''$.content''',
                                                                    ).toString();
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        32.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: _model.clickedTagFilter ==
                                                                              functions.convertJsonToString(getJsonField(
                                                                                tagFiltersItem,
                                                                                r'''$.content''',
                                                                              ))
                                                                          ? FlutterFlowTheme.of(context).primary
                                                                          : Color(0xFFF3F4F6),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          6.0,
                                                                          12.0,
                                                                          6.0),
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          getJsonField(
                                                                            tagFiltersItem,
                                                                            r'''$.content''',
                                                                          )?.toString(),
                                                                          'None',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.notoSansJp(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                              ),
                                                                              color: _model.clickedTagFilter ==
                                                                                      functions.convertJsonToString(getJsonField(
                                                                                        tagFiltersItem,
                                                                                        r'''$.content''',
                                                                                      ))
                                                                                  ? Colors.white
                                                                                  : FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).divide(
                                                                  SizedBox(
                                                                      width:
                                                                          8.0)),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 8.0)),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Shift Cards',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .notoSansJp(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    Builder(
                                                      builder: (context) {
                                                        final cards = _model
                                                            .cardsdata
                                                            .where((e) =>
                                                                (functions.convertJsonToString(
                                                                        getJsonField(
                                                                      e,
                                                                      r'''$.request_date''',
                                                                    )) ==
                                                                    dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .selectedDate
                                                                            ?.date0)) &&
                                                                (_model.clickedMonthStatus ==
                                                                        'total_approved'
                                                                    ? (functions.convertJsonToString(
                                                                            getJsonField(
                                                                          e,
                                                                          r'''$.is_approved''',
                                                                        )) ==
                                                                        'true')
                                                                    : (_model.clickedMonthStatus ==
                                                                            'total_pending'
                                                                        ? (functions.convertJsonToString(
                                                                                getJsonField(
                                                                              e,
                                                                              r'''$.is_approved''',
                                                                            )) ==
                                                                            'false')
                                                                        : (_model.clickedMonthStatus ==
                                                                                'total_problems'
                                                                            ? ((functions.convertJsonToString(
                                                                                        getJsonField(
                                                                                      e,
                                                                                      r'''$.is_problem''',
                                                                                    )) ==
                                                                                    'true') &&
                                                                                (functions.convertJsonToString(
                                                                                        getJsonField(
                                                                                      e,
                                                                                      r'''$.is_problem_solved''',
                                                                                    )) ==
                                                                                    'false'))
                                                                            : (_model.clickedMonthStatus == 'total_requests'
                                                                                ? true
                                                                                : false)))) &&
                                                                functions
                                                                    .filterCardTags(
                                                                        getJsonField(
                                                                          e,
                                                                          r'''$.notice_tag''',
                                                                          true,
                                                                        ),
                                                                        _model
                                                                            .clickedTagFilter)!)
                                                            .toList()
                                                            .sortedList(
                                                                keyOf: (e) =>
                                                                    functions
                                                                        .convertJsonToString(
                                                                            getJsonField(
                                                                      e,
                                                                      r'''$.shift_time''',
                                                                    )),
                                                                desc: false)
                                                            .toList();

                                                        return ListView
                                                            .separated(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              cards.length,
                                                          separatorBuilder: (_,
                                                                  __) =>
                                                              SizedBox(
                                                                  height: 16.0),
                                                          itemBuilder: (context,
                                                              cardsIndex) {
                                                            final cardsItem =
                                                                cards[
                                                                    cardsIndex];
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              MediaQuery.sizeOf(context).height * 0.8,
                                                                          child:
                                                                              ManagerIndiComponentWidget(
                                                                            cards:
                                                                                cardsItem,
                                                                            storeId:
                                                                                _model.selectedStoreId,
                                                                            card:
                                                                                (card) async {
                                                                              _model.removeFromCardsdata(_model.cardsdata
                                                                                  .where((e) =>
                                                                                      getJsonField(
                                                                                        e,
                                                                                        r'''$.shift_request_id''',
                                                                                      ) ==
                                                                                      getJsonField(
                                                                                        card,
                                                                                        r'''$.shift_request_id''',
                                                                                      ))
                                                                                  .toList()
                                                                                  .firstOrNull!);
                                                                              safeSetState(() {});
                                                                              _model.addToCardsdata(card!);
                                                                              safeSetState(() {});
                                                                            },
                                                                            isProblemSolvedCallBack:
                                                                                (isProblemSolvedCallBack) async {
                                                                              _model.montlystat = functions.changeTotalProblems(_model.montlystat.toList(), dateTimeFormat("yyyy-MM", _model.selectedDate?.date0), isProblemSolvedCallBack)!.toList().cast<dynamic>();
                                                                              safeSetState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      valueOrDefault<
                                                                          Color>(
                                                                    functions.convertJsonToString(getJsonField(
                                                                              cardsItem,
                                                                              r'''$.is_problem''',
                                                                            )) ==
                                                                            'true'
                                                                        ? (functions.convertJsonToString(getJsonField(
                                                                                  cardsItem,
                                                                                  r'''$.is_problem_solved''',
                                                                                )) ==
                                                                                'true'
                                                                            ? Color(0xFFF3F4F6)
                                                                            : Color(0xFFFDE68A))
                                                                        : Color(0xFFF3F4F6),
                                                                    Color(
                                                                        0xFFF3F4F6),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          16.0,
                                                                          16.0,
                                                                          16.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Container(
                                                                            width:
                                                                                40.0,
                                                                            height:
                                                                                40.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  valueOrDefault<String>(
                                                                                    functions.makeInitial(functions.convertJsonToString(getJsonField(
                                                                                      cardsItem,
                                                                                      r'''$.user_name''',
                                                                                    ))),
                                                                                    'J',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      cardsItem,
                                                                                      r'''$.user_name''',
                                                                                    )?.toString(),
                                                                                    'Name',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      cardsItem,
                                                                                      r'''$.shift_name''',
                                                                                    )?.toString(),
                                                                                    'Morning',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(height: 4.0)),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              if (functions.convertJsonToString(getJsonField(
                                                                                        cardsItem,
                                                                                        r'''$.is_problem''',
                                                                                      )) ==
                                                                                      'true'
                                                                                  ? (functions.convertJsonToString(getJsonField(
                                                                                        cardsItem,
                                                                                        r'''$.is_problem_solved''',
                                                                                      )) ==
                                                                                      'true')
                                                                                  : false)
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                  child: Container(
                                                                                    height: 24.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                      child: Text(
                                                                                        'Solved',
                                                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                              font: GoogleFonts.notoSansJp(
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              fontSize: 10.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              Container(
                                                                                height: 24.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: functions.convertJsonToString(getJsonField(
                                                                                            cardsItem,
                                                                                            r'''$.is_late''',
                                                                                          )) ==
                                                                                          'true'
                                                                                      ? Color(0xFFFEE2E2)
                                                                                      : (functions.convertJsonToString(getJsonField(
                                                                                                cardsItem,
                                                                                                r'''$.is_over_time''',
                                                                                              )) ==
                                                                                              'true'
                                                                                          ? Color(0xFFEDE9FE)
                                                                                          : (functions.convertJsonToString(getJsonField(
                                                                                                    cardsItem,
                                                                                                    r'''$.is_problem''',
                                                                                                  )) ==
                                                                                                  'true'
                                                                                              ? (functions.convertJsonToString(getJsonField(
                                                                                                        cardsItem,
                                                                                                        r'''$.is_problem_solved''',
                                                                                                      )) ==
                                                                                                      'true'
                                                                                                  ? Color(0xFFDCFCE7)
                                                                                                  : Color(0xFFFEF3C7))
                                                                                              : Color(0xFFDCFCE7))),
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      functions.convertJsonToString(getJsonField(
                                                                                                cardsItem,
                                                                                                r'''$.is_late''',
                                                                                              )) ==
                                                                                              'true'
                                                                                          ? 'Late'
                                                                                          : valueOrDefault<String>(
                                                                                              functions.convertJsonToString(getJsonField(
                                                                                                        cardsItem,
                                                                                                        r'''$.is_over_time''',
                                                                                                      )) ==
                                                                                                      'true'
                                                                                                  ? 'Overtime'
                                                                                                  : (functions.convertJsonToString(getJsonField(
                                                                                                            cardsItem,
                                                                                                            r'''$.is_problem''',
                                                                                                          )) ==
                                                                                                          'true'
                                                                                                      ? (functions.convertJsonToString(getJsonField(
                                                                                                                cardsItem,
                                                                                                                r'''$.is_problem_solved''',
                                                                                                              )) ==
                                                                                                              'true'
                                                                                                          ? 'Normal'
                                                                                                          : 'Problem')
                                                                                                      : 'Normal'),
                                                                                              'Normal',
                                                                                            ),
                                                                                      'Normal',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          font: GoogleFonts.notoSansJp(
                                                                                            fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                          ),
                                                                                          color: functions.convertJsonToString(getJsonField(
                                                                                                    cardsItem,
                                                                                                    r'''$.is_late''',
                                                                                                  )) ==
                                                                                                  'true'
                                                                                              ? Color(0xFFDC2626)
                                                                                              : (functions.convertJsonToString(getJsonField(
                                                                                                        cardsItem,
                                                                                                        r'''$.is_over_time''',
                                                                                                      )) ==
                                                                                                      'true'
                                                                                                  ? Color(0xFF7C3AED)
                                                                                                  : (functions.convertJsonToString(getJsonField(
                                                                                                            cardsItem,
                                                                                                            r'''$.is_problem''',
                                                                                                          )) ==
                                                                                                          'true'
                                                                                                      ? (functions.convertJsonToString(getJsonField(
                                                                                                                cardsItem,
                                                                                                                r'''$.is_problem_solved''',
                                                                                                              )) ==
                                                                                                              'true'
                                                                                                          ? Color(0xFF16A34A)
                                                                                                          : Color(0xFFF59E0B))
                                                                                                      : Color(0xFF16A34A))),
                                                                                          fontSize: 10.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ].divide(SizedBox(width: 12.0)),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children:
                                                                            [
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Working Time',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      font: GoogleFonts.notoSansJp(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      fontSize: 8.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  getJsonField(
                                                                                    cardsItem,
                                                                                    r'''$.shift_time''',
                                                                                  )?.toString(),
                                                                                  '00:00 ~ 00:00',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.notoSansJp(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(SizedBox(height: 4.0)),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Estimate Start Time',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      font: GoogleFonts.notoSansJp(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      fontSize: 8.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Align(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  valueOrDefault<String>(
                                                                                    getJsonField(
                                                                                      cardsItem,
                                                                                      r'''$.confirm_start_time''',
                                                                                    )?.toString(),
                                                                                    'Not Attend',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.notoSansJp(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).error,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ].divide(SizedBox(height: 4.0)),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Estimate End Time',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      font: GoogleFonts.notoSansJp(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      fontSize: 8.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  getJsonField(
                                                                                    cardsItem,
                                                                                    r'''$.confirm_end_time''',
                                                                                  )?.toString(),
                                                                                  'Not  Out',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.notoSansJp(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(SizedBox(height: 4.0)),
                                                                          ),
                                                                        ].divide(SizedBox(width: 16.0)),
                                                                      ),
                                                                      if (functions
                                                                              .convertJsonToString(getJsonField(
                                                                            cardsItem,
                                                                            r'''$.notice_tag''',
                                                                          )) !=
                                                                          '[]')
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              0.0),
                                                                          child:
                                                                              Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final tags = getJsonField(
                                                                                cardsItem,
                                                                                r'''$.notice_tag''',
                                                                              ).toList();

                                                                              return SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: List.generate(tags.length, (tagsIndex) {
                                                                                    final tagsItem = tags[tagsIndex];
                                                                                    return Container(
                                                                                      height: 28.0,
                                                                                      decoration: BoxDecoration(
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        borderRadius: BorderRadius.circular(14.0),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                                                                                        child: Text(
                                                                                          valueOrDefault<String>(
                                                                                            getJsonField(
                                                                                              tagsItem,
                                                                                              r'''$.content''',
                                                                                            )?.toString(),
                                                                                            'None',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                font: GoogleFonts.notoSansJp(
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                                ),
                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                fontSize: 10.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }).divide(SizedBox(width: 8.0)),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                    ].divide(SizedBox(
                                                                        height:
                                                                            12.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 12.0)),
                                                ),
                                              ].divide(SizedBox(height: 20.0)),
                                            ),
                                          ),
                                        ),
                                      ].addToStart(SizedBox(height: 20.0)),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.87, 0.9),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
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
                                                child: Container(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.8,
                                                  child: InsertScheduleWidget(
                                                    selectedDate: _model
                                                        .selectedDate?.date0,
                                                    storeId:
                                                        _model.selectedStoreId,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (FFAppState().isLoading1 ||
                  FFAppState().isLoading2 ||
                  FFAppState().isLoading3)
                wrapWithModel(
                  model: _model.isloadingModel,
                  updateCallback: () => safeSetState(() {}),
                  child: IsloadingWidget(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
