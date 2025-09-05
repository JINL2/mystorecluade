#!/usr/bin/env node

/**
 * Update All Pages Script
 * Adds storage-manager.js to all HTML pages
 */

const fs = require('fs');
const path = require('path');

const pages = [
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/dashboard/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/employee/employee-setting/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/employee/salary/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/employee/schedule/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/finance/balance-sheet/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/finance/cash-ending/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/finance/income-statement/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/finance/journal-input/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/finance/transaction-history/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/marketing/marketing-plan/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/product/inventory/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/settings/account-mapping/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/settings/company-store/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/settings/counterparty/index.html',
    '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/pages/settings/currency/index.html'
];

function getRelativePath(filePath) {
    // Count how many directories deep we are
    const afterPages = filePath.split('/pages/')[1];
    const depth = afterPages.split('/').length - 1;
    
    // Generate the appropriate number of ../
    if (depth === 3) {
        return '../../../core/utils/storage-manager.js';
    } else if (depth === 2) {
        return '../../core/utils/storage-manager.js';
    } else {
        return '../core/utils/storage-manager.js';
    }
}

pages.forEach(pagePath => {
    try {
        let content = fs.readFileSync(pagePath, 'utf8');
        
        // Check if storage-manager is already included
        if (!content.includes('storage-manager.js')) {
            const relativePath = getRelativePath(pagePath);
            
            // Find where to insert - right before supabase.js
            const supabaseIndex = content.indexOf('<!-- Supabase Configuration -->');
            
            if (supabaseIndex !== -1) {
                const insertText = `    <!-- Storage Manager -->\n    <script src="${relativePath}"></script>\n    \n`;
                content = content.slice(0, supabaseIndex) + insertText + content.slice(supabaseIndex);
                
                fs.writeFileSync(pagePath, content, 'utf8');
                console.log(`✅ Updated: ${path.basename(path.dirname(pagePath))}/index.html`);
            } else {
                console.log(`⚠️ Could not find insertion point in: ${path.basename(path.dirname(pagePath))}/index.html`);
            }
        } else {
            console.log(`ℹ️ Already updated: ${path.basename(path.dirname(pagePath))}/index.html`);
        }
    } catch (error) {
        console.error(`❌ Error updating ${pagePath}:`, error.message);
    }
});

console.log('\n✨ All pages have been updated with storage-manager.js');
