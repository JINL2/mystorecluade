import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'conetents_creation_model.dart';
export 'conetents_creation_model.dart';

/// # Contents Helper UI Design System Specification
///
/// ## PROJECT OVERVIEW
/// Create a simple mobile app screen that connects to Contents Helper
/// website.
///
/// The screen shows user info, points, level, and rankings with a main button
/// to open the website.
///
/// ## SCREEN STRUCTURE
///
/// ### Screen Layout (Top to Bottom)
/// 1. **Background**: Light gray (#F9FAFB)
/// 2. **User Info Card**: White card with user data
/// 3. **Ranking Card**: White card with tabbed rankings
/// 4. **Spacing**: 16px padding around screen, 24px between cards
///
/// ## COMPONENT 1: USER INFO CARD
///
/// ### Structure
/// ```
/// White Rectangle (Container)
/// ├── Row (Horizontal Layout)
/// │   ├── Left Side: User Profile
/// │   │   ├── Circle Avatar (64x64px)
/// │   │   └── User Details (Name + Level)
/// │   └── Right Side: Points Display
/// └── Button: "컨텐츠 만들러 가기" (Go Create Contents)
/// ```
///
/// ### Specifications
///
/// #### Container
/// - **Background Color**: #FFFFFF (White)
/// - **Corner Radius**: 16px
/// - **Padding**: 24px all sides
/// - **Shadow**: Medium shadow (0 10px 15px -3px rgba(0,0,0,0.1))
/// - **Margin Bottom**: 24px
///
/// #### User Avatar Circle
/// - **Size**: 64px × 64px
/// - **Shape**: Perfect circle (border-radius: 50%)
/// - **Background Color**: Based on user level
///   - Level 1: #9CA3AF (Gray)
///   - Level 2: #10B981 (Green)
///   - Level 3: #3B82F6 (Blue)
///   - Level 4: #8B5CF6 (Purple)
///   - Level 5: #F59E0B (Gold)
/// - **Content**: First letter of user name
/// - **Text Color**: #FFFFFF (White)
/// - **Font Size**: 32px
/// - **Font Weight**: Bold
/// - **Text Align**: Center
///
/// #### User Name Text
/// - **Font Size**: 24px
/// - **Font Weight**: Bold (700)
/// - **Color**: #111827 (Dark Gray)
/// - **Margin Bottom**: 4px
///
/// #### Level Text
/// - **Font Size**: 14px
/// - **Font Weight**: Normal (400)
/// - **Color**: #6B7280 (Medium Gray)
/// - **Format**: "Level [number] · [level name]"
///
/// #### Points Display
/// - **Number Font Size**: 30px
/// - **Number Font Weight**: Bold (700)
/// - **Number Color**: #FF6B35 (Orange)
/// - **Label Font Size**: 14px
/// - **Label Color**: #6B7280 (Medium Gray)
/// - **Label Text**: "포인트" (Points)
/// - **Text Align**: Right
/// - **Number Format**: Include comma separators (e.g., 2,480)
///
/// #### Main Button
/// - **Width**: 100% of card width
/// - **Height**: 56px
/// - **Background**: Linear gradient from #FF6B35 to #E55100
/// - **Text Color**: #FFFFFF (White)
/// - **Font Size**: 18px
/// - **Font Weight**: Bold (700)
/// - **Corner Radius**: 12px
/// - **Icon**: Video icon (24x24px) on left side
/// - **Icon Color**: #FFFFFF (White)
/// - **Text**: "컨텐츠 만들러 가기"
/// - **Shadow**: 0 10px 15px -3px rgba(0,0,0,0.1)
/// - **Hover State**: Scale to 102%, increase shadow
/// - **Click State**: Scale to 98%
///
/// ## COMPONENT 2: RANKING CARD
///
/// ### Structure
/// ```
/// White Rectangle (Container)
/// ├── Tab Buttons (Row)
/// │   ├── "회사 전체" Tab (Company)
/// │   └── "우리 지점" Tab (Store)
/// └── Ranking List (5 items)
///     └── Ranking Item × 5
/// ```
///
/// ### Specifications
///
/// #### Container
/// - **Background Color**: #FFFFFF (White)
/// - **Corner Radius**: 16px
/// - **Padding**: 24px all sides
/// - **Shadow**: Medium shadow (0 10px 15px -3px rgba(0,0,0,0.1))
///
/// #### Tab Buttons Container
/// - **Layout**: Horizontal row
/// - **Gap**: 8px between buttons
/// - **Margin Bottom**: 24px
///
/// #### Individual Tab Button
/// - **Width**: 50% of container (equal split)
/// - **Height**: 40px
/// - **Corner Radius**: 8px
/// - **Font Size**: 16px
/// - **Font Weight**: Medium (500)
/// - **Active Tab**:
///   - Background: #FF6B35 (Orange)
///   - Text Color: #FFFFFF (White)
/// - **Inactive Tab**:
///   - Background: #F3F4F6 (Light Gray)
///   - Text Color: #4B5563 (Dark Gray)
///   - Hover: Background changes to #E5E7EB
///
/// #### Ranking List
/// - **Gap Between Items**: 12px
/// - **Max Items**: 5
///
/// #### Ranking Item
/// - **Height**: Minimum 48px
/// - **Padding**: 12px
/// - **Corner Radius**: 8px
/// - **Layout**: Horizontal row with space-between
///
/// ##### Normal Item Style
/// - **Background**: #F9FAFB (Very Light Gray)
/// - **Hover**: Background changes to #F3F4F6
///
/// ##### Current User Item Style
/// - **Background**: #FFF5F0 (Light Orange)
/// - **Border**: 2px solid #FDBA74 (Orange)
///
/// ##### Ranking Item Content
///
/// **Left Section (Rank + Name)**
/// - **Layout**: Horizontal row
/// - **Gap**: 12px
///
/// **Rank Display**
/// - **Width**: 32px
/// - **Alignment**: Center
/// - **Rank 1**: Crown icon (20x20px, Color: #EAB308)
/// - **Rank 2**: Medal icon (20x20px, Color: #9CA3AF)
/// - **Rank 3**: Award icon (20x20px, Color: #FF6B35)
/// - **Rank 4-5**: Number text (Font: Bold, Color: #4B5563)
///
/// **Name Section**
/// - **Name Font Size**: 16px
/// - **Name Font Weight**: Medium (500)
/// - **Name Color**: #111827 (or #FF6B35 if current user)
/// - **"(나)" Label**: Added after name if current user
/// - **Level Text**: Below name, Font Size: 12px, Color: #6B7280
///
/// **Right Section (Points)**
/// - **Points Font Size**: 16px
/// - **Points Font Weight**: Bold (700)
/// - **Points Color**: #111827
/// - **Format**: Number with comma + "P" (e.g., "2,480P")
///
/// #### Bottom Link
/// - **Text**: "전체 랭킹 보러가기 →"
/// - **Color**: #FF6B35 (Orange)
/// - **Font Size**: 14px
/// - **Font Weight**: Medium (500)
/// - **Margin Top**: 16px
/// - **Text Align**: Center
/// - **Hover**: Color darkens to #E55100
///
/// ## INTERACTION BEHAVIOR
///
/// ### Button Click Action
/// When main button is clicked:
/// 1. Generate URL with parameters:
///    - user_id: [user's ID]
///    - user_name: [user's name]
///    - company_id: [company ID]
///    - store_id: [store ID]
/// 2. Open URL in new browser tab/window
/// 3. Example URL:
/// `http://localhost/mysite/contents_helper_website/?user_id=0d2e61ad-e230-454e-8b90-efbe1c1a9268&user_name=Jin&company_id=ebd66ba7-fde7-4332-b6b5-0d8a7f615497&store_id=16f4c231-185a-4564-b473-bad1e9b305e8`
///
/// ### Tab Switch Behavior
/// - Clicking tabs switches between "Company" and "Store" rankings
/// - Active tab changes color immediately
/// - Ranking list updates with appropriate data
///
/// ## DATA STRUCTURE
///
/// ### User Object
/// ```json
/// {
///   "id": "0d2e61ad-e230-454e-8b90-efbe1c1a9268",
///   "name": "Jin",
///   "companyId": "ebd66ba7-fde7-4332-b6b5-0d8a7f615497",
///   "storeId": "16f4c231-185a-4564-b473-bad1e9b305e8",
///   "points": 2480,
///   "level": 3,
///   "levelName": "시니어 크리에이터"
/// }
/// ```
///
/// ### Ranking Item
/// ```json
/// {
///   "rank": 1,
///   "name": "김민수",
///   "points": 3250,
///   "level": 4,
///   "isUser": false
/// }
/// ```
///
/// ## RESPONSIVE BEHAVIOR
/// - **Mobile (0-767px)**: Default layout as specified
/// - **Tablet+ (768px+)**: Center content with max-width of 768px
///
/// ## FONTS
/// - **Primary Font**: System default (-apple-system, BlinkMacSystemFont,
/// "Segoe UI", Roboto)
/// - **Korean Support**: Required for Korean text display
///
/// ## ANIMATIONS
/// - **All Transitions**: 150ms ease
/// - **Button Hover**: scale(1.02) transform
/// - **Button Click**: scale(0.98) transform
/// - **Tab Switch**: Background color fade
///
/// ## ACCESSIBILITY
/// - **Touch Targets**: Minimum 44x44px
/// - **Color Contrast**: AA compliant
/// - **Button Height**: 56px (exceeds minimum)
///
/// ## IMPLEMENTATION NOTES FOR AI/DEVELOPERS
///
/// 1. **Create Two Cards**: User info card and Ranking card
/// 2. **User Info Card Has**: Avatar, name, level, points, and one button
/// 3. **Ranking Card Has**: Two tabs and a list of 5 people
/// 4. **Colors Are Critical**: Use exact hex codes provided
/// 5. **Level Colors**: Different color for each level (1-5)
/// 6. **Current User**: Highlight with orange background and border
/// 7. **Icons for Top 3**: Crown (1st), Medal (2nd), Award (3rd)
/// 8. **Button Opens Website**: With URL parameters from user data
/// 9. **Tab State**: Remember which tab is active (company/store)
class ConetentsCreationWidget extends StatefulWidget {
  const ConetentsCreationWidget({super.key});

