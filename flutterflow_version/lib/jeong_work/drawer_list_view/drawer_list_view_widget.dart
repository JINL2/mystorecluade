import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/drawer_company_name/drawer_company_name_widget.dart';
import '/jeong_work/drawer_store/drawer_store_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'drawer_list_view_model.dart';
export 'drawer_list_view_model.dart';

class DrawerListViewWidget extends StatefulWidget {
  const DrawerListViewWidget({
    super.key,
    this.companyInfo,
  });

  final CompaniesStruct? companyInfo;

  @override
  State<DrawerListViewWidget> createState() => _DrawerListViewWidgetState();
}

class _DrawerListViewWidgetState extends State<DrawerListViewWidget> {
  late DrawerListViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DrawerListViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                FFAppState().companyChoosen = widget.companyInfo!.companyId;
                FFAppState().storeChoosen = '';
                safeSetState(() {});

                context.pushNamed(
                  HomepageWidget.routeName,
                  queryParameters: {
                    'companyclicked': serializeParam(
                      true,
                      ParamType.bool,
                    ),
                  }.withoutNulls,
                );
              },
              child: wrapWithModel(
                model: _model.drawerCompanyNameModel,
                updateCallback: () => safeSetState(() {}),
                child: DrawerCompanyNameWidget(
                  companyInfo: widget.companyInfo,
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final storeInfo = widget.companyInfo?.stores.toList() ?? [];

              return ListView.separated(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: storeInfo.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.0),
                itemBuilder: (context, storeInfoIndex) {
                  final storeInfoItem = storeInfo[storeInfoIndex];
                  return InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      FFAppState().storeChoosen = storeInfoItem.storeId;
                      FFAppState().companyChoosen =
                          widget.companyInfo!.companyId;
                      safeSetState(() {});

                      context.pushNamed(
                        HomepageWidget.routeName,
                        queryParameters: {
                          'storeclicked': serializeParam(
                            true,
                            ParamType.bool,
                          ),
                        }.withoutNulls,
                      );
                    },
                    child: wrapWithModel(
                      model: _model.drawerStoreModels.getModel(
                        storeInfoItem.storeId,
                        storeInfoIndex,
                      ),
                      updateCallback: () => safeSetState(() {}),
                      child: DrawerStoreWidget(
                        key: Key(
                          'Key769_${storeInfoItem.storeId}',
                        ),
                        companyInfo: widget.companyInfo,
                        storeInfo: storeInfoItem,
                      ),
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
