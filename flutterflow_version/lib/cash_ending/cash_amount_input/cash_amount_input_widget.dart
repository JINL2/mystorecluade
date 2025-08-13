import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/cash_ending/cash_ending_component/cash_ending_component_widget.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cash_amount_input_model.dart';
export 'cash_amount_input_model.dart';

class CashAmountInputWidget extends StatefulWidget {
  const CashAmountInputWidget({
    super.key,
    this.currencyId,
    this.currencyDenominationData,
    this.currencyType,
    this.currencies,
  });

  final String? currencyId;
  final List<CurrencyDenominationsRow>? currencyDenominationData;
  final List<CurrencyTypesRow>? currencyType;
  final Future Function(CurrenciesStruct? currencies)? currencies;

  @override
  State<CashAmountInputWidget> createState() => _CashAmountInputWidgetState();
}

class _CashAmountInputWidgetState extends State<CashAmountInputWidget> {
  late CashAmountInputModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CashAmountInputModel());

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

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Cash Ending',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                  ),
                  Builder(
                    builder: (context) {
                      final currency =
                          widget.currencyDenominationData?.toList() ?? [];

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: currency.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.0),
                        itemBuilder: (context, currencyIndex) {
                          final currencyItem = currency[currencyIndex];
                          return CashEndingComponentWidget(
                            key: Key(
                                'Keyj9f_${currencyIndex}_of_${currency.length}'),
                            currencyDenomination: currencyItem,
                            denominationMapping: (denominationMapping) async {
                              if (functions.isListHaveDenominationDatatype(
                                  _model.denominations.toList(),
                                  denominationMapping?.denominationId)!) {
                                _model.denominations = functions
                                    .removeValuefromDenominationData(
                                        denominationMapping?.denominationId,
                                        denominationMapping?.quantity,
                                        _model.denominations.toList())!
                                    .toList()
                                    .cast<DenominationsStruct>();
                                safeSetState(() {});
                              } else {
                                _model.addToDenominations(denominationMapping!);
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
                        await widget.currencies?.call(
                          CurrenciesStruct(
                            currencyId: widget.currencyId,
                            denominations: _model.denominations,
                          ),
                        );
                        FFAppState().isLoading2 = false;
                        safeSetState(() {});
                        Navigator.pop(context);
                      }
                    },
                    text: 'Confirm',
                    options: FFButtonOptions(
                      width: 136.0,
                      height: 58.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.notoSansJp(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
        if ((FFAppState().isLoading1 == true) ||
            FFAppState().isLoading2 ||
            FFAppState().isLoading3)
          wrapWithModel(
            model: _model.isloadingModel,
            updateCallback: () => safeSetState(() {}),
            child: IsloadingWidget(),
          ),
      ],
    );
  }
}
