import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'counterparty_comp_model.dart';
export 'counterparty_comp_model.dart';

class CounterpartyCompWidget extends StatefulWidget {
  const CounterpartyCompWidget({
    super.key,
    this.counterpartyInfo,
    this.clickedId,
  });

  final CounterpartiesRow? counterpartyInfo;
  final String? clickedId;

  @override
  State<CounterpartyCompWidget> createState() => _CounterpartyCompWidgetState();
}

class _CounterpartyCompWidgetState extends State<CounterpartyCompWidget>
    with TickerProviderStateMixin {
  late CounterpartyCompModel _model;

  var hasContainerTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CounterpartyCompModel());

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.clickedId == widget.counterpartyInfo?.counterpartyId
            ? FlutterFlowTheme.of(context).accent1
            : Color(0x00000000),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: widget.clickedId == widget.counterpartyInfo?.counterpartyId
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: widget.counterpartyInfo!.isInternal
                      ? (widget.counterpartyInfo?.linkedCompanyId ==
                              FFAppState().companyChoosen
                          ? Color(0xFFDBE9FE)
                          : Color(0xFFDCFCE7))
                      : FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      widget.counterpartyInfo!.isInternal
                          ? (widget.counterpartyInfo?.linkedCompanyId ==
                                  FFAppState().companyChoosen
                              ? 'I'
                              : 'I')
                          : 'E',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: widget.counterpartyInfo!.isInternal
                                ? (widget.counterpartyInfo?.linkedCompanyId ==
                                        FFAppState().companyChoosen
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).success)
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget.counterpartyInfo?.name,
                            'Name',
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
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        Container(
                          height: 18.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                  ),
                  Container(
                    height: 18.0,
                    decoration: BoxDecoration(
                      color: widget.counterpartyInfo!.isInternal
                          ? (widget.counterpartyInfo?.linkedCompanyId ==
                                  FFAppState().companyChoosen
                              ? Color(0xFFDBE9FE)
                              : Color(0xFFDCFCE7))
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(6.0, 2.0, 6.0, 2.0),
                      child: Text(
                        widget.counterpartyInfo!.isInternal
                            ? (widget.counterpartyInfo?.linkedCompanyId ==
                                    FFAppState().companyChoosen
                                ? 'My Company'
                                : 'Internal')
                            : 'External',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.notoSansJp(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: widget.counterpartyInfo!.isInternal
                                  ? (widget.counterpartyInfo
                                              ?.linkedCompanyId ==
                                          FFAppState().companyChoosen
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).success)
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 11.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    ).animateOnActionTrigger(
        animationsMap['containerOnActionTriggerAnimation']!,
        hasBeenTriggered: hasContainerTriggered);
  }
}
