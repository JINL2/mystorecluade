import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/buttons/add_button/add_button_widget.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/popup/popup_widget.dart';
import '/manager/calnder_comp/calnder_comp_widget.dart';
import '/manager/force_add_shift/force_add_shift_widget.dart';
import '/manager/managershift_list/managershift_list_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'timetable_manage123_model.dart';
export 'timetable_manage123_model.dart';

class TimetableManage123Widget extends StatefulWidget {
  const TimetableManage123Widget({super.key});

  static String routeName = 'timetableManage123';
  static String routePath = '/timetableManage123123';

  @override
  State<TimetableManage123Widget> createState() =>
      _TimetableManage123WidgetState();
}

class _TimetableManage123WidgetState extends State<TimetableManage123Widget>
    with TickerProviderStateMixin {
  late TimetableManage123Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TimetableManage123Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().shiftMetaData = [];
      FFAppState().managerShiftDetail = [];
      FFAppState().isLoading1 = false;
      FFAppState().isLoading2 = false;
      FFAppState().isLoading3 = false;
      safeSetState(() {});
      _model.selectedDate = getCurrentTimestamp;
      _model.selectedStoreId = _model.storeDropDownValue;
      safeSetState(() {});
      if (FFAppState().isLoading1 == false) {
        FFAppState().isLoading1 = true;
        safeSetState(() {});
        _model.goalMeta1 = await GetshiftmetadataCall.call(
          pStoreId: _model.storeDropDownValue,
        );

        if ((_model.goalMeta1?.succeeded ?? true)) {
          _model.goalMeta1Finish =
              await actions.mergeAndRemoveDuplicatesShiftMeta(
            FFAppState().shiftMetaData.toList(),
            ((_model.goalMeta1?.jsonBody ?? '')
                    .toList()
                    .map<ShiftMetaDataStruct?>(ShiftMetaDataStruct.maybeFromMap)
                    .toList() as Iterable<ShiftMetaDataStruct?>)
                .withoutNulls
                .toList(),
          );
          FFAppState().shiftMetaData =
              _model.goalMeta1Finish!.toList().cast<ShiftMetaDataStruct>();
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

        _model.goalManager1 = await GetManagerShiftCall.call(
          pStoreId: _model.storeDropDownValue,
          pRequestDate: _model.selectedDate?.toString(),
        );

        if ((_model.goalManager1?.succeeded ?? true)) {
          _model.goalManagerFinish1 =
              await actions.mergeAndRemoveDuplicatesManagerShift(
            FFAppState().managerShiftDetail.toList(),
            ((_model.goalManager1?.jsonBody ?? '')
                    .toList()
                    .map<ManagerShiftDetailStruct?>(
                        ManagerShiftDetailStruct.maybeFromMap)
                    .toList() as Iterable<ManagerShiftDetailStruct?>)
                .withoutNulls
                .toList(),
          );
          FFAppState().managerShiftDetail = _model.goalManagerFinish1!
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

        FFAppState().isLoading1 = false;
        FFAppState().isLoading2 = false;
        FFAppState().isLoading3 = false;
        safeSetState(() {});
      } else {
        FFAppState().isLoading1 = false;
        FFAppState().isLoading2 = false;
        FFAppState().isLoading3 = false;
        safeSetState(() {});
      }

      FFAppState().isLoading1 = false;
      FFAppState().isLoading2 = false;
      FFAppState().isLoading3 = false;
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.oKSwitchValue = true;
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
                                                FlutterFlowDropDown<String>(
                                                  controller: _model
                                                          .storeDropDownValueController ??=
                                                      FormFieldController<
                                                          String>(
                                                    _model.storeDropDownValue ??=
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
                                                            .storeDropDownValue =
                                                        val);
                                                    _model.selectedStoreId =
                                                        _model
                                                            .storeDropDownValue;
                                                    safeSetState(() {});
                                                    if (FFAppState()
                                                            .isLoading2 ==
                                                        false) {
                                                      FFAppState().isLoading2 =
                                                          true;
                                                      safeSetState(() {});
                                                      if (functions
                                                          .isListHaveDatatypeList(
                                                              _model
                                                                  .storeDropDownValue,
                                                              FFAppState()
                                                                  .shiftMetaData
                                                                  .toList())!) {
                                                        FFAppState()
                                                            .isLoading2 = false;
                                                        safeSetState(() {});
                                                      } else {
                                                        _model.dreamMeta2 =
                                                            await GetshiftmetadataCall
                                                                .call(
                                                          pStoreId: _model
                                                              .storeDropDownValue,
                                                        );

                                                        if ((_model.dreamMeta2
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.dreamMeta2Complete =
                                                              await actions
                                                                  .mergeAndRemoveDuplicatesShiftMeta(
                                                            FFAppState()
                                                                .shiftMetaData
                                                                .toList(),
                                                            ((_model.dreamMeta2?.jsonBody ??
                                                                            '')
                                                                        .toList()
                                                                        .map<ShiftMetaDataStruct?>(ShiftMetaDataStruct
                                                                            .maybeFromMap)
                                                                        .toList()
                                                                    as Iterable<
                                                                        ShiftMetaDataStruct?>)
                                                                .withoutNulls
                                                                .toList(),
                                                          );
                                                          FFAppState()
                                                                  .shiftMetaData =
                                                              _model
                                                                  .dreamMeta2Complete!
                                                                  .toList()
                                                                  .cast<
                                                                      ShiftMetaDataStruct>();
                                                          safeSetState(() {});
                                                        } else {
                                                          FFAppState()
                                                                  .isLoading2 =
                                                              false;
                                                          safeSetState(() {});
                                                        }

                                                        _model.dreamManager2 =
                                                            await GetManagerShiftCall
                                                                .call(
                                                          pStoreId: _model
                                                              .storeDropDownValue,
                                                          pRequestDate: _model
                                                              .selectedDate
                                                              ?.toString(),
                                                        );

                                                        if ((_model
                                                                .dreamManager2
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.dreamManager2Complete =
                                                              await actions
                                                                  .mergeAndRemoveDuplicatesManagerShift(
                                                            FFAppState()
                                                                .managerShiftDetail
                                                                .toList(),
                                                            ((_model.dreamManager2
                                                                            ?.jsonBody ??
                                                                        '')
                                                                    .toList()
                                                                    .map<ManagerShiftDetailStruct?>(
                                                                        ManagerShiftDetailStruct
                                                                            .maybeFromMap)
                                                                    .toList() as Iterable<ManagerShiftDetailStruct?>)
                                                                .withoutNulls
                                                                .toList(),
                                                          );
                                                          FFAppState()
                                                                  .managerShiftDetail =
                                                              _model
                                                                  .dreamManager2Complete!
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

                                                        FFAppState()
                                                            .isLoading2 = false;
                                                        safeSetState(() {});
                                                      }
                                                    } else {
                                                      FFAppState().isLoading2 =
                                                          false;
                                                      safeSetState(() {});
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                  width: 200.0,
                                                  height: 40.0,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .notoSansJp(
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
                                                  hintText: 'Choose Store',
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  borderWidth: 1.0,
                                                  borderRadius: 8.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  hidesUnderline: true,
                                                  isOverButton: false,
                                                  isSearchable: false,
                                                  isMultiSelect: false,
                                                ),
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
                                                            .storeDropDownValue,
                                                        pRequestDate: _model
                                                            .selectedDate
                                                            ?.toString(),
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
                                                storeId:
                                                    _model.storeDropDownValue,
                                                onSelectDateAction:
                                                    (selectedDate) async {
                                                  _model.selectedDate =
                                                      selectedDate;
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
                                                final managerInfo = FFAppState()
                                                        .managerShiftDetail
                                                        .where((e) =>
                                                            (_model.storeDropDownValue ==
                                                                e.storeId) &&
                                                            (functions.changeDateTimeToString(
                                                                    _model
                                                                        .selectedDate) ==
                                                                e.requestDate))
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
                                                  itemCount: managerInfo.length,
                                                  itemBuilder: (context,
                                                      managerInfoIndex) {
                                                    final managerInfoItem =
                                                        managerInfo[
                                                            managerInfoIndex];
                                                    return Visibility(
                                                      visible: managerInfoItem
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
                                                                  flex: 1,
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
                                                                            managerInfoItem.shiftName,
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
                                                                  flex: 1,
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
                                                                final pendding =
                                                                    managerInfoItem
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
                                                                      pendding
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          penddingIndex) {
                                                                    final penddingItem =
                                                                        pendding[
                                                                            penddingIndex];
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
                                                                                      penddingItem.userName,
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
                                                                                value: _model.checkboxValueMap[penddingItem] ??= false,
                                                                                onChanged: (newValue) async {
                                                                                  safeSetState(() => _model.checkboxValueMap[penddingItem] = newValue!);
                                                                                  if (newValue!) {
                                                                                    _model.addToSelectedShiftRequestId(penddingItem.shiftRequestId);
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    _model.removeFromSelectedShiftRequestId(penddingItem.shiftRequestId);
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
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    1.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Filter',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.notoSansJp(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Store  ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                    FlutterFlowDropDown<String>(
                                                      controller: _model
                                                              .filterStore22ValueController ??=
                                                          FormFieldController<
                                                              String>(
                                                        _model.filterStore22Value ??=
                                                            '',
                                                      ),
                                                      options: List<
                                                              String>.from(
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
                                                              .map((e) =>
                                                                  e.storeId)
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
                                                          .map((e) =>
                                                              e.storeName)
                                                          .toList(),
                                                      onChanged: (val) async {
                                                        safeSetState(() => _model
                                                                .filterStore22Value =
                                                            val);
                                                        _model.selectedStoreId =
                                                            _model
                                                                .storeDropDownValue;
                                                        safeSetState(() {});
                                                        if (FFAppState()
                                                                .isLoading2 ==
                                                            false) {
                                                          FFAppState()
                                                                  .isLoading2 =
                                                              true;
                                                          safeSetState(() {});
                                                          if (functions.isListHaveDatatypeList(
                                                              _model
                                                                  .filterStore22Value,
                                                              FFAppState()
                                                                  .shiftMetaData
                                                                  .toList())!) {
                                                            FFAppState()
                                                                    .isLoading2 =
                                                                false;
                                                            safeSetState(() {});
                                                          } else {
                                                            _model.meta11 =
                                                                await GetshiftmetadataCall
                                                                    .call(
                                                              pStoreId: _model
                                                                  .filterStore22Value,
                                                            );

                                                            if ((_model.meta11
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model.meta12 =
                                                                  await actions
                                                                      .mergeAndRemoveDuplicatesShiftMeta(
                                                                FFAppState()
                                                                    .shiftMetaData
                                                                    .toList(),
                                                                ((_model.meta11?.jsonBody ??
                                                                            '')
                                                                        .toList()
                                                                        .map<ShiftMetaDataStruct?>(
                                                                            ShiftMetaDataStruct.maybeFromMap)
                                                                        .toList() as Iterable<ShiftMetaDataStruct?>)
                                                                    .withoutNulls
                                                                    .toList(),
                                                              );
                                                              FFAppState()
                                                                      .shiftMetaData =
                                                                  _model.meta12!
                                                                      .toList()
                                                                      .cast<
                                                                          ShiftMetaDataStruct>();
                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .isLoading2 =
                                                                  false;
                                                              safeSetState(
                                                                  () {});
                                                            }

                                                            _model.manager11 =
                                                                await GetManagerShiftCall
                                                                    .call(
                                                              pStoreId: _model
                                                                  .filterStore22Value,
                                                              pRequestDate: _model
                                                                  .selectedDate
                                                                  ?.toString(),
                                                            );

                                                            if ((_model
                                                                    .manager11
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model.manager12 =
                                                                  await actions
                                                                      .mergeAndRemoveDuplicatesManagerShift(
                                                                FFAppState()
                                                                    .managerShiftDetail
                                                                    .toList(),
                                                                ((_model.manager11?.jsonBody ??
                                                                            '')
                                                                        .toList()
                                                                        .map<ManagerShiftDetailStruct?>(
                                                                            ManagerShiftDetailStruct.maybeFromMap)
                                                                        .toList() as Iterable<ManagerShiftDetailStruct?>)
                                                                    .withoutNulls
                                                                    .toList(),
                                                              );
                                                              FFAppState()
                                                                      .managerShiftDetail =
                                                                  _model
                                                                      .manager12!
                                                                      .toList()
                                                                      .cast<
                                                                          ManagerShiftDetailStruct>();
                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .isLoading2 =
                                                                  false;
                                                              safeSetState(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                    .isLoading2 =
                                                                false;
                                                            safeSetState(() {});
                                                          }
                                                        } else {
                                                          FFAppState()
                                                                  .isLoading2 =
                                                              false;
                                                          safeSetState(() {});
                                                        }

                                                        safeSetState(() {});
                                                      },
                                                      width: 120.0,
                                                      height: 30.0,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                      hintText: 'Select',
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBackground,
                                                      elevation: 2.0,
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      borderWidth: 0.0,
                                                      borderRadius: 8.0,
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      hidesUnderline: true,
                                                      isOverButton: false,
                                                      isSearchable: false,
                                                      isMultiSelect: false,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        if (_model
                                                                .oKSwitchValue ==
                                                            true)
                                                          Text(
                                                            'Not Filled',
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
                                                        if (_model
                                                                .oKSwitchValue ==
                                                            false)
                                                          Text(
                                                            'Filled',
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
                                                      ],
                                                    ),
                                                    Switch.adaptive(
                                                      value:
                                                          _model.oKSwitchValue!,
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                .oKSwitchValue =
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
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                              child: Container(
                                                width: 100.0,
                                                decoration: BoxDecoration(),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child: PopupWidget(
                                                              popupTitle:
                                                                  'Add Shift',
                                                              widgetBuilder: () =>
                                                                  ForceAddShiftWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  child: wrapWithModel(
                                                    model:
                                                        _model.addButtonModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: AddButtonWidget(
                                                      textParameter:
                                                          '+Add Shift',
                                                      colorParameter:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              wrapWithModel(
                                                model: _model
                                                    .managershiftListModel,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: ManagershiftListWidget(
                                                  storeId:
                                                      _model.filterStore22Value,
                                                  okswitch:
                                                      _model.oKSwitchValue,
                                                ),
                                              ),
                                            ]
                                                .divide(SizedBox(height: 24.0))
                                                .addToStart(
                                                    SizedBox(height: 12.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].addToStart(SizedBox(height: 20.0)),
                                ),
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
