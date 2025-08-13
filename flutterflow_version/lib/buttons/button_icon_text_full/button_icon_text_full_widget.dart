import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button_icon_text_full_model.dart';
export 'button_icon_text_full_model.dart';

class ButtonIconTextFullWidget extends StatefulWidget {
  const ButtonIconTextFullWidget({
    super.key,
    required this.buttontext,
    this.iconbutton,
  });

  final String? buttontext;
  final Widget? iconbutton;

  @override
  State<ButtonIconTextFullWidget> createState() =>
      _ButtonIconTextFullWidgetState();
}

class _ButtonIconTextFullWidgetState extends State<ButtonIconTextFullWidget> {
  late ButtonIconTextFullModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonIconTextFullModel());

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
          width: double.infinity,
          height: 41.8,
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
