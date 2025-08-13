import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button_icon_tex80_model.dart';
export 'button_icon_tex80_model.dart';

class ButtonIconTex80Widget extends StatefulWidget {
  const ButtonIconTex80Widget({
    super.key,
    required this.buttontext,
    this.iconbutton,
  });

  final String? buttontext;
  final Widget? iconbutton;

  @override
  State<ButtonIconTex80Widget> createState() => _ButtonIconTex80WidgetState();
}

class _ButtonIconTex80WidgetState extends State<ButtonIconTex80Widget> {
  late ButtonIconTex80Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonIconTex80Model());

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
      alignment: AlignmentDirectional(0.0, -1.0),
      child: FFButtonWidget(
        onPressed: () {
          print('Button pressed ...');
        },
        text: widget.buttontext!,
        icon: widget.iconbutton,
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 0.8,
          height: 41.8,
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconAlignment: IconAlignment.start,
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).primary,
          textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.notoSansJp(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).accent4,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
          elevation: 0.0,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
