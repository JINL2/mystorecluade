/**
 * Page Generator Script
 * Creates all pages with common navbar and data persistence
 */

const pages = [
    // Finance Pages
    { path: 'finance/income-statement', title: 'Income Statement', subtitle: 'View revenue and expenses', activeItem: 'finance' },
    { path: 'finance/journal-input', title: 'Journal Input', subtitle: 'Record financial transactions', activeItem: 'finance' },
    { path: 'finance/transaction-history', title: 'Transaction History', subtitle: 'View all transactions', activeItem: 'finance' },
    { path: 'finance/cash-ending', title: 'Cash Ending', subtitle: 'Daily cash reconciliation', activeItem: 'finance' },
    
    // Employee Pages
    { path: 'employee/schedule', title: 'Employee Schedule', subtitle: 'Manage work schedules', activeItem: 'employee' },
    { path: 'employee/employee-setting', title: 'Employee Settings', subtitle: 'Manage employee information', activeItem: 'employee' },
    { path: 'employee/salary', title: 'Salary Management', subtitle: 'Manage payroll and compensation', activeItem: 'employee' },
    
    // Product Pages
    { path: 'product/inventory', title: 'Inventory', subtitle: 'Manage product inventory', activeItem: 'product' },
    
    // Marketing Pages
    { path: 'marketing/marketing-plan', title: 'Marketing Plan', subtitle: 'Plan and track marketing campaigns', activeItem: 'marketing' },
    
    // Settings Pages
    { path: 'settings/currency', title: 'Currency Settings', subtitle: 'Configure currency and exchange rates', activeItem: 'setting' },
    { path: 'settings/store-setting', title: 'Company & Store Settings', subtitle: 'Manage company and store information', activeItem: 'setting' },
    { path: 'settings/account-mapping', title: 'Account Mapping', subtitle: 'Configure chart of accounts', activeItem: 'setting' },
    { path: 'settings/counterparty', title: 'Counterparty', subtitle: 'Manage business partners', activeItem: 'setting' }
];

// Export for use in build scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = pages;
}