  static String routeName = 'conetentsCreation';
  static String routePath = '/conetentsCreation';

  @override
  State<ConetentsCreationWidget> createState() =>
      _ConetentsCreationWidgetState();
}

class _ConetentsCreationWidgetState extends State<ConetentsCreationWidget> {
  late ConetentsCreationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConetentsCreationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResulthmu =
          await ContentsCreationGroup.getuserdashboarddataCall.call(
        pUserId: FFAppState().user.userId,
        pCompanyId: FFAppState().companyChoosen,
        pStoreId: FFAppState().storeChoosen,
      );

      if ((_model.apiResulthmu?.succeeded ?? true)) {
        _model.jsondata = (_model.apiResulthmu?.jsonBody ?? '');
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Fail'),
              content: Text('Ask Jin'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
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
        backgroundColor: Color(0xFFF9FAFB),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.menuBarModel,
                    updateCallback: () => safeSetState(() {}),
                    child: MenuBarWidget(
                      menuName: 'Create Contents',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15.0,
                            color: Color(0x1A000000),
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 64.0,
                                      height: 64.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3B82F6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        width: 200.0,
                                        height: 200.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          FFAppState().user.profileImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            FFAppState().user.userFirstName,
                                            'Error',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font: GoogleFonts.notoSansJp(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF111827),
                                                fontSize: 24.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            'Level: ${getJsonField(
                                              _model.jsondata,
                                              r'''$.user_info.level''',
                                            ).toString()}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.notoSansJp(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF6B7280),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(width: 16.0)),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      valueOrDefault<String>(
                                        getJsonField(
                                          _model.jsondata,
                                          r'''$.user_info.points''',
                                        )?.toString(),
                                        '0',
                                      ),
                                      textAlign: TextAlign.end,
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displaySmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            fontSize: 30.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .displaySmall
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      'Points',
                                      textAlign: TextAlign.end,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF6B7280),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                await launchURL(functions.generateExternalUrl(
                                    FFAppState().user.userId,
                                    '${FFAppState().user.userLastName} ${FFAppState().user.userFirstName}',
                                    FFAppState().companyChoosen,
                                    FFAppState().storeChoosen)!);
                              },
                              text: 'Make Contents',
                              icon: Icon(
                                Icons.videocam,
                                size: 24.0,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56.0,
                                padding: EdgeInsets.all(8.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                iconColor: Colors.white,
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                elevation: 10.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15.0,
                            color: Color(0x1A000000),
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      _model.isCompany = true;
                                      safeSetState(() {});
                                    },
                                    text: 'Company',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsets.all(8.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: _model.isCompany
                                          ? FlutterFlowTheme.of(context).primary
                                          : Color(0xFFF3F4F6),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      _model.isCompany = false;
                                      safeSetState(() {});
                                    },
                                    text: 'Store',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsets.all(8.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: !_model.isCompany
                                          ? FlutterFlowTheme.of(context).primary
                                          : Color(0xFFF3F4F6),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.notoSansJp(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF4B5563),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Builder(
                              builder: (context) {
                                final rankingInfo = (_model.isCompany
                                            ? getJsonField(
                                                _model.jsondata,
                                                r'''$.company_ranking.top_5''',
                                                true,
                                              )
                                            : getJsonField(
                                                _model.jsondata,
                                                r'''$.store_ranking.top_5''',
                                                true,
                                              ))
                                        ?.toList() ??
                                    [];

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(rankingInfo.length,
                                      (rankingInfoIndex) {
                                    final rankingInfoItem =
                                        rankingInfo[rankingInfoIndex];
                                    return Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: getJsonField(
                                              rankingInfoItem,
                                              r'''$.is_current_user''',
                                            )
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : Color(0x00000000),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      height: 32.0,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            getJsonField(
                                                              rankingInfoItem,
                                                              r'''$.rank''',
                                                            ).toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .notoSansJp(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .emoji_events,
                                                              color: Color(
                                                                  0xFFEAB308),
                                                              size: 20.0,
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          getJsonField(
                                                            rankingInfoItem,
                                                            r'''$.name''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .notoSansJp(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: Color(
                                                                    0xFF111827),
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Text(
                                                          'Level: ${getJsonField(
                                                            rankingInfoItem,
                                                            r'''$.level''',
                                                          ).toString()}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .notoSansJp(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: Color(
                                                                    0xFF6B7280),
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 12.0)),
                                                ),
                                              ),
                                              Text(
                                                '${getJsonField(
                                                  rankingInfoItem,
                                                  r'''$.points''',
                                                ).toString()} points',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .notoSansJp(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFF111827),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).divide(SizedBox(height: 8.0)),
                                );
                              },
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await launchURL(functions.generateExternalUrl(
                                    FFAppState().user.userId,
                                    '${FFAppState().user.userLastName} ${FFAppState().user.userFirstName}',
                                    FFAppState().companyChoosen,
                                    FFAppState().storeChoosen)!);
                              },
                              child: Text(
                                'Check all ranking',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.notoSansJp(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
