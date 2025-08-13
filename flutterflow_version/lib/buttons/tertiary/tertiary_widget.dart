import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tertiary_model.dart';
export 'tertiary_model.dart';

class TertiaryWidget extends StatefulWidget {
  const TertiaryWidget({
    super.key,
    required this.buttontext,
    this.iconbutton,
  });

  final String? buttontext;
  final Widget? iconbutton;

  @override
  State<TertiaryWidget> createState() => _TertiaryWidgetState();
}

class _TertiaryWidgetState extends State<TertiaryWidget> {
  late TertiaryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TertiaryModel());

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
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: 41.8,
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            iconAlignment: IconAlignment.start,
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0x00226DFF),
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.notoSansJp(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
