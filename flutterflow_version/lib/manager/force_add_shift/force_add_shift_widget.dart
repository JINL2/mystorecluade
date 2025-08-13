import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'force_add_shift_model.dart';
export 'force_add_shift_model.dart';

class ForceAddShiftWidget extends StatefulWidget {
  const ForceAddShiftWidget({
    super.key,
    this.storeId,
  });

  final String? storeId;

  @override
  State<ForceAddShiftWidget> createState() => _ForceAddShiftWidgetState();
}

class _ForceAddShiftWidgetState extends State<ForceAddShiftWidget> {
  late ForceAddShiftModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForceAddShiftModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedDate = getCurrentTimestamp;
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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 5,
                  child: FFButtonWidget(
                    onPressed: () async {
                      _model.selectedDate = getCurrentTimestamp;
                      safeSetState(() {});
                      // selectTime
                      await showModalBottomSheet<bool>(
                          context: context,
                          builder: (context) {
                            final _datePickedCupertinoTheme =
                                CupertinoTheme.of(context);
                            return ScrollConfiguration(
                              behavior: const MaterialScrollBehavior().copyWith(
                                dragDevices: {
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.stylus,
                                  PointerDeviceKind.unknown
                                },
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                child: CupertinoTheme(
                                  data: _datePickedCupertinoTheme.copyWith(
                                    textTheme: _datePickedCupertinoTheme
                                        .textTheme
                                        .copyWith(
                                      dateTimePickerTextStyle: FlutterFlowTheme
                                              .of(context)
                                          .headlineMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    minimumDate: DateTime(1900),
                                    initialDateTime: getCurrentTimestamp,
                                    maximumDate: DateTime(2050),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    use24hFormat: false,
                                    onDateTimeChanged: (newDateTime) =>
                                        safeSetState(() {
                                      _model.datePicked = newDateTime;
                                    }),
                                  ),
                                ),
                              ),
                            );
                          });
                      _model.selectedDate = _model.datePicked;
                      safeSetState(() {});
                    },
                    text: 'choose Time ',
                    options: FFButtonOptions(
                      height: 40.0,
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
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    dateTimeFormat("yyyy-MM-dd", _model.selectedDate),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterFlowDropDown<String>(
                  controller: _model.storeDropdownValueController ??=
                      FormFieldController<String>(
                    _model.storeDropdownValue ??= '',
                  ),
                  options: List<String>.from(FFAppState()
                      .user
                      .companies
                      .where((e) => FFAppState().companyChoosen == e.companyId)
                      .toList()
                      .firstOrNull!
                      .stores
                      .map((e) => e.storeId)
                      .toList()),
                  optionLabels: FFAppState()
                      .user
                      .companies
                      .where((e) => FFAppState().companyChoosen == e.companyId)
                      .toList()
                      .firstOrNull!
                      .stores
                      .map((e) => e.storeName)
                      .toList(),
                  onChanged: (val) =>
                      safeSetState(() => _model.storeDropdownValue = val),
                  width: 200.0,
                  height: 40.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.notoSansJp(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  hintText: 'Select Store',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  elevation: 2.0,
                  borderColor: FlutterFlowTheme.of(context).primary,
                  borderWidth: 0.5,
                  borderRadius: 8.0,
                  margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  hidesUnderline: true,
                  isOverButton: false,
                  isSearchable: false,
                  isMultiSelect: false,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_model.storeDropdownValue != null &&
                    _model.storeDropdownValue != '')
                  FlutterFlowDropDown<String>(
                    controller: _model.shiftDropDownValueController ??=
                        FormFieldController<String>(
                      _model.shiftDropDownValue ??= '',
                    ),
                    options: List<String>.from(FFAppState()
                        .shiftMetaData
                        .where((e) => _model.storeDropdownValue == e.storeId)
                        .toList()
                        .map((e) => e.shiftId)
                        .toList()),
                    optionLabels: FFAppState()
                        .shiftMetaData
                        .where((e) => _model.storeDropdownValue == e.storeId)
                        .toList()
                        .map((e) => e.shiftName)
                        .toList(),
                    onChanged: (val) =>
                        safeSetState(() => _model.shiftDropDownValue = val),
                    width: 200.0,
                    height: 40.0,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.notoSansJp(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    hintText: 'Select Shift',
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    elevation: 2.0,
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderWidth: 0.5,
                    borderRadius: 8.0,
                    margin:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    hidesUnderline: true,
                    isOverButton: false,
                    isSearchable: false,
                    isMultiSelect: false,
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_model.shiftDropDownValue != null &&
                    _model.shiftDropDownValue != '')
                  FutureBuilder<List<VUserStoresRow>>(
                    future: VUserStoresTable().queryRows(
                      queryFn: (q) => q.eqOrNull(
                        'store_id',
                        _model.storeDropdownValue,
                      ),
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
                      List<VUserStoresRow> userIdDropdownVUserStoresRowList =
                          snapshot.data!;

                      return FlutterFlowDropDown<String>(
                        controller: _model.userIdDropdownValueController ??=
                            FormFieldController<String>(
                          _model.userIdDropdownValue ??= '',
                        ),
                        options: List<String>.from(
                            userIdDropdownVUserStoresRowList
                                .map((e) => e.userId)
                                .withoutNulls
                                .toList()),
                        optionLabels: userIdDropdownVUserStoresRowList
                            .map((e) => e.userFullname)
                            .withoutNulls
                            .toList(),
                        onChanged: (val) async {
                          safeSetState(() => _model.userIdDropdownValue = val);
                          _model.chooseUserName =
                              userIdDropdownVUserStoresRowList
                                  .where((e) =>
                                      _model.userIdDropdownValue == e.userId)
                                  .toList()
                                  .firstOrNull
                                  ?.userFullname;
                          safeSetState(() {});
                        },
                        width: 200.0,
                        height: 40.0,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.notoSansJp(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                        hintText: 'Choose Employee',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).primary,
                        borderWidth: 0.5,
                        borderRadius: 8.0,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      );
                    },
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (functions.managerShiftIsHaveData(
                            FFAppState().managerShiftDetail.toList(),
                            functions
                                .changeDateTimeToString(_model.selectedDate),
                            _model.shiftDropDownValue,
                            _model.userIdDropdownValue,
                            _model.storeDropdownValue)) {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Fail'),
                                content: Text('Already Have It'),
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
                                content: Text('start'),
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
                          _model.createmanagershift =
                              await ShiftRequestsTable().insert({
                            'user_id': _model.userIdDropdownValue,
                            'shift_id': _model.shiftDropDownValue,
                            'store_id': _model.storeDropdownValue,
                            'request_date':
                                supaSerialize<DateTime>(_model.selectedDate),
                            'is_approved': true,
                            'approved_by': FFAppState().user.userId,
                            'updated_at':
                                supaSerialize<DateTime>(getCurrentTimestamp),
                            'start_time': supaSerialize<DateTime>(
                                functions.changeStringToDateTime(FFAppState()
                                    .shiftMetaData
                                    .where((e) =>
                                        _model.shiftDropDownValue == e.shiftId)
                                    .toList()
                                    .firstOrNull
                                    ?.startTime)),
                            'end_time': supaSerialize<DateTime>(
                                functions.changeStringToDateTime(FFAppState()
                                    .shiftMetaData
                                    .where((e) =>
                                        _model.shiftDropDownValue == e.shiftId)
                                    .toList()
                                    .firstOrNull
                                    ?.endTime)),
                          });
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text(
                                    _model.createmanagershift!.shiftRequestId),
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
                          _model.newManageShiftData =
                              await actions.createUserIdByShiftReuqestId(
                            FFAppState().managerShiftDetail.toList(),
                            functions.changeDateTimeToString(_model.datePicked),
                            _model.shiftDropDownValue,
                            _model.userIdDropdownValue,
                            _model.chooseUserName,
                            _model.createmanagershift?.shiftRequestId,
                            _model.storeDropdownValue,
                            FFAppState()
                                .shiftMetaData
                                .where((e) =>
                                    _model.shiftDropDownValue == e.shiftId)
                                .toList()
                                .firstOrNull
                                ?.shiftName,
                          );
                          FFAppState().managerShiftDetail = _model
                              .newManageShiftData!
                              .toList()
                              .cast<ManagerShiftDetailStruct>();
                          safeSetState(() {});
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Create New Shift'),
                                content: Text('Succeess'),
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

                        Navigator.pop(context);

                        safeSetState(() {});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 40.0,
                          ),
                          Text(
                            'Confirm',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ].divide(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
