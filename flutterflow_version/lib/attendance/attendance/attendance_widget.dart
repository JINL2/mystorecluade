import '/attendance/calander_data/calander_data_widget.dart';
import '/attendance/datetestes/datetestes_widget.dart';
import '/attendance/user_timetable_schedule/user_timetable_schedule_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/common/calender_bottom_sheet/calender_bottom_sheet_widget.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'attendance_model.dart';
export 'attendance_model.dart';

class AttendanceWidget extends StatefulWidget {
  const AttendanceWidget({super.key});

  static String routeName = 'attendance';
  static String routePath = '/attendance';

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  late AttendanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AttendanceModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isLoading1 = true;
      safeSetState(() {});
      _model.clickedDate = functions.getTodayPlusMinus(getCurrentTimestamp, 0);
      _model.isApprovedFilter = 'true';
      safeSetState(() {});
      _model.oPLUserShiftOverview =
          await UserShiftGroup.usershiftoverviewCall.call(
        pUserId: FFAppState().user.userId,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0),
        pStoreId: FFAppState().storeChoosen,
        pCompanyId: FFAppState().companyChoosen,
      );

      if ((_model.oPLUserShiftOverview?.succeeded ?? true)) {
        _model.addToUserMonthSummary(
            (_model.oPLUserShiftOverview?.jsonBody ?? ''));
        _model.addToMonthFilter(
            dateTimeFormat("yyyy-MM", _model.clickedDate!.date0!));
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail API'),
              content: Text(
                  (_model.oPLUserShiftOverview?.jsonBody ?? '').toString()),
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

      _model.oPLUserShiftCards = await UserShiftGroup.usershiftcardsCall.call(
        pUserId: FFAppState().user.userId,
        pRequestDate: dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0),
        pStoreId: FFAppState().storeChoosen,
        pCompanyId: FFAppState().companyChoosen,
      );

      if ((_model.oPLUserShiftCards?.succeeded ?? true)) {
        _model.userShiftCard =
            (_model.oPLUserShiftCards?.jsonBody ?? '').toList().cast<dynamic>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail API'),
              content:
                  Text((_model.oPLUserShiftCards?.jsonBody ?? '').toString()),
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                                      Text(
                                        'This Month Working Stat',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.notoSansJp(
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
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
                                                    _model.userMonthSummary
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.actual_work_days''',
                                                  )?.toString(),
                                                  'error',
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
                                                    _model.userMonthSummary
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.actual_work_hours''',
                                                  )?.toString(),
                                                  'error',
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
                                                '${valueOrDefault<String>(
                                                  getJsonField(
                                                    _model.userMonthSummary
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.overtime_total''',
                                                  )?.toString(),
                                                  'error',
                                                )}${getJsonField(
                                                      _model.userMonthSummary
                                                          .where((e) =>
                                                              functions
                                                                  .convertJsonToString(
                                                                      getJsonField(
                                                                e,
                                                                r'''$.request_month''',
                                                              )) ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0))
                                                          .toList()
                                                          .firstOrNull,
                                                      r'''$.overtime_total''',
                                                    ) != null ? ' m' : ''}',
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
                                                'OverTime',
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
                                                '${valueOrDefault<String>(
                                                  getJsonField(
                                                    _model.userMonthSummary
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_month''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))
                                                        .toList()
                                                        .firstOrNull,
                                                    r'''$.late_deduction_total''',
                                                  )?.toString(),
                                                  'error',
                                                )}${getJsonField(
                                                      _model.userMonthSummary
                                                          .where((e) =>
                                                              functions
                                                                  .convertJsonToString(
                                                                      getJsonField(
                                                                e,
                                                                r'''$.request_month''',
                                                              )) ==
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0))
                                                          .toList()
                                                          .firstOrNull,
                                                      r'''$.late_deduction_total''',
                                                    ) != null ? ' m' : ''}',
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
                                                'LateDeduct',
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
                                                    functions.convertJsonToString(
                                                                getJsonField(
                                                              _model
                                                                  .userMonthSummary
                                                                  .where((e) =>
                                                                      functions
                                                                          .convertJsonToString(
                                                                              getJsonField(
                                                                        e,
                                                                        r'''$.request_month''',
                                                                      )) ==
                                                                      dateTimeFormat(
                                                                          "yyyy-MM",
                                                                          _model
                                                                              .clickedDate
                                                                              ?.date0))
                                                                  .toList()
                                                                  .firstOrNull,
                                                              r'''$.salary_type''',
                                                            )) ==
                                                            'hourly'
                                                        ? '${valueOrDefault<String>(
                                                            getJsonField(
                                                              _model
                                                                  .userMonthSummary
                                                                  .where((e) =>
                                                                      functions
                                                                          .convertJsonToString(
                                                                              getJsonField(
                                                                        e,
                                                                        r'''$.request_month''',
                                                                      )) ==
                                                                      dateTimeFormat(
                                                                          "yyyy-MM",
                                                                          _model
                                                                              .clickedDate
                                                                              ?.date0))
                                                                  .toList()
                                                                  .firstOrNull,
                                                              r'''$.estimated_salary''',
                                                            )?.toString(),
                                                            'error',
                                                          )} ${valueOrDefault<String>(
                                                            getJsonField(
                                                              _model
                                                                  .userMonthSummary
                                                                  .where((e) =>
                                                                      functions
                                                                          .convertJsonToString(
                                                                              getJsonField(
                                                                        e,
                                                                        r'''$.request_month''',
                                                                      )) ==
                                                                      dateTimeFormat(
                                                                          "yyyy-MM",
                                                                          _model
                                                                              .clickedDate
                                                                              ?.date0))
                                                                  .toList()
                                                                  .firstOrNull,
                                                              r'''$.currency_symbol''',
                                                            )?.toString(),
                                                            'error',
                                                          )}'
                                                        : 'Monthly Salary',
                                                    '0 VND',
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
                                    ].divide(SizedBox(height: 16.0)),
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
                                                        if (!_model.monthFilter
                                                            .contains(dateTimeFormat(
                                                                "yyyy-MM",
                                                                _model
                                                                    .clickedDate
                                                                    ?.date0))) {
                                                          FFAppState()
                                                                  .isLoading2 =
                                                              true;
                                                          safeSetState(() {});
                                                          _model.addToMonthFilter(
                                                              dateTimeFormat(
                                                                  "yyyy-MM",
                                                                  _model
                                                                      .clickedDate!
                                                                      .date0!));
                                                          safeSetState(() {});
                                                          _model.dateClickG =
                                                              await UserShiftGroup
                                                                  .usershiftoverviewCall
                                                                  .call(
                                                            pUserId:
                                                                FFAppState()
                                                                    .user
                                                                    .userId,
                                                            pRequestDate:
                                                                dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.date0),
                                                            pStoreId: FFAppState()
                                                                .storeChoosen,
                                                            pCompanyId: FFAppState()
                                                                .companyChoosen,
                                                          );

                                                          if ((_model.dateClickA
                                                                  ?.succeeded ??
                                                              true)) {
                                                            _model.addToUserMonthSummary(
                                                                (_model.dateClickG
                                                                        ?.jsonBody ??
                                                                    ''));
                                                            safeSetState(() {});
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Fail API'),
                                                                  content: Text(
                                                                      (_model.dateClickG?.jsonBody ??
                                                                              '')
                                                                          .toString()),
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
                                                if (!_model.monthFilter
                                                    .contains(dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate
                                                            ?.date0))) {
                                                  FFAppState().isLoading2 =
                                                      true;
                                                  safeSetState(() {});
                                                  _model.addToMonthFilter(
                                                      dateTimeFormat(
                                                          "yyyy-MM",
                                                          _model.clickedDate!
                                                              .date0!));
                                                  safeSetState(() {});
                                                  _model.dateClickB =
                                                      await UserShiftGroup
                                                          .usershiftoverviewCall
                                                          .call(
                                                    pUserId: FFAppState()
                                                        .user
                                                        .userId,
                                                    pRequestDate:
                                                        dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.clickedDate
                                                                ?.date0),
                                                    pStoreId: FFAppState()
                                                        .storeChoosen,
                                                    pCompanyId: FFAppState()
                                                        .companyChoosen,
                                                  );

                                                  if ((_model.dateClickB
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.addToUserMonthSummary(
                                                        (_model.dateClickB
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
                                                          content: Text((_model
                                                                      .dateClickB
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
                                              dateTimeFormat("yyyy-MM-dd",
                                                  _model.clickedDate!.date0!),
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
                                                if (!_model.monthFilter
                                                    .contains(dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate
                                                            ?.date0))) {
                                                  FFAppState().isLoading2 =
                                                      true;
                                                  safeSetState(() {});
                                                  _model.addToMonthFilter(
                                                      dateTimeFormat(
                                                          "yyyy-MM",
                                                          _model.clickedDate!
                                                              .date0!));
                                                  safeSetState(() {});
                                                  _model.dateClickA =
                                                      await UserShiftGroup
                                                          .usershiftoverviewCall
                                                          .call(
                                                    pUserId: FFAppState()
                                                        .user
                                                        .userId,
                                                    pRequestDate:
                                                        dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.clickedDate
                                                                ?.date0),
                                                    pStoreId: FFAppState()
                                                        .storeChoosen,
                                                    pCompanyId: FFAppState()
                                                        .companyChoosen,
                                                  );

                                                  if ((_model.dateClickA
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.addToUserMonthSummary(
                                                        (_model.dateClickA
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
                                                          content: Text((_model
                                                                      .dateClickA
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
                                              if (!_model.monthFilter.contains(
                                                  dateTimeFormat(
                                                      "yyyy-MM",
                                                      _model.clickedDate
                                                          ?.date0))) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.addToMonthFilter(
                                                    dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate!
                                                            .date0!));
                                                safeSetState(() {});
                                                _model.dateClickF =
                                                    await UserShiftGroup
                                                        .usershiftoverviewCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateClickF
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model.addToUserMonthSummary(
                                                      (_model.dateClickF
                                                              ?.jsonBody ??
                                                          ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail API'),
                                                        content: Text((_model
                                                                    .dateClickF
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
                                                colorTrueFalse: _model
                                                        .userShiftCard
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_date''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .clickedDate
                                                                    ?.dateM2))
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
                                              if (!_model.monthFilter.contains(
                                                  dateTimeFormat(
                                                      "yyyy-MM",
                                                      _model.clickedDate
                                                          ?.date0))) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.addToMonthFilter(
                                                    dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate!
                                                            .date0!));
                                                safeSetState(() {});
                                                _model.dateClickE =
                                                    await UserShiftGroup
                                                        .usershiftoverviewCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateClickE
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model.addToUserMonthSummary(
                                                      (_model.dateClickE
                                                              ?.jsonBody ??
                                                          ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail API'),
                                                        content: Text((_model
                                                                    .dateClickE
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
                                                colorTrueFalse: _model
                                                        .userShiftCard
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_date''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .clickedDate
                                                                    ?.dateM1))
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
                                              colorTrueFalse: _model
                                                      .userShiftCard
                                                      .where((e) =>
                                                          functions
                                                              .convertJsonToString(
                                                                  getJsonField(
                                                            e,
                                                            r'''$.request_date''',
                                                          )) ==
                                                          dateTimeFormat(
                                                              "yyyy-MM-dd",
                                                              _model.clickedDate
                                                                  ?.date0))
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
                                              if (!_model.monthFilter.contains(
                                                  dateTimeFormat(
                                                      "yyyy-MM",
                                                      _model.clickedDate
                                                          ?.date0))) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.addToMonthFilter(
                                                    dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate!
                                                            .date0!));
                                                safeSetState(() {});
                                                _model.dateClickD =
                                                    await UserShiftGroup
                                                        .usershiftoverviewCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateClickD
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model.addToUserMonthSummary(
                                                      (_model.dateClickD
                                                              ?.jsonBody ??
                                                          ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail API'),
                                                        content: Text((_model
                                                                    .dateClickD
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
                                                colorTrueFalse: _model
                                                        .userShiftCard
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_date''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .clickedDate
                                                                    ?.datetmw))
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
                                              if (!_model.monthFilter.contains(
                                                  dateTimeFormat(
                                                      "yyyy-MM",
                                                      _model.clickedDate
                                                          ?.date0))) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.addToMonthFilter(
                                                    dateTimeFormat(
                                                        "yyyy-MM",
                                                        _model.clickedDate!
                                                            .date0!));
                                                safeSetState(() {});
                                                _model.dateClickC =
                                                    await UserShiftGroup
                                                        .usershiftoverviewCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pRequestDate: dateTimeFormat(
                                                      "yyyy-MM-dd",
                                                      _model
                                                          .clickedDate?.date0),
                                                  pStoreId:
                                                      FFAppState().storeChoosen,
                                                  pCompanyId: FFAppState()
                                                      .companyChoosen,
                                                );

                                                if ((_model.dateClickC
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model.addToUserMonthSummary(
                                                      (_model.dateClickC
                                                              ?.jsonBody ??
                                                          ''));
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail API'),
                                                        content: Text((_model
                                                                    .dateClickC
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
                                                colorTrueFalse: _model
                                                        .userShiftCard
                                                        .where((e) =>
                                                            functions
                                                                .convertJsonToString(
                                                                    getJsonField(
                                                              e,
                                                              r'''$.request_date''',
                                                            )) ==
                                                            dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .clickedDate
                                                                    ?.datetmw2))
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
                                              '${_model.userShiftCard.where((e) => functions.convertJsonToString(getJsonField(
                                                    e,
                                                    r'''$.request_date''',
                                                  )) == dateTimeFormat("yyyy-MM-dd", _model.clickedDate?.date0)).toList().firstOrNull != null ? 'Have Shift' : 'No Shift'}',
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
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Switch(
                                            value: _model.filteredApproveValue!,
                                            onChanged: (newValue) async {
                                              safeSetState(() =>
                                                  _model.filteredApproveValue =
                                                      newValue);
                                              if (newValue) {
                                                _model.isApprovedFilter =
                                                    'true';
                                                safeSetState(() {});
                                              } else {
                                                _model.isApprovedFilter =
                                                    'false';
                                                safeSetState(() {});
                                              }
                                            },
                                            activeColor: Colors.white,
                                            activeTrackColor: Color(0xFF3B82F6),
                                            inactiveTrackColor:
                                                Color(0xFFE5E7EB),
                                            inactiveThumbColor: Colors.white,
                                          ),
                                          Text(
                                            'Approve Filter',
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
                                                  fontSize: 12.0,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final userShiftCards = _model.userShiftCard
                                    .where((e) =>
                                        (functions.convertJsonToString(
                                                getJsonField(
                                              e,
                                              r'''$.request_date''',
                                            )) ==
                                            dateTimeFormat("yyyy-MM-dd",
                                                _model.clickedDate?.date0)) &&
                                        (functions.convertJsonToString(
                                                getJsonField(
                                              e,
                                              r'''$.is_approved''',
                                            )) ==
                                            _model.isApprovedFilter))
                                    .toList()
                                    .sortedList(
                                        keyOf: (e) =>
                                            functions.convertJsonToString(
                                                getJsonField(
                                              e,
                                              r'''$.shift_time''',
                                            )),
                                        desc: true)
                                    .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: userShiftCards.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 12.0),
                                  itemBuilder: (context, userShiftCardsIndex) {
                                    final userShiftCardsItem =
                                        userShiftCards[userShiftCardsIndex];
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
                                          if (functions.convertJsonToString(
                                                  getJsonField(
                                                userShiftCardsItem,
                                                r'''$.is_approved''',
                                              )) ==
                                              'true') {
                                            if (functions.convertJsonToString(
                                                    getJsonField(
                                                  userShiftCardsItem,
                                                  r'''$.request_date''',
                                                )) ==
                                                dateTimeFormat("yyyy-MM-dd",
                                                    getCurrentTimestamp)) {
                                              var confirmDialogResponse =
                                                  await showDialog<bool>(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Do You Want To Attend Or Check Out?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        false),
                                                                child:
                                                                    Text('No'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        true),
                                                                child:
                                                                    Text('Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ) ??
                                                      false;
                                              if (confirmDialogResponse) {
                                                FFAppState().isLoading2 = true;
                                                safeSetState(() {});
                                                _model.qrScan1 =
                                                    await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                  '#C62828', // scanning line color
                                                  'Cancel', // cancel button text
                                                  true, // whether to show the flash icon
                                                  ScanMode.QR,
                                                );

                                                _model.updateShiftRequest1 =
                                                    await UserShiftGroup
                                                        .updateshiftrequestsvCall
                                                        .call(
                                                  pUserId:
                                                      FFAppState().user.userId,
                                                  pStoreId: _model.qrScan1,
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

                                                if ((_model.updateShiftRequest1
                                                        ?.succeeded ??
                                                    true)) {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Status: ${getJsonField(
                                                          (_model.updateShiftRequest1
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.status''',
                                                        ).toString()}'),
                                                        content: Text(
                                                            ' Set Time: ${getJsonField(
                                                          (_model.updateShiftRequest1
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.time''',
                                                        ).toString()}'),
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
                                                  _model.workingboolean = true;
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Fail'),
                                                        content: Text((_model
                                                                    .updateShiftRequest1
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
                                                  FFAppState().isLoading2 =
                                                      false;
                                                  safeSetState(() {});
                                                }
                                              } else {
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
                                                        FocusManager.instance
                                                            .primaryFocus
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
                                                              UserTimetableScheduleWidget(
                                                            cardInfo:
                                                                userShiftCardsItem,
                                                            action: () async {
                                                              FFAppState()
                                                                      .isLoading3 =
                                                                  true;
                                                              safeSetState(
                                                                  () {});
                                                              _model.callback1 =
                                                                  await UserShiftGroup
                                                                      .usershiftcardsCall
                                                                      .call(
                                                                pUserId:
                                                                    FFAppState()
                                                                        .user
                                                                        .userId,
                                                                pRequestDate: dateTimeFormat(
                                                                    "yyyy-MM-dd",
                                                                    _model
                                                                        .clickedDate
                                                                        ?.date0),
                                                                pStoreId:
                                                                    FFAppState()
                                                                        .storeChoosen,
                                                                pCompanyId:
                                                                    FFAppState()
                                                                        .companyChoosen,
                                                              );

                                                              if ((_model
                                                                      .callback1
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                _model
                                                                    .userShiftCard = (_model
                                                                            .callback1
                                                                            ?.jsonBody ??
                                                                        '')
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
                                                                      title: Text(
                                                                          'Fail update Report'),
                                                                      content: Text((_model.callback1?.jsonBody ??
                                                                              '')
                                                                          .toString()),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }

                                                              FFAppState()
                                                                      .isLoading3 =
                                                                  false;
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              }
                                            } else {
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
                                                            UserTimetableScheduleWidget(
                                                          cardInfo:
                                                              userShiftCardsItem,
                                                          action: () async {
                                                            FFAppState()
                                                                    .isLoading3 =
                                                                true;
                                                            safeSetState(() {});
                                                            _model.callback2 =
                                                                await UserShiftGroup
                                                                    .usershiftcardsCall
                                                                    .call(
                                                              pUserId:
                                                                  FFAppState()
                                                                      .user
                                                                      .userId,
                                                              pRequestDate: dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  _model
                                                                      .clickedDate
                                                                      ?.date0),
                                                              pStoreId: FFAppState()
                                                                  .storeChoosen,
                                                              pCompanyId:
                                                                  FFAppState()
                                                                      .companyChoosen,
                                                            );

                                                            if ((_model
                                                                    .callback2
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model
                                                                  .userShiftCard = (_model
                                                                          .callback2
                                                                          ?.jsonBody ??
                                                                      '')
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
                                                                    title: Text(
                                                                        'Fail update Report'),
                                                                    content: Text(
                                                                        (_model.callback2?.jsonBody ??
                                                                                '')
                                                                            .toString()),
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
                                                                    .isLoading3 =
                                                                false;
                                                            safeSetState(() {});
                                                          },
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

                                        safeSetState(() {});
                                      },
                                      child: CalanderDataWidget(
                                        key: Key(
                                            'Keyxny_${userShiftCardsIndex}_of_${userShiftCards.length}'),
                                        cardInfo: userShiftCardsItem,
                                        today: dateTimeFormat(
                                            "yyyy-MM-dd", getCurrentTimestamp),
                                        workingBoolean: _model.workingboolean,
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
