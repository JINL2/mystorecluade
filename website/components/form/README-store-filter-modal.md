# Toss Store Filter Modal Component

A reusable modal component for filtering by store with a clean, modern design based on the employee management interface pattern.

## Component Location

**JavaScript**: `/components/form/toss-store-filter-modal.js`
**CSS**: `/components/form/toss-store-filter-modal.css`

## Features

- ✅ **Modal Interface**: Clean overlay modal design
- ✅ **Multi-select Support**: Select multiple stores or single store
- ✅ **Search Functionality**: Filter stores by name or description
- ✅ **All Stores Option**: Optional "All Stores" selection
- ✅ **Responsive Design**: Mobile-friendly layout
- ✅ **Keyboard Accessibility**: ESC to close, proper focus management
- ✅ **Customizable**: Extensive configuration options

## Basic Usage

### 1. Include the Component Files

```html
<!-- CSS -->
<link rel="stylesheet" href="components/form/toss-store-filter-modal.css">

<!-- JavaScript -->
<script src="components/form/toss-store-filter-modal.js"></script>
```

### 2. Initialize the Component

```javascript
// Sample store data
const stores = [
    {
        store_id: 'store-1',
        store_name: 'Downtown Branch',
        description: '123 Main St, Downtown'
    },
    {
        store_id: 'store-2', 
        store_name: 'Mall Location',
        description: 'Westfield Shopping Center'
    },
    {
        store_id: 'store-3',
        store_name: 'Airport Store', 
        description: 'Terminal 2, Gate B15'
    }
];

// Initialize the modal
const storeFilterModal = new TossStoreFilterModal({
    stores: stores,
    selectedStores: [], // Initially no stores selected
    onApply: (selectedStoreIds) => {
        console.log('Selected stores:', selectedStoreIds);
        // Handle the filter application
    }
});
```

### 3. Show the Modal

```javascript
// Show the modal (typically triggered by a button click)
document.getElementById('filter-button').addEventListener('click', () => {
    storeFilterModal.show();
});
```

## Configuration Options

```javascript
const options = {
    // Basic Options
    containerId: 'store-filter-modal',           // Modal container ID
    modalTitle: 'Filter by Store',               // Modal header title
    stores: [],                                  // Array of store objects
    selectedStores: [],                          // Array of initially selected store IDs
    
    // Feature Toggles
    showAllStoresOption: true,                   // Show "All Stores" option
    multiSelect: true,                           // Allow multiple store selection
    showSearch: true,                            // Enable search functionality
    
    // Labels & Text
    allStoresLabel: 'All Stores',               // Label for "All Stores" option
    searchPlaceholder: 'Search stores...',      // Search input placeholder
    confirmButtonText: 'Apply Filter',          // Confirm button text
    cancelButtonText: 'Cancel',                 // Cancel button text
    
    // Layout
    maxHeight: '400px',                         // Max height for store list
    
    // Callbacks
    onApply: (selectedStoreIds) => {},          // Called when Apply is clicked
    onCancel: () => {},                         // Called when modal is cancelled
    onStoreToggle: (storeId, currentSelection) => {} // Called when store is toggled
};

const modal = new TossStoreFilterModal(options);
```

## Store Data Format

Stores should be objects with the following structure:

```javascript
const store = {
    store_id: 'unique-store-id',        // Required: Unique identifier
    store_name: 'Store Name',           // Required: Display name
    description: 'Store Description',   // Optional: Subtitle/description
    
    // Alternative field names are also supported:
    id: 'unique-store-id',             // Alternative to store_id
    name: 'Store Name',                // Alternative to store_name
    address: 'Store Address'           // Alternative to description
};
```

## Methods

### Show/Hide Modal
```javascript
modal.show();           // Show the modal
modal.hide();           // Hide the modal
```

### Update Data
```javascript
// Update the stores list
modal.updateStores(newStoresArray);

// Set selected stores
modal.setSelectedStores(['store-1', 'store-3']);

// Get current selection
const selected = modal.getSelectedStores();
```

