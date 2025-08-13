import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button_icon_text_smal_model.dart';
export 'button_icon_text_smal_model.dart';

class ButtonIconTextSmalWidget extends StatefulWidget {
  const ButtonIconTextSmalWidget({
    super.key,
    required this.buttontext,
    this.iconbutton,
  });

  final String? buttontext;
  final Widget? iconbutton;

  @override
  State<ButtonIconTextSmalWidget> createState() =>
      _ButtonIconTextSmalWidgetState();
}

class _ButtonIconTextSmalWidgetState extends State<ButtonIconTextSmalWidget> {
  late ButtonIconTextSmalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonIconTextSmalModel());

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
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
        child: FFButtonWidget(
          onPressed: () {
            print('Button pressed ...');
          },
          text: widget.buttontext!,
          icon: widget.iconbutton,
          options: FFButtonOptions(
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: 20.0,
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            iconAlignment: IconAlignment.start,
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.notoSansJp(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodySmall.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).accent4,
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
