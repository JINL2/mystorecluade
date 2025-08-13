import '/components/role_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listview_role_model.dart';
export 'listview_role_model.dart';

class ListviewRoleWidget extends StatefulWidget {
  const ListviewRoleWidget({
    super.key,
    required this.rolename,
  });

  final String? rolename;

  @override
  State<ListviewRoleWidget> createState() => _ListviewRoleWidgetState();
}

class _ListviewRoleWidgetState extends State<ListviewRoleWidget> {
  late ListviewRoleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListviewRoleModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Builder(
      builder: (context) {
        final jh = FFAppState().user.companies.toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: jh.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.0),
          itemBuilder: (context, jhIndex) {
            final jhItem = jh[jhIndex];
            return wrapWithModel(
              model: _model.roleCardModels.getModel(
                jhItem.companyId,
                jhIndex,
              ),
              updateCallback: () => safeSetState(() {}),
              child: RoleCardWidget(
                key: Key(
                  'Keyw2v_${jhItem.companyId}',
                ),
                rolename: widget.rolename!,
              ),
            );
          },
        );
      },
    );
  }
}
