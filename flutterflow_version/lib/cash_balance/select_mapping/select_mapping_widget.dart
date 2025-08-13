import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'select_mapping_model.dart';
export 'select_mapping_model.dart';

class SelectMappingWidget extends StatefulWidget {
  const SelectMappingWidget({
    super.key,
    this.transacDetail,
    this.cashLocationId,
    this.cashDifferences,
  });

  final dynamic transacDetail;
  final String? cashLocationId;
  final double? cashDifferences;

  @override
  State<SelectMappingWidget> createState() => _SelectMappingWidgetState();
}

class _SelectMappingWidgetState extends State<SelectMappingWidget> {
  late SelectMappingModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectMappingModel());

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
        color: FlutterFlowTheme.of(context).alternate,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed(CashEndingWidget.routeName);
                  },
                  text: 'Go Calculate Cash',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF4A90E2),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (widget.cashDifferences! > 0.0) {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Daily Error'),
                            content: Text(widget.cashDifferences.toString()),
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
                      _model.insertAtIndexInTransactionDetail(
                          0,
                          TransactionDetailStruct(
                            accountId: 'd4a7a16e-45a1-47fe-992b-ff807c8673f0',
                            description: 'Daily Error',
                            debit:
                                ((widget.cashDifferences!).abs()).toString(),
                            credit: '0',
                            counterpartyId: '',
                            amount: (widget.cashDifferences!).abs(),
                            cash: CashStruct(
                              cashLocationId: widget.cashLocationId,
                            ),
                          ));
                      safeSetState(() {});
                      _model.insertAtIndexInTransactionDetail(
                          1,
                          TransactionDetailStruct(
                            accountId: 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf',
                            description: 'Daily Error',
                            debit: '0',
                            credit:
                                ((widget.cashDifferences!).abs()).toString(),
                            counterpartyId: '',
                            amount: (widget.cashDifferences!).abs(),
                          ));
                      safeSetState(() {});
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            content: Text('more start'),
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
                      _model.errorAPImoreCash = await JournalEntryGroup
                          .insertjournalwitheverythingCall
                          .call(
                        pCompanyId: FFAppState().companyChoosen,
                        pStoreId: FFAppState().storeChoosen,
                        pEntryDate: getCurrentTimestamp.toString(),
                        pBaseAmount: (widget.cashDifferences!).abs(),
                        pLinesJson: _model.transactionDetail
                            .map((e) => e.toMap())
                            .toList(),
                        pCreatedBy: FFAppState().user.userId,
                      );

                      if ((_model.errorAPImoreCash?.succeeded ?? true)) {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Insert'),
                              content: Text('Success'),
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
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              content: Text(
                                  (_model.errorAPImoreCash?.jsonBody ?? '')
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
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Daily Error'),
                            content: Text(widget.cashDifferences.toString()),
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
                      _model.insertAtIndexInTransactionDetail(
                          0,
                          TransactionDetailStruct(
                            accountId: 'd4a7a16e-45a1-47fe-992b-ff807c8673f0',
                            description: 'Daily Error',
                            debit: '0',
                            credit:
                                ((widget.cashDifferences!).abs()).toString(),
                            counterpartyId: '',
                            amount: (widget.cashDifferences!).abs(),
                            cash: CashStruct(
                              cashLocationId: widget.cashLocationId,
                            ),
                          ));
                      safeSetState(() {});
                      _model.insertAtIndexInTransactionDetail(
                          1,
                          TransactionDetailStruct(
                            accountId: 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf',
                            description: 'Daily Error',
                            debit:
                                ((widget.cashDifferences!).abs()).toString(),
                            credit: '0',
                            counterpartyId: '',
                            amount: (widget.cashDifferences!).abs(),
                          ));
                      safeSetState(() {});
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            content: Text('less start'),
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
                      _model.errorAPIlessCash = await JournalEntryGroup
                          .insertjournalwitheverythingCall
                          .call(
                        pCompanyId: FFAppState().companyChoosen,
                        pStoreId: FFAppState().storeChoosen,
                        pEntryDate: getCurrentTimestamp.toString(),
                        pBaseAmount: (widget.cashDifferences!).abs(),
                        pLinesJson: _model.transactionDetail
                            .map((e) => e.toMap())
                            .toList(),
                        pCreatedBy: FFAppState().user.userId,
                      );

                      if ((_model.errorAPIlessCash?.succeeded ?? true)) {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Insert'),
                              content: Text('Success'),
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
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              content: Text(
                                  (_model.errorAPIlessCash?.jsonBody ?? '')
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

                    Navigator.pop(context);

                    safeSetState(() {});
                  },
                  text: 'Auto Journal Mapping',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF4A90E2),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
