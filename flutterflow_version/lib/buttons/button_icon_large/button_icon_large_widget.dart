import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'button_icon_large_model.dart';
export 'button_icon_large_model.dart';

class ButtonIconLargeWidget extends StatefulWidget {
  const ButtonIconLargeWidget({
    super.key,
    required this.buttontext,
    this.iconbutton,
  });

  final String? buttontext;
  final Widget? iconbutton;

  @override
  State<ButtonIconLargeWidget> createState() => _ButtonIconLargeWidgetState();
}

class _ButtonIconLargeWidgetState extends State<ButtonIconLargeWidget> {
  late ButtonIconLargeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonIconLargeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowIconButton(
        borderRadius: 100.0,
        buttonSize: MediaQuery.sizeOf(context).width * 0.2,
        fillColor: FlutterFlowTheme.of(context).primary,
        icon: widget.iconbutton!,
        onPressed: () {
          print('IconButton pressed ...');
        },
      ),
    );
  }
}
