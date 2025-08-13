import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/debt_control/counterparty_view_point/counterparty_view_point_widget.dart';
import '/debt_control/debt_overview/debt_overview_widget.dart';
import '/debt_control/select_my_perspective/select_my_perspective_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'debt_control_widget.dart' show DebtControlWidget;
import 'package:flutter/material.dart';

class DebtControlModel extends FlutterFlowModel<DebtControlWidget> {
  ///  Local state fields for this page.

  String viewpoint = 'company';

  List<DebtOverviewStruct> debtOverview = [];
  void addToDebtOverview(DebtOverviewStruct item) => debtOverview.add(item);
  void removeFromDebtOverview(DebtOverviewStruct item) =>
      debtOverview.remove(item);
  void removeAtIndexFromDebtOverview(int index) => debtOverview.removeAt(index);
  void insertAtIndexInDebtOverview(int index, DebtOverviewStruct item) =>
      debtOverview.insert(index, item);
  void updateDebtOverviewAtIndex(
          int index, Function(DebtOverviewStruct) updateFn) =>
      debtOverview[index] = updateFn(debtOverview[index]);

  String filter = 'all';

  dynamic counterpartyMatrix;

  String? clickedCounterparty;

  String? currentViewpointName;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (debtOverview)] action in debtControl widget.
  ApiCallResponse? debtOverviewapi;
  // Stores action output result for [Backend Call - API (getcounterpartymatrix)] action in debtControl widget.
  ApiCallResponse? counterpartyMatrixapi;
  // Model for DebtContro.
  late MenuBarModel debtControModel;
  // Model for selectMyPerspective component.
  late SelectMyPerspectiveModel selectMyPerspectiveModel;
  // Model for debt_overview component.
  late DebtOverviewModel debtOverviewModel;
  // Model for counterpartyViewPoint component.
  late CounterpartyViewPointModel counterpartyViewPointModel;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    debtControModel = createModel(context, () => MenuBarModel());
    selectMyPerspectiveModel =
        createModel(context, () => SelectMyPerspectiveModel());
    debtOverviewModel = createModel(context, () => DebtOverviewModel());
    counterpartyViewPointModel =
        createModel(context, () => CounterpartyViewPointModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    debtControModel.dispose();
    selectMyPerspectiveModel.dispose();
    debtOverviewModel.dispose();
    counterpartyViewPointModel.dispose();
    isloadingModel.dispose();
  }
}
