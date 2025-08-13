import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/components/show_counterparty_widget.dart';
import '/debt_control/counterparty_card/counterparty_card_widget.dart';
import '/debt_control/counterparty_view_point/counterparty_view_point_widget.dart';
import '/debt_control/debt_overview/debt_overview_widget.dart';
import '/debt_control/select_my_perspective/select_my_perspective_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'debt_control_model.dart';
export 'debt_control_model.dart';

/// This is a mobile debt management app screen in Korean.
///
/// Please create this UI structure in FlutterFlow:
///
/// SCREEN STRUCTURE:
///
/// 1. APP BAR
/// - Title: "채무 관리" (Debt Management)
/// - Search icon (right)
/// - Notification icon with red dot badge (right)
///
/// 2. USER LOCATION BAR
/// - Light blue background (#EFF6FF)
/// - Text: "우리 그룹 > 화장품회사 > 마케팅부서" (Our Group > Cosmetics Company > Marketing
/// Dept)
/// - Font size: 12px, color: #1E40AF
///
/// 3. VIEW MODE SELECTOR (3 tabs)
/// - Container with gray background (#F3F4F6)
/// - 3 buttons: "회사 전체" (Company Total) - selected, "본사" (Headquarters),
/// "마케팅부서" (Marketing Dept)
/// - Selected button: white background with shadow, blue text (#2563EB)
/// - Unselected buttons: transparent, gray text (#6B7280)
///
/// 4. SUMMARY CARD
/// - Blue gradient background (#3B82F6 to #2563EB)
/// - Top section:
///   * Label: "화장품회사 전체" with building icon
///   * Large amount: "₩2.5억" (₩250 million)
///   * Subtitle: "23건의 거래" (23 transactions)
/// - Bottom grid (2 columns):
///   * Left: "받을 돈" (Receivables) ₩1500만
///   * Right: "줄 돈" (Payables) ₩2.6억
///
/// 5. FILTER SECTION
/// - Header row: "거래처" (Counterparties) left, "상세 필터" (Filter) right
/// - 3 filter buttons: "전체" (All) - selected, "그룹사" (Group), "외부" (External)
///
/// 6. COUNTERPARTY LIST (ListView)
/// Each card contains:
/// - Left: Circle avatar with 2-letter abbreviation
/// - Center: Company name, badges (internal/group), last transaction time
/// - Right: Net balance amount with color coding (red for negative, green for
/// positive)
/// - Some cards have expandable sections showing department-level
/// transactions
///
/// Card Examples:
/// a) Jin Company
///    - Avatar: "JC" on gray background
///    - Balance: -₩2.6억 (red)
///    - Shows "본사 및 2개 부서와 거래 중" (Trading with HQ and 2 departments)
///
/// b) 화장품회사 내부부서 (Internal Departments)
///    - Avatar: "내부" on blue background
///    - Balance: ±₩0
///    - Green badge: "같은 회사" (Same Company)
///    - Expanded view shows 3 department transactions
///
/// c) 옷브랜드회사 (Fashion Brand Company)
///    - Avatar: "패션" on blue background
///    - Balance: +₩250만 (green)
///    - Blue badge: "우리 그룹" (Our Group)
///
/// 7. BOTTOM BUTTONS
/// - "새 거래 추가" (Add New Transaction) - blue filled button
/// - "상세 내역" (View Details) - white outlined button
///
/// DESIGN TOKENS:
/// - Primary blue: #3B82F6
/// - Success green: #16A34A
/// - Error red: #DC2626
/// - Background gray: #F3F4F6
/// - Card background: white
/// - Border radius: 8-12px for cards, 16px for summary card
/// - Padding: 16px standard
/// - Font: System default
/// - Shadow: 0 1px 3px rgba(0,0,0,0.1)
///
/// Please create this as a responsive mobile screen with proper scrolling for
/// the counterparty list. Use Container, Column, Row, ListView, and Card
/// widgets. Make the summary card stand out with gradient background and
/// white text. Ensure proper spacing and padding throughout.
class DebtControlWidget extends StatefulWidget {
  const DebtControlWidget({super.key});

  static String routeName = 'debtControl';
  static String routePath = '/debtControl';

  @override
  State<DebtControlWidget> createState() => _DebtControlWidgetState();
}

class _DebtControlWidgetState extends State<DebtControlWidget> {
  late DebtControlModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DebtControlModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().isLoading1 = true;
      safeSetState(() {});
      _model.debtOverviewapi = await DebtControlGroup.debtOverviewCall.call(
        pCompanyId: FFAppState().companyChoosen,
        pStoreId: FFAppState().storeChoosen,
      );

