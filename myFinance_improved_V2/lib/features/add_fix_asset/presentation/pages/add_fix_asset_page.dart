import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../domain/entities/fixed_asset.dart';
import '../providers/fixed_asset_providers.dart';
import '../providers/states/fixed_asset_state.dart';
import '../widgets/asset_form_sheet.dart';
import '../widgets/asset_list_item.dart';

class AddFixAssetPage extends ConsumerStatefulWidget {
  const AddFixAssetPage({super.key});

  @override
  ConsumerState<AddFixAssetPage> createState() => _AddFixAssetPageState();
}

class _AddFixAssetPageState extends ConsumerState<AddFixAssetPage> {
  @override
  void initState() {
    super.initState();
    // Initialize state from app state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final notifier = ref.read(fixedAssetProvider.notifier);

      // Update selected store
      final storeId = appState.storeChoosen.isEmpty ? null : appState.storeChoosen;
      notifier.updateSelectedStore(storeId);

      // Fetch currency information
      _fetchCurrencyInfo(appState.companyChoosen);

      // Load assets
      notifier.loadAssets(
        companyId: appState.companyChoosen,
        storeId: storeId,
      );
    });
  }

  Future<void> _fetchCurrencyInfo(String companyId) async {
    if (companyId.isEmpty) return;

    try {
      final currency = await ref.read(companyBaseCurrencyProvider(companyId).future);
      if (mounted && currency != null) {
        final symbol = await ref.read(currencySymbolProvider(currency).future);
        if (mounted) {
          ref.read(fixedAssetProvider.notifier).updateCurrency(
            baseCurrencyId: currency,
            currencySymbol: symbol,
          );
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final assetState = ref.watch(fixedAssetProvider);
    final userData = appState.user;

    // Extract stores from user data
    List<dynamic> stores = [];
    if (userData is Map<String, dynamic>) {
      final companies = userData['companies'] as List<dynamic>? ?? [];
      if (companies.isNotEmpty) {
        dynamic selectedCompany;
        try {
          selectedCompany = companies.firstWhere(
            (c) => c['company_id'] == appState.companyChoosen,
            orElse: () => null,
          );
          selectedCompany ??= companies.first;
        } catch (e) {
          selectedCompany = companies.first;
        }

        if (selectedCompany != null) {
          stores = (selectedCompany['stores'] as List<dynamic>?) ?? [];
        }
      }
    }

    final companyId = appState.companyChoosen;

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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Fixed Assets',
          style: TossTextStyles.body.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
      ),
      body: Column(
        children: [
          // Store selector section
          _buildStoreSelector(stores, assetState.selectedStoreId),

          // Assets list
          Expanded(
            child: _buildAssetsList(companyId, assetState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssetBottomSheet(assetState);
        },
        backgroundColor: TossColors.primary,
        elevation: 2,
        child: const Icon(
          Icons.add,
          color: TossColors.white,
        ),
      ),
    );
  }

  Widget _buildAssetsList(String companyId, FixedAssetState assetState) {
    if (companyId.isEmpty) {
      return Center(
        child: Text(
          'No company selected',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
        ),
      );
    }

    if (assetState.isLoading) {
      return const Center(child: TossLoadingView());
    }

    if (assetState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Error loading assets',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              assetState.errorMessage!,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (assetState.assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No assets found',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Add your first asset to get started',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      itemCount: assetState.assets.length,
      itemBuilder: (context, index) {
        final asset = assetState.assets[index];
        return AssetListItem(
          asset: asset,
          currencySymbol: assetState.currencySymbol,
          onEdit: () => _showEditAssetBottomSheet(asset, assetState.currencySymbol),
          onDelete: () => _deleteAsset(asset.assetId!),
        );
      },
    );
  }

  Future<void> _deleteAsset(String assetId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: const Text('Are you sure you want to delete this asset?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TossColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref.read(fixedAssetProvider.notifier).deleteAsset(assetId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Asset deleted successfully' : 'Failed to delete asset'),
            backgroundColor: success ? TossColors.success : TossColors.error,
          ),
        );
      }
    }
  }

  void _showAddAssetBottomSheet(FixedAssetState assetState) {
    final appState = ref.read(appStateProvider);
    final authAsync = ref.read(authStateProvider);

    // Extract user from auth state
    final user = authAsync.when(
      data: (u) => u,
      loading: () => null,
      error: (_, __) => null,
    );

    if (user == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => AssetFormSheet(
        mode: AssetFormMode.create,
        companyId: appState.companyChoosen,
        storeId: assetState.selectedStoreId,
        currencySymbol: assetState.currencySymbol,
        onSave: (asset) async {
          try {
            final success = await ref.read(fixedAssetProvider.notifier).createAsset(asset);

            if (mounted && success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: TossColors.white, size: 20),
                      SizedBox(width: TossSpacing.space3),
                      Text('Asset added successfully'),
                    ],
                  ),
                  backgroundColor: TossColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                ),
              );
            } else if (mounted && !success) {
              final errorMsg = ref.read(fixedAssetProvider).errorMessage ?? 'Unknown error';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add asset: $errorMsg'),
                  backgroundColor: TossColors.error,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add asset: $e'),
                  backgroundColor: TossColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditAssetBottomSheet(FixedAsset asset, String currencySymbol) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => AssetFormSheet(
        mode: AssetFormMode.edit,
        existingAsset: asset,
        companyId: asset.companyId,
        storeId: asset.storeId,
        currencySymbol: currencySymbol,
        onSave: (updatedAsset) async {
          try {
            final success = await ref.read(fixedAssetProvider.notifier).updateAsset(updatedAsset);

            if (mounted && success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Asset updated successfully'),
                  backgroundColor: TossColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                ),
              );
            } else if (mounted && !success) {
              final errorMsg = ref.read(fixedAssetProvider).errorMessage ?? 'Unknown error';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update asset: $errorMsg'),
                  backgroundColor: TossColors.error,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update asset: $e'),
                  backgroundColor: TossColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildStoreSelector(List<dynamic> stores, String? selectedStoreId) {
    // Find selected store name
    String selectedStoreName = 'All Stores';
    if (selectedStoreId != null && stores.isNotEmpty) {
      try {
        final store = stores.firstWhere(
          (s) => (s as Map<String, dynamic>)['store_id'] == selectedStoreId,
          orElse: () => null,
        );
        if (store != null) {
          selectedStoreName = (store as Map<String, dynamic>)['store_name']?.toString() ?? 'Unknown Store';
        }
      } catch (e) {
        // Keep default name
      }
    }

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () async {
            final appState = ref.read(appStateProvider);

            // Create selection items with "All Stores" option
            final items = [
              TossSelectionItem.fromGeneric(
                id: '',
                title: 'All Stores',
                subtitle: 'Show assets from all stores',
                icon: Icons.store,
              ),
              ...stores.map((store) => TossSelectionItem.fromStore(store as Map<String, dynamic>)),
            ];

            await TossSelectionBottomSheet.show<void>(
              context: context,
              title: 'Select Store',
              items: items,
              selectedId: selectedStoreId ?? '',
              onItemSelected: (item) {
                final newStoreId = item.id.isEmpty ? null : item.id;

                // Update notifier
                ref.read(fixedAssetProvider.notifier).updateSelectedStore(newStoreId);

                // Update app state
                ref.read(appStateProvider.notifier).selectStore(item.id);

                // Reload assets with new store filter
                ref.read(fixedAssetProvider.notifier).loadAssets(
                  companyId: appState.companyChoosen,
                  storeId: newStoreId,
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedStoreName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: TossColors.gray400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
