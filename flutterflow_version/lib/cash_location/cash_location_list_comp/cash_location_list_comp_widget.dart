import '/cash_location/cash_location_part/cash_location_part_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cash_location_list_comp_model.dart';
export 'cash_location_list_comp_model.dart';

class CashLocationListCompWidget extends StatefulWidget {
  const CashLocationListCompWidget({
    super.key,
    this.cashLocationByType,
    bool? isChooseCash,
    this.callbackAction,
  }) : this.isChooseCash = isChooseCash ?? false;

  final dynamic cashLocationByType;
  final bool isChooseCash;
  final Future Function(String? callbackId, String? callbackName)?
      callbackAction;

  @override
  State<CashLocationListCompWidget> createState() =>
      _CashLocationListCompWidgetState();
}

class _CashLocationListCompWidgetState
    extends State<CashLocationListCompWidget> {
  late CashLocationListCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CashLocationListCompModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isSelectedId = '';
      safeSetState(() {});
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

    return Visibility(
      visible: functions.convertJsonToString(getJsonField(
            widget.cashLocationByType,
            r'''$.count''',
          )) !=
          '0',
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    getJsonField(
                      widget.cashLocationByType,
                      r'''$.icon''',
                    ).toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    getJsonField(
                      widget.cashLocationByType,
                      r'''$.label''',
                    ).toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF6B7280),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
            ),
            Builder(
              builder: (context) {
                final partDetail = getJsonField(
                  widget.cashLocationByType,
                  r'''$.items''',
                ).toList();

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(partDetail.length, (partDetailIndex) {
                    final partDetailItem = partDetail[partDetailIndex];
                    return InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (functions.convertJsonToString(getJsonField(
                              partDetailItem,
                              r'''$.cash_location_id''',
                            )) ==
                            FFAppState().isSelectedId) {
                          FFAppState().isSelectedId = '';
                          safeSetState(() {});
                          _model.clickedLocationId = '';
                          safeSetState(() {});
                          _model.clickedLocationName = null;
                          safeSetState(() {});
                        } else {
                          FFAppState().isSelectedId = getJsonField(
                            partDetailItem,
                            r'''$.cash_location_id''',
                          ).toString();
                          safeSetState(() {});
                          _model.clickedLocationId = getJsonField(
                            partDetailItem,
                            r'''$.cash_location_id''',
                          ).toString();
                          safeSetState(() {});
                          _model.clickedLocationName = getJsonField(
                            partDetailItem,
                            r'''$.location_name''',
                          ).toString();
                          safeSetState(() {});
                        }

                        await widget.callbackAction?.call(
                          _model.clickedLocationId,
                          _model.clickedLocationName,
                        );
                      },
                      child: wrapWithModel(
                        model: _model.cashLocationPartModels.getModel(
                          partDetailItem.toString(),
                          partDetailIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: CashLocationPartWidget(
                          key: Key(
                            'Keyty1_${partDetailItem.toString()}',
                          ),
                          cashLocationPart: partDetailItem,
                          isChooseCash: false,
                          clickedId: getJsonField(
                            partDetailItem,
                            r'''$.cash_location_id''',
                          ).toString(),
                        ),
                      ),
                    );
                  }).divide(SizedBox(height: 8.0)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
