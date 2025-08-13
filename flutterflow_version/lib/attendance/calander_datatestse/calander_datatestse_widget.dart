import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calander_datatestse_model.dart';
export 'calander_datatestse_model.dart';

class CalanderDatatestseWidget extends StatefulWidget {
  const CalanderDatatestseWidget({
    super.key,
    this.isapproved,
    this.clickedDate,
    this.shiftId,
    this.shiftRequestId,
    this.shiftStatus,
    this.perhour,
    this.estimated,
    this.vShiftRequestMonth,
  });

  final bool? isapproved;
  final DateTime? clickedDate;
  final String? shiftId;
  final String? shiftRequestId;
  final ShiftStatusStruct? shiftStatus;
  final String? perhour;
  final String? estimated;
  final VShiftRequestMonthStruct? vShiftRequestMonth;

  @override
  State<CalanderDatatestseWidget> createState() =>
      _CalanderDatatestseWidgetState();
}

class _CalanderDatatestseWidgetState extends State<CalanderDatatestseWidget> {
  late CalanderDatatestseModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalanderDatatestseModel());

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

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.business_rounded,
                          color: Color(0xFF6B7280),
                          size: 20.0,
                        ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          functions.getStoreNameByIdFromList(
                              FFAppState()
                                  .user
                                  .companies
                                  .where((e) =>
                                      FFAppState().companyChoosen ==
                                      e.companyId)
                                  .toList()
                                  .firstOrNull
                                  ?.stores
                                  .toList(),
                              FFAppState().storeChoosen),
                          'Store Name',
                        ),
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.notoSansJp(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: Color(0xFF111827),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.shiftStatus?.requestDate ==
                              dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp)
                          ? (widget.vShiftRequestMonth?.isApproved == true
                              ? (widget.vShiftRequestMonth?.actualStartTime != null &&
                                      widget.vShiftRequestMonth?.actualStartTime !=
                                          ''
                                  ? (widget.vShiftRequestMonth?.actualEndTime != null &&
                                          widget.vShiftRequestMonth?.actualEndTime !=
                                              ''
                                      ? Color(0xFFF3E8FF)
                                      : Color(0xFFDBEAFE))
                                  : Color(0xFFDBEAFE))
                              : Color(0xFFFEF3C7))
                          : (widget.vShiftRequestMonth?.isApproved == true
                              ? (widget.vShiftRequestMonth?.actualStartTime != null &&
                                      widget.vShiftRequestMonth?.actualStartTime !=
                                          ''
                                  ? (widget.vShiftRequestMonth?.actualEndTime !=
                                              null &&
                                          widget.vShiftRequestMonth?.actualEndTime != ''
                                      ? Color(0xFFF3E8FF)
                                      : Color(0xFFB45309))
                                  : Color(0xFFE0F2FE))
                              : Color(0xFFFEF3C7)),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                      child: Text(
                        widget.shiftStatus?.requestDate ==
                                dateTimeFormat(
                                    "yyyy-MM-dd", getCurrentTimestamp)
                            ? (widget.vShiftRequestMonth?.isApproved == true
                                ? (widget.vShiftRequestMonth?.actualStartTime != null &&
                                        widget.vShiftRequestMonth?.actualStartTime !=
                                            ''
                                    ? (widget.vShiftRequestMonth?.actualEndTime != null &&
                                            widget.vShiftRequestMonth
                                                    ?.actualEndTime !=
                                                ''
                                        ? '✅ Checked Out'
                                        : '👷 Working')
                                    : '📅 Scheduled')
                                : '🕰️ Pending')
                            : (widget.vShiftRequestMonth?.isApproved == true
                                ? (widget.vShiftRequestMonth?.actualStartTime !=
                                            null &&
                                        widget.vShiftRequestMonth?.actualStartTime !=
                                            ''
                                    ? (widget.vShiftRequestMonth?.actualEndTime !=
                                                null &&
                                            widget.vShiftRequestMonth?.actualEndTime != ''
                                        ? '✅ Checked Out'
                                        : '⚠️ Incomplete')
                                    : '✓ Approved')
                                : '🕰️ Pending'),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.notoSansJp(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: widget.shiftStatus?.requestDate ==
                                      dateTimeFormat(
                                          "yyyy-MM-dd", getCurrentTimestamp)
                                  ? (widget.vShiftRequestMonth?.isApproved == true
                                      ? (widget.vShiftRequestMonth?.actualStartTime != null &&
                                              widget.vShiftRequestMonth?.actualStartTime !=
                                                  ''
                                          ? (widget.vShiftRequestMonth?.actualEndTime != null && widget.vShiftRequestMonth?.actualEndTime != ''
                                              ? Color(0xFF7C3AED)
                                              : Color(0xFF0284C7))
                                          : Color(0xFF1D4ED8))
                                      : Color(0xFFD97706))
                                  : (widget.vShiftRequestMonth?.isApproved == true
                                      ? (widget.vShiftRequestMonth?.actualStartTime != null &&
                                              widget.vShiftRequestMonth
                                                      ?.actualStartTime !=
                                                  ''
                                          ? (widget.vShiftRequestMonth?.actualEndTime != null &&
                                                  widget.vShiftRequestMonth?.actualEndTime != ''
                                              ? Color(0xFF7C3AED)
                                              : Color(0xFFFEF3C7))
                                          : Color(0xFF16A34A))
                                      : Color(0xFFD97706)),
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF6B7280),
                      size: 16.0,
                    ),
                    Text(
                      '${valueOrDefault<String>(
                        FFAppState()
                            .shiftMetaData
                            .where((e) => e.shiftId == widget.shiftId)
                            .toList()
                            .firstOrNull
                            ?.startTime,
                        '10:00',
                      )} - ${FFAppState().shiftMetaData.where((e) => e.shiftId == widget.shiftId).toList().firstOrNull?.endTime}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF6B7280),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Salary/hour',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF6B7280),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            widget.perhour,
                            '30000',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111827),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ],
                    ),
                    Text(
                      '·',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF6B7280),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Confirmed Salary',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF6B7280),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            (widget.vShiftRequestMonth?.actualStartTime !=
                                            null &&
                                        widget.vShiftRequestMonth
                                                ?.actualStartTime !=
                                            '') &&
                                    (widget.vShiftRequestMonth
                                                ?.actualEndTime !=
                                            null &&
                                        widget.vShiftRequestMonth
                                                ?.actualEndTime !=
                                            '')
                                ? valueOrDefault<String>(
                                    widget.vShiftRequestMonth?.totalSalaryPay,
                                    '123,123',
                                  )
                                : 'Not Finished',
                            'None',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111827),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ],
                    ),
                  ].divide(SizedBox(width: 4.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
