import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import '/jeong_work/drawer_list_view/drawer_list_view_widget.dart';
import '/jeong_work/home_cate_list_view_v1/home_cate_list_view_v1_widget.dart';
import '/index.dart';
import 'homepage_widget.dart' show HomepageWidget;
import 'package:flutter/material.dart';

class HomepageModel extends FlutterFlowModel<HomepageWidget> {
  ///  Local state fields for this page.

  bool? firstLogIn;

  bool? companyclicked;

  bool? storeclicked;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getUserCompanies)] action in homepage widget.
  ApiCallResponse? userinformation1;
  // Stores action output result for [Backend Call - API (getCategoriesWithFeatures)] action in homepage widget.
  ApiCallResponse? usercategory1;
  // Stores action output result for [Backend Call - API (getUserCompanies)] action in homepage widget.
  ApiCallResponse? userinformation2;
  // Stores action output result for [Backend Call - API (getCategoriesWithFeatures)] action in homepage widget.
  ApiCallResponse? usercate;
  // Models for DrawerListView dynamic component.
  late FlutterFlowDynamicModels<DrawerListViewModel> drawerListViewModels;
  // Model for addCompany.
  late AddModel addCompanyModel;
  // Model for addStore.
  late AddModel addStoreModel;
  // Model for addByCode.
  late AddModel addByCodeModel;
  // Model for showCode.
  late AddModel showCodeModel;
  // Stores action output result for [Backend Call - API (getUserCompanies)] action in Icon widget.
  ApiCallResponse? apiuser;
  // Stores action output result for [Backend Call - API (getCategoriesWithFeatures)] action in Icon widget.
  ApiCallResponse? apicategory;
  // Models for HomeCateListViewV1 dynamic component.
  late FlutterFlowDynamicModels<HomeCateListViewV1Model>
      homeCateListViewV1Models;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    drawerListViewModels =
        FlutterFlowDynamicModels(() => DrawerListViewModel());
    addCompanyModel = createModel(context, () => AddModel());
    addStoreModel = createModel(context, () => AddModel());
    addByCodeModel = createModel(context, () => AddModel());
    showCodeModel = createModel(context, () => AddModel());
    homeCateListViewV1Models =
        FlutterFlowDynamicModels(() => HomeCateListViewV1Model());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    drawerListViewModels.dispose();
    addCompanyModel.dispose();
    addStoreModel.dispose();
    addByCodeModel.dispose();
    showCodeModel.dispose();
    homeCateListViewV1Models.dispose();
    isloadingModel.dispose();
  }
}
