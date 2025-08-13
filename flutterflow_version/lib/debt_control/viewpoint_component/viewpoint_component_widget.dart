import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'viewpoint_component_model.dart';
export 'viewpoint_component_model.dart';

class ViewpointComponentWidget extends StatefulWidget {
  const ViewpointComponentWidget({
    super.key,
    required this.name,
    String? selectedViewpoint,
  }) : this.selectedViewpoint = selectedViewpoint ?? 'Company';

  final String? name;
  final String selectedViewpoint;

  @override
  State<ViewpointComponentWidget> createState() =>
      _ViewpointComponentWidgetState();
}

class _ViewpointComponentWidgetState extends State<ViewpointComponentWidget> {
  late ViewpointComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewpointComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      decoration: BoxDecoration(
        color: widget.selectedViewpoint == widget.name
            ? Colors.white
            : Color(0x00000000),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            valueOrDefault<String>(
              widget.name,
              'Error',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.notoSansJp(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: widget.name == widget.selectedViewpoint
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ),
      ),
    );
  }
}
