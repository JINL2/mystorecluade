import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_icons_fa.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';

class SalesInvoicePage extends ConsumerStatefulWidget {
  const SalesInvoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends ConsumerState<SalesInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  String _selectedPeriod = 'This month';
  
  // Sorting
  String _sortBy = 'Date';
  bool _sortAscending = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          'Inventory count',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create invoice page
          NavigationHelper.navigateTo(
            context,
            '/salesInvoice/create',
          );
        },
        backgroundColor: TossColors.primary,
        child: const Icon(Icons.add, color: TossColors.white),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),
          
          // This month section with voucher count
          _buildVoucherCountSection(),
          
          // Invoice list grouped by date
          _buildInvoiceList(),
          
          // Bottom padding for FAB
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Filter Section
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showFilterSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 22,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _selectedPeriod,
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Container(
                width: 1,
                height: 20,
                color: TossColors.gray200,
              ),
              
              // Sort Section
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showSortSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 22,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _sortBy,
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_sortBy != 'Date')
                          Icon(
                            _sortAscending
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                            size: 16,
                            color: TossColors.primary,
                          ),
                        SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Search Field
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: _searchController,
            hintText: 'Search invoices...',
            onChanged: (value) {
              // Handle search
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherCountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Icon container
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: FaIcon(
                  AppIcons.fileAlt,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This month',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    '581 vouchers',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: TossSpacing.iconXS,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList() {
    // Sample data structure
    final invoiceGroups = [
      {
        'date': 'Today, 31/08/2025',
        'invoices': [
          {
            'id': 'IV20250831-001',
            'time': '15:30',
            'user': 'Phương Quyên',
            'products': 58,
            'completed': true,
          },
          {
            'id': 'IV20250831-002',
            'time': '14:00',
            'user': 'Nguyễn Văn A',
            'products': 45,
            'completed': true,
          },
        ],
      },
      {
        'date': 'Thursday, 28/08/2025',
        'invoices': [
          {
            'id': 'IV20250828-001',
            'time': '16:45',
            'user': 'Trần Thị B',
            'products': 72,
            'completed': true,
          },
          {
            'id': 'IV20250828-002',
            'time': '10:30',
            'user': 'Lê Văn C',
            'products': 33,
            'completed': false,
          },
        ],
      },
    ];

    return Column(
      children: invoiceGroups.map((group) {
        return Container(
          margin: EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            top: TossSpacing.space3,
          ),
          child: TossWhiteCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Date header
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: TossColors.gray100,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: TossColors.primary,
                        size: TossSpacing.iconSM,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        group['date'] as String,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Invoice items
                ...(group['invoices'] as List<Map<String, dynamic>>)
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final invoice = entry.value;
                  final isLast = index == (group['invoices'] as List).length - 1;
                  
                  return Column(
                    children: [
                      _buildInvoiceItem(invoice),
                      if (!isLast)
                        Divider(
                          height: 1,
                          color: TossColors.gray100,
                          indent: TossSpacing.space4,
                          endIndent: TossSpacing.space4,
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvoiceItem(Map<String, dynamic> invoice) {
    return InkWell(
      onTap: () {
        // Navigate to invoice detail
      },
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Time
            Container(
              width: 50,
              child: Text(
                invoice['time'],
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice['id'],
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Text(
                        invoice['user'],
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        '•',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        '${invoice['products']} products',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Status icon
            if (invoice['completed'] == true)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: TossColors.success,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule,
                  size: 16,
                  color: TossColors.warning,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Filter by Period',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // Filter options
            _buildFilterOption('Today', _selectedPeriod == 'Today'),
            _buildFilterOption('This week', _selectedPeriod == 'This week'),
            _buildFilterOption('This month', _selectedPeriod == 'This month'),
            _buildFilterOption('Last month', _selectedPeriod == 'Last month'),
            _buildFilterOption('All time', _selectedPeriod == 'All time'),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Sort by',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // Sort options
            _buildSortOption('Date', Icons.calendar_today, _sortBy == 'Date'),
            _buildSortOption('Invoice ID', Icons.tag, _sortBy == 'Invoice ID'),
            _buildSortOption('User', Icons.person, _sortBy == 'User'),
            _buildSortOption('Products', Icons.inventory_2, _sortBy == 'Products'),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPeriod = title;
          });
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon, bool isSelected) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_sortBy == title) {
              _sortAscending = !_sortAscending;
            } else {
              _sortBy = title;
              _sortAscending = false;
            }
          });
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected) ...[
                Icon(
                  _sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                  size: 16,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}