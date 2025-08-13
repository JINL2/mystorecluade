import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'datetestes_model.dart';
export 'datetestes_model.dart';

class DatetestesWidget extends StatefulWidget {
  const DatetestesWidget({
    super.key,
    this.date,
    this.day,
    this.clickedDate,
    this.colorTrueFalse,
  });

  final DateTime? date;
  final String? day;
  final String? clickedDate;
  final bool? colorTrueFalse;

  @override
  State<DatetestesWidget> createState() => _DatetestesWidgetState();
}

class _DatetestesWidgetState extends State<DatetestesWidget> {
  late DatetestesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DatetestesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          widget.clickedDate == dateTimeFormat("yyyy-MM-dd", widget.date)
              ? Color(0xFF3B82F6)
              : (widget.colorTrueFalse != null
                  ? valueOrDefault<Color>(
                      widget.colorTrueFalse!
                          ? Color(0xFFDBEAFE)
                          : Color(0xFFF3F4F6),
                      Color(0xFF3B82F6),
                    )
                  : Color(0xFFF3F4F6)),
          Color(0xFF3B82F6),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  valueOrDefault<String>(
                    dateTimeFormat("dd", widget.date),
                    'date',
                  ),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.notoSansJp(
                          fontWeight: FontWeight.w600,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        color: valueOrDefault<Color>(
                          dateTimeFormat("yyyy-MM-dd", widget.date) ==
                                  widget.clickedDate
                              ? Colors.white
                              : (widget.colorTrueFalse != null
                                  ? valueOrDefault<Color>(
                                      widget.colorTrueFalse!
                                          ? Color(0xFF1D4ED8)
                                          : Color(0xFF6B7280),
                                      Colors.white,
                                    )
                                  : Color(0xFF6B7280)),
                          Colors.white,
                        ),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
              child: Text(
                valueOrDefault<String>(
                  widget.day,
                  'day',
                ),
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.notoSansJp(
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: valueOrDefault<Color>(
                        dateTimeFormat("yyyy-MM-dd", widget.date) ==
                                widget.clickedDate
                            ? Colors.white
                            : (widget.colorTrueFalse != null
                                ? valueOrDefault<Color>(
                                    widget.colorTrueFalse!
                                        ? Color(0xFF1D4ED8)
                                        : Color(0xFF6B7280),
                                    Colors.white,
                                  )
                                : Color(0xFF6B7280)),
                        Colors.white,
                      ),
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodySmall.fontStyle,
                    ),
              ),
            ),
            if (dateTimeFormat("yyyy-MM-dd", widget.date) ==
                dateTimeFormat("yyyy-MM-dd", getCurrentTimestamp))
              Icon(
                Icons.star,
                color: FlutterFlowTheme.of(context).accent1,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}
