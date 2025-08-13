import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'button_icon_small_model.dart';
export 'button_icon_small_model.dart';

class ButtonIconSmallWidget extends StatefulWidget {
  const ButtonIconSmallWidget({
    super.key,
    this.iconbutton,
  });

  final Widget? iconbutton;

  @override
  State<ButtonIconSmallWidget> createState() => _ButtonIconSmallWidgetState();
}

class _ButtonIconSmallWidgetState extends State<ButtonIconSmallWidget> {
  late ButtonIconSmallModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonIconSmallModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowIconButton(
      borderRadius: 20.0,
      buttonSize: MediaQuery.sizeOf(context).width * 0.1,
      fillColor: FlutterFlowTheme.of(context).primary,
      icon: widget.iconbutton!,
      onPressed: () {
        print('IconButton pressed ...');
      },
    );
  }
}
