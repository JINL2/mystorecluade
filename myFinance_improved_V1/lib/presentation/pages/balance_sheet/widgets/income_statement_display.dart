import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:intl/intl.dart';

class IncomeStatementDisplay extends StatelessWidget {
  final Map<String, dynamic> incomeStatementData;
  final String currencySymbol;
  final VoidCallback onEdit;

  const IncomeStatementDisplay({
    Key? key,
    required this.incomeStatementData,
    required this.currencySymbol,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = incomeStatementData['data'] as List<dynamic>;
    final parameters = incomeStatementData['parameters'] as Map<String, dynamic>;
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header with Date Range info
              _buildHeader(parameters),
              
              // Income Statement Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                child: Column(
                  children: [
                    // Key Metrics Summary
                    _buildKeyMetricsSummary(data),
                    SizedBox(height: TossSpacing.space6),
                    
                    // Income Statement Sections
                    ...data.map<Widget>((section) => 
                      _buildSection(section)
                    ).toList(),
                    
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
  
  Widget _buildHeader(Map<String, dynamic> parameters) {
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
                    Icons.receipt_long_outlined,
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
                        'Income Statement',
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
  
  Widget _buildKeyMetricsSummary(List<dynamic> data) {
    // Extract key metrics from data
    final revenue = _findSectionTotal(data, 'Revenue');
    final grossProfit = _findSectionTotal(data, 'Gross Profit');
    final operatingIncome = _findSectionTotal(data, 'Operating Income');
    final netIncome = _findSectionTotal(data, 'Net Income');
    final grossMargin = _findSectionTotal(data, 'Gross Margin');
    final netMargin = _findSectionTotal(data, 'Net Margin');
    
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
            'Net Income',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            _formatCurrency(netIncome, currencySymbol),
            style: TossTextStyles.h1.copyWith(
              color: _isPositiveAmount(netIncome)
                  ? TossColors.success 
                  : TossColors.error,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: _buildMiniCard(
                  'Revenue',
                  _formatCurrency(revenue, currencySymbol),
                  TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMiniCard(
                  'Gross Profit',
                  _formatCurrency(grossProfit, currencySymbol),
                  TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMiniCard(
                  'Operating',
                  _formatCurrency(operatingIncome, currencySymbol),
                  TossColors.info,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _buildPercentageCard(
                  'Gross Margin',
                  grossMargin,
                  TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildPercentageCard(
                  'Net Margin',
                  netMargin,
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
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPercentageCard(String label, String percentage, Color color) {
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
            '${percentage ?? '0'}%',
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
  
  Widget _buildSection(Map<String, dynamic> section) {
    final sectionName = section['section'] as String;
    final sectionTotal = section['section_total']; // Can be String or double
    final subcategories = section['subcategories'] as List<dynamic>? ?? [];
    
    // Determine section type and styling
    final isPositiveSection = ['Revenue', 'Gross Profit', 'Operating Income', 'EBITDA', 'Net Income', 'Income Before Tax'].contains(sectionName);
    final isNegativeSection = ['Cost of Goods Sold', 'Expenses'].contains(sectionName);
    final isMarginSection = sectionName.contains('Margin');
    
    Color sectionColor = TossColors.gray600;
    IconData sectionIcon = Icons.analytics_outlined;
    
    if (isPositiveSection) {
      sectionColor = TossColors.success;
      sectionIcon = Icons.trending_up_outlined;
    } else if (isNegativeSection) {
      sectionColor = TossColors.error;
      sectionIcon = Icons.trending_down_outlined;
    } else if (isMarginSection) {
      sectionColor = TossColors.primary;
      sectionIcon = Icons.percent_outlined;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
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
              color: sectionColor.withOpacity(0.05),
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
                    color: sectionColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(sectionIcon, color: sectionColor, size: 20),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    sectionName,
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
                    isMarginSection ? '${sectionTotal.toString()}%' : _formatCurrency(sectionTotal.toString(), currencySymbol),
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: sectionColor,
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
          if (subcategories.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space4,
              ),
              child: Column(
                children: subcategories.map<Widget>((subcategory) => 
                  _buildSubcategory(subcategory)
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSubcategory(Map<String, dynamic> subcategory) {
    final subcategoryName = subcategory['subcategory'] as String;
    final subcategoryTotal = subcategory['subcategory_total']; // Can be String or double  
    final accounts = subcategory['accounts'] as List<dynamic>? ?? [];
    
    return Column(
      children: [
        if (subcategoryName.isNotEmpty && subcategoryTotal != null)
          _buildSubcategoryHeader(subcategoryName, subcategoryTotal),
        if (accounts.isNotEmpty) ...accounts.map<Widget>((account) => 
          _buildAccountItem(account)
        ).toList(),
        SizedBox(height: TossSpacing.space3),
      ],
    );
  }
  
  Widget _buildSubcategoryHeader(String name, dynamic total) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          Container(
            constraints: BoxConstraints(minWidth: 80, maxWidth: 120),
            child: Text(
              _formatCurrency(total?.toString() ?? '0', currencySymbol),
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w700,
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
  
  Widget _buildAccountItem(Map<String, dynamic> account) {
    final accountName = account['account_name'] as String;
    final netAmount = account['net_amount'];
    final accountType = account['account_type'] as String;
    
    final isIncome = accountType == 'income';
    final hasActivity = netAmount != null && netAmount != 0;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text('  ', style: TossTextStyles.bodySmall), // Indentation
                Flexible(
                  child: Text(
                    accountName,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (hasActivity) ...[ 
                  SizedBox(width: TossSpacing.space1),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isIncome ? TossColors.success : TossColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          Container(
            constraints: BoxConstraints(minWidth: 80, maxWidth: 120),
            child: Text(
              _formatCurrency(netAmount?.toString() ?? '0', currencySymbol),
              style: TossTextStyles.body.copyWith(
                color: hasActivity 
                    ? (isIncome ? TossColors.success : TossColors.error)
                    : TossColors.gray500,
                fontWeight: hasActivity ? FontWeight.w500 : FontWeight.w400,
                fontSize: 13,
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
  
  String _findSectionTotal(List<dynamic> data, String sectionName) {
    try {
      final section = data.firstWhere(
        (section) => section['section'] == sectionName,
        orElse: () => {'section_total': '0'},
      );
      return section['section_total']?.toString() ?? '0';
    } catch (e) {
      return '0';
    }
  }
  
  bool _isPositiveAmount(dynamic amount) {
    if (amount == null) return false;
    
    try {
      if (amount is num) {
        return amount >= 0;
      } else if (amount is String) {
        final parsed = double.tryParse(amount);
        return parsed != null && parsed >= 0;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _formatCurrency(dynamic amount, String currencySymbol) {
    if (amount == null || amount.toString().isEmpty || amount.toString() == 'null') {
      return '$currencySymbol 0';
    }
    
    try {
      double numericAmount;
      if (amount is num) {
        numericAmount = amount.toDouble();
      } else {
        numericAmount = double.tryParse(amount.toString()) ?? 0.0;
      }
      
      final formatter = NumberFormat('#,##0', 'en_US');
      final absAmount = numericAmount.abs();
      final formatted = formatter.format(absAmount);
      
      if (numericAmount < 0) {
        return '-$currencySymbol$formatted';
      }
      return '$currencySymbol$formatted';
    } catch (e) {
      return '$currencySymbol 0';
    }
  }
}