### Cleanup
```javascript
// Destroy the modal and clean up
modal.destroy();
```

## Complete Example

```html
<!DOCTYPE html>
<html>
<head>
    <title>Store Filter Example</title>
    <link rel="stylesheet" href="components/form/toss-store-filter-modal.css">
</head>
<body>
    <!-- Trigger Button -->
    <button id="show-filter" class="toss-btn toss-btn-primary">
        Filter by Store
    </button>
    
    <!-- Selected stores display -->
    <div id="selected-stores"></div>
    
    <script src="components/form/toss-store-filter-modal.js"></script>
    <script>
        // Sample data
        const stores = [
            { store_id: '1', store_name: 'Downtown', description: 'Main Street Location' },
            { store_id: '2', store_name: 'Mall', description: 'Shopping Center' },
            { store_id: '3', store_name: 'Airport', description: 'Terminal 2' }
        ];
        
        // Initialize modal
        const storeFilter = new TossStoreFilterModal({
            stores: stores,
            onApply: (selectedIds) => {
                updateSelectedDisplay(selectedIds);
            }
        });
        
        // Show modal on button click
        document.getElementById('show-filter').addEventListener('click', () => {
            storeFilter.show();
        });
        
        // Update display
        function updateSelectedDisplay(selectedIds) {
            const display = document.getElementById('selected-stores');
            if (selectedIds.length === 0 || selectedIds.includes('all')) {
                display.textContent = 'All Stores Selected';
            } else {
                const selectedNames = selectedIds.map(id => 
                    stores.find(s => s.store_id === id)?.store_name
                ).filter(Boolean);
                display.textContent = `Selected: ${selectedNames.join(', ')}`;
            }
        }
    </script>
</body>
</html>
```

## Integration with Existing Pages

To integrate with your existing pages (like employee management):

```javascript
// Example: Employee page with store filtering
class EmployeePage {
    constructor() {
        this.employees = [];
        this.filteredEmployees = [];
        
        // Initialize store filter modal
        this.storeFilter = new TossStoreFilterModal({
            stores: this.loadStores(),
            selectedStores: ['all'],
            onApply: (selectedStores) => {
                this.filterEmployeesByStore(selectedStores);
            }
        });
        
        this.setupFilterButton();
    }
    
    setupFilterButton() {
        // Add click handler to your existing "All Stores" button
        const filterButton = document.querySelector('.store-filter-button');
        filterButton.addEventListener('click', () => {
            this.storeFilter.show();
        });
    }
    
    filterEmployeesByStore(selectedStores) {
        if (selectedStores.includes('all') || selectedStores.length === 0) {
            this.filteredEmployees = [...this.employees];
        } else {
            this.filteredEmployees = this.employees.filter(emp => 
                selectedStores.includes(emp.store_id)
            );
        }
        
        this.renderEmployees();
        this.updateFilterButtonText(selectedStores);
    }
    
    updateFilterButtonText(selectedStores) {
        const button = document.querySelector('.store-filter-button');
        if (selectedStores.includes('all') || selectedStores.length === 0) {
            button.textContent = 'All Stores';
        } else if (selectedStores.length === 1) {
            const storeName = this.getStoreName(selectedStores[0]);
            button.textContent = storeName;
        } else {
            button.textContent = `${selectedStores.length} Stores`;
        }
    }
}
```

## Styling Customization

The component uses CSS custom properties that can be overridden:

```css
/* Customize colors */
.toss-store-filter-modal {
    --toss-primary: #your-primary-color;
    --toss-primary-surface: #your-surface-color;
    --toss-white: #ffffff;
    --toss-border: #e5e5e5;
}

/* Customize modal size */
.toss-store-filter-content {
    max-width: 600px; /* Make wider */
}

/* Customize store item appearance */
.toss-store-icon {
    background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
}
```

This component provides a professional, reusable solution for store filtering across your application pages.