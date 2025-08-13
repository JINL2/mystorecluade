import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dropdown_text_model.dart';
export 'dropdown_text_model.dart';

class DropdownTextWidget extends StatefulWidget {
  const DropdownTextWidget({
    super.key,
    required this.dropdowntext,
  });

  final String? dropdowntext;

  @override
  State<DropdownTextWidget> createState() => _DropdownTextWidgetState();
}

class _DropdownTextWidgetState extends State<DropdownTextWidget> {
  late DropdownTextModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownTextModel());

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
      child: FlutterFlowDropDown<String>(
        multiSelectController: _model.dropDownValueController ??=
            FormListFieldController<String>(null),
        options: ['', '', ''],
        width: double.infinity,
        height: 40.0,
        menuOffset: Offset(0.0, 0),
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.notoSansJp(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Select...',
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 2.0,
        borderColor: Colors.transparent,
        borderWidth: 0.0,
        borderRadius: 8.0,
        margin: EdgeInsets.all(20.0),
        hidesUnderline: true,
        isOverButton: false,
        isSearchable: false,
        isMultiSelect: true,
        onMultiSelectChanged: (val) =>
            safeSetState(() => _model.dropDownValue = val),
      ),
    );
  }
}
