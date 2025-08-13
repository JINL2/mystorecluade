# Company & Store Dashboard Widget Design

## Purpose
The Company & Store Dashboard is a widget that opens from the homepage (via drawer or app bar) to provide an intuitive interface for selecting the active company and store. It displays user data with smart caching and persists selections across app sessions.

## Widget Type
This is a **Bottom Sheet Modal Widget** that slides up from the bottom of the screen, providing a focused selection experience without navigating away from the homepage.

## Integration with Homepage

### Opening the Dashboard
The dashboard can be opened from:
1. **App Bar**: Company/Store name tap
2. **Drawer Menu**: "Switch Company/Store" button
3. **First Login**: Auto-opens if no company selected

### Homepage Integration Points
```dart
// In homepage_page.dart
void _openCompanyStoreDashboard() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CompanyStoreDashboardWidget(
      onSelectionComplete: (company, store) {
        // Update providers
        ref.read(selectedCompanyProvider.notifier).selectCompany(company);
        ref.read(selectedStoreProvider.notifier).selectStore(store);
        // Close dashboard
        Navigator.pop(context);
        // Refresh homepage
        _refreshHomepage();
      },
    ),
  );
}
```

## Widget Structure

### 1. Bottom Sheet Container
```dart
class CompanyStoreDashboardWidget extends ConsumerStatefulWidget {
  final Function(Company company, Store? store) onSelectionComplete;
  
  const CompanyStoreDashboardWidget({
    Key? key,
    required this.onSelectionComplete,
  }) : super(key: key);
}
```

