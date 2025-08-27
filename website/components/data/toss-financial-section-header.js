/**
 * Toss Financial Section Header Component
 * A specialized component for financial tables with reliable border rendering
 * 
 * Usage:
 * const header = new TossFinancialSectionHeader({
 *     container: '#header-container',
 *     title: 'REVENUE',
 *     type: 'revenue',
 *     colspan: 2
 * });
 */

class TossFinancialSectionHeader {
    constructor(options = {}) {
        this.options = {
            container: options.container || '.toss-financial-section-header-container',
            title: options.title || 'SECTION',
            type: options.type || 'default', // revenue, cogs, expenses, net-income, default
            colspan: options.colspan || 2,
            tableMode: options.tableMode !== false, // true for table cell, false for standalone div
            className: options.className || '',
            ...options
        };
        
        this.container = null;
        this.element = null;
        
        this.init();
    }
    
    init() {
        const container = document.querySelector(this.options.container);
        if (!container) {
            console.error('TossFinancialSectionHeader: Container not found:', this.options.container);
            return;
        }
        
        this.container = container;
        this.render();
    }
    
    render() {
        if (this.options.tableMode) {
            this.renderTableHeader();
        } else {
            this.renderStandaloneHeader();
        }
    }
    
    renderTableHeader() {
        const typeClass = this.getTypeClass();
        const customClass = this.options.className ? ` ${this.options.className}` : '';
        
        const html = `
            <tr class="toss-financial-section-header-row section-header ${typeClass}${customClass}">
                <td class="toss-financial-section-header-cell" colspan="${this.options.colspan}">
                    ${this.escapeHtml(this.options.title)}
                </td>
            </tr>
        `;
        
        this.container.innerHTML = html;
        this.element = this.container.querySelector('.toss-financial-section-header-row');
    }
    
    renderStandaloneHeader() {
        const typeClass = this.getTypeClass();
        const customClass = this.options.className ? ` ${this.options.className}` : '';
        
        const html = `
            <div class="toss-financial-section-header ${typeClass}${customClass}">
                ${this.escapeHtml(this.options.title)}
            </div>
        `;
        
        this.container.innerHTML = html;
        this.element = this.container.querySelector('.toss-financial-section-header');
    }
    
    getTypeClass() {
        const typeMap = {
            'revenue': 'revenue',
            'cogs': 'cogs',
            'cost-of-goods-sold': 'cogs',
            'expenses': 'expenses',
            'expense': 'expenses',
            'net-income': 'net-income',
            'net_income': 'net-income',
            'default': 'revenue' // Default to revenue styling
        };
        
        return typeMap[this.options.type.toLowerCase()] || 'revenue';
    }
    
    updateTitle(newTitle) {
        this.options.title = newTitle;
        if (this.element) {
            const cell = this.element.querySelector('.toss-financial-section-header-cell');
            if (cell) {
                cell.textContent = this.escapeHtml(newTitle);
            } else if (this.element.classList.contains('toss-financial-section-header')) {
                this.element.textContent = this.escapeHtml(newTitle);
            }
        }
    }
    
    updateType(newType) {
        if (this.element) {
            // Remove old type classes
            const oldTypeClass = this.getTypeClass();
            this.element.classList.remove(oldTypeClass);
            
            // Update type and add new class
            this.options.type = newType;
            const newTypeClass = this.getTypeClass();
            this.element.classList.add(newTypeClass);
            
            // Update cell classes if in table mode
            if (this.options.tableMode) {
                const cell = this.element.querySelector('.toss-financial-section-header-cell');
                if (cell) {
                    // Update border colors via CSS custom properties would be ideal,
                    // but for now the CSS handles the different types
                }
            }
        }
    }
    
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    destroy() {
        if (this.container) {
            this.container.innerHTML = '';
        }
        this.element = null;
        this.container = null;
    }
    
    // Static method to create section header HTML
    static createHTML(title, type = 'revenue', colspan = 2, tableMode = true, className = '') {
        const typeClass = TossFinancialSectionHeader.getStaticTypeClass(type);
        const customClass = className ? ` ${className}` : '';
        
        if (tableMode) {
            return `
                <tr class="toss-financial-section-header-row section-header ${typeClass}${customClass}">
                    <td class="toss-financial-section-header-cell" colspan="${colspan}">
                        ${TossFinancialSectionHeader.escapeStaticHtml(title)}
                    </td>
                </tr>
            `;
        } else {
            return `
                <div class="toss-financial-section-header ${typeClass}${customClass}">
                    ${TossFinancialSectionHeader.escapeStaticHtml(title)}
                </div>
            `;
        }
    }
    
    static getStaticTypeClass(type) {
        const typeMap = {
            'revenue': 'revenue',
            'cogs': 'cogs',
            'cost-of-goods-sold': 'cogs',
            'expenses': 'expenses',
            'expense': 'expenses',
            'net-income': 'net-income',
            'net_income': 'net-income',
            'default': 'revenue'
        };
        
        return typeMap[type.toLowerCase()] || 'revenue';
    }
    
    static escapeStaticHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TossFinancialSectionHeader;
}