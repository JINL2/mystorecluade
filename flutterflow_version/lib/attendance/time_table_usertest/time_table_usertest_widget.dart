import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import '/time_table/register_cal_comp/register_cal_comp_widget.dart';
import '/time_table/shift_test/shift_test_widget.dart';
import '/time_table/table_schdule/table_schdule_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'time_table_usertest_model.dart';
export 'time_table_usertest_model.dart';

class TimeTableUsertestWidget extends StatefulWidget {
  const TimeTableUsertestWidget({super.key});

  static String routeName = 'timeTableUsertest';
  static String routePath = '/timeTableUsertest';

  @override
  State<TimeTableUsertestWidget> createState() =>
      _TimeTableUsertestWidgetState();
}

class _TimeTableUsertestWidgetState extends State<TimeTableUsertestWidget>
    with TickerProviderStateMixin {
  late TimeTableUsertestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TimeTableUsertestModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedDatePageState = getCurrentTimestamp;
      safeSetState(() {});
      FFAppState().shiftMetaData = [];
      safeSetState(() {});
      FFAppState().isLoading1 = false;
      FFAppState().isLoading2 = false;
      FFAppState().isLoading3 = false;
      safeSetState(() {});
      if (FFAppState().isLoading1 == false) {
        FFAppState().isLoading1 = true;
        safeSetState(() {});
        _model.newshiftMetadata = await GetshiftmetadataCall.call(
          pStoreId: _model.dropDownStoreValue,
        );

        if ((_model.newshiftMetadata?.succeeded ?? true)) {
          _model.newMetadata2 = await actions.mergeAndRemoveDuplicatesShiftMeta(
            FFAppState().shiftMetaData.toList(),
            ((_model.newshiftMetadata?.jsonBody ?? '')
                    .toList()
                    .map<ShiftMetaDataStruct?>(ShiftMetaDataStruct.maybeFromMap)
                    .toList() as Iterable<ShiftMetaDataStruct?>)
                .withoutNulls
                .toList(),
          );
          FFAppState().shiftMetaData =
              _model.newMetadata2!.toList().cast<ShiftMetaDataStruct>();
          safeSetState(() {});
        } else {
          FFAppState().isLoading1 = false;
          safeSetState(() {});
        }

        _model.newshiftstatus = await GetUserShiftStatusCall.call(
          pUserId: FFAppState().user.userId,
          pStoreId: _model.dropDownStoreValue,
          pRequestDate: _model.selectedDatePageState?.toString(),
        );

        if ((_model.newshiftstatus?.succeeded ?? true)) {
          if (_model.newshiftstatus != null) {
            _model.newShiftData2 =
                await actions.mergeAndRemoveDuplicatesShiftStatus(
              FFAppState().shiftStatus.toList(),
              ((_model.newshiftstatus?.jsonBody ?? '')
                      .toList()
                      .map<ShiftStatusStruct?>(ShiftStatusStruct.maybeFromMap)
                      .toList() as Iterable<ShiftStatusStruct?>)
                  .withoutNulls
                  .toList(),
            );
            FFAppState().shiftStatus =
                _model.newShiftData2!.toList().cast<ShiftStatusStruct>();
            safeSetState(() {});
            FFAppState().isLoading1 = false;
            safeSetState(() {});
          } else {
            FFAppState().isLoading1 = false;
            safeSetState(() {});
          }

          FFAppState().isLoading1 = false;
          safeSetState(() {});
        } else {
          FFAppState().isLoading1 = false;
          safeSetState(() {});
        }

        FFAppState().isLoading1 = false;
        safeSetState(() {});
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

    _model.switchValue = true;
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
                      menuName: 'Schedule',
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 1.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment(0.0, 0),
                                child: TabBar(
                                  labelColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  unselectedLabelColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.notoSansJp(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  unselectedLabelStyle:
                                      FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                  indicatorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  tabs: [
                                    Tab(
                                      text: 'Register',
                                    ),
                                    Tab(
                                      text: 'My Schedule',
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
                                    Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        primary: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropDownStoreValueController ??=
                                                  FormFieldController<String>(
                                                _model.dropDownStoreValue ??=
                                                    FFAppState()
                                                        .user
                                                        .companies
                                                        .where((e) =>
                                                            FFAppState()
                                                                .companyChoosen ==
                                                            e.companyId)
                                                        .toList()
                                                        .firstOrNull
                                                        ?.stores
                                                        .firstOrNull
                                                        ?.storeId,
                                              ),
                                              options: List<String>.from(
                                                  FFAppState()
                                                      .user
                                                      .companies
                                                      .where((e) =>
                                                          FFAppState()
                                                              .companyChoosen ==
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
                                                      FFAppState()
                                                          .companyChoosen ==
                                                      e.companyId)
                                                  .toList()
                                                  .firstOrNull!
                                                  .stores
                                                  .map((e) => e.storeName)
                                                  .toList(),
                                              onChanged: (val) async {
                                                safeSetState(() => _model
                                                    .dropDownStoreValue = val);
                                                if (FFAppState().isLoading3 ==
                                                    false) {
                                                  FFAppState().isLoading3 =
                                                      true;
                                                  safeSetState(() {});
                                                  _model.shiftId = null;
                                                  safeSetState(() {});
                                                  if (functions
                                                      .isListHaveDatatypeList(
                                                          _model
                                                              .dropDownStoreValue,
                                                          FFAppState()
                                                              .shiftMetaData
                                                              .toList())!) {
                                                    FFAppState().isLoading3 =
                                                        false;
                                                    safeSetState(() {});
                                                  } else {
                                                    _model.dream1 =
                                                        await GetshiftmetadataCall
                                                            .call(
                                                      pStoreId: _model
                                                          .dropDownStoreValue,
                                                    );

                                                    if ((_model.dream1
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.dream1Complete =
                                                          await actions
                                                              .mergeAndRemoveDuplicatesShiftMeta(
                                                        FFAppState()
                                                            .shiftMetaData
                                                            .toList(),
                                                        ((_model.dream1?.jsonBody ??
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
                                                      FFAppState()
                                                              .shiftMetaData =
                                                          _model.dream1Complete!
                                                              .toList()
                                                              .cast<
                                                                  ShiftMetaDataStruct>();
                                                      safeSetState(() {});
                                                    }
                                                    _model.dream2 =
                                                        await GetUserShiftStatusCall
                                                            .call(
                                                      pUserId: FFAppState()
                                                          .user
                                                          .userId,
                                                      pStoreId: _model
                                                          .dropDownStoreValue,
                                                      pRequestDate: _model
                                                          .selectedDatePageState
                                                          ?.toString(),
                                                    );

                                                    if ((_model.dream2
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.dream2complete =
                                                          await actions
                                                              .mergeAndRemoveDuplicatesShiftStatus(
                                                        FFAppState()
                                                            .shiftStatus
                                                            .toList(),
                                                        ((_model.dream2?.jsonBody ??
                                                                        '')
                                                                    .toList()
                                                                    .map<ShiftStatusStruct?>(
                                                                        ShiftStatusStruct
                                                                            .maybeFromMap)
                                                                    .toList()
                                                                as Iterable<
                                                                    ShiftStatusStruct?>)
                                                            .withoutNulls
                                                            .toList(),
                                                      );
                                                      FFAppState().shiftStatus =
                                                          _model.dream2complete!
                                                              .toList()
                                                              .cast<
                                                                  ShiftStatusStruct>();
                                                      safeSetState(() {});
                                                    }
                                                    FFAppState().isLoading3 =
                                                        false;
                                                    safeSetState(() {});
                                                  }
                                                } else {
                                                  FFAppState().isLoading3 =
                                                      false;
                                                  safeSetState(() {});
                                                }

                                                safeSetState(() {});
                                              },
                                              width: 200.0,
                                              height: 50.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.notoSansJp(
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
                                              hintText: 'Choose the store',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              elevation: 2.0,
                                              borderColor: Colors.black,
                                              borderWidth: 0.0,
                                              borderRadius: 12.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        24.0, 0.0, 24.0, 20.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    wrapWithModel(
                                                      model: _model
                                                          .registerCalCompModel,
                                                      updateCallback: () =>
                                                          safeSetState(() {}),
                                                      child:
                                                          RegisterCalCompWidget(
                                                        inputDateComPara:
                                                            getCurrentTimestamp,
                                                        initialSelectedDate:
                                                            getCurrentTimestamp,
                                                        onSelectDateAction:
                                                            (selectedDate) async {
                                                          _model.selectedDatePageState =
                                                              selectedDate;
                                                          _model.shiftId = null;
                                                          safeSetState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 24.0)),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  12.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            flex: 5,
                                                            child: Text(
                                                              'Shift',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .notoSansJp(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 5,
                                                            child: Text(
                                                              'Time',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .notoSansJp(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (_model
                                                            .selectedDatePageState !=
                                                        null)
                                                      Builder(
                                                        builder: (context) {
                                                          final shiftDetail =
                                                              FFAppState()
                                                                  .shiftMetaData
                                                                  .where((e) =>
                                                                      _model
                                                                          .dropDownStoreValue ==
                                                                      e.storeId)
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
                                                                shiftDetail
                                                                    .length,
                                                            separatorBuilder: (_,
                                                                    __) =>
                                                                SizedBox(
                                                                    height:
                                                                        12.0),
                                                            itemBuilder: (context,
                                                                shiftDetailIndex) {
                                                              final shiftDetailItem =
                                                                  shiftDetail[
                                                                      shiftDetailIndex];
                                                              return AnimatedOpacity(
                                                                opacity: _model
                                                                            .shiftId ==
                                                                        shiftDetailItem
                                                                            .shiftId
                                                                    ? 1.0
                                                                    : 0.1,
                                                                duration:
                                                                    300.0.ms,
                                                                curve: Curves
                                                                    .easeInOut,
                                                                child: InkWell(
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
                                                                    _model.shiftId =
                                                                        shiftDetailItem
                                                                            .shiftId;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      wrapWithModel(
                                                                    model: _model
                                                                        .shiftTestModels
                                                                        .getModel(
                                                                      shiftDetailItem
                                                                          .shiftId,
                                                                      shiftDetailIndex,
                                                                    ),
                                                                    updateCallback: () =>
                                                                        safeSetState(
                                                                            () {}),
                                                                    child:
                                                                        ShiftTestWidget(
                                                                      key: Key(
                                                                        'Keyiy4_${shiftDetailItem.shiftId}',
                                                                      ),
                                                                      shiftName:
                                                                          shiftDetailItem
                                                                              .shiftName,
                                                                      startTime:
                                                                          shiftDetailItem
                                                                              .startTime,
                                                                      endTime:
                                                                          shiftDetailItem
                                                                              .endTime,
                                                                      shiftId:
                                                                          shiftDetailItem
                                                                              .shiftId,
                                                                      selectedDate: dateTimeFormat(
                                                                          "yyyy-MM-dd",
                                                                          _model
                                                                              .selectedDatePageState),
                                                                      requestDate:
                                                                          _model
                                                                              .selectedDatePageState!,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (_model.shiftId != null &&
                                                    _model.shiftId != '') {
                                                  if (FFAppState().isLoading2 ==
                                                      false) {
                                                    FFAppState().isLoading2 =
                                                        true;
                                                    safeSetState(() {});
                                                    if (FFAppState()
                                                            .shiftStatus
                                                            .where((e) =>
                                                                (_model.shiftId ==
                                                                    e
                                                                        .shiftId) &&
                                                                (e.requestDate ==
                                                                    dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .selectedDatePageState)))
                                                            .toList()
                                                            .firstOrNull !=
                                                        null) {
                                                      if (FFAppState()
                                                          .shiftStatus
                                                          .where((e) =>
                                                              (_model.shiftId ==
                                                                  e.shiftId) &&
                                                              (e.requestDate ==
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDatePageState)))
                                                          .toList()
                                                          .firstOrNull!
                                                          .isApproved) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Already Approved'),
                                                              content: Text(
                                                                  'Ask To Manager'),
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
                                                      } else {
                                                        _model.deleteResult =
                                                            await ShiftRequestsTable()
                                                                .delete(
                                                          matchingRows:
                                                              (rows) =>
                                                                  rows.eqOrNull(
                                                            'shift_request_id',
                                                            FFAppState()
                                                                .shiftStatus
                                                                .where((e) =>
                                                                    (_model.shiftId ==
                                                                        e
                                                                            .shiftId) &&
                                                                    (e.requestDate ==
                                                                        dateTimeFormat(
                                                                            "yyyy-MM-dd",
                                                                            _model.selectedDatePageState)))
                                                                .toList()
                                                                .firstOrNull
                                                                ?.shiftRequestId,
                                                          ),
                                                          returnRows: true,
                                                        );
                                                        FFAppState().shiftStatus = functions
                                                            .removeFromList(
                                                                FFAppState()
                                                                    .shiftStatus
                                                                    .map((e) => e
                                                                        .toMap())
                                                                    .toList(),
                                                                _model
                                                                    .deleteResult
                                                                    ?.firstOrNull
                                                                    ?.shiftRequestId,
                                                                'shift_request_id')!
                                                            .map((e) =>
                                                                ShiftStatusStruct
                                                                    .maybeFromMap(
                                                                        e))
                                                            .withoutNulls
                                                            .toList()
                                                            .cast<
                                                                ShiftStatusStruct>();
                                                        safeSetState(() {});
                                                      }

                                                      FFAppState().isLoading2 =
                                                          false;
                                                      safeSetState(() {});
                                                    } else {
                                                      _model.insertShift =
                                                          await ShiftRequestsTable()
                                                              .insert({
                                                        'user_id': FFAppState()
                                                            .user
                                                            .userId,
                                                        'shift_id':
                                                            _model.shiftId,
                                                        'store_id': _model
                                                            .dropDownStoreValue,
                                                        'request_date':
                                                            supaSerialize<
                                                                    DateTime>(
                                                                _model
                                                                    .selectedDatePageState),
                                                        'is_approved': false,
                                                        'start_time': supaSerialize<
                                                                DateTime>(
                                                            functions.changeStringToDateTime(
                                                                FFAppState()
                                                                    .shiftMetaData
                                                                    .where((e) =>
                                                                        _model
                                                                            .shiftId ==
                                                                        e.shiftId)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.startTime)),
                                                        'end_time': supaSerialize<
                                                                DateTime>(
                                                            functions.changeStringToDateTime(
                                                                FFAppState()
                                                                    .shiftMetaData
                                                                    .where((e) =>
                                                                        _model
                                                                            .shiftId ==
                                                                        e.shiftId)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.endTime)),
                                                      });
                                                      FFAppState()
                                                          .addToShiftStatus(
                                                              ShiftStatusStruct(
                                                        shiftId: _model
                                                            .insertShift
                                                            ?.shiftId,
                                                        requestDate:
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .insertShift
                                                                    ?.requestDate),
                                                        totalRegistered: 1,
                                                        isRegisteredByMe: true,
                                                        shiftRequestId: _model
                                                            .insertShift
                                                            ?.shiftRequestId,
                                                        isApproved: false,
                                                        storeId: _model
                                                            .insertShift
                                                            ?.storeId,
                                                      ));
                                                      safeSetState(() {});
                                                    }

                                                    FFAppState().isLoading2 =
                                                        false;
                                                    safeSetState(() {});
                                                  }
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail'),
                                                        content: Text(
                                                            'Choose Shift'),
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

                                                safeSetState(() {});
                                              },
                                              child: wrapWithModel(
                                                model: _model.addModel,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: AddWidget(
                                                  name: FFAppState()
                                                          .shiftStatus
                                                          .where((e) =>
                                                              (_model.shiftId ==
                                                                  e.shiftId) &&
                                                              (e.requestDate ==
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDatePageState)))
                                                          .toList()
                                                          .isNotEmpty
                                                      ? 'Cancel'
                                                      : 'Register',
                                                  color: FFAppState()
                                                          .shiftStatus
                                                          .where((e) =>
                                                              (_model.shiftId ==
                                                                  e.shiftId) &&
                                                              (e.requestDate ==
                                                                  dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .selectedDatePageState)))
                                                          .toList()
                                                          .isNotEmpty
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  height: 45,
                                                ),
                                              ),
                                            ),
                                          ]
                                              .divide(SizedBox(height: 24.0))
                                              .addToStart(
                                                  SizedBox(height: 16.0)),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: FFAppState()
                                              .shiftStatus
                                              .firstOrNull !=
                                          null,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            1.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 4.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Filter',
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
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Store  ',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .notoSansJp(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            FlutterFlowDropDown<
                                                                String>(
                                                              controller: _model
                                                                      .filterStoreValueController ??=
                                                                  FormFieldController<
                                                                      String>(
                                                                _model.filterStoreValue ??=
                                                                    '',
                                                              ),
                                                              options: List<String>.from(FFAppState()
                                                                  .user
                                                                  .companies
                                                                  .where((e) =>
                                                                      FFAppState()
                                                                          .companyChoosen ==
                                                                      e
                                                                          .companyId)
                                                                  .toList()
                                                                  .firstOrNull!
                                                                  .stores
                                                                  .map((e) =>
                                                                      e.storeId)
                                                                  .toList()),
                                                              optionLabels: FFAppState()
                                                                  .user
                                                                  .companies
                                                                  .where((e) =>
                                                                      FFAppState()
                                                                          .companyChoosen ==
                                                                      e
                                                                          .companyId)
                                                                  .toList()
                                                                  .firstOrNull!
                                                                  .stores
                                                                  .map((e) => e
                                                                      .storeName)
                                                                  .toList(),
                                                              onChanged:
                                                                  (val) async {
                                                                safeSetState(() =>
                                                                    _model.filterStoreValue =
                                                                        val);
                                                                if (FFAppState()
                                                                        .isLoading3 ==
                                                                    false) {
                                                                  FFAppState()
                                                                          .isLoading3 =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.shiftId =
                                                                      null;
                                                                  safeSetState(
                                                                      () {});
                                                                  if (functions.isListHaveDatatypeList(
                                                                      _model
                                                                          .filterStoreValue,
                                                                      FFAppState()
                                                                          .shiftMetaData
                                                                          .toList())!) {
                                                                    FFAppState()
                                                                            .isLoading3 =
                                                                        false;
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    _model.meta11 =
                                                                        await GetshiftmetadataCall
                                                                            .call(
                                                                      pStoreId:
                                                                          _model
                                                                              .filterStoreValue,
                                                                    );

                                                                    if ((_model
                                                                            .meta11
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      _model.meta12 =
                                                                          await actions
                                                                              .mergeAndRemoveDuplicatesShiftMeta(
                                                                        FFAppState()
                                                                            .shiftMetaData
                                                                            .toList(),
                                                                        ((_model.meta11?.jsonBody ?? '').toList().map<ShiftMetaDataStruct?>(ShiftMetaDataStruct.maybeFromMap).toList()
                                                                                as Iterable<ShiftMetaDataStruct?>)
                                                                            .withoutNulls
                                                                            .toList(),
                                                                      );
                                                                      FFAppState().shiftMetaData = _model
                                                                          .meta12!
                                                                          .toList()
                                                                          .cast<
                                                                              ShiftMetaDataStruct>();
                                                                      safeSetState(
                                                                          () {});
                                                                    }
                                                                    _model.userShift11 =
                                                                        await GetUserShiftStatusCall
                                                                            .call(
                                                                      pUserId: FFAppState()
                                                                          .user
                                                                          .userId,
                                                                      pStoreId:
                                                                          _model
                                                                              .filterStoreValue,
                                                                      pRequestDate: _model
                                                                          .selectedDatePageState
                                                                          ?.toString(),
                                                                    );

                                                                    if ((_model
                                                                            .userShift11
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      _model.userShift12 =
                                                                          await actions
                                                                              .mergeAndRemoveDuplicatesShiftStatus(
                                                                        FFAppState()
                                                                            .shiftStatus
                                                                            .toList(),
                                                                        ((_model.userShift11?.jsonBody ?? '').toList().map<ShiftStatusStruct?>(ShiftStatusStruct.maybeFromMap).toList()
                                                                                as Iterable<ShiftStatusStruct?>)
                                                                            .withoutNulls
                                                                            .toList(),
                                                                      );
                                                                      FFAppState().shiftStatus = _model
                                                                          .userShift12!
                                                                          .toList()
                                                                          .cast<
                                                                              ShiftStatusStruct>();
                                                                      safeSetState(
                                                                          () {});
                                                                    }
                                                                    FFAppState()
                                                                            .isLoading3 =
                                                                        false;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                } else {
                                                                  FFAppState()
                                                                          .isLoading3 =
                                                                      false;
                                                                  safeSetState(
                                                                      () {});
                                                                }

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              width: 150.0,
                                                              height: 30.0,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .notoSansJp(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                              hintText:
                                                                  'Select...',
                                                              icon: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 24.0,
                                                              ),
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              elevation: 2.0,
                                                              borderColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              borderWidth: 1.0,
                                                              borderRadius: 8.0,
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              hidesUnderline:
                                                                  true,
                                                              isOverButton:
                                                                  false,
                                                              isSearchable:
                                                                  false,
                                                              isMultiSelect:
                                                                  false,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Approval ',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .notoSansJp(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            Switch.adaptive(
                                                              value: _model
                                                                  .switchValue!,
                                                              onChanged:
                                                                  (newValue) async {
                                                                safeSetState(() =>
                                                                    _model.switchValue =
                                                                        newValue);
                                                              },
                                                              activeColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              activeTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              inactiveTrackColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                              inactiveThumbColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                ),
                                                child: SingleChildScrollView(
                                                  primary: false,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      wrapWithModel(
                                                        model: _model
                                                            .tableSchduleModel,
                                                        updateCallback: () =>
                                                            safeSetState(() {}),
                                                        child:
                                                            TableSchduleWidget(
                                                          filteredStore: _model
                                                              .filterStoreValue!,
                                                          fileredApproval:
                                                              _model
                                                                  .switchValue!,
                                                        ),
                                                      ),
                                                    ]
                                                        .divide(SizedBox(
                                                            height: 24.0))
                                                        .addToStart(SizedBox(
                                                            height: 12.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                              .addToStart(
                                                  SizedBox(height: 32.0))
                                              .addToEnd(SizedBox(height: 32.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          ),
        ),
      ),
    );
  }
}
