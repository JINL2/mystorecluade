import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'counterparty_view_point_model.dart';
export 'counterparty_view_point_model.dart';

class CounterpartyViewPointWidget extends StatefulWidget {
  const CounterpartyViewPointWidget({
    super.key,
    this.counterpartyViewpoint,
  });

  final Future Function(String counterpartyViewpoint)? counterpartyViewpoint;

  @override
  State<CounterpartyViewPointWidget> createState() =>
      _CounterpartyViewPointWidgetState();
}

class _CounterpartyViewPointWidgetState
    extends State<CounterpartyViewPointWidget> {
  late CounterpartyViewPointModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CounterpartyViewPointModel());

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
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.counterpartyViewpoint = 'company';
                safeSetState(() {});
                await widget.counterpartyViewpoint?.call(
                  'all',
                );
              },
              child: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  color: _model.counterpartyViewpoint == 'company'
                      ? Color(0xFF3B82F6)
                      : FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Company',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: _model.counterpartyViewpoint == 'company'
                                ? Colors.white
                                : Color(0xFF6B7280),
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
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.counterpartyViewpoint = 'store';
                safeSetState(() {});
                await widget.counterpartyViewpoint?.call(
                  'group',
                );
              },
              child: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  color: _model.counterpartyViewpoint == 'store'
                      ? Color(0xFF3B82F6)
                      : FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Internal',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: _model.counterpartyViewpoint == 'store'
                                ? Colors.white
                                : Color(0xFF6B7280),
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
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.counterpartyViewpoint = 'external';
                safeSetState(() {});
                await widget.counterpartyViewpoint?.call(
                  'external',
                );
              },
              child: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  color: _model.counterpartyViewpoint == 'external'
                      ? Color(0xFF3B82F6)
                      : FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'External',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: _model.counterpartyViewpoint == 'external'
                                ? Colors.white
                                : Color(0xFF6B7280),
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
              ),
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }
}
