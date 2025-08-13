import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'radio_button_model.dart';
export 'radio_button_model.dart';

class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({
    super.key,
    required this.optiontext,
    this.iconbutton,
  });

  final String? optiontext;
  final Widget? iconbutton;

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  late RadioButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RadioButtonModel());

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
      child: FlutterFlowRadioButton(
        options: ['Option 1', 'Option 2', 'Option 3'].toList(),
        onChanged: (val) => safeSetState(() {}),
        controller: _model.radioButtonValueController ??=
            FormFieldController<String>(null),
        optionHeight: 32.0,
        optionWidth: MediaQuery.sizeOf(context).width * 0.3,
        textStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.notoSansJp(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.notoSansJp(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        buttonPosition: RadioButtonPosition.left,
        direction: Axis.vertical,
        radioButtonColor: FlutterFlowTheme.of(context).primary,
        inactiveRadioButtonColor:
            FlutterFlowTheme.of(context).secondaryBackground,
        toggleable: false,
        horizontalAlignment: WrapAlignment.start,
        verticalAlignment: WrapCrossAlignment.center,
      ),
    );
  }
}
