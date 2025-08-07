import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/cash_location_model.dart';
import '../providers/cash_location_provider.dart';

class CashLocationCard extends ConsumerWidget {
  final CashLocationModel location;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const CashLocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          location.locationName,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!location.isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                          child: Text(
                            'Inactive',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (location.bankName != null || location.storeName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      location.bankName ?? location.storeName ?? '',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: TossColors.gray400,
                size: 20,
              ),
              onPressed: () => _showActions(context, ref),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIcon() {
    IconData icon;
    Color color;
    
    switch (location.locationType) {
      case 'cash':
        icon = Icons.payments_outlined;
        color = TossColors.success;
        break;
      case 'bank':
        icon = Icons.account_balance_outlined;
        color = TossColors.info;
        break;
      case 'vault':
        icon = Icons.lock_outline;
        color = TossColors.warning;
        break;
      default:
        icon = Icons.place_outlined;
        color = TossColors.gray600;
    }
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }
  
  void _showActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.edit_outlined, color: TossColors.gray700),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: Icon(
                  location.isActive ? Icons.pause_outlined : Icons.play_arrow_outlined,
                  color: TossColors.gray700,
                ),
                title: Text(location.isActive ? 'Deactivate' : 'Activate'),
                onTap: () async {
                  Navigator.pop(context);
                  if (location.isActive) {
                    await ref.read(deleteCashLocationProvider)(location.id);
                  } else {
                    final supabase = Supabase.instance.client;
                    await supabase
                        .from('cash_locations')
                        .update({'deleted_at': null})
                        .eq('cash_location_id', location.id);
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.delete_outline, color: TossColors.error),
                title: Text('Delete', style: TextStyle(color: TossColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}