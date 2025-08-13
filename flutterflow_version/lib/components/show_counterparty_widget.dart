import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/counterparty_comp_widget.dart';
import '/components/menu_bar_widget.dart';
import '/debt_control/create_debt_transaction/create_debt_transaction_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'show_counterparty_model.dart';
export 'show_counterparty_model.dart';

class ShowCounterpartyWidget extends StatefulWidget {
  const ShowCounterpartyWidget({
    super.key,
    this.callbackAction,
    required this.clikcedViewpoint,
  });

  final Future Function(String? callbackId, String? callbackName)?
      callbackAction;
  final String? clikcedViewpoint;

  @override
  State<ShowCounterpartyWidget> createState() => _ShowCounterpartyWidgetState();
}

class _ShowCounterpartyWidgetState extends State<ShowCounterpartyWidget> {
  late ShowCounterpartyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShowCounterpartyModel());

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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(36.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.menuBarModel,
              updateCallback: () => safeSetState(() {}),
              child: MenuBarWidget(
                menuName: 'Counterparty List',
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Choose Counterparty',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
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
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                      ),
                      FutureBuilder<List<CounterpartiesRow>>(
                        future: CounterpartiesTable().queryRows(
                          queryFn: (q) => q
                              .eqOrNull(
                                'company_id',
                                FFAppState().companyChoosen,
                              )
                              .order('name', ascending: true),
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 80.0,
                                height: 80.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<CounterpartiesRow> columnCounterpartiesRowList =
                              snapshot.data!;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                columnCounterpartiesRowList.length,
                                (columnIndex) {
                              final columnCounterpartiesRow =
                                  columnCounterpartiesRowList[columnIndex];
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (_model.clickedId ==
                                      columnCounterpartiesRow.counterpartyId) {
                                    _model.clickedId = '';
                                    safeSetState(() {});
                                  } else {
                                    _model.clickedId =
                                        columnCounterpartiesRow.counterpartyId;
                                    safeSetState(() {});
                                  }
                                },
                                child: CounterpartyCompWidget(
                                  key: Key(
                                      'Key3qi_${columnIndex}_of_${columnCounterpartiesRowList.length}'),
                                  clickedId: _model.clickedId,
                                  counterpartyInfo: columnCounterpartiesRow,
                                ),
                              );
                            }).divide(SizedBox(height: 8.0)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: FFButtonWidget(
                onPressed: !(_model.clickedId != null && _model.clickedId != ''
                        ? true
                        : false)
                    ? null
                    : () async {
                        if (_model.clickedId != null &&
                            _model.clickedId != '') {
                          _model.getdebtcard = await DebtControlGroup
                              .getsinglecounterpartyCall
                              .call(
                            pCompanyId: FFAppState().companyChoosen,
                            pCounterpartyId: _model.clickedId,
                            pStoreId: FFAppState().storeChoosen,
                          );

                          if ((_model.getdebtcard?.succeeded ?? true)) {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: CreateDebtTransactionWidget(
                                    debtCard:
                                        (_model.getdebtcard?.jsonBody ?? ''),
                                    viewpoint: widget.clikcedViewpoint!,
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('fail'),
                                  content: Text(
                                      (_model.getdebtcard?.jsonBody ?? '')
                                          .toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
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
                text: _model.clickedId != null && _model.clickedId != ''
                    ? 'Confirm'
                    : 'Choose Counterparty',
                options: FFButtonOptions(
                  width: 340.0,
                  height: 48.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconAlignment: IconAlignment.start,
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: _model.clickedId != null && _model.clickedId != ''
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.notoSansJp(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color:
                            _model.clickedId != null && _model.clickedId != ''
                                ? Colors.white
                                : FlutterFlowTheme.of(context).primaryText,
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
          ],
        ),
      ),
    );
  }
}
