import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/manager/shift_detail/shift_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'managershift_list_model.dart';
export 'managershift_list_model.dart';

class ManagershiftListWidget extends StatefulWidget {
  const ManagershiftListWidget({
    super.key,
    this.storeId,
    this.okswitch,
  });

  final String? storeId;
  final bool? okswitch;

  @override
  State<ManagershiftListWidget> createState() => _ManagershiftListWidgetState();
}

class _ManagershiftListWidgetState extends State<ManagershiftListWidget> {
  late ManagershiftListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManagershiftListModel());

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
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final managerShift =
                    (widget.storeId != null && widget.storeId != ''
                            ? FFAppState()
                                .managerShiftDetail
                                .where((e) =>
                                    (widget.storeId == e.storeId) &&
                                    (widget.okswitch ==
                                        (e.totalRequired > e.totalApproved)))
                                .toList()
                                .sortedList(
                                    keyOf: (e) => e.requestDate, desc: false)
                            : FFAppState().managerShiftDetail.sortedList(
                                keyOf: (e) => e.requestDate, desc: false))
                        .toList();

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: managerShift.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.0),
                  itemBuilder: (context, managerShiftIndex) {
                    final managerShiftItem = managerShift[managerShiftIndex];
                    return Visibility(
                      visible: managerShiftItem.totalApproved != 0,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7.0,
                              color: Color(0x1A000000),
                              offset: Offset(
                                0.0,
                                1.0,
                              ),
                              spreadRadius: 4.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 12.0, 12.0, 12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${managerShiftItem.requestDate}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Builder(
                                builder: (context) {
                                  final shiftName = managerShiftItem.shifts
                                      .sortedList(
                                          keyOf: (e) => e.shiftName,
                                          desc: false)
                                      .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: shiftName.length,
                                    itemBuilder: (context, shiftNameIndex) {
                                      final shiftNameItem =
                                          shiftName[shiftNameIndex];
                                      return ShiftDetailWidget(
                                        key: Key(
                                            'Keyv1r_${shiftNameIndex}_of_${shiftName.length}'),
                                        storeId: managerShiftItem.storeId,
                                        shifName: valueOrDefault<String>(
                                          shiftNameItem.shiftName,
                                          'Shift Name',
                                        ),
                                        managerDetail: managerShiftItem,
                                        approved:
                                            shiftNameItem.approvedEmployees,
                                        fullShift:
                                            managerShiftItem.totalRequired <
                                                managerShiftItem.totalApproved,
                                      );
                                    },
                                  );
                                },
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ].divide(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
