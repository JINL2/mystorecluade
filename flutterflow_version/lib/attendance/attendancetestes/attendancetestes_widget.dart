import '/attendance/calander_datatestse/calander_datatestse_widget.dart';
import '/attendance/datetestes/datetestes_widget.dart';
import '/attendance/user_timetable_scheduletestes/user_timetable_scheduletestes_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/common/calender_bottom_sheet/calender_bottom_sheet_widget.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'attendancetestes_model.dart';
export 'attendancetestes_model.dart';

class AttendancetestesWidget extends StatefulWidget {
  const AttendancetestesWidget({super.key});

  static String routeName = 'attendancetestes';
  static String routePath = '/attendancetestes';

  @override
  State<AttendancetestesWidget> createState() => _AttendancetestesWidgetState();
}

class _AttendancetestesWidgetState extends State<AttendancetestesWidget> {
  late AttendancetestesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AttendancetestesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isLoading1 = true;
      FFAppState().shiftStatus = [];
      FFAppState().shiftMetaData = [];
      safeSetState(() {});
      _model.clickedDate = functions.getTodayPlusMinus(getCurrentTimestamp, 0);
      safeSetState(() {});
      _model.oPLCurrencyType = await CurrencyTypesTable().queryRows(
        queryFn: (q) => q,
      );
      _model.oPLOverView =
          await UserShiftGroup.usershiftmonthlysummaryCall.call(
        pUserId: FFAppState().user.userId,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0),
        pStoreId: FFAppState().storeChoosen,
        pCompanyId: FFAppState().companyChoosen,
      );

      if ((_model.oPLOverView?.succeeded ?? true)) {
        _model.addToOverView((_model.oPLOverView?.jsonBody ?? ''));
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('API Overview Fail'),
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

      _model.oPLgetusersalaryindividual =
          await GetusersalaryindividualCall.call(
        pUserId: FFAppState().user.userId,
        pStoreId: FFAppState().storeChoosen,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp),
      );

      if ((_model.oPLgetusersalaryindividual?.succeeded ?? true)) {
        _model.vsalaryIndividual =
            ((_model.oPLgetusersalaryindividual?.jsonBody ?? '')
                    .toList()
                    .map<VSalaryIndividualStruct?>(
                        VSalaryIndividualStruct.maybeFromMap)
                    .toList() as Iterable<VSalaryIndividualStruct?>)
                .withoutNulls
                .toList()
                .cast<VSalaryIndividualStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('API fail get user salary individual'),
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

      _model.oPLShiftRequestMonthly = await GetshiftrequestmonthlyCall.call(
        pUserId: FFAppState().user.userId,
        pStoreId: FFAppState().storeChoosen,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp),
      );

      if ((_model.oPLShiftRequestMonthly?.succeeded ?? true)) {
        _model.vshiftRequestMonth =
            ((_model.oPLShiftRequestMonthly?.jsonBody ?? '')
                    .toList()
                    .map<VShiftRequestMonthStruct?>(
                        VShiftRequestMonthStruct.maybeFromMap)
                    .toList() as Iterable<VShiftRequestMonthStruct?>)
                .withoutNulls
                .toList()
                .cast<VShiftRequestMonthStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail Monthly Request'),
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

      _model.oPLshiftMetaData = await GetshiftmetadataCall.call(
        pStoreId: FFAppState().storeChoosen,
      );

      if ((_model.oPLshiftMetaData?.succeeded ?? true)) {
        FFAppState().shiftMetaData = ((_model.oPLshiftMetaData?.jsonBody ?? '')
                .toList()
                .map<ShiftMetaDataStruct?>(ShiftMetaDataStruct.maybeFromMap)
                .toList() as Iterable<ShiftMetaDataStruct?>)
            .withoutNulls
            .toList()
            .cast<ShiftMetaDataStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail Meta Data'),
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

      _model.oPLUserShiftStatus = await GetUserShiftStatusCall.call(
        pUserId: FFAppState().user.userId,
        pStoreId: FFAppState().storeChoosen,
        pRequestDate: getCurrentTimestamp.toString(),
      );

      if ((_model.oPLUserShiftStatus?.succeeded ?? true)) {
        FFAppState().shiftStatus = ((_model.oPLUserShiftStatus?.jsonBody ?? '')
                .toList()
                .map<ShiftStatusStruct?>(ShiftStatusStruct.maybeFromMap)
                .toList() as Iterable<ShiftStatusStruct?>)
            .withoutNulls
            .toList()
            .cast<ShiftStatusStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail Shift Status'),
              content:
                  Text((_model.oPLUserShiftStatus?.jsonBody ?? '').toString()),
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

      _model.oPLGetUserShiftQuantity = await GetUserShiftQuantityCall.call(
        pUserId: FFAppState().user.userId,
        pStoreId: FFAppState().storeChoosen,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp),
      );

      if ((_model.oPLGetUserShiftQuantity?.succeeded ?? true)) {
        _model.userShiftQuantity =
            ((_model.oPLGetUserShiftQuantity?.jsonBody ?? '')
                    .toList()
                    .map<UserShiftQuantityStruct?>(
                        UserShiftQuantityStruct.maybeFromMap)
                    .toList() as Iterable<UserShiftQuantityStruct?>)
                .withoutNulls
                .toList()
                .cast<UserShiftQuantityStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail Quantity API'),
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

      FFAppState().isLoading1 = false;
      safeSetState(() {});
    });

    _model.filteredApproveValue = true;
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
        backgroundColor: Color(0xFFF9FAFB),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    wrapWithModel(
                      model: _model.menuBarModel,
                      updateCallback: () => safeSetState(() {}),
                      child: MenuBarWidget(
                        menuName: 'My Schedule',
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(
                                        0.0,
                                        4.0,
                                      ),
                                    )
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF3B82F6),
                                      Color(0xFF2563EB)
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(1.0, 1.0),
                                    end: AlignmentDirectional(-1.0, -1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: Text(
                                          'This Month Working Stat',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.notoSansJp(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xCCFFFFFF),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    _model.overView
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.approved_shift_count''',
                                                  )?.toString(),
                                                  '0',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displayMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .notoSansJp(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 36.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displayMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Text(
                                                'Work Day',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .notoSansJp(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xCCFFFFFF),
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 1.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x4DFFFFFF),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    _model.overView
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.total_paid_hours''',
                                                  )?.toString(),
                                                  '0',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displayMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .notoSansJp(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 36.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displayMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Text(
                                                'Work Hour',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .notoSansJp(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xCCFFFFFF),
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(width: 20.0)),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 20.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    getJsonField(
                                                      _model.overView
                                                          .where((e) =>
                                                              functions
                                                                  .convertJsonToString(
                                                                      getJsonField(
                                                                e,
                                                                r'''$.month''',
                                                              )) ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0))
                                                          .toList()
                                                          .firstOrNull,
                                                      r'''$.total_payment''',
                                                    )?.toString(),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .notoSansJp(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    _model.oPLCurrencyType
                                                        ?.where((e) =>
                                                            e.currencyId ==
                                                            getJsonField(
                                                              _model.overView
                                                                  .where((e) =>
                                                                      functions
                                                                          .convertJsonToString(
                                                                              getJsonField(
                                                                        e,
                                                                        r'''$.month''',
                                                                      )) ==
                                                                      dateTimeFormat(
                                                                          "yyyy-MM",
                                                                          _model
                                                                              .clickedDate
                                                                              ?.date0))
                                                                  .toList()
                                                                  .firstOrNull,
                                                              r'''$.currency_id''',
                                                            ).toString())
                                                        .toList()
                                                        .firstOrNull
                                                        ?.currencyCode,
                                                    'VND',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .notoSansJp(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Text(
                                                'Salary',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts
                                                          .notoSansJp(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xCCFFFFFF),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(
                                        0.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
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
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.8,
                                                      child:
                                                          CalenderBottomSheetWidget(
                                                        inputDateComPara: _model
                                                            .clickedDate?.date0,
                                                        initialSelectedDate:
                                                            _model.clickedDate
                                                                ?.date0,
                                                        onSelectDateAction:
                                                            (selectedDate) async {
                                                          _model.clickedDate =
                                                              functions
                                                                  .getTodayPlusMinus(
                                                                      selectedDate,
                                                                      0);
                                                          safeSetState(() {});
                                                          if (!functions.booldateinjson(
                                                              _model.overView
                                                                  .toList(),
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0))!) {
                                                            FFAppState()
                                                                    .isLoading2 =
                                                                true;
                                                            safeSetState(() {});
                                                            _model.clickDate =
                                                                await UserShiftGroup
                                                                    .usershiftmonthlysummaryCall
                                                                    .call(
                                                              pUserId:
                                                                  FFAppState()
                                                                      .user
                                                                      .userId,
                                                              pStoreId: FFAppState()
                                                                  .storeChoosen,
                                                              pRequestDate: dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0),
                                                              pCompanyId:
                                                                  FFAppState()
                                                                      .companyChoosen,
                                                            );

                                                            if ((_model
                                                                    .clickDate
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model.addToOverView((_model
                                                                      .clickDate
                                                                      ?.jsonBody ??
                                                                  ''));
                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Fail API'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }

                                                            FFAppState()
                                                                    .isLoading2 =
                                                                false;
                                                            safeSetState(() {});
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));

                                            safeSetState(() {});
                                          },
                                          child: Container(
                                            width: 136.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Choose Date',
                                                    style: FlutterFlowTheme.of(
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
                                                          color:
                                                              Color(0xFFA0A7B4),
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
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Color(0xFFA0A7B4),
                                                    size: 16.0,
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 12.0, 24.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.clickedDate =
                                                    functions.getTodayPlusMinus(
                                                        _model
                                                            .clickedDate?.date0,
                                                        -1);
                                                safeSetState(() {});
                                                if (!functions.booldateinjson(
                                                    _model.overView.toList(),
                                                    dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        _model.clickedDate
                                                            ?.date0))!) {
                                                  FFAppState().isLoading2 =
                                                      true;
                                                  safeSetState(() {});
                                                  _model.dateBack =
                                                      await UserShiftGroup
                                                          .usershiftmonthlysummaryCall
                                                          .call(
                                                    pUserId: FFAppState()
                                                        .user
                                                        .userId,
                                                    pStoreId: FFAppState()
                                                        .storeChoosen,
                                                    pRequestDate:
                                                        dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.clickedDate
                                                                ?.date0),
                                                    pCompanyId: FFAppState()
                                                        .companyChoosen,
                                                  );

                                                  if ((_model.dateBack
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.addToOverView((_model
                                                            .dateBack
                                                            ?.jsonBody ??
                                                        ''));
                                                    safeSetState(() {});
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Fail API'),
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

                                                  FFAppState().isLoading2 =
                                                      false;
                                                  safeSetState(() {});
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 36.0,
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                dateTimeFormat("yyyy-MM-dd",
                                                    _model.clickedDate?.date0),
                                                'yyyy-MM-dd',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.notoSansJp(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF111827),
                                                    fontSize: 20.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.clickedDate =
                                                    functions.getTodayPlusMinus(
                                                        _model
                                                            .clickedDate?.date0,
                                                        1);
                                                safeSetState(() {});
                                                if (!functions.booldateinjson(
                                                    _model.overView.toList(),
                                                    dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        _model.clickedDate
                                                            ?.date0))!) {
                                                  FFAppState().isLoading2 =
                                                      true;
                                                  safeSetState(() {});
                                                  _model.datefoward =
                                                      await UserShiftGroup
                                                          .usershiftmonthlysummaryCall
                                                          .call(
                                                    pUserId: FFAppState()
                                                        .user
                                                        .userId,
                                                    pStoreId: FFAppState()
                                                        .storeChoosen,
                                                    pRequestDate:
                                                        dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.clickedDate
                                                                ?.date0),
                                                    pCompanyId: FFAppState()
                                                        .companyChoosen,
                                                  );

                                                  if ((_model.datefoward
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.addToOverView((_model
                                                            .datefoward
                                                            ?.jsonBody ??
                                                        ''));
                                                    safeSetState(() {});
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Fail API'),
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

                                                  FFAppState().isLoading2 =
                                                      false;
                                                  safeSetState(() {});
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 36.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.clickedDate =
                                                  functions.getTodayPlusMinus(
                                                      _model.clickedDate?.date0,
                                                      -2);
                                              safeSetState(() {});
                                              if (!functions.booldateinjson(
                                                  _model.overView.toList(),
                                                  dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model.clickedDate
                                                          ?.date0))!) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.dateM2 = await UserShiftGroup
                                                    .usershiftmonthlysummaryCall
                                                    .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateM2?.succeeded ??
                                                    true)) {
                                                  _model.addToOverView((_model
                                                          .dateM2?.jsonBody ??
                                                      ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Fail API '),
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

                                                FFAppState().isLoading2 = false;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: wrapWithModel(
                                              model: _model
                                                  .dayBeforeYesterdayModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: DatetestesWidget(
                                                date:
                                                    _model.clickedDate?.dateM2,
                                                day: _model.clickedDate?.dayM2,
                                                clickedDate: dateTimeFormat(
                                                    "yyyy-MM-dd",
                                                    _model.clickedDate?.date0),
                                                colorTrueFalse: FFAppState()
                                                        .shiftStatus
                                                        .where((e) =>
                                                            (e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.dateM2)) &&
                                                            (e.isApproved ==
                                                                true))
                                                        .toList()
                                                        .firstOrNull !=
                                                    null,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.clickedDate =
                                                  functions.getTodayPlusMinus(
                                                      _model.clickedDate?.date0,
                                                      -1);
                                              safeSetState(() {});
                                              if (!functions.booldateinjson(
                                                  _model.overView.toList(),
                                                  dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model.clickedDate
                                                          ?.date0))!) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.dateM1 = await UserShiftGroup
                                                    .usershiftmonthlysummaryCall
                                                    .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateM1?.succeeded ??
                                                    true)) {
                                                  _model.addToOverView((_model
                                                          .dateM1?.jsonBody ??
                                                      ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Fail API call'),
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

                                                FFAppState().isLoading2 = false;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: wrapWithModel(
                                              model: _model.yesterdayModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: DatetestesWidget(
                                                date:
                                                    _model.clickedDate?.dateM1,
                                                day: _model.clickedDate?.dayM1,
                                                clickedDate: dateTimeFormat(
                                                    "yyyy-MM-dd",
                                                    _model.clickedDate?.date0),
                                                colorTrueFalse: FFAppState()
                                                        .shiftStatus
                                                        .where((e) =>
                                                            (e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.dateM1)) &&
                                                            (e.isApproved ==
                                                                true))
                                                        .toList()
                                                        .firstOrNull !=
                                                    null,
                                              ),
                                            ),
                                          ),
                                          wrapWithModel(
                                            model: _model.todayModel,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: DatetestesWidget(
                                              date: _model.clickedDate?.date0,
                                              day: _model.clickedDate?.day0,
                                              clickedDate: dateTimeFormat(
                                                  "yyyy-MM-dd",
                                                  _model.clickedDate?.date0),
                                              colorTrueFalse: FFAppState()
                                                      .shiftStatus
                                                      .where((e) =>
                                                          (e.requestDate ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0)) &&
                                                          (e.isApproved ==
                                                              true))
                                                      .toList()
                                                      .firstOrNull !=
                                                  null,
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.clickedDate =
                                                  functions.getTodayPlusMinus(
                                                      _model.clickedDate?.date0,
                                                      1);
                                              safeSetState(() {});
                                              if (!functions.booldateinjson(
                                                  _model.overView.toList(),
                                                  dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model.clickedDate
                                                          ?.date0))!) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.dateTmw =
                                                    await UserShiftGroup
                                                        .usershiftmonthlysummaryCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model
                                                        .dateTmw?.succeeded ??
                                                    true)) {
                                                  _model.addToOverView((_model
                                                          .dateTmw?.jsonBody ??
                                                      ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Fail API Call'),
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

                                                FFAppState().isLoading2 = false;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: wrapWithModel(
                                              model: _model.tmwModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: DatetestesWidget(
                                                date:
                                                    _model.clickedDate?.datetmw,
                                                day: _model.clickedDate?.daytmw,
                                                clickedDate: dateTimeFormat(
                                                    "yyyy-MM-dd",
                                                    _model.clickedDate?.date0),
                                                colorTrueFalse: FFAppState()
                                                        .shiftStatus
                                                        .where((e) =>
                                                            (e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.datetmw)) &&
                                                            (e.isApproved ==
                                                                true))
                                                        .toList()
                                                        .firstOrNull !=
                                                    null,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.clickedDate =
                                                  functions.getTodayPlusMinus(
                                                      _model.clickedDate?.date0,
                                                      2);
                                              safeSetState(() {});
                                              if (!functions.booldateinjson(
                                                  _model.overView.toList(),
                                                  dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model.clickedDate
                                                          ?.date0))!) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.datetmw2 =
                                                    await UserShiftGroup
                                                        .usershiftmonthlysummaryCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model
                                                        .datetmw2?.succeeded ??
                                                    true)) {
                                                  _model.addToOverView((_model
                                                          .datetmw2?.jsonBody ??
                                                      ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail API'),
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

                                                FFAppState().isLoading2 = false;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: wrapWithModel(
                                              model: _model.dayAfterTmwModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: DatetestesWidget(
                                                date: _model
                                                    .clickedDate?.datetmw2,
                                                day:
                                                    _model.clickedDate?.daytmw2,
                                                clickedDate: dateTimeFormat(
                                                    "yyyy-MM-dd",
                                                    _model.clickedDate?.date0),
                                                colorTrueFalse: FFAppState()
                                                        .shiftStatus
                                                        .where((e) =>
                                                            (e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.datetmw2)) &&
                                                            (e.isApproved ==
                                                                true))
                                                        .toList()
                                                        .firstOrNull !=
                                                    null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(
                                        0.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _model.userShiftQuantity
                                                          .where((e) =>
                                                              e.requestDate ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0))
                                                          .toList()
                                                          .firstOrNull !=
                                                      null
                                                  ? '${dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0)} / ${_model.userShiftQuantity.where((e) => e.requestDate == dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0)).toList().firstOrNull?.shiftQuantity} Shifts'
                                                  : 'Don\'t Have Shift',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.notoSansJp(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF111827),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Switch(
                                        value: _model.filteredApproveValue!,
                                        onChanged: (newValue) async {
                                          safeSetState(() =>
                                              _model.filteredApproveValue =
                                                  newValue);
                                        },
                                        activeColor: Colors.white,
                                        activeTrackColor: Color(0xFF3B82F6),
                                        inactiveTrackColor: Color(0xFFE5E7EB),
                                        inactiveThumbColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final shiftStatus = FFAppState()
                                    .shiftStatus
                                    .where((e) =>
                                        (e.requestDate ==
                                            dateTimeFormat("yyyy-MM-dd",
                                                _model.clickedDate?.date0)) &&
                                        (e.isApproved ==
                                            _model.filteredApproveValue))
                                    .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: shiftStatus.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 12.0),
                                  itemBuilder: (context, shiftStatusIndex) {
                                    final shiftStatusItem =
                                        shiftStatus[shiftStatusIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        currentUserLocationValue =
                                            await getCurrentUserLocation(
                                                defaultLocation:
                                                    LatLng(0.0, 0.0));
                                        if (FFAppState().isLoading2 == false) {
                                          FFAppState().isLoading2 = true;
                                          safeSetState(() {});
                                          if (shiftStatusItem.isApproved) {
                                            if (shiftStatusItem.requestDate ==
                                                dateTimeFormat("yyyy-MM-dd",
                                                    getCurrentTimestamp)) {
                                              _model.scanQR =
                                                  await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                '#C62828', // scanning line color
                                                'Cancel', // cancel button text
                                                true, // whether to show the flash icon
                                                ScanMode.QR,
                                              );

                                              _model.scanedStoreId =
                                                  _model.scanQR;
                                              safeSetState(() {});
                                              if (_model.vshiftRequestMonth
                                                          .where((e) =>
                                                              e.requestDate ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  getCurrentTimestamp))
                                                          .toList()
                                                          .firstOrNull
                                                          ?.actualStartTime !=
                                                      null &&
                                                  _model.vshiftRequestMonth
                                                          .where((e) =>
                                                              e.requestDate ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  getCurrentTimestamp))
                                                          .toList()
                                                          .firstOrNull
                                                          ?.actualStartTime !=
                                                      '') {
                                                if (_model.vshiftRequestMonth
                                                            .where((e) =>
                                                                e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    getCurrentTimestamp))
                                                            .toList()
                                                            .firstOrNull
                                                            ?.actualEndTime !=
                                                        null &&
                                                    _model.vshiftRequestMonth
                                                            .where((e) =>
                                                                e.requestDate ==
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    getCurrentTimestamp))
                                                            .toList()
                                                            .firstOrNull
                                                            ?.actualEndTime !=
                                                        '') {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'You Already Attended'),
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
                                                } else {
                                                  var confirmDialogResponse =
                                                      await showDialog<bool>(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Check Your Finish'),
                                                                content: Text(
                                                                    'Your Finish Time is \" ${dateTimeFormat("HH:mm:ss", getCurrentTimestamp)}\" '),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext,
                                                                            false),
                                                                    child: Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext,
                                                                            true),
                                                                    child: Text(
                                                                        'Confirm'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ) ??
                                                          false;
                                                  if (confirmDialogResponse) {
                                                    _model.clickFinish =
                                                        await UpdateShiftRequestsCall
                                                            .call(
                                                      pUserId: FFAppState()
                                                          .user
                                                          .userId,
                                                      pStoreId: _model.scanQR,
                                                      pRequestDate: dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          getCurrentTimestamp),
                                                      pTime: getCurrentTimestamp
                                                          .toString(),
                                                      pLat: functions.lat(
                                                          currentUserLocationValue,
                                                          true),
                                                      pLng: functions.lat(
                                                          currentUserLocationValue,
                                                          false),
                                                    );

                                                    if ((_model.clickFinish
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.vshiftRequestMonth = functions
                                                          .updateShiftRequestMonth(
                                                              _model
                                                                  .vshiftRequestMonth
                                                                  .toList(),
                                                              shiftStatusItem
                                                                  .shiftRequestId,
                                                              dateTimeFormat(
                                                                  "yyyy-MM-dd HH:mm:ss",
                                                                  getCurrentTimestamp),
                                                              false)!
                                                          .toList()
                                                          .cast<
                                                              VShiftRequestMonthStruct>();
                                                      safeSetState(() {});
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Success Finish'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'API Fail'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }

                                                    FFAppState().isLoading2 =
                                                        false;
                                                    safeSetState(() {});
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Not Finished'),
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
                                                    FFAppState().isLoading2 =
                                                        false;
                                                    safeSetState(() {});
                                                  }

                                                  context.pushNamed(
                                                      HomepageWidget.routeName);
                                                }
                                              } else {
                                                var confirmDialogResponse =
                                                    await showDialog<bool>(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Check Your Attend'),
                                                              content: Text(
                                                                  'Your Attend Time is \" ${dateTimeFormat("HH:mm:ss", getCurrentTimestamp)} \"'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                  child: Text(
                                                                      'Confirm'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ) ??
                                                        false;
                                                if (confirmDialogResponse) {
                                                  _model.clickAttend =
                                                      await UpdateShiftRequestsCall
                                                          .call(
                                                    pUserId: FFAppState()
                                                        .user
                                                        .userId,
                                                    pStoreId:
                                                        _model.scanedStoreId,
                                                    pRequestDate: dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        getCurrentTimestamp),
                                                    pTime: getCurrentTimestamp
                                                        .toString(),
                                                    pLat: functions.lat(
                                                        currentUserLocationValue,
                                                        true),
                                                    pLng: functions.lat(
                                                        currentUserLocationValue,
                                                        false),
                                                  );

                                                  if ((_model.clickAttend
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.vshiftRequestMonth = functions
                                                        .updateShiftRequestMonth(
                                                            _model
                                                                .vshiftRequestMonth
                                                                .toList(),
                                                            shiftStatusItem
                                                                .shiftRequestId,
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd HH:mm:ss",
                                                                getCurrentTimestamp),
                                                            true)!
                                                        .toList()
                                                        .cast<
                                                            VShiftRequestMonthStruct>();
                                                    safeSetState(() {});
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Success Attend'),
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
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'API Attend Fail'),
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

                                                  FFAppState().isLoading2 =
                                                      false;
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Not Attended'),
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
                                                  FFAppState().isLoading2 =
                                                      false;
                                                  safeSetState(() {});
                                                }

                                                context.pushNamed(
                                                    HomepageWidget.routeName);
                                              }
                                            } else {
                                              FFAppState().isLoading2 = false;
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
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child: Container(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.8,
                                                        child:
                                                            UserTimetableScheduletestesWidget(
                                                          shiftStatus:
                                                              shiftStatusItem,
                                                          vSalaryIndividual: _model
                                                              .vsalaryIndividual
                                                              .where((e) =>
                                                                  e.requestDate ==
                                                                  shiftStatusItem
                                                                      .requestDate)
                                                              .toList()
                                                              .firstOrNull,
                                                          vShiftRequest: _model
                                                              .vshiftRequestMonth
                                                              .where((e) =>
                                                                  e.shiftRequestId ==
                                                                  shiftStatusItem
                                                                      .shiftRequestId)
                                                              .toList()
                                                              .firstOrNull,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            }
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Not Approved'),
                                                  content:
                                                      Text('Ask To Manager'),
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
                                        FFAppState().isLoading2 = false;
                                        safeSetState(() {});

                                        safeSetState(() {});
                                      },
                                      child: CalanderDatatestseWidget(
                                        key: Key(
                                            'Keyd2l_${shiftStatusIndex}_of_${shiftStatus.length}'),
                                        isapproved: shiftStatusItem.isApproved,
                                        shiftId: shiftStatusItem.shiftId,
                                        shiftRequestId:
                                            shiftStatusItem.shiftRequestId,
                                        clickedDate: _model.clickedDate?.dateM2,
                                        shiftStatus: shiftStatusItem,
                                        perhour: _model.vsalaryIndividual
                                                    .where((e) =>
                                                        e.requestDate ==
                                                        shiftStatusItem
                                                            .requestDate)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.salaryType ==
                                                'hourly'
                                            ? _model.vsalaryIndividual
                                                .where((e) =>
                                                    e.requestDate ==
                                                    shiftStatusItem.requestDate)
                                                .toList()
                                                .firstOrNull
                                                ?.userSalary
                                            : 'Monthly',
                                        estimated: _model.vsalaryIndividual
                                                    .where((e) =>
                                                        e.requestDate ==
                                                        shiftStatusItem
                                                            .requestDate)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.salaryType ==
                                                'hourly'
                                            ? _model.vsalaryIndividual
                                                .where((e) =>
                                                    e.requestDate ==
                                                    shiftStatusItem.requestDate)
                                                .toList()
                                                .firstOrNull
                                                ?.totalSalary
                                            : 'Monthly',
                                        vShiftRequestMonth: _model
                                            .vshiftRequestMonth
                                            .where((e) =>
                                                e.shiftRequestId ==
                                                shiftStatusItem.shiftRequestId)
                                            .toList()
                                            .firstOrNull,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ]
                      .divide(SizedBox(height: 16.0))
                      .addToStart(SizedBox(height: 16.0)),
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
          ),
        ),
      ),
    );
  }
}
