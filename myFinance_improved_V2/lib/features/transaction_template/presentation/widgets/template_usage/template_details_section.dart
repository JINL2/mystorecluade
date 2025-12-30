/// Template Details Section - Collapsible template details
///
/// Purpose: Displays detailed template information in collapsible section
/// Shows DEBIT/CREDIT entries with account names and locations
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Collapsible section showing template details
class TemplateDetailsSection extends StatelessWidget {
  final Map<String, dynamic> template;
  final bool isExpanded;
  final VoidCallback onToggle;

  const TemplateDetailsSection({
    super.key,
    required this.template,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: TossColors.gray600,
                      size: 20,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Template Details',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray800,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: TossSpacing.space3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: _TemplateDataDisplay(template: template, data: data),
            ),
          ),
        ],
      ],
    );
  }
}

/// Internal widget to display template data entries
class _TemplateDataDisplay extends StatelessWidget {
  final Map<String, dynamic> template;
  final List<dynamic> data;

  const _TemplateDataDisplay({
    required this.template,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tags = template['tags'] as Map<String, dynamic>? ?? {};
    final counterpartyStoreName = tags['counterparty_store_name']?.toString();

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray300),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: data.map((entry) {
          final entryMap = entry as Map<String, dynamic>;
          return _TemplateEntryRow(
            entry: entryMap,
            counterpartyStoreName: counterpartyStoreName,
          );
        }).toList(),
      ),
    );
  }
}

/// Single entry row in template details
class _TemplateEntryRow extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String? counterpartyStoreName;

  const _TemplateEntryRow({
    required this.entry,
    this.counterpartyStoreName,
  });

  @override
  Widget build(BuildContext context) {
    final type = entry['type']?.toString() ?? '';
    final accountName = entry['account_name']?.toString() ?? 'Unknown';
    final cashLocationName = entry['cash_location_name']?.toString();
    final counterpartyName = entry['counterparty_name']?.toString();
    final counterpartyCashLocationName =
        entry['counterparty_cash_location_name']?.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          // DEBIT/CREDIT badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: type == 'debit'
                  ? TossColors.primary.withValues(alpha: 0.1)
                  : TossColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              type.toUpperCase(),
              style: TossTextStyles.caption.copyWith(
                color: type == 'debit' ? TossColors.primary : TossColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (cashLocationName != null)
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    text: cashLocationName,
                  ),
                if (counterpartyName != null)
                  _DetailRow(
                    icon: Icons.person_outline,
                    text: counterpartyName,
                  ),
                if (counterpartyName != null && counterpartyStoreName != null)
                  _DetailRow(
                    icon: Icons.store_outlined,
                    text: counterpartyStoreName!,
                  ),
                if (counterpartyCashLocationName != null)
                  _DetailRow(
                    icon: Icons.account_balance_outlined,
                    text: counterpartyCashLocationName,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper widget for detail rows with icon
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space1),
      child: Row(
        children: [
          Icon(icon, size: 14, color: TossColors.gray500),
          const SizedBox(width: TossSpacing.space1),
          Text(
            text,
            style: TossTextStyles.caption.copyWith(color: TossColors.gray700),
          ),
        ],
      ),
    );
  }
}
