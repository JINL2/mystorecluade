import '/cash_location/cash_location_part/cash_location_part_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cash_location_list_comp_widget.dart' show CashLocationListCompWidget;
import 'package:flutter/material.dart';

class CashLocationListCompModel
    extends FlutterFlowModel<CashLocationListCompWidget> {
  ///  Local state fields for this component.

  dynamic cashLocationByType;

  String? clickedLocationId;

  String? clickedType;

  String? selectedType;

  String? clickedLocationName;

  ///  State fields for stateful widgets in this component.

  // Models for cashLocationPart dynamic component.
  late FlutterFlowDynamicModels<CashLocationPartModel> cashLocationPartModels;

  @override
  void initState(BuildContext context) {
    cashLocationPartModels =
        FlutterFlowDynamicModels(() => CashLocationPartModel());
  }

  @override
  void dispose() {
    cashLocationPartModels.dispose();
  }
}
