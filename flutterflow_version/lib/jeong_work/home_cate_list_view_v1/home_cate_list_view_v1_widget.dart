import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/home_feature_v1/home_feature_v1_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_cate_list_view_v1_model.dart';
export 'home_cate_list_view_v1_model.dart';

class HomeCateListViewV1Widget extends StatefulWidget {
  const HomeCateListViewV1Widget({
    super.key,
    this.cateInfo,
  });

  final CategoryFeaturesStruct? cateInfo;

  @override
  State<HomeCateListViewV1Widget> createState() =>
      _HomeCateListViewV1WidgetState();
}

class _HomeCateListViewV1WidgetState extends State<HomeCateListViewV1Widget> {
  late HomeCateListViewV1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeCateListViewV1Model());

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
          Align(
            alignment: AlignmentDirectional(-1.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 0.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget.cateInfo?.categoryName,
                  'Category Name',
                ),
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.notoSansJp(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        child: Builder(
                          builder: (context) {
                            final categoryInfo = widget.cateInfo?.features
                                    .where((e) => functions.isListHaveString(
                                        e.featureId,
                                        FFAppState()
                                            .user
                                            .companies
                                            .where((e) =>
                                                FFAppState().companyChoosen ==
                                                e.companyId)
                                            .toList()
                                            .firstOrNull
                                            ?.role
                                            .permissions
                                            .toList())!)
                                    .toList()
                                    .sortedList(
                                        keyOf: (e) => e.featureName,
                                        desc: false)
                                    .toList() ??
                                [];

                            return GridView.builder(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                8.0,
                                0,
                                8.0,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                childAspectRatio: 1.0,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: categoryInfo.length,
                              itemBuilder: (context, categoryInfoIndex) {
                                final categoryInfoItem =
                                    categoryInfo[categoryInfoIndex];
                                return Visibility(
                                  visible: functions.isListHaveString(
                                          categoryInfoItem.featureId,
                                          FFAppState()
                                              .user
                                              .companies
                                              .where((e) =>
                                                  FFAppState().companyChoosen ==
                                                  e.companyId)
                                              .toList()
                                              .firstOrNull
                                              ?.role
                                              .permissions
                                              .toList()) ??
                                      true,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await actions.navigateToRoute(
                                        context,
                                        categoryInfoItem.route,
                                      );
                                    },
                                    child: wrapWithModel(
                                      model:
                                          _model.homeFeatureV1Models.getModel(
                                        categoryInfoItem.featureId,
                                        categoryInfoIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: HomeFeatureV1Widget(
                                        key: Key(
                                          'Keygqv_${categoryInfoItem.featureId}',
                                        ),
                                        featureInfo: categoryInfoItem,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ].divide(SizedBox(height: 12.0)),
      ),
    );
  }
}
