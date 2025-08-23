import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../helpers/navigation_helper.dart';
import 'providers/add_fix_asset_providers.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../widgets/common/toss_scaffold.dart';

class AddFixAssetPage extends ConsumerStatefulWidget {
  const AddFixAssetPage({super.key});

  @override
  ConsumerState<AddFixAssetPage> createState() => _AddFixAssetPageState();
}

class _AddFixAssetPageState extends ConsumerState<AddFixAssetPage> {
  String? selectedStoreId;
  String? baseCurrencyId;
  String currencySymbol = '\$'; // Default symbol

  @override
  void initState() {
    super.initState();
    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    // If app state has empty store (headquarters), set selectedStoreId to null
    // Otherwise use the actual store ID
    selectedStoreId = appState.storeChoosen.isEmpty ? null : appState.storeChoosen;
    
    // Fetch base currency for the selected company
    _fetchBaseCurrency();
  }
  
  Future<void> _fetchBaseCurrency() async {
    try {
      final currency = await ref.read(companyBaseCurrencyProvider.future);
      if (mounted && currency != null) {
        setState(() {
          baseCurrencyId = currency;
        });
        
        // Now fetch the currency symbol
        _fetchCurrencySymbol(currency);
      }
    } catch (e) {
    }
  }
  
  Future<void> _fetchCurrencySymbol(String currencyId) async {
    try {
      final symbol = await ref.read(currencySymbolProvider(currencyId).future);
      if (mounted) {
        setState(() {
          currencySymbol = symbol;
        });
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    
    // Only auto-select first store if we haven't explicitly set to headquarters (null)
    // and we don't have a selected store from app state
    final appStateStoreId = appState.storeChoosen;
    if (selectedStoreId == null && appStateStoreId.isNotEmpty && stores.isNotEmpty) {
      selectedStoreId = stores.first['store_id'];
    }

    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: TossColors.gray900,
          ),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: const Text(
          'Fixed Assets',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
      ),
      body: Column(
        children: [
          // Store selector section
          _buildStoreSelector(stores),
          
          // Assets list
          Expanded(
            child: _buildAssetsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssetBottomSheet();
        },
        backgroundColor: TossColors.primary,
        elevation: 2,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStoreSelector(List<dynamic> stores) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => _showStoreSelector(stores),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: TossColors.gray100,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Store',
                      style: TextStyle(
                        fontSize: 13,
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStoreName(selectedStoreId, stores),
                      style: const TextStyle(
                        fontSize: 16,
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStoreName(String? storeId, List<dynamic> stores) {
    if (storeId == null) {
      return 'Headquarters';
    }
    if (storeId.isEmpty || stores.isEmpty) {
      return 'Select Store';
    }
    
    try {
      final store = stores.firstWhere(
        (store) => store['store_id'] == storeId,
        orElse: () => null,
      );
      final storeName = store?['store_name'] ?? 'Select Store';
      return storeName;
    } catch (e) {
      return 'Select Store';
    }
  }

  Widget _buildAssetsList() {
    final fixedAssetsAsync = ref.watch(fixedAssetsProvider(selectedStoreId));

    return fixedAssetsAsync.when(
      data: (assets) {
        if (assets.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_outlined,
                  size: 64,
                  color: TossColors.gray400,
                ),
                SizedBox(height: 16),
                Text(
                  'No assets found',
                  style: TextStyle(
                    fontSize: 16,
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add your first asset to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: TossColors.gray400,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            return _buildAssetItem(asset);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: 2,
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading assets',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(Map<String, dynamic> asset) {
    // Handle both int and double types from database
    final acquisitionCost = (asset['acquisition_cost'] ?? 0).toDouble();
    final usefulLifeYears = (asset['useful_life_years'] ?? 0).toInt();
    final salvageValue = (asset['salvage_value'] ?? 0).toDouble();
    
    // Calculate additional metrics
    final annualDepreciation = usefulLifeYears > 0 
        ? (acquisitionCost - salvageValue) / usefulLifeYears 
        : 0.0;
    final acquisitionDate = DateTime.tryParse(asset['acquisition_date'] ?? '');
    final currentValue = _calculateCurrentValue(acquisitionCost, annualDepreciation, acquisitionDate);
    final depreciationRate = acquisitionCost > 0 
        ? ((acquisitionCost - currentValue) / acquisitionCost * 100) 
        : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section with asset name and actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.business_center_outlined,
                    size: 20,
                    color: TossColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset['asset_name'] ?? 'Unknown Asset',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Purchased ${_formatDate(asset['acquisition_date'])}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    // Add safety check for widget lifecycle
                    if (!mounted) return;
                    
                    if (value == 'edit') {
                      if (mounted) {
                        _showEditAssetBottomSheet(asset);
                      }
                    } else if (value == 'delete') {
                      if (mounted) {
                        // TODO: Implement delete functionality
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: TossColors.gray700),
                          SizedBox(width: 12),
                          Text('Edit Asset'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: TossColors.error),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: TossColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Current value and depreciation status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        TossColors.primary.withOpacity(0.05),
                        TossColors.primary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Value',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currencySymbol${currentValue.toStringAsFixed(0)}',
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: depreciationRate > 50 
                              ? TossColors.error.withOpacity(0.1)
                              : TossColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_down,
                              size: 16,
                              color: depreciationRate > 50 
                                  ? TossColors.error 
                                  : TossColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${depreciationRate.toStringAsFixed(1)}%',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: depreciationRate > 50 
                                    ? TossColors.error 
                                    : TossColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Key metrics grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Original Cost',
                        '$currencySymbol${acquisitionCost.toStringAsFixed(0)}',
                        Icons.attach_money,
                        TossColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        'Annual Deprec.',
                        '$currencySymbol${annualDepreciation.toStringAsFixed(0)}',
                        Icons.calendar_today_outlined,
                        TossColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Useful Life',
                        '$usefulLifeYears years',
                        Icons.schedule,
                        TossColors.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        'Salvage Value',
                        '$currencySymbol${salvageValue.toStringAsFixed(0)}',
                        Icons.savings_outlined,
                        TossColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateCurrentValue(double acquisitionCost, double annualDepreciation, DateTime? acquisitionDate) {
    if (acquisitionDate == null || annualDepreciation <= 0) {
      return acquisitionCost;
    }
    
    final yearsOwned = DateTime.now().difference(acquisitionDate).inDays / 365;
    final totalDepreciation = annualDepreciation * yearsOwned;
    final currentValue = acquisitionCost - totalDepreciation;
    
    return currentValue > 0 ? currentValue : 0;
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }


  void _showEditAssetBottomSheet(Map<String, dynamic> asset) {
    // Create controllers with existing values
    final nameController = TextEditingController(text: asset['asset_name'] ?? '');
    final costController = TextEditingController(
      text: (asset['acquisition_cost'] ?? 0).toDouble().toStringAsFixed(0)
    );
    final salvageController = TextEditingController(
      text: (asset['salvage_value'] ?? 0).toDouble().toStringAsFixed(0)
    );
    final usefulLifeController = TextEditingController(
      text: (asset['useful_life_years'] ?? 0).toString()
    );
    
    // Parse acquisition date
    DateTime selectedDate = DateTime.now();
    if (asset['acquisition_date'] != null) {
      try {
        selectedDate = DateTime.parse(asset['acquisition_date']);
      } catch (e) {
        selectedDate = DateTime.now();
      }
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: TossColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // Title section
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 24,
                          color: TossColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Asset',
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Update asset information',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 24,
                          color: TossColors.gray600,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Asset Name Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asset Name',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter asset name',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                          ),
                          filled: true,
                          fillColor: TossColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.gray200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.gray200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Acquisition Date Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acquisition Date',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TossColors.gray300,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: TossColors.gray400,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatDate(selectedDate.toIso8601String()),
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Cost and Salvage Value Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Acquisition Cost',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: costController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                              ),
                              decoration: InputDecoration(
                                prefixText: '$currencySymbol ',
                                prefixStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                hintText: '0',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                filled: true,
                                fillColor: TossColors.gray100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray300,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray300,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salvage Value',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: salvageController,
                              keyboardType: TextInputType.number,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                              decoration: InputDecoration(
                                prefixText: '$currencySymbol ',
                                prefixStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray600,
                                ),
                                hintText: '0',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                filled: true,
                                fillColor: TossColors.gray50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.gray200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Useful Life Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Useful Life (Years)',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usefulLifeController,
                        keyboardType: TextInputType.number,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter years',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                          ),
                          filled: true,
                          fillColor: TossColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.gray200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.gray200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TossColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Depreciation Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TossColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: TossColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Depreciation Summary',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Annual Depreciation:',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '$currencySymbol${_calculateDepreciation(costController.text, salvageController.text, usefulLifeController.text)}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Value:',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '$currencySymbol${_calculateCurrentValueForEdit(costController.text, salvageController.text, usefulLifeController.text, selectedDate)}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: TossColors.gray300,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // TODO: Implement save functionality
                            // For now, just close the bottom sheet
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Asset updated successfully'),
                                backgroundColor: TossColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _calculateDepreciation(String cost, String salvage, String years) {
    try {
      final costValue = double.tryParse(cost) ?? 0;
      final salvageValue = double.tryParse(salvage) ?? 0;
      final yearsValue = int.tryParse(years) ?? 0;
      
      if (yearsValue <= 0) return '0';
      return ((costValue - salvageValue) / yearsValue).toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }
  
  String _calculateCurrentValueForEdit(String cost, String salvage, String years, DateTime acquisitionDate) {
    try {
      final costValue = double.tryParse(cost) ?? 0;
      final salvageValue = double.tryParse(salvage) ?? 0;
      final yearsValue = int.tryParse(years) ?? 0;
      
      if (yearsValue <= 0) return costValue.toStringAsFixed(0);
      
      final annualDepreciation = (costValue - salvageValue) / yearsValue;
      final yearsOwned = DateTime.now().difference(acquisitionDate).inDays / 365;
      final totalDepreciation = annualDepreciation * yearsOwned;
      final currentValue = costValue - totalDepreciation;
      
      return (currentValue > salvageValue ? currentValue : salvageValue).toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }
  void _showAddAssetBottomSheet() {
    // Create controllers for the form
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final salvageController = TextEditingController();
    final usefulLifeController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: TossColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // Title section with icon
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              TossColors.primary.withOpacity(0.8),
                              TossColors.primary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_business,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Asset',
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track your business assets',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 24,
                          color: TossColors.gray600,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Asset Name Field with enhanced design
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Asset Name',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' *',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., MacBook Pro, Office Desk',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor: TossColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: TossColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Purchase Date Field with calendar icon
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 18,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Purchase Date',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' *',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: TossColors.primary,
                                    onPrimary: Colors.white,
                                    surface: TossColors.background,
                                    onSurface: TossColors.gray900,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setBottomSheetState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: TossColors.gray200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: TossColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _formatDate(selectedDate.toIso8601String()),
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: TossColors.gray500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Financial Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TossColors.gray100,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: TossColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.payments_outlined,
                                size: 16,
                                color: TossColors.success,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Financial Information',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray800,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Purchase Cost Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Purchase Cost',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: costController,
                              keyboardType: TextInputType.number,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                prefixText: '$currencySymbol ',
                                prefixStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.success,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                hintText: '0',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: TossColors.gray200,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: TossColors.success,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Salvage Value and Useful Life Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Salvage Value',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: salvageController,
                                    keyboardType: TextInputType.number,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      prefixText: '$currencySymbol ',
                                      prefixStyle: TossTextStyles.body.copyWith(
                                        color: TossColors.gray600,
                                        fontSize: 15,
                                      ),
                                      hintText: '0',
                                      hintStyle: TossTextStyles.body.copyWith(
                                        color: TossColors.gray400,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: TossColors.gray200,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: TossColors.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Useful Life',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: usefulLifeController,
                                    keyboardType: TextInputType.number,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      suffixText: 'years',
                                      suffixStyle: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray500,
                                        fontSize: 13,
                                      ),
                                      hintText: '0',
                                      hintStyle: TossTextStyles.body.copyWith(
                                        color: TossColors.gray400,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: TossColors.gray200,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: TossColors.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
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
                  
                  const SizedBox(height: 20),
                  
                  // Depreciation Preview Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TossColors.primary.withOpacity(0.05),
                          TossColors.primary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TossColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.trending_down,
                                size: 18,
                                color: TossColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Depreciation Preview',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 14,
                                        color: TossColors.gray600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Annual Depreciation',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$currencySymbol${_calculateDepreciation(costController.text, salvageController.text, usefulLifeController.text)}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 1,
                                color: TossColors.gray100,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 14,
                                        color: TossColors.gray600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Current Book Value',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$currencySymbol${costController.text.isEmpty ? '0' : costController.text}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Action Buttons with gradient
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: const BorderSide(
                              color: TossColors.gray300,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TossColors.primary.withOpacity(0.9),
                                TossColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              // TODO: Implement save functionality
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text('Asset added successfully'),
                                    ],
                                  ),
                                  backgroundColor: TossColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Add Asset',
                                  style: TossTextStyles.body.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _showStoreSelector(List<dynamic> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Select Store',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Store options with scrollable list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stores.length + 1, // +1 for Headquarters
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // First item is always Headquarters with null value
                      return _buildStoreOption(null, 'Headquarters');
                    }
                    
                    final store = stores[index - 1];
                    return _buildStoreOption(
                      store['store_id'] as String,
                      store['store_name'] as String,
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreOption(String? storeId, String storeName) {
    final isSelected = selectedStoreId == storeId;
    
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        
        setState(() {
          selectedStoreId = storeId;
        });
        
        // Update app state with the new store selection
        // For headquarters (null), we set empty string in app state but keep local selectedStoreId as null
        final appStateValue = storeId ?? '';
        await ref.read(appStateProvider.notifier).setStoreChoosen(appStateValue);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.store_outlined,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}