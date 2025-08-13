import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/bank_vault_ending/vault_currency_textfield/vault_currency_textfield_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'vault_currency_list_view_model.dart';
export 'vault_currency_list_view_model.dart';

class VaultCurrencyListViewWidget extends StatefulWidget {
  const VaultCurrencyListViewWidget({
    super.key,
    this.companyId,
    this.currencyId,
    this.vaultAmountLine,
  });

  final String? companyId;
  final String? currencyId;
  final Future Function(List<VaultAmountLineStruct> vaultAmountLine)?
      vaultAmountLine;

  @override
  State<VaultCurrencyListViewWidget> createState() =>
      _VaultCurrencyListViewWidgetState();
}

class _VaultCurrencyListViewWidgetState
    extends State<VaultCurrencyListViewWidget> {
  late VaultCurrencyListViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VaultCurrencyListViewModel());

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vault Ending',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.notoSansJp(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                ),
          ),
          FutureBuilder<List<CurrencyDenominationsRow>>(
            future: CurrencyDenominationsTable().queryRows(
              queryFn: (q) => q
                  .eqOrNull(
                    'currency_id',
                    widget.currencyId,
                  )
                  .eqOrNull(
                    'company_id',
                    widget.companyId,
                  )
                  .order('value'),
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
              List<CurrencyDenominationsRow>
                  listViewCurrencyDenominationsRowList = snapshot.data!;

              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: listViewCurrencyDenominationsRowList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewCurrencyDenominationsRow =
                      listViewCurrencyDenominationsRowList[listViewIndex];
                  return VaultCurrencyTextfieldWidget(
                    key: Key(
                        'Keysc4_${listViewIndex}_of_${listViewCurrencyDenominationsRowList.length}'),
                    denominationValue:
                        listViewCurrencyDenominationsRow.value.toString(),
                    denominationId:
                        listViewCurrencyDenominationsRow.denominationId,
                    vaultAmountRow: (vaultAmountRow) async {
                      if (functions.isListHaveVaultAmountLineData(
                          _model.vaultAmountLine.toList(),
                          listViewCurrencyDenominationsRow.denominationId)!) {
                        _model.vaultAmountLine = functions
                            .removeValuefromVaultData(
                                listViewCurrencyDenominationsRow.denominationId,
                                _model.vaultAmountLine.toList(),
                                vaultAmountRow?.quantity)!
                            .toList()
                            .cast<VaultAmountLineStruct>();
                        safeSetState(() {});
                      } else {
                        _model.addToVaultAmountLine(vaultAmountRow!);
                        safeSetState(() {});
                      }
                    },
                  );
                },
              );
            },
          ),
          FFButtonWidget(
            onPressed: () async {
              if (FFAppState().isLoading2 == false) {
                FFAppState().isLoading2 = true;
                safeSetState(() {});
                await widget.vaultAmountLine?.call(
                  _model.vaultAmountLine,
                );
                FFAppState().isLoading2 = false;
                safeSetState(() {});
                Navigator.pop(context);
              }
            },
            text: 'Confirm',
            options: FFButtonOptions(
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.notoSansJp(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: Colors.white,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ]
            .divide(SizedBox(height: 12.0))
            .addToStart(SizedBox(height: 20.0))
            .addToEnd(SizedBox(height: 20.0)),
      ),
    );
  }
}
