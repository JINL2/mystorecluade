import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../helpers/snackbar_helpers.dart';

/// Bottom sheet to display company and store codes
class CodesDisplaySheet extends StatelessWidget {
  const CodesDisplaySheet({
    super.key,
    required this.companyName,
    required this.companyCode,
    required this.stores,
  });

  final String companyName;
  final String companyCode;
  final List<Map<String, dynamic>> stores;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: TossSpacing.space10,
            height: TossSpacing.space1,
            margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
            child: Row(
              children: [
                Text(
                  'Company & Store Codes',
                  style: TossTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Codes List - Scrollable
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                TossSpacing.paddingXL,
                0,
                TossSpacing.paddingXL,
                TossSpacing.paddingXL + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Company Code
                  _buildCodeItem(
                    context: context,
                    icon: Icons.business,
                    title: companyName,
                    subtitle: 'Company Code',
                    code: companyCode,
                    onCopy: () => SnackbarHelpers.copyToClipboard(context, companyCode, 'Company code'),
                  ),

                  if (stores.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space3),

                    // Store Codes
                    ...stores.map((store) => Padding(
                      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                      child: _buildCodeItem(
                        context: context,
                        icon: Icons.store_outlined,
                        title: store['store_name'] as String? ?? '',
                        subtitle: 'Store Code',
                        code: store['store_code'] as String? ?? '',
                        onCopy: () => SnackbarHelpers.copyToClipboard(
                          context,
                          store['store_code'] as String? ?? '',
                          'Store code',
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String code,
    required VoidCallback onCopy,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1/2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    code,
                    style: TossTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1/2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_outlined,
                          size: TossSpacing.iconXS,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          'Copy',
                          style: TossTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show the codes display sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required String companyName,
    required String companyCode,
    required List<Map<String, dynamic>> stores,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CodesDisplaySheet(
        companyName: companyName,
        companyCode: companyCode,
        stores: stores,
      ),
    );
  }
}