      if ((_model.debtOverviewapi?.succeeded ?? true)) {
        _model.debtOverview = ((_model.debtOverviewapi?.jsonBody ?? '')
                .toList()
                .map<DebtOverviewStruct?>(DebtOverviewStruct.maybeFromMap)
                .toList() as Iterable<DebtOverviewStruct?>)
            .withoutNulls
            .toList()
            .cast<DebtOverviewStruct>();
        safeSetState(() {});
        _model.counterpartyMatrixapi =
            await DebtControlGroup.getcounterpartymatrixCall.call(
          pCompanyId: FFAppState().companyChoosen,
          pStoreId: FFAppState().storeChoosen,
          pPageSize: 15,
        );

        if ((_model.counterpartyMatrixapi?.succeeded ?? true)) {
          _model.counterpartyMatrix =
              (_model.counterpartyMatrixapi?.jsonBody ?? '');
          _model.currentViewpointName = FFAppState()
              .user
              .companies
              .where((e) => FFAppState().companyChoosen == e.companyId)
              .toList()
              .firstOrNull
              ?.companyName;
          safeSetState(() {});
        }
      }
      FFAppState().isLoading1 = false;
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
        backgroundColor: Color(0xFFF3F4F6),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      wrapWithModel(
                        model: _model.debtControModel,
                        updateCallback: () => safeSetState(() {}),
                        child: MenuBarWidget(
                          menuName: 'Debt Control',
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFEFF6FF),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '${FFAppState().user.companies.where((e) => e.companyId == FFAppState().companyChoosen).toList().firstOrNull?.companyName} > ${functions.getStoreNameByIdFromList(FFAppState().user.companies.where((e) => e.companyId == FFAppState().companyChoosen).toList().firstOrNull?.stores.toList(), FFAppState().storeChoosen)}',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1E40AF),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.selectMyPerspectiveModel,
                        updateCallback: () => safeSetState(() {}),
                        child: SelectMyPerspectiveWidget(
                          selectedVietPoint: (selectedVietpoint) async {
                            _model.viewpoint = selectedVietpoint;
                            safeSetState(() {});
                            if (_model.viewpoint == 'company') {
                              _model.currentViewpointName = FFAppState()
                                  .user
                                  .companies
                                  .where((e) =>
                                      FFAppState().companyChoosen ==
                                      e.companyId)
                                  .toList()
                                  .firstOrNull
                                  ?.companyName;
                              safeSetState(() {});
                            } else {
                              if (_model.viewpoint == 'store') {
                                _model.currentViewpointName =
                                    functions.getStoreNameByIdFromList(
                                        FFAppState()
                                            .user
                                            .companies
                                            .where((e) =>
                                                e.companyId ==
                                                FFAppState().companyChoosen)
                                            .toList()
                                            .firstOrNull
                                            ?.stores
                                            .toList(),
                                        FFAppState().storeChoosen);
                                safeSetState(() {});
                              } else {
                                _model.currentViewpointName =
                                    '${FFAppState().user.companies.where((e) => FFAppState().companyChoosen == e.companyId).toList().firstOrNull?.companyName}\'s Headquarter';
                                safeSetState(() {});
                              }
                            }
                          },
                        ),
                      ),
                      wrapWithModel(
                        model: _model.debtOverviewModel,
                        updateCallback: () => safeSetState(() {}),
                        child: DebtOverviewWidget(
                          debtOverivew: _model.debtOverview
                              .where((e) => e.viewMode == _model.viewpoint)
                              .toList()
                              .firstOrNull!,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 0.0),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Counterparty',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1F2937),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                '상세 필터',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF3B82F6),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        child: wrapWithModel(
                          model: _model.counterpartyViewPointModel,
                          updateCallback: () => safeSetState(() {}),
                          child: CounterpartyViewPointWidget(
                            counterpartyViewpoint:
                                (counterpartyViewpoint) async {
                              _model.filter = counterpartyViewpoint;
                              safeSetState(() {});
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 100.0),
                        child: Builder(
                          builder: (context) {
                            final counterpartyOverview = functions
                                .getCurrentCounterparties(
                                    _model.counterpartyMatrix!,
                                    _model.viewpoint,
                                    _model.filter)
                                .toList();

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: counterpartyOverview.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.0),
                              itemBuilder:
                                  (context, counterpartyOverviewIndex) {
                                final counterpartyOverviewItem =
                                    counterpartyOverview[
                                        counterpartyOverviewIndex];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (functions
                                            .convertJsonToString(getJsonField(
                                          counterpartyOverviewItem,
                                          r'''$.counterparty_id''',
                                        )) ==
                                        _model.clickedCounterparty) {
                                      _model.clickedCounterparty = null;
                                      safeSetState(() {});
                                    } else {
                                      _model.clickedCounterparty = getJsonField(
                                        counterpartyOverviewItem,
                                        r'''$.counterparty_id''',
                                      ).toString();
                                      safeSetState(() {});
                                    }
                                  },
                                  child: CounterpartyCardWidget(
                                    key: Key(
                                        'Keyp6u_${counterpartyOverviewIndex}_of_${counterpartyOverview.length}'),
                                    counterpartyCard: counterpartyOverviewItem,
                                    clickedCounterparty:
                                        _model.clickedCounterparty,
                                    clikcedViewPoint: _model.viewpoint,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                ),
              ),
              if ((FFAppState().isLoading1 == true) ||
                  FFAppState().isLoading2 ||
                  FFAppState().isLoading3)
                wrapWithModel(
                  model: _model.isloadingModel,
                  updateCallback: () => safeSetState(() {}),
                  child: IsloadingWidget(),
                ),
              Align(
                alignment: AlignmentDirectional(0.87, 0.9),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: ShowCounterpartyWidget(
                              clikcedViewpoint: _model.viewpoint,
                              callbackAction:
                                  (callbackId, callbackName) async {},
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 60.0,
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
