import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import 'create_store_f1_widget.dart' show CreateStoreF1Widget;
import 'package:flutter/material.dart';

class CreateStoreF1Model extends FlutterFlowModel<CreateStoreF1Widget> {
  ///  Local state fields for this component.

  List<StoresStruct> newStoreData = [];
  void addToNewStoreData(StoresStruct item) => newStoreData.add(item);
  void removeFromNewStoreData(StoresStruct item) => newStoreData.remove(item);
  void removeAtIndexFromNewStoreData(int index) => newStoreData.removeAt(index);
  void insertAtIndexInNewStoreData(int index, StoresStruct item) =>
      newStoreData.insert(index, item);
  void updateNewStoreDataAtIndex(int index, Function(StoresStruct) updateFn) =>
      newStoreData[index] = updateFn(newStoreData[index]);

  int? storeCount;

  String? storeId;

  String? storeCode;

  ///  State fields for stateful widgets in this component.

  // State field(s) for StoreName widget.
  FocusNode? storeNameFocusNode;
  TextEditingController? storeNameTextController;
  String? Function(BuildContext, String?)? storeNameTextControllerValidator;
  // State field(s) for StoreAddress widget.
  FocusNode? storeAddressFocusNode;
  TextEditingController? storeAddressTextController;
  String? Function(BuildContext, String?)? storeAddressTextControllerValidator;
  // State field(s) for StorePhone widget.
  FocusNode? storePhoneFocusNode;
  TextEditingController? storePhoneTextController;
  String? Function(BuildContext, String?)? storePhoneTextControllerValidator;
  // Model for add component.
  late AddModel addModel;
  // Stores action output result for [Backend Call - Insert Row] action in add widget.
  StoresRow? addstore;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    storeNameFocusNode?.dispose();
    storeNameTextController?.dispose();

    storeAddressFocusNode?.dispose();
    storeAddressTextController?.dispose();

    storePhoneFocusNode?.dispose();
    storePhoneTextController?.dispose();

    addModel.dispose();
  }
}
