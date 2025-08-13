import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/time_table/day_text/day_text_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calnder_comp_model.dart';
export 'calnder_comp_model.dart';

class CalnderCompWidget extends StatefulWidget {
  const CalnderCompWidget({
    super.key,
    required this.inputDateComPara,
    this.onSelectDateAction,
    this.initialSelectedDate,
    this.storeId,
    this.selectedShift,
  });

  final DateTime? inputDateComPara;
  final Future Function(DateTime? selectedDate)? onSelectDateAction;
  final DateTime? initialSelectedDate;
  final String? storeId;
  final Future Function(List<String> selectedShift)? selectedShift;

  @override
  State<CalnderCompWidget> createState() => _CalnderCompWidgetState();
}

class _CalnderCompWidgetState extends State<CalnderCompWidget> {
  late CalnderCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalnderCompModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.inputDate = widget.inputDateComPara;
      safeSetState(() {});
      if (widget.initialSelectedDate != null) {
        _model.selectedDate = widget.initialSelectedDate;
        safeSetState(() {});
      }
    });

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
      width: 350.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.rotate(
                  angle: 180.0 * (math.pi / 180),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    buttonSize: 45.0,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      _model.inputDate =
                          functions.getLastMonthDateTime(_model.inputDate!);
                      safeSetState(() {});
                    },
                  ),
                ),
                Text(
                  '${dateTimeFormat("MMMM", dateTimeFromSecondsSinceEpoch(valueOrDefault<int>(
                        _model.inputDate?.secondsSinceEpoch,
                        0,
                      )))} ${valueOrDefault<String>(
                    dateTimeFormat("y", widget.inputDateComPara),
                    '0',
                  )}',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        font: GoogleFonts.notoSansJp(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelLarge.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelLarge.fontStyle,
                      ),
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  buttonSize: 45.0,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    _model.inputDate = functions
                        .getNextMonthDateTime(widget.inputDateComPara!);
                    safeSetState(() {});
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(26.0, 10.0, 26.0, 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                wrapWithModel(
                  model: _model.dayTextModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Mon',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel2,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Tue',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Wed',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel4,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Thu',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel5,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Fri',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel6,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Sat',
                  ),
                ),
                wrapWithModel(
                  model: _model.dayTextModel7,
                  updateCallback: () => safeSetState(() {}),
                  child: DayTextWidget(
                    day: 'Sun',
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
              child: Builder(
                builder: (context) {
                  final calendar =
                      functions.getCalendarForMonth(_model.inputDate!).toList();

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 1.0,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: calendar.length,
                    itemBuilder: (context, calendarIndex) {
                      final calendarItem = calendar[calendarIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.selectedDate = calendarItem.calendarDate;
                          safeSetState(() {});
                          _model.selectedShift = [];
                          safeSetState(() {});
                          await widget.selectedShift?.call(
                            _model.selectedShift,
                          );
                          await widget.onSelectDateAction?.call(
                            _model.selectedDate,
                          );
                        },
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: dateTimeFormat(
                                        "d/M/y", calendarItem.calendarDate) ==
                                    dateTimeFormat("d/M/y", _model.selectedDate)
                                ? FlutterFlowTheme.of(context).primaryText
                                : Color(0x00000000),
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: dateTimeFormat(
                                          "d/M/y", calendarItem.calendarDate) ==
                                      dateTimeFormat(
                                          "d/M/y", getCurrentTimestamp)
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : Color(0x00000000),
                              width: 0.5,
                            ),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Text(
                                        dateTimeFormat(
                                            "d",
                                            dateTimeFromSecondsSinceEpoch(
                                                valueOrDefault<int>(
                                              calendarItem.calendarDate
                                                  ?.secondsSinceEpoch,
                                              0,
                                            ))),
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              font: GoogleFonts.notoSansJp(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                              color: (calendarItem
                                                              .isPreviousMonth ==
                                                          true) ||
                                                      (calendarItem.isNextMonth ==
                                                          true)
                                                  ? (dateTimeFormat(
                                                              "d/M/y",
                                                              calendarItem
                                                                  .calendarDate) ==
                                                          dateTimeFormat(
                                                              "d/M/y",
                                                              _model
                                                                  .selectedDate)
                                                      ? FlutterFlowTheme.of(context)
                                                          .alternate
                                                      : FlutterFlowTheme.of(context)
                                                          .secondaryText)
                                                  : (dateTimeFormat(
                                                              "d/M/y",
                                                              calendarItem
                                                                  .calendarDate) ==
                                                          dateTimeFormat(
                                                              "d/M/y",
                                                              _model
                                                                  .selectedDate)
                                                      ? FlutterFlowTheme.of(context)
                                                          .alternate
                                                      : FlutterFlowTheme.of(context)
                                                          .primaryText),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                              lineHeight: 1.1,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState()
                                          .managerShiftDetail
                                          .where((e) =>
                                              (functions.changeDateTimeToString(
                                                      calendarItem
                                                          .calendarDate) ==
                                                  e.requestDate) &&
                                              (widget.storeId == e.storeId))
                                          .toList()
                                          .firstOrNull !=
                                      null)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          3.0, 3.0, 0.0, 0.0),
                                      child: Container(
                                        width: 5.0,
                                        height: 5.0,
                                        decoration: BoxDecoration(
                                          color: FFAppState()
                                                      .managerShiftDetail
                                                      .where((e) =>
                                                          functions.changeDateTimeToString(
                                                              dateTimeFromSecondsSinceEpoch(
                                                                  valueOrDefault<
                                                                      int>(
                                                            calendarItem
                                                                .calendarDate
                                                                ?.secondsSinceEpoch,
                                                            0,
                                                          ))) ==
                                                          e.requestDate)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.totalRequired ==
                                                  FFAppState()
                                                      .managerShiftDetail
                                                      .where((e) =>
                                                          functions.changeDateTimeToString(
                                                              dateTimeFromSecondsSinceEpoch(
                                                                  valueOrDefault<
                                                                      int>(
                                                            calendarItem
                                                                .calendarDate
                                                                ?.secondsSinceEpoch,
                                                            0,
                                                          ))) ==
                                                          e.requestDate)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.totalApproved
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .tertiary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 40.0,
            decoration: BoxDecoration(),
          ),
        ].addToStart(SizedBox(height: 16.0)),
      ),
    );
  }
}
