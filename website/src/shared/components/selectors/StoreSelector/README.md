# StoreSelector Component

A reusable store selector dropdown component with configurable options for displaying and selecting stores from any company.

## Features

- 🏪 **Multi-Company Support**: Configurable to work with stores from any company
- 📏 **Customizable Size**: Configurable width and max-height with documented defaults
- ✅ **Visual Selection Feedback**: Blue checkmarks and background for selected items
- 🏠 **Home Icons**: Material Design home icons for all store items
- 🎨 **Toss Design System**: Matches the Toss design language
- 🔒 **Type Safety**: Full TypeScript support with exported types
- ♿ **Accessibility**: Keyboard navigation and click-outside-to-close support

## Installation

Import the component from the shared selectors directory:

```tsx
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import type { StoreSelectorProps } from '@/shared/components/selectors/StoreSelector';
```

## Basic Usage

```tsx
import { useState } from 'react';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';

function MyPage() {
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  const stores = [
    { store_id: '1', store_name: '강남점' },
    { store_id: '2', store_name: '홍대점' },
    { store_id: '3', store_name: '명동점' },
  ];

  return (
    <StoreSelector
      stores={stores}
      selectedStoreId={selectedStoreId}
      onStoreSelect={setSelectedStoreId}
    />
  );
}
```

## Advanced Usage

### Custom Size

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  width="320px"        // Default: 280px
  maxHeight="400px"    // Default: 380px
/>
```

### Multi-Company Support

```tsx
<StoreSelector
  stores={companyA.stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  companyId={companyA.company_id}
/>
```

### Custom Labels (Localization)

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  allStoresLabel="모든 매장"  // Korean
  showAllStoresOption={true}
/>
```

### Disabled State

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  disabled={true}
/>
```

### Hide "All Stores" Option

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  showAllStoresOption={false}
/>
```

## Props API

### `StoreSelectorProps`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `stores` | `Store[]` | Required | Array of stores to display |
| `selectedStoreId` | `string \| null` | Required | Currently selected store ID (null = "All Stores") |
| `onStoreSelect` | `(storeId: string \| null) => void` | Required | Callback when store is selected |
| `companyId` | `string` | Optional | Company ID for multi-company support |
| `width` | `string` | `'280px'` | Custom width (e.g., '300px', '20rem', '100%') |
| `maxHeight` | `string` | `'380px'` | Max height for dropdown (e.g., '400px', '25rem') |
| `className` | `string` | `''` | Additional CSS classes |
| `showAllStoresOption` | `boolean` | `true` | Show/hide "All Stores" option |
| `allStoresLabel` | `string` | `'All Stores'` | Custom label for "All Stores" (for localization) |
| `disabled` | `boolean` | `false` | Disable the selector |

### `Store` Type

```typescript
interface Store {
  store_id: string;    // Unique store identifier
  store_name: string;  // Display name for the store
}
```

## Default Sizes

The component uses the following default dimensions that can be overridden:

- **Width**: `280px` - Control section width
- **Max Height**: `380px` - Maximum height for dropdown list
- **Control Height**: `48px` - Fixed height of control section
- **Option Height**: `48px` - Fixed height of each dropdown option

## Styling

The component uses CSS Modules for scoped styling. You can:

1. Override via `className` prop for additional styling
2. Use CSS custom properties via inline styles:

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  style={{
    '--store-selector-width': '350px',
    '--store-selector-max-height': '450px',
  } as React.CSSProperties}
/>
```

## Examples

### Example 1: Inventory Page

```tsx
import { useAppState } from '@/app/providers/app_state_provider';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';

function InventoryPage() {
  const { currentCompany } = useAppState();
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);

  return (
    <StoreSelector
      stores={currentCompany?.stores || []}
      selectedStoreId={selectedStoreId}
      onStoreSelect={setSelectedStoreId}
      companyId={currentCompany?.company_id}
    />
  );
}
```

### Example 2: Sales Report with Custom Styling

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  width="100%"
  maxHeight="500px"
  className={styles.customSelector}
/>
```

### Example 3: Korean Localization

```tsx
<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreSelect}
  allStoresLabel="전체 매장"
/>
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Accessibility

- Click outside to close dropdown
- Proper event propagation handling
- Visual selection indicators
- Disabled state support

## Migration Guide

If you're migrating from inline store selector code:

### Before:

```tsx
// Inline store selector code in component
const [storeDropdownOpen, setStoreDropdownOpen] = useState(false);
// ... lots of JSX for dropdown
```

### After:

```tsx
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';

<StoreSelector
  stores={currentCompany?.stores || []}
  selectedStoreId={selectedStoreId}
  onStoreSelect={setSelectedStoreId}
/>
```

## Notes

- The component automatically closes dropdown when clicking outside
- Selecting a store closes the dropdown automatically
- Empty state is shown when no stores are available
- Event propagation is properly managed to prevent conflicts

## Related Components

- [TossButton](../../toss/TossButton) - For action buttons
- [TossInput](../../toss/TossInput) - For text inputs
- [Navbar](../../common/Navbar) - Main navigation component
