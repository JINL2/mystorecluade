import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/transaction_history/transaction_detail/transaction_detail_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_history_model.dart';
export 'transaction_history_model.dart';

class TransactionHistoryWidget extends StatefulWidget {
  const TransactionHistoryWidget({super.key});

  static String routeName = 'transactionHistory';
  static String routePath = '/transactionHistory';

  @override
  State<TransactionHistoryWidget> createState() =>
      _TransactionHistoryWidgetState();
}

class _TransactionHistoryWidgetState extends State<TransactionHistoryWidget> {
  late TransactionHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionHistoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isLoading1 = true;
      FFAppState().offest = 0;
      safeSetState(() {});
      if (FFAppState().storeChoosen != '') {
        _model.onlystore = await GetjournalLineCall.call(
          storeId: FFAppState().storeChoosen,
          rangeHeader: functions.generateRangeHeader(
              FFAppState().offest, FFAppState().limit),
          companyId: FFAppState().companyChoosen,
        );

        if ((_model.onlystore?.succeeded ?? true)) {
          _model.journalEntriesId = GetjournalLineCall.journalId(
            (_model.onlystore?.jsonBody ?? ''),
          )!
              .toList()
              .cast<String>();
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Fail'),
                content: Text('Call Journal'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        _model.apiResulty0a = await GetjournalLineCall.call(
          companyId: FFAppState().companyChoosen,
          rangeHeader: functions.generateRangeHeader(
              FFAppState().offest, FFAppState().limit),
          storeId: null,
        );

        if ((_model.apiResulty0a?.succeeded ?? true)) {
          _model.journalEntriesId = GetjournalLineCall.journalId(
            (_model.apiResulty0a?.jsonBody ?? ''),
          )!
              .toList()
              .cast<String>();
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Fail'),
                content: Text('Call Journal'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      }

      FFAppState().isLoading1 = false;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.menuBarModel,
                    updateCallback: () => safeSetState(() {}),
                    child: MenuBarWidget(
                      menuName: 'Transaction Template',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Text(
                                    'Transaction History',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.notoSansJp(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 16.0),
                                child: Builder(
                                  builder: (context) {
                                    final journalId =
                                        _model.journalEntriesId.toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: journalId.length,
                                      itemBuilder: (context, journalIdIndex) {
                                        final journalIdItem =
                                            journalId[journalIdIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 8.0),
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            elevation: 1.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            TransactionDetailWidget(
                                                          key: Key(
                                                              'Keyuv2_${journalIdIndex}_of_${journalId.length}'),
                                                          jounrlEntryId:
                                                              journalIdItem,
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  FFAppState().offest =
                                      FFAppState().offest + 10;
                                  safeSetState(() {});
                                  FFAppState().rangeHeader =
                                      functions.generateRangeHeader(
                                          FFAppState().offest,
                                          FFAppState().limit);
                                  safeSetState(() {});
                                  if (FFAppState().storeChoosen != '') {
                                    _model.getnewlistforStore =
                                        await GetjournalLineCall.call(
                                      storeId: FFAppState().storeChoosen,
                                      rangeHeader: FFAppState().rangeHeader,
                                      companyId: FFAppState().companyChoosen,
                                    );

                                    if ((_model.onlystore?.succeeded ?? true)) {
                                      _model.journalEntriesId = functions
                                          .mergeStringListToStringList(
                                              _model.journalEntriesId.toList(),
                                              GetjournalLineCall.journalId(
                                                (_model.getnewlistforStore
                                                        ?.jsonBody ??
                                                    ''),
                                              )!
                                                  .toList())
                                          .toList()
                                          .cast<String>();
                                      safeSetState(() {});
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Fail'),
                                            content: Text('Call Journal'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    _model.getnewlistforCompany =
                                        await GetjournalLineCall.call(
                                      companyId: FFAppState().companyChoosen,
                                      rangeHeader: FFAppState().rangeHeader,
                                      storeId: null,
                                    );

                                    if ((_model.apiResulty0a?.succeeded ??
                                        true)) {
                                      _model.journalEntriesId = functions
                                          .mergeStringListToStringList(
                                              _model.journalEntriesId.toList(),
                                              GetjournalLineCall.journalId(
                                                (_model.getnewlistforCompany
                                                        ?.jsonBody ??
                                                    ''),
                                              )!
                                                  .toList())
                                          .toList()
                                          .cast<String>();
                                      safeSetState(() {});
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Fail'),
                                            content: Text('Call Journal'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
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
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 60.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          ),
        ),
      ),
    );
  }
}
