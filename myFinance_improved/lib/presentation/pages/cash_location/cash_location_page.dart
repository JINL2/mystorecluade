import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/toss/toss_text_field.dart';
import 'models/cash_location_model.dart';
import 'providers/cash_location_provider.dart';
import 'widgets/cash_location_summary_card.dart';
import 'widgets/cash_location_filter_tabs.dart';
import 'widgets/cash_location_card.dart';
import 'widgets/add_location_sheet.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  const CashLocationPage({super.key});
  
  static const String routeName = 'cashLocation';
  static const String routePath = '/cashLocation';
  
  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(cashLocationsProvider);
    
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cash Locations',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: TossColors.gray700,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(cashLocationFilterProvider.notifier).update(
                    (state) => state.copyWith(searchQuery: null),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const CashLocationSummaryCard(),
                const Divider(height: 1),
                const SizedBox(height: 8),
                // Search or Filter tabs
                if (_isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TossTextField(
                      controller: _searchController,
                      hintText: 'Search locations...',
                      suffixIcon: const Icon(Icons.search, color: TossColors.gray400),
                      onChanged: (value) {
                        ref.read(cashLocationFilterProvider.notifier).update(
                          (state) => state.copyWith(searchQuery: value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  const CashLocationFilterTabs(),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          
          // Locations List
          Expanded(
            child: locationsAsync.when(
              data: (locations) {
                if (locations.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(cashLocationsProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: locations.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return CashLocationCard(
                        location: location,
                        onTap: () => _showLocationDetails(location),
                        onEdit: () => _showEditLocation(location),
                        onDelete: () => _confirmDelete(location),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: TossColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load locations',
                      style: TossTextStyles.h3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(cashLocationsProvider);
                      },
                      child: Text(
                        'Retry',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLocation,
        backgroundColor: TossColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    final filter = ref.watch(cashLocationFilterProvider);
    final hasFilters = filter.searchQuery != null || 
                      filter.locationType != null || 
                      filter.storeId != null;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasFilters ? Icons.search_off : Icons.account_balance_wallet_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters 
              ? 'No locations found' 
              : 'No cash locations yet',
            style: TossTextStyles.h2,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
              ? 'Try adjusting your filters'
              : 'Add your first cash location to get started',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                ref.read(cashLocationFilterProvider.notifier).state = 
                  const CashLocationFilter();
                _searchController.clear();
              },
              child: Text(
                'Clear filters',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _showAddLocation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddLocationSheet(
        onLocationAdded: (location) {
          // Location will be automatically updated via stream
        },
      ),
    );
  }
  
  void _showEditLocation(CashLocationModel location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddLocationSheet(
        locationToEdit: location,
        onLocationAdded: (location) {
          // Location will be automatically updated via stream
        },
      ),
    );
  }
  
  void _showLocationDetails(CashLocationModel location) {
    ref.read(selectedCashLocationProvider.notifier).state = location;
    // TODO: Navigate to detail page or show detail bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location details: ${location.displayName}'),
        action: SnackBarAction(
          label: 'Edit',
          onPressed: () => _showEditLocation(location),
        ),
      ),
    );
  }
  
  void _confirmDelete(CashLocationModel location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: const Text('Delete Location'),
        content: Text(
          'Are you sure you want to delete "${location.displayName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: TossColors.gray600),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(deleteCashLocationProvider)(location.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Location deleted successfully'),
                      backgroundColor: TossColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: ${e.toString()}'),
                      backgroundColor: TossColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: TossColors.error),
            ),
          ),
        ],
      ),
    );
  }
}