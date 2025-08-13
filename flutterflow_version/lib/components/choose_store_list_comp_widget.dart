import '/components/choose_store_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'choose_store_list_comp_model.dart';
export 'choose_store_list_comp_model.dart';

class ChooseStoreListCompWidget extends StatefulWidget {
  const ChooseStoreListCompWidget({
    super.key,
    this.callbackAction,
    this.choosenCompany,
  });

  final Future Function(String callbackId, String? choosenName)? callbackAction;
  final String? choosenCompany;

  @override
  State<ChooseStoreListCompWidget> createState() =>
      _ChooseStoreListCompWidgetState();
}

class _ChooseStoreListCompWidgetState extends State<ChooseStoreListCompWidget> {
  late ChooseStoreListCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChooseStoreListCompModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.companyName = valueOrDefault<String>(
        FFAppState()
            .user
            .companies
            .where((e) => e.companyId == widget.choosenCompany)
            .toList()
            .firstOrNull
            ?.companyName,
        'Error',
      );
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '🏢',
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
                    valueOrDefault<String>(
                      _model.companyName,
                      'Error',
                    ),
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
                final storeList = FFAppState()
                        .user
                        .companies
                        .where((e) => e.companyId == widget.choosenCompany)
                        .toList()
                        .firstOrNull
                        ?.stores
                        .toList() ??
                    [];

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(storeList.length, (storeListIndex) {
                      final storeListItem = storeList[storeListIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (_model.choosenId == storeListItem.storeId) {
                            _model.choosenId = null;
                            _model.choosenName = null;
                            safeSetState(() {});
                          } else {
                            _model.choosenId = storeListItem.storeId;
                            _model.choosenName = storeListItem.storeName;
                            safeSetState(() {});
                          }
                        },
                        child: ChooseStoreCompWidget(
                          key: Key(
                              'Keypla_${storeListIndex}_of_${storeList.length}'),
                          storeInformation: storeListItem,
                          companyName: _model.companyName,
                          selectedId: _model.choosenId,
                        ),
                      );
                    }).divide(SizedBox(height: 8.0)),
                  ),
                );
              },
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: FFButtonWidget(
                  onPressed:
                      (_model.choosenId == null || _model.choosenId == '')
                          ? null
                          : () async {
                              await widget.callbackAction?.call(
                                _model.choosenId!,
                                _model.choosenName,
                              );
                              Navigator.pop(context);
                            },
                  text: _model.choosenId != null && _model.choosenId != ''
                      ? 'Confirm'
                      : 'Choose Stores',
                  options: FFButtonOptions(
                    width: 340.0,
                    height: 48.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconAlignment: IconAlignment.start,
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: _model.choosenId != null && _model.choosenId != ''
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
