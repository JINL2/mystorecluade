import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class BalanceSheetDisplay extends StatelessWidget {
  final Map<String, dynamic> balanceSheetData;
  final String currencySymbol;
  final VoidCallback onEdit;

  const BalanceSheetDisplay({
    Key? key,
    required this.balanceSheetData,
    required this.currencySymbol,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = balanceSheetData['data'];
    final companyInfo = balanceSheetData['company_info'];
    final uiData = balanceSheetData['ui_data'];
    final totals = data['totals'];
    final parameters = balanceSheetData['parameters'];
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header with Store and Date info
              _buildHeader(companyInfo, parameters),
              
              // Balance Sheet Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                child: Column(
                  children: [
                    // Balance Verification Card
                    _buildBalanceVerificationCard(uiData['balance_verification'], currencySymbol),
                    SizedBox(height: TossSpacing.space4),
                    
                    // Summary Cards
                    _buildSummaryCards(totals, currencySymbol),
                    SizedBox(height: TossSpacing.space6),
                    
                    // Assets Section
                    if (data['current_assets'].length > 0 || data['non_current_assets'].length > 0) ...[
                      _buildAssetsSection(data, totals, currencySymbol),
                      SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Liabilities Section
                    if (data['current_liabilities'].length > 0 || data['non_current_liabilities'].length > 0) ...[
                      _buildLiabilitiesSection(data, totals, currencySymbol),
                      SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Equity Section
                    if (data['equity'].length > 0) ...[
                      _buildEquitySection(data, totals, currencySymbol),
                      SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Comprehensive Income (if any)
                    if (data['comprehensive_income'].length > 0) ...[
                      _buildComprehensiveIncomeSection(data, totals, currencySymbol),
                      SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Bottom padding
                    SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader(Map<String, dynamic> companyInfo, Map<String, dynamic> parameters) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.all(TossSpacing.space4),
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.primary.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withOpacity(0.05),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    companyInfo['store_name'] != null ? Icons.store_outlined : Icons.business_outlined,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyInfo['store_name'] ?? companyInfo['company_name'] ?? 'Balance Sheet',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, 
                            color: TossColors.gray500, size: 14),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            '${parameters['start_date']} ~ ${parameters['end_date']}',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, 
                        color: TossColors.gray600, size: 16),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        'Edit',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
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
    );
  }
  
  Widget _buildBalanceVerificationCard(Map<String, dynamic> verification, String currencySymbol) {
    final isBalanced = verification['is_balanced'] ?? false;
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: isBalanced 
          ? TossColors.success.withOpacity(0.05)
          : TossColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isBalanced 
            ? TossColors.success.withOpacity(0.2)
            : TossColors.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle_outline : Icons.error_outline,
            color: isBalanced ? TossColors.success : TossColors.error,
            size: 24,
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBalanced ? 'Balance Sheet is Balanced' : 'Balance Sheet is Not Balanced',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  'Assets: $currencySymbol${verification['total_assets_formatted']} = Liabilities + Equity: $currencySymbol${verification['total_liabilities_and_equity_formatted']}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCards(Map<String, dynamic> totals, String currencySymbol) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withOpacity(0.08),
            TossColors.primary.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total Assets',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            _formatCurrency(totals['total_assets'], currencySymbol),
            style: TossTextStyles.h1.copyWith(
              color: TossColors.gray900,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: _buildMiniCard(
                  'Assets',
                  _formatCurrency(totals['total_assets'], currencySymbol),
                  TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMiniCard(
                  'Liabilities',
                  _formatCurrency(totals['total_liabilities'], currencySymbol),
                  TossColors.warning,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMiniCard(
                  'Equity',
                  _formatCurrency(totals['total_equity'], currencySymbol),
                  TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMiniCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 11,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAssetsSection(Map<String, dynamic> data, Map<String, dynamic> totals, String currencySymbol) {
    return _buildSection(
      title: 'Assets',
      total: totals['total_assets'],
      currencySymbol: currencySymbol,
      icon: Icons.account_balance_wallet_outlined,
      color: TossColors.success,
      children: [
        // Current Assets
        if (data['current_assets'].length > 0) ...[
          _buildSubSection(
            'Current Assets',
            totals['total_current_assets'],
            currencySymbol,
            data['current_assets'],
          ),
        ],
        // Non-Current Assets
        if (data['non_current_assets'].length > 0) ...[
          if (data['current_assets'].length > 0) SizedBox(height: TossSpacing.space3),
          _buildSubSection(
            'Non-Current Assets',
            totals['total_non_current_assets'],
            currencySymbol,
            data['non_current_assets'],
          ),
        ],
      ],
    );
  }
  
  Widget _buildLiabilitiesSection(Map<String, dynamic> data, Map<String, dynamic> totals, String currencySymbol) {
    return _buildSection(
      title: 'Liabilities',
      total: totals['total_liabilities'],
      currencySymbol: currencySymbol,
      icon: Icons.receipt_long_outlined,
      color: TossColors.warning,
      children: [
        // Current Liabilities
        if (data['current_liabilities'].length > 0) ...[
          _buildSubSection(
            'Current Liabilities',
            totals['total_current_liabilities'],
            currencySymbol,
            data['current_liabilities'],
          ),
        ],
        // Non-Current Liabilities
        if (data['non_current_liabilities'].length > 0) ...[
          if (data['current_liabilities'].length > 0) SizedBox(height: TossSpacing.space3),
          _buildSubSection(
            'Non-Current Liabilities',
            totals['total_non_current_liabilities'],
            currencySymbol,
            data['non_current_liabilities'],
          ),
        ],
      ],
    );
  }
  
  Widget _buildEquitySection(Map<String, dynamic> data, Map<String, dynamic> totals, String currencySymbol) {
    return _buildSection(
      title: 'Shareholder\'s Equity',
      total: totals['total_equity'],
      currencySymbol: currencySymbol,
      icon: Icons.pie_chart_outline,
      color: TossColors.primary,
      children: [
        ...data['equity'].map<Widget>((account) => 
          _buildAccountItem(account, currencySymbol)
        ).toList(),
      ],
    );
  }
  
  Widget _buildComprehensiveIncomeSection(Map<String, dynamic> data, Map<String, dynamic> totals, String currencySymbol) {
    return _buildSection(
      title: 'Other Comprehensive Income',
      total: totals['total_comprehensive_income'],
      currencySymbol: currencySymbol,
      icon: Icons.trending_up_outlined,
      color: TossColors.info,
      children: [
        ...data['comprehensive_income'].map<Widget>((account) => 
          _buildAccountItem(account, currencySymbol)
        ).toList(),
      ],
    );
  }
  
  Widget _buildSection({
    required String title,
    required dynamic total,
    required String currencySymbol,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    title,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Container(
                  constraints: BoxConstraints(minWidth: 80, maxWidth: 140),
                  child: Text(
                    _formatCurrency(total, currencySymbol),
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space4,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubSection(String title, dynamic total, String currencySymbol, List<dynamic> accounts) {
    return Column(
      children: [
        _buildBalanceItem(title, '', true, false),
        ...accounts.map((account) => _buildAccountItem(account, currencySymbol)).toList(),
        Divider(color: TossColors.gray100, height: TossSpacing.space4),
        _buildBalanceItem('Total $title', _formatCurrency(total, currencySymbol), true, true),
      ],
    );
  }
  
  Widget _buildAccountItem(Map<String, dynamic> account, String currencySymbol) {
    final balance = account['balance'] ?? 0;
    final hasTransactions = account['has_transactions'] ?? false;
    
    return _buildBalanceItem(
      '  ${account['account_name']}',
      _formatCurrency(balance, currencySymbol),
      false,
      false,
      hasTransactions: hasTransactions,
    );
  }
  
  Widget _buildBalanceItem(String label, String value, bool isBold, bool isSubtotal, {bool hasTransactions = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: isBold
                      ? TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )
                      : TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontSize: 13,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (hasTransactions && !isBold && !isSubtotal) ...[
                  SizedBox(width: TossSpacing.space1),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TossColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          if (value.isNotEmpty)
            Container(
              constraints: BoxConstraints(minWidth: 80, maxWidth: 120),
              child: Text(
                value,
                style: isSubtotal
                  ? TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    )
                  : TossTextStyles.body.copyWith(
                      color: value.startsWith('-') ? TossColors.error : TossColors.gray700,
                      fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }
  
  String _formatCurrency(dynamic amount, String currencySymbol) {
    if (amount == null) return '$currencySymbol 0';
    
    final formatter = NumberFormat('#,##0', 'en_US');
    final absAmount = amount.abs();
    final formatted = formatter.format(absAmount);
    
    if (amount < 0) {
      return '-$currencySymbol$formatted';
    }
    return '$currencySymbol$formatted';
  }
}