import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calander_data_model.dart';
export 'calander_data_model.dart';

class CalanderDataWidget extends StatefulWidget {
  const CalanderDataWidget({
    super.key,
    this.cardInfo,
    this.today,
    bool? workingBoolean,
  }) : this.workingBoolean = workingBoolean ?? false;

  final dynamic cardInfo;
  final String? today;
  final bool workingBoolean;

  @override
  State<CalanderDataWidget> createState() => _CalanderDataWidgetState();
}

class _CalanderDataWidgetState extends State<CalanderDataWidget> {
  late CalanderDataModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalanderDataModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          getJsonField(
                            widget.cardInfo,
                            r'''$.store_name''',
                          )?.toString(),
                          'Error',
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
                  Stack(
                    children: [
                      if (widget.workingBoolean == false)
                        Container(
                          decoration: BoxDecoration(
                            color: functions.convertJsonToString(getJsonField(
                                      widget.cardInfo,
                                      r'''$.request_date''',
                                    )) ==
                                    widget.today
                                ? (functions.convertJsonToString(getJsonField(
                                          widget.cardInfo,
                                          r'''$.is_approved''',
                                        )) ==
                                        'true'
                                    ? (getJsonField(
                                              widget.cardInfo,
                                              r'''$.actual_start_time''',
                                            ) !=
                                            null
                                        ? (getJsonField(
                                                  widget.cardInfo,
                                                  r'''$.actual_end_time''',
                                                ) !=
                                                null
                                            ? Color(0xFFF3E8FF)
                                            : Color(0xFFE0F2FE))
                                        : Color(0xFFDBEAFE))
                                    : Color(0xFFFEF3C7))
                                : (functions.convertJsonToString(getJsonField(
                                          widget.cardInfo,
                                          r'''$.is_approved''',
                                        )) ==
                                        'true'
                                    ? (getJsonField(
                                              widget.cardInfo,
                                              r'''$.actual_start_time''',
                                            ) !=
                                            null
                                        ? (getJsonField(
                                                  widget.cardInfo,
                                                  r'''$.actual_end_time''',
                                                ) !=
                                                null
                                            ? Color(0xFFF3E8FF)
                                            : Color(0xFFB45309))
                                        : Color(0xFFE0F2FE))
                                    : Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 4.0, 12.0, 4.0),
                            child: Text(
                              functions.convertJsonToString(getJsonField(
                                        widget.cardInfo,
                                        r'''$.request_date''',
                                      )) ==
                                      widget.today
                                  ? (functions.convertJsonToString(getJsonField(
                                            widget.cardInfo,
                                            r'''$.is_approved''',
                                          )) ==
                                          'true'
                                      ? (getJsonField(
                                                widget.cardInfo,
                                                r'''$.actual_start_time''',
                                              ) !=
                                              null
                                          ? (getJsonField(
                                                    widget.cardInfo,
                                                    r'''$.actual_end_time''',
                                                  ) !=
                                                  null
                                              ? '✅ Checked Out'
                                              : '👷 Working')
                                          : '📅 Scheduled')
                                      : '🕰️ Pending')
                                  : (functions.convertJsonToString(getJsonField(
                                            widget.cardInfo,
                                            r'''$.is_approved''',
                                          )) ==
                                          'true'
                                      ? (getJsonField(
                                                widget.cardInfo,
                                                r'''$.actual_start_time''',
                                              ) !=
                                              null
                                          ? (getJsonField(
                                                    widget.cardInfo,
                                                    r'''$.actual_end_time''',
                                                  ) !=
                                                  null
                                              ? '✅ Checked Out'
                                              : '⚠️ Incomplete')
                                          : '✓ Approved')
                                      : '🕰️ Pending'),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: functions.convertJsonToString(
                                                getJsonField(
                                              widget.cardInfo,
                                              r'''$.request_date''',
                                            )) ==
                                            widget.today
                                        ? (functions.convertJsonToString(
                                                    getJsonField(
                                                  widget.cardInfo,
                                                  r'''$.is_approved''',
                                                )) ==
                                                'true'
                                            ? (getJsonField(
                                                      widget.cardInfo,
                                                      r'''$.actual_start_time''',
                                                    ) !=
                                                    null
                                                ? (getJsonField(
                                                          widget.cardInfo,
                                                          r'''$.actual_end_time''',
                                                        ) !=
                                                        null
                                                    ? Color(0xFF7C3AED)
                                                    : Color(0xFF0284C7))
                                                : Color(0xFF1D4ED8))
                                            : Color(0xFFD97706))
                                        : (functions.convertJsonToString(
                                                    getJsonField(
                                                  widget.cardInfo,
                                                  r'''$.is_approved''',
                                                )) ==
                                                'true'
                                            ? (getJsonField(
                                                      widget.cardInfo,
                                                      r'''$.actual_start_time''',
                                                    ) !=
                                                    null
                                                ? (getJsonField(
                                                          widget.cardInfo,
                                                          r'''$.actual_end_time''',
                                                        ) !=
                                                        null
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
                      if (widget.workingBoolean)
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 4.0, 12.0, 4.0),
                            child: Text(
                              '👷 Working',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.notoSansJp(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF0284C7),
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
                      valueOrDefault<String>(
                        getJsonField(
                          widget.cardInfo,
                          r'''$.shift_time''',
                        )?.toString(),
                        'error',
                      ),
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
                          functions.convertJsonToString(getJsonField(
                                    widget.cardInfo,
                                    r'''$.salary_type''',
                                  )) ==
                                  'hourly'
                              ? getJsonField(
                                  widget.cardInfo,
                                  r'''$.salary_amount''',
                                ).toString()
                              : 'Monthly',
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
                          getJsonField(
                                    widget.cardInfo,
                                    r'''$.actual_start_time''',
                                  ) !=
                                  null
                              ? (getJsonField(
                                        widget.cardInfo,
                                        r'''$.actual_end_time''',
                                      ) !=
                                      null
                                  ? getJsonField(
                                      widget.cardInfo,
                                      r'''$.total_pay_with_bonus''',
                                    ).toString()
                                  : 'Not Checked Out')
                              : 'Not Checked In',
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
              if (functions.convertJsonToString(getJsonField(
                    widget.cardInfo,
                    r'''$.is_reported''',
                  )) ==
                  'true')
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent3,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 8.0, 12.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.report_problem,
                                color: FlutterFlowTheme.of(context).tertiary,
                                size: 24.0,
                              ),
                              Text(
                                'We\'ll Check This at Month-End',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF0F172A),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
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
    );
  }
}
