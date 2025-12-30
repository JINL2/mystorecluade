import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';
import '../providers/lc_providers.dart';

class LCDetailPage extends ConsumerWidget {
  final String lcId;

  const LCDetailPage({super.key, required this.lcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lcAsync = ref.watch(lcDetailProvider(lcId));

    return lcAsync.when(
      loading: () => TossScaffold(
        appBar: TossAppBar1(
          title: 'LC Details',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      ),
      error: (error, _) => TossScaffold(
        appBar: TossAppBar1(
          title: 'LC Details',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: TossColors.error),
              const SizedBox(height: TossSpacing.space3),
              Text('Failed to load LC', style: TossTextStyles.bodyLarge),
              const SizedBox(height: TossSpacing.space2),
              TextButton(
                onPressed: () => ref.invalidate(lcDetailProvider(lcId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (lc) => _LCDetailContent(lc: lc),
    );
  }
}

class _LCDetailContent extends ConsumerStatefulWidget {
  final LetterOfCredit lc;

  const _LCDetailContent({required this.lc});

  @override
  ConsumerState<_LCDetailContent> createState() => _LCDetailContentState();
}

class _LCDetailContentState extends ConsumerState<_LCDetailContent> {
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _amountFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final lc = widget.lc;

    return TossScaffold(
      appBar: TossAppBar1(
        title: lc.lcNumber,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(true),
        ),
        actions: [
          if (lc.isEditable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/letter-of-credit/${lc.id}/edit'),
            ),
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(action, lc),
            itemBuilder: (context) => [
              if (lc.status == LCStatus.draft)
                const PopupMenuItem(
                  value: 'apply',
                  child: ListTile(
                    leading: Icon(Icons.send),
                    title: Text('Apply for LC'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              if (lc.status == LCStatus.applied)
                const PopupMenuItem(
                  value: 'issue',
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text('Mark as Issued'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              if (lc.status.isActive)
                const PopupMenuItem(
                  value: 'amend',
                  child: ListTile(
                    leading: Icon(Icons.edit_note),
                    title: Text('Add Amendment'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              if (lc.status == LCStatus.draft)
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Amount Card
            _buildStatusCard(lc),

            const SizedBox(height: TossSpacing.space4),

            // Warnings
            if (lc.isExpired || lc.isShipmentOverdue) ...[
              _buildWarningBanner(lc),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Amount Details
            _buildSection('Amount Details', [
              _buildInfoRow('LC Amount', '${lc.currencyCode} ${_amountFormat.format(lc.amount)}'),
              _buildInfoRow('Utilized', '${lc.currencyCode} ${_amountFormat.format(lc.amountUtilized)}'),
              _buildInfoRow('Available', '${lc.currencyCode} ${_amountFormat.format(lc.availableAmount)}'),
              if (lc.tolerancePlusPercent > 0 || lc.toleranceMinusPercent > 0)
                _buildInfoRow(
                  'Tolerance',
                  '+${lc.tolerancePlusPercent}% / -${lc.toleranceMinusPercent}%',
                ),
            ]),

            const SizedBox(height: TossSpacing.space4),

            // Dates
            _buildSection('Important Dates', [
              if (lc.issueDateUtc != null)
                _buildInfoRow('Issue Date', _dateFormat.format(lc.issueDateUtc!)),
              _buildInfoRow('Expiry Date', _dateFormat.format(lc.expiryDateUtc),
                  valueColor: lc.isExpired ? TossColors.error : null),
              if (lc.latestShipmentDateUtc != null)
                _buildInfoRow(
                  'Latest Shipment',
                  _dateFormat.format(lc.latestShipmentDateUtc!),
                  valueColor: lc.isShipmentOverdue ? TossColors.error : null,
                ),
              _buildInfoRow('Presentation Period', '${lc.presentationPeriodDays} days'),
            ]),

            const SizedBox(height: TossSpacing.space4),

            // Parties
            _buildSection('Parties', [
              if (lc.applicantName != null)
                _buildInfoRow('Applicant', lc.applicantName!),
              if (lc.issuingBankName != null)
                _buildInfoRow('Issuing Bank', lc.issuingBankName!),
              if (lc.advisingBankName != null)
                _buildInfoRow('Advising Bank', lc.advisingBankName!),
              if (lc.confirmingBankName != null)
                _buildInfoRow('Confirming Bank', lc.confirmingBankName!),
            ]),

            const SizedBox(height: TossSpacing.space4),

            // Trade Terms
            if (lc.incotermsCode != null || lc.portOfLoading != null) ...[
              _buildSection('Trade Terms', [
                if (lc.incotermsCode != null)
                  _buildInfoRow('Incoterms', '${lc.incotermsCode}${lc.incotermsPlace != null ? ' - ${lc.incotermsPlace}' : ''}'),
                if (lc.portOfLoading != null)
                  _buildInfoRow('Port of Loading', lc.portOfLoading!),
                if (lc.portOfDischarge != null)
                  _buildInfoRow('Port of Discharge', lc.portOfDischarge!),
                _buildInfoRow('Partial Shipment', lc.partialShipmentAllowed ? 'Allowed' : 'Not Allowed'),
                _buildInfoRow('Transshipment', lc.transshipmentAllowed ? 'Allowed' : 'Not Allowed'),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Payment Terms
            if (lc.paymentTermsCode != null) ...[
              _buildSection('Payment Terms', [
                _buildInfoRow('Payment Terms', lc.paymentTermsCode!),
                if (lc.usanceDays != null)
                  _buildInfoRow('Usance', '${lc.usanceDays} days ${lc.usanceFrom ?? ''}'),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Required Documents
            if (lc.requiredDocuments.isNotEmpty) ...[
              _buildSection('Required Documents', [
                ...lc.requiredDocuments.map((doc) => _buildDocumentRow(doc)),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Special Conditions
            if (lc.specialConditions != null && lc.specialConditions!.isNotEmpty) ...[
              _buildSection('Special Conditions', [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    lc.specialConditions!,
                    style: TossTextStyles.bodyMedium,
                  ),
                ),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Amendments
            if (lc.amendments.isNotEmpty) ...[
              _buildSection('Amendments (${lc.amendments.length})', [
                ...lc.amendments.map((a) => _buildAmendmentCard(a)),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Related Documents
            if (lc.poNumber != null || lc.piNumber != null) ...[
              _buildSection('Related Documents', [
                if (lc.piNumber != null)
                  _buildLinkRow('Proforma Invoice', lc.piNumber!, () {
                    if (lc.piId != null) {
                      context.push('/proforma-invoice/${lc.piId}');
                    }
                  }),
                if (lc.poNumber != null)
                  _buildLinkRow('Purchase Order', lc.poNumber!, () {
                    if (lc.poId != null) {
                      context.push('/purchase-order/${lc.poId}');
                    }
                  }),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Notes
            if (lc.notes != null && lc.notes!.isNotEmpty) ...[
              _buildSection('Notes', [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    lc.notes!,
                    style: TossTextStyles.bodyMedium,
                  ),
                ),
              ]),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Metadata
            _buildSection('Information', [
              if (lc.createdAtUtc != null)
                _buildInfoRow('Created', _dateFormat.format(lc.createdAtUtc!)),
              if (lc.updatedAtUtc != null)
                _buildInfoRow('Last Updated', _dateFormat.format(lc.updatedAtUtc!)),
              _buildInfoRow('Version', '${lc.version}'),
            ]),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(LetterOfCredit lc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusBadge(lc.status),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Available',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lc.formattedAvailableAmount,
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (lc.amountUtilized > 0) ...[
              const SizedBox(height: TossSpacing.space3),
              // Utilization progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Utilization',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      Text(
                        '${lc.utilizationPercent.toStringAsFixed(1)}%',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: lc.utilizationPercent / 100,
                    backgroundColor: TossColors.gray200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      lc.utilizationPercent >= 100
                          ? TossColors.success
                          : TossColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner(LetterOfCredit lc) {
    final isExpired = lc.isExpired;
    final isShipmentOverdue = lc.isShipmentOverdue;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: TossColors.error),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isExpired)
                  Text(
                    'LC has expired',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (isShipmentOverdue)
                  Text(
                    'Shipment deadline has passed',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray800,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor ?? TossColors.gray800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Text(
                value,
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(LCRequiredDocument doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          Icon(Icons.description_outlined, size: 18, color: TossColors.gray500),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              '${doc.code}${doc.name != null ? ' - ${doc.name}' : ''}',
              style: TossTextStyles.bodyMedium,
            ),
          ),
          Text(
            '${doc.copiesOriginal}/${doc.copiesCopy}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmendmentCard(LCAmendment amendment) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amendment #${amendment.amendmentNumber}',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildAmendmentStatusBadge(amendment.status),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            amendment.changesSummary,
            style: TossTextStyles.bodyMedium,
          ),
          if (amendment.amendmentDateUtc != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              _dateFormat.format(amendment.amendmentDateUtc!),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(LCStatus status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case LCStatus.draft:
        bgColor = TossColors.gray200;
        textColor = TossColors.gray700;
        break;
      case LCStatus.applied:
        bgColor = TossColors.warning.withOpacity(0.1);
        textColor = TossColors.warning;
        break;
      case LCStatus.issued:
        bgColor = TossColors.primary.withOpacity(0.1);
        textColor = TossColors.primary;
        break;
      case LCStatus.advised:
        bgColor = TossColors.info.withOpacity(0.1);
        textColor = TossColors.info;
        break;
      case LCStatus.confirmed:
        bgColor = TossColors.success.withOpacity(0.1);
        textColor = TossColors.success;
        break;
      case LCStatus.amended:
        bgColor = TossColors.warning.withOpacity(0.1);
        textColor = TossColors.warning;
        break;
      case LCStatus.documentsSubmitted:
        bgColor = TossColors.info.withOpacity(0.1);
        textColor = TossColors.info;
        break;
      case LCStatus.utilized:
        bgColor = TossColors.success.withOpacity(0.2);
        textColor = TossColors.success;
        break;
      case LCStatus.expired:
        bgColor = TossColors.error.withOpacity(0.1);
        textColor = TossColors.error;
        break;
      case LCStatus.closed:
        bgColor = TossColors.gray300;
        textColor = TossColors.gray700;
        break;
      case LCStatus.cancelled:
        bgColor = TossColors.gray200;
        textColor = TossColors.gray500;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Text(
        status.label,
        style: TossTextStyles.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAmendmentStatusBadge(LCAmendmentStatus status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case LCAmendmentStatus.pending:
        bgColor = TossColors.warning.withOpacity(0.1);
        textColor = TossColors.warning;
        break;
      case LCAmendmentStatus.approved:
        bgColor = TossColors.success.withOpacity(0.1);
        textColor = TossColors.success;
        break;
      case LCAmendmentStatus.rejected:
        bgColor = TossColors.error.withOpacity(0.1);
        textColor = TossColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        status.label,
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleAction(String action, LetterOfCredit lc) async {
    final notifier = ref.read(lcFormNotifierProvider.notifier);

    switch (action) {
      case 'apply':
        final confirmed = await _showConfirmDialog(
          'Apply for LC',
          'Are you sure you want to apply for this LC?',
        );
        if (confirmed) {
          await notifier.updateStatus(lc.id, LCStatus.applied);
          ref.invalidate(lcDetailProvider(lc.id));
        }
        break;
      case 'issue':
        final confirmed = await _showConfirmDialog(
          'Mark as Issued',
          'Are you sure you want to mark this LC as issued?',
        );
        if (confirmed) {
          await notifier.updateStatus(lc.id, LCStatus.issued);
          ref.invalidate(lcDetailProvider(lc.id));
        }
        break;
      case 'amend':
        _showAmendmentDialog(lc);
        break;
      case 'delete':
        final confirmed = await _showConfirmDialog(
          'Delete LC',
          'Are you sure you want to delete this LC? This cannot be undone.',
          isDestructive: true,
        );
        if (confirmed) {
          final success = await notifier.delete(lc.id);
          if (success && mounted) {
            context.pop(true);
          }
        }
        break;
    }
  }

  Future<bool> _showConfirmDialog(String title, String message,
      {bool isDestructive = false}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: isDestructive
                    ? ElevatedButton.styleFrom(
                        backgroundColor: TossColors.error,
                      )
                    : null,
                child: Text(isDestructive ? 'Delete' : 'Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAmendmentDialog(LetterOfCredit lc) {
    final summaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Amendment'),
        content: TextField(
          controller: summaryController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Changes Summary',
            hintText: 'Describe the changes...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (summaryController.text.isNotEmpty) {
                final notifier = ref.read(lcFormNotifierProvider.notifier);
                await notifier.addAmendment(
                  lc.id,
                  LCAmendmentCreateParams(
                    changesSummary: summaryController.text,
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  ref.invalidate(lcDetailProvider(lc.id));
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
