import '/backend/supabase/supabase.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import '/jeong_work/popup/popup_widget.dart';
import '/role_permission/create_role_v1/create_role_v1_widget.dart';
import '/role_permission/role_permissio_component/role_permissio_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'role_permission_page_model.dart';
export 'role_permission_page_model.dart';

class RolePermissionPageWidget extends StatefulWidget {
  const RolePermissionPageWidget({super.key});

  static String routeName = 'rolePermissionPage';
  static String routePath = '/rolePermissionPage';

  @override
  State<RolePermissionPageWidget> createState() =>
      _RolePermissionPageWidgetState();
}

class _RolePermissionPageWidgetState extends State<RolePermissionPageWidget> {
  late RolePermissionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RolePermissionPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isLoading1 = false;
      FFAppState().isLoading2 = false;
      FFAppState().isLoading3 = false;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.menuBarModel,
                updateCallback: () => safeSetState(() {}),
                child: MenuBarWidget(
                  menuName: 'Role List',
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              40.0, 0.0, 40.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState()
                                              .user
                                              .companies
                                              .where((e) =>
                                                  FFAppState().companyChoosen ==
                                                  e.companyId)
                                              .toList()
                                              .firstOrNull
                                              ?.companyName,
                                          'CompanyName',
                                        ),
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.notoSansJp(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (FFAppState().isLoading1 == false) {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: Container(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.8,
                                                  child: PopupWidget(
                                                    popupTitle: 'Create Role',
                                                    widgetBuilder: () =>
                                                        CreateRoleV1Widget(
                                                      companyId: FFAppState()
                                                          .companyChoosen,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));

                                        FFAppState().isLoading1 = false;
                                        safeSetState(() {});
                                      }
                                    },
                                    child: wrapWithModel(
                                      model: _model.addModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: AddWidget(
                                        name: '+ Add role',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 0.0),
                          child:
                              FutureBuilder<List<ViewRolesWithPermissionsRow>>(
                            future: ViewRolesWithPermissionsTable().queryRows(
                              queryFn: (q) => q
                                  .eqOrNull(
                                    'company_id',
                                    FFAppState().companyChoosen,
                                  )
                                  .neqOrNull(
                                    'role_type',
                                    'owner',
                                  )
                                  .order('created_at', ascending: true),
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
                              List<ViewRolesWithPermissionsRow>
                                  listViewViewRolesWithPermissionsRowList =
                                  snapshot.data!;

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewViewRolesWithPermissionsRowList
                                        .length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 12.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewViewRolesWithPermissionsRow =
                                      listViewViewRolesWithPermissionsRowList[
                                          listViewIndex];
                                  return wrapWithModel(
                                    model: _model.debtControlComponentModels
                                        .getModel(
                                      listViewViewRolesWithPermissionsRow
                                          .roleId!,
                                      listViewIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: RolePermissioComponentWidget(
                                      key: Key(
                                        'Key4ch_${listViewViewRolesWithPermissionsRow.roleId!}',
                                      ),
                                      roleDetails:
                                          listViewViewRolesWithPermissionsRow,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
