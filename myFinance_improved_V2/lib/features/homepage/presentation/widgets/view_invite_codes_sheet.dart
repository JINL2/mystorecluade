import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Codes Bottom Sheet
///
/// Displays company and store codes with copy functionality.
/// Matches legacy design with horizontal layout (icon + name left, code + copy button right).
class CodesBottomSheet extends StatelessWidget {
  final dynamic company;

  const CodesBottomSheet({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final companyCode = company['company_code'] as String? ?? '';
    final companyName = company['company_name'] as String;
    final stores = company['stores'] as List<dynamic>? ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Company & Store Codes',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: TossColors.textSecondary),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Codes List - Scrollable
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                TossSpacing.space4,
                0,
                TossSpacing.space4,
                TossSpacing.space4,
              ),
              child: Column(
                children: [
                  // Company Code
                  _CodeCard(
                    context: context,
                    title: companyName,
                    subtitle: 'Company Code',
                    code: companyCode,
                    icon: Icons.business,
                  ),

                  // Store Codes
                  if (stores.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space3),
                    ...stores.map((store) {
                      final storeName = store['store_name'] as String;
                      final storeCode = store['store_code'] as String? ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: TossSpacing.space3,
                        ),
                        child: _CodeCard(
                          context: context,
                          title: storeName,
                          subtitle: 'Store Code',
                          code: storeCode,
                          icon: Icons.store_outlined,
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Code Card Widget (matches legacy design)
///
/// Layout: [Icon] [Name/Subtitle] ... [Code] [Copy Button]
class _CodeCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String subtitle;
  final String code;
  final IconData icon;

  const _CodeCard({
    required this.context,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: code.isNotEmpty ? () => _copyToClipboard(context) : null,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray100.withOpacity(0.5),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.border.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(icon, color: TossColors.primary, size: 20),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Code and copy button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    code.isEmpty ? 'No code' : code,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: code.isEmpty
                          ? TossColors.textTertiary
                          : TossColors.textPrimary,
                    ),
                  ),
                  if (code.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.copy_outlined,
                            size: 12,
                            color: TossColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Copy',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Copy code to clipboard with feedback
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$subtitle "$code" copied!'),
        duration: const Duration(seconds: 2),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
