import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'role_card_model.dart';
export 'role_card_model.dart';

class RoleCardWidget extends StatefulWidget {
  const RoleCardWidget({
    super.key,
    required this.rolename,
  });

  final String? rolename;

  @override
  State<RoleCardWidget> createState() => _RoleCardWidgetState();
}

class _RoleCardWidgetState extends State<RoleCardWidget> {
  late RoleCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RoleCardModel());

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
      width: double.infinity,
      height: 75.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        shape: BoxShape.rectangle,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              label: 'Edit',
              backgroundColor: FlutterFlowTheme.of(context).alternate,
              icon: Icons.edit,
              onPressed: (_) {
                print('SlidableActionWidget pressed ...');
              },
            ),
            SlidableAction(
              label: 'Delete',
              backgroundColor: FlutterFlowTheme.of(context).error,
              icon: Icons.delete_outline_rounded,
              onPressed: (_) {
                print('SlidableActionWidget pressed ...');
              },
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            title: Text(
              widget.rolename!,
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.notoSansJp(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleLarge.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_back_ios_sharp,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            tileColor: FlutterFlowTheme.of(context).secondaryBackground,
            dense: false,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