### 2. Visual Layout
```
┌────────────────────────────────────────┐
│  ─────                                 │ ← Drag handle
│                                        │
│  Select Company & Store          ✕     │ ← Header with close
│                                        │
│  👤 Welcome back, Jin                  │ ← User greeting
│  You have access to 3 companies        │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  🏢 MyCompany                 ✓  │  │ ← Selected company
│  │  Technology • Owner              │  │
│  │  2 stores available              │  │
│  │                                  │  │
│  │  📍 Main Store             [✓]   │  │ ← Store selection
│  │  📍 Branch Store           [ ]   │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  🏢 SecondCompany              │  │ ← Unselected company
│  │  Retail • Manager               │  │
│  │  1 store available               │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  ➕ Add New Company             │  │ ← Add company option
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  🔗 Join Company with Code      │  │ ← Join by code
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │       Continue                   │  │ ← Primary action
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

## Component Breakdown

### 1. Dashboard Container
```dart
Container(
  height: MediaQuery.of(context).size.height * 0.85, // 85% of screen
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  child: Column(
    children: [
      _DragHandle(),
      _Header(),
      _UserInfo(),
      Expanded(child: _CompanyList()),
      _ActionButtons(),
      _ContinueButton(),
    ],
  ),
)
```

### 2. Company Card Component
```dart
class _CompanyCard extends StatelessWidget {
  final Company company;
  final bool isSelected;
  final Store? selectedStore;
  final Function(Company) onCompanyTap;
  final Function(Store) onStoreTap;
  
  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: () => onCompanyTap(company),
      selected: isSelected,
      child: Column(
        children: [
          // Company header
          Row(
            children: [
              _CompanyIcon(company.name),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: TossTextStyles.h4),
                    Text(
                      '${company.type} • ${company.role.name}',
                      style: TossTextStyles.caption,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: TossColors.primary),
            ],
          ),
          
          // Store list (if selected)
          if (isSelected) ...[
            SizedBox(height: 12),
            ...company.stores.map((store) => 
              _StoreItem(
                store: store,
                isSelected: selectedStore?.id == store.id,
                onTap: () => onStoreTap(store),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 3. Store Item Component
```dart
class _StoreItem extends StatelessWidget {
  final Store store;
  final bool isSelected;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.location_on, size: 20, color: TossColors.gray600),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                store.name,
                style: TossTextStyles.body,
              ),
            ),
            TossRadio(
              value: isSelected,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}
```

## State Management

### 1. Dashboard State Provider
```dart
@riverpod
class CompanyDashboardState extends _$CompanyDashboardState {
  @override
  CompanyDashboardStateData build() {
    final userData = ref.watch(userDataProvider);
    final appSelection = ref.watch(appSelectionProvider);
    
    return CompanyDashboardStateData(
      companies: userData.companies,
      selectedCompanyId: appSelection.selectedCompanyId,
      selectedStoreId: appSelection.selectedStoreId,
      isLoading: false,
    );
  }
  
  void selectCompany(Company company) {
    state = state.copyWith(
      selectedCompanyId: company.id,
      selectedStoreId: null, // Reset store when company changes
    );
  }
  
  void selectStore(Store store) {
    state = state.copyWith(selectedStoreId: store.id);
  }
}
```

### 2. Persistence Provider
```dart
@riverpod
class AppSelectionPersistence extends _$AppSelectionPersistence {
  @override
  Future<void> build() async {
    // Load persisted selections on startup
    final prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('selected_company_id');
    final storeId = prefs.getString('selected_store_id');
    
    if (companyId != null) {
      ref.read(selectedCompanyProvider.notifier).selectById(companyId);
    }
    if (storeId != null) {
      ref.read(selectedStoreProvider.notifier).selectById(storeId);
    }
  }
  
  Future<void> persistSelection(String companyId, String? storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_company_id', companyId);
    if (storeId != null) {
      await prefs.setString('selected_store_id', storeId);
    } else {
      await prefs.remove('selected_store_id');
    }
  }
}
```

## RPC Integration

### Get User Companies RPC
```dart
// Called by userDataProvider
Future<UserData> getUserCompanies(String userId) async {
  final response = await supabase.rpc(
    'get_user_companies',
    params: {'p_user_id': userId},
  );
  
  return UserData.fromJson(response);
}
```

### RPC Response Caching
```dart
@riverpod
class UserDataCache extends _$UserDataCache {
  static const _cacheKey = 'user_data_cache';
  static const _cacheExpiry = Duration(hours: 24);
  
  @override
  Future<UserData?> build() async {
    // Try loading from cache first
    final cached = await _loadFromCache();
    if (cached != null && !_isExpired(cached)) {
      return cached.data;
    }
    
    // Otherwise fetch fresh data
    return _fetchAndCache();
  }
  
  Future<UserData> _fetchAndCache() async {
    final userId = ref.watch(currentUserIdProvider);
    final data = await getUserCompanies(userId);
    
    // Cache the result
    await _saveToCache(data);
    
    return data;
  }
}
```

## Animations & Interactions

### 1. Opening Animation
- Slide up from bottom: 350ms ease-out
- Background fade: 250ms
- Content stagger: 50ms delay per item

### 2. Selection Feedback
- Company card tap: Scale to 0.98
- Store selection: Smooth radio animation
- Continue button: Enable/disable with fade

### 3. Micro-interactions
- Pull down to dismiss
- Haptic feedback on selection
- Success animation on continue

## Error Handling

### 1. Network Errors
```dart
Widget _buildErrorState(String message) {
  return TossErrorWidget(
    title: 'Unable to load companies',
    message: message,
    onRetry: _retryLoading,
  );
}
```

### 2. Empty States
```dart
Widget _buildEmptyState() {
  return TossEmptyWidget(
    icon: Icons.business,
    title: 'No companies yet',
    message: 'Create your first company or join one with a code',
    action: TossButton(
      text: 'Create Company',
      onPressed: _openCreateCompany,
    ),
  );
}
```

## Accessibility

- **Screen Reader**: Semantic labels for all interactive elements
- **Keyboard Navigation**: Tab order and enter/space selection
- **Focus Management**: Auto-focus on first company
- **Announcements**: Selection changes announced

## Performance Considerations

1. **Lazy Loading**: Load store details only when company selected
2. **Image Caching**: Cache company logos/avatars
3. **Debounced Selection**: Prevent rapid selection changes
4. **Optimistic Updates**: Update UI before API confirmation

## Analytics Events

```dart
// Track user interactions
analytics.track('company_dashboard_opened');
analytics.track('company_selected', {
  'company_id': company.id,
  'company_name': company.name,
  'role': company.role.name,
});
analytics.track('store_selected', {
  'store_id': store.id,
  'store_name': store.name,
  'company_id': company.id,
});
analytics.track('company_dashboard_completed');
```

## Usage Example

```dart
// In homepage, open dashboard on company name tap
GestureDetector(
  onTap: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CompanyStoreDashboardWidget(
        onSelectionComplete: (company, store) {
          // Handle selection
          _updateAppState(company, store);
          // Refresh homepage
          _refreshFeatures();
        },
      ),
    );
  },
  child: Row(
    children: [
      Text(selectedCompany.name),
      Icon(Icons.arrow_drop_down, size: 16),
    ],
  ),
)
```