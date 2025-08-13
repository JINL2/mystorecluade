import '/buttons/add_button/add_button_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/store_shift/store_shift_component/store_shift_component_widget.dart';
import 'store_shift_setting_widget.dart' show StoreShiftSettingWidget;
import 'package:flutter/material.dart';

class StoreShiftSettingModel extends FlutterFlowModel<StoreShiftSettingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for chooseStore widget.
  String? chooseStoreValue;
  FormFieldController<String>? chooseStoreValueController;
  // Model for add_button component.
  late AddButtonModel addButtonModel;
  // Models for StoreShiftComponent dynamic component.
  late FlutterFlowDynamicModels<StoreShiftComponentModel>
      storeShiftComponentModels;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    addButtonModel = createModel(context, () => AddButtonModel());
    storeShiftComponentModels =
        FlutterFlowDynamicModels(() => StoreShiftComponentModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    addButtonModel.dispose();
    storeShiftComponentModels.dispose();
  }
}
