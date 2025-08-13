import '/cash_location/cash_location_comp/cash_location_comp_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cash_location_model.dart';
export 'cash_location_model.dart';

class CashLocationWidget extends StatefulWidget {
  const CashLocationWidget({super.key});

  static String routeName = 'cashLocation';
  static String routePath = '/cashLocation';

  @override
  State<CashLocationWidget> createState() => _CashLocationWidgetState();
}

class _CashLocationWidgetState extends State<CashLocationWidget> {
  late CashLocationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CashLocationModel());

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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        wrapWithModel(
                          model: _model.menuBarModel,
                          updateCallback: () => safeSetState(() {}),
                          child: MenuBarWidget(
                            menuName: 'Cash Location',
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          child: wrapWithModel(
                            model: _model.cashLocationCompModel,
                            updateCallback: () => safeSetState(() {}),
                            child: CashLocationCompWidget(
                              isChooseCash: false,
                              companyId: FFAppState().companyChoosen,
                              storeId: FFAppState().storeChoosen,
                              cashLocationChoosen:
                                  (locationId, locationName) async {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
