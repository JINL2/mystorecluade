import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'add_fix_asset_model.dart';
export 'add_fix_asset_model.dart';

class AddFixAssetWidget extends StatefulWidget {
  const AddFixAssetWidget({super.key});

  static String routeName = 'addFixAsset';
  static String routePath = '/addFixAsset';

  @override
  State<AddFixAssetWidget> createState() => _AddFixAssetWidgetState();
}

class _AddFixAssetWidgetState extends State<AddFixAssetWidget> {
  late AddFixAssetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddFixAssetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  menuName: 'Add Fixed Asset',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
