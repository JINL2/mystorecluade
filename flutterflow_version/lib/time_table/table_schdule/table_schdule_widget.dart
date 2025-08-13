import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/time_table/schdule_list/schdule_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'table_schdule_model.dart';
export 'table_schdule_model.dart';

class TableSchduleWidget extends StatefulWidget {
  const TableSchduleWidget({
    super.key,
    required this.filteredStore,
    required this.fileredApproval,
  });

  final String? filteredStore;
  final bool? fileredApproval;

  @override
  State<TableSchduleWidget> createState() => _TableSchduleWidgetState();
}

class _TableSchduleWidgetState extends State<TableSchduleWidget> {
  late TableSchduleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TableSchduleModel());

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
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Date',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'shop',
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Shift',
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.notoSansJp(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final shiftStatusDetail =
                  (widget.filteredStore != null && widget.filteredStore != ''
                          ? (widget.fileredApproval!
                              ? FFAppState()
                                  .shiftStatus
                                  .where((e) =>
                                      (widget.filteredStore == e.storeId) &&
                                      e.isApproved)
                                  .toList()
                              : FFAppState()
                                  .shiftStatus
                                  .where((e) =>
                                      (widget.filteredStore == e.storeId) &&
                                      !e.isApproved)
                                  .toList())
                          : (widget.fileredApproval!
                              ? FFAppState()
                                  .shiftStatus
                                  .where((e) => e.isApproved)
                                  .toList()
                              : FFAppState()
                                  .shiftStatus
                                  .where((e) => !e.isApproved)
                                  .toList()))
                      .toList();

              return ListView.separated(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: shiftStatusDetail.length,
                separatorBuilder: (_, __) => SizedBox(height: 4.0),
                itemBuilder: (context, shiftStatusDetailIndex) {
                  final shiftStatusDetailItem =
                      shiftStatusDetail[shiftStatusDetailIndex];
                  return wrapWithModel(
                    model: _model.schduleListModels.getModel(
                      shiftStatusDetailItem.shiftRequestId,
                      shiftStatusDetailIndex,
                    ),
                    updateCallback: () => safeSetState(() {}),
                    child: SchduleListWidget(
                      key: Key(
                        'Keyu3j_${shiftStatusDetailItem.shiftRequestId}',
                      ),
                      storeShift: shiftStatusDetailItem,
                      shiftId: shiftStatusDetailItem.shiftId,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
