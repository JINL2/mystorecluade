/**
 * Toss Modal Component
 * Based on Toss Design System
 * Reusable modal component for popups and dialogs
 */

class TossModal {
    constructor(options = {}) {
        this.options = {
            id: options.id || 'toss-modal-' + Date.now(),
            title: options.title || '',
            subtitle: options.subtitle || '',
            content: options.content || '',
            size: options.size || 'md', // sm, md, lg, xl, fullscreen
            icon: options.icon || null, // { type: 'success|error|warning|info', svg: '...' }
            showClose: options.showClose !== false,
            showHeader: options.showHeader !== false,
            showFooter: options.showFooter !== false,
            tabs: options.tabs || [], // [{ id: 'tab1', label: 'Tab 1', content: '...', active: true }]
            buttons: options.buttons || [], // [{ label: 'OK', class: 'toss-btn-primary', onClick: fn }]
            onOpen: options.onOpen || null,
            onClose: options.onClose || null,
            closeOnOverlay: options.closeOnOverlay !== false,
            closeOnEsc: options.closeOnEsc !== false,
            centered: options.centered || false,
            className: options.className || '',
            zIndex: options.zIndex || null // Custom z-index override
        };
        
        this.modal = null;
        this.overlay = null;
        this.isOpen = false;
        this.activeTab = null;
        
        this.init();
    }
    
    init() {
        this.createModal();
        this.attachEventListeners();
    }
    
    createModal() {
        // Create overlay
        this.overlay = document.createElement('div');
        this.overlay.className = `toss-modal-overlay ${this.options.className}`;
        this.overlay.id = this.options.id + '-overlay';
        
        // Create modal container
        this.modal = document.createElement('div');
        this.modal.className = `toss-modal toss-modal-${this.options.size} ${this.options.className}`;
        this.modal.id = this.options.id;
        
        // Build modal content
        let modalHTML = '';
        
        // Header
        if (this.options.showHeader) {
            modalHTML += this.buildHeader();
        }
        
        // Tabs (if provided)
        if (this.options.tabs.length > 0) {
            modalHTML += this.buildTabs();
        }
        
        // Body
        modalHTML += this.buildBody();
        
        // Footer
        if (this.options.showFooter && this.options.buttons.length > 0) {
            modalHTML += this.buildFooter();
        }
        
        this.modal.innerHTML = modalHTML;
        this.overlay.appendChild(this.modal);
        document.body.appendChild(this.overlay);
        
        // Set custom z-index if provided
        if (this.options.zIndex) {
            this.overlay.style.zIndex = this.options.zIndex;
        }
        
        // Set active tab if tabs exist
        if (this.options.tabs.length > 0) {
            const activeTab = this.options.tabs.find(tab => tab.active) || this.options.tabs[0];
            this.setActiveTab(activeTab.id);
        }
    }
    
    buildHeader() {
        const iconHTML = this.options.icon ? `
            <div class="toss-modal-icon ${this.options.icon.type || ''}">
                ${this.options.icon.svg || this.getDefaultIcon(this.options.icon.type)}
            </div>
        ` : '';
        
        const closeButtonHTML = this.options.showClose ? `
            <button class="toss-modal-close" onclick="${this.options.id}_instance.close()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        ` : '';
        
        return `
            <div class="toss-modal-header">
                <div class="toss-modal-header-content">
                    ${iconHTML}
                    <div>
                        <h2 class="toss-modal-title">${this.options.title}</h2>
                        ${this.options.subtitle ? `<p class="toss-modal-subtitle">${this.options.subtitle}</p>` : ''}
                    </div>
                </div>
                ${closeButtonHTML}
            </div>
        `;
    }
    
    buildTabs() {
        const tabsHTML = this.options.tabs.map(tab => `
            <button class="toss-modal-tab ${tab.active ? 'active' : ''}" 
                    data-tab-id="${tab.id}"
                    onclick="${this.options.id}_instance.switchTab('${tab.id}')">
                ${tab.label}
            </button>
        `).join('');
        
        return `<div class="toss-modal-tabs">${tabsHTML}</div>`;
    }
    
    buildBody() {
        if (this.options.tabs.length > 0) {
            // Build tab panels
            const panelsHTML = this.options.tabs.map(tab => `
                <div class="toss-modal-panel ${tab.active ? 'active' : ''}" data-panel-id="${tab.id}">
                    ${this.options.centered ? this.buildCenteredContent(tab.content) : tab.content}
                </div>
            `).join('');
            
            return `<div class="toss-modal-body">${panelsHTML}</div>`;
        } else {
            // Single content
            const content = this.options.centered ? 
                this.buildCenteredContent(this.options.content) : 
                this.options.content;
            
            return `<div class="toss-modal-body">${content}</div>`;
        }
    }
    
    buildCenteredContent(content) {
        // Check if content is already structured for centered display
        if (typeof content === 'object' && content.icon) {
            return `
                <div class="toss-modal-centered-content">
                    <div class="toss-modal-content-icon">
                        ${content.icon}
                    </div>
                    <h3 class="toss-modal-content-title">${content.title || ''}</h3>
                    <p class="toss-modal-content-description">${content.description || ''}</p>
                </div>
            `;
        }
        
        // Default centered content wrapper
        return `<div class="toss-modal-centered-content">${content}</div>`;
    }
    
    buildFooter() {
        const buttonsHTML = this.options.buttons.map((btn, index) => {
            const btnClass = btn.class || 'toss-btn toss-btn-secondary';
            const buttonId = btn.id || `${this.options.id}-btn-${index}`;
            
            return `
                <button class="${btnClass}" 
                        id="${buttonId}"
                        data-btn-index="${index}"
                        ${btn.disabled ? 'disabled' : ''}>
                    ${btn.icon ? btn.icon : ''}
                    ${btn.label}
                </button>
            `;
        }).join('');
        
        const footerClass = this.options.buttons.find(b => b.align === 'left') ? 'toss-modal-footer-between' : '';
        
        return `
            <div class="toss-modal-footer ${footerClass}">
                ${buttonsHTML}
            </div>
        `;
    }
    
    getDefaultIcon(type) {
        const icons = {
            success: '<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>',
            error: '<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>',
            warning: '<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>',
            info: '<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>'
        };
        
        return icons[type] || '';
    }
    
    attachEventListeners() {
        // Attach button click handlers
        this.options.buttons.forEach((btn, index) => {
            if (btn.onClick) {
                const buttonId = btn.id || `${this.options.id}-btn-${index}`;
                // Use CSS.escape to properly escape the ID for querySelector
                const escapedId = CSS.escape ? CSS.escape(buttonId) : buttonId.replace(/([!"#$%&'()*+,.\/:;<=>?@[\\\]^`{|}~])/g, '\\$1');
                const buttonEl = this.modal.querySelector(`#${escapedId}`);
                if (buttonEl) {
                    buttonEl.addEventListener('click', () => {
                        btn.onClick(this);
                    });
                }
            }
        });
        
        // Close on overlay click
        if (this.options.closeOnOverlay) {
            this.overlay.addEventListener('click', (e) => {
                if (e.target === this.overlay) {
                    this.close();
                }
            });
        }
        
        // Close on ESC key
        if (this.options.closeOnEsc) {
            this.escHandler = (e) => {
                if (e.key === 'Escape' && this.isOpen) {
                    this.close();
                }
            };
        }
    }
    
    open() {
        if (this.isOpen) return;
        
        this.overlay.classList.add('show');
        this.modal.classList.add('toss-modal-fade-in');
        document.body.style.overflow = 'hidden';
        this.isOpen = true;
        
        // Attach ESC handler when opening
        if (this.escHandler) {
            document.addEventListener('keydown', this.escHandler);
        }
        
        // Callback
        if (this.options.onOpen) {
            this.options.onOpen(this);
        }
    }
    
    close() {
        if (!this.isOpen) return;
        
        this.modal.classList.remove('toss-modal-fade-in');
        this.modal.classList.add('toss-modal-fade-out');
        
        setTimeout(() => {
            this.overlay.classList.remove('show');
            this.modal.classList.remove('toss-modal-fade-out');
            document.body.style.overflow = '';
            this.isOpen = false;
            
            // Remove ESC handler when closing
            if (this.escHandler) {
                document.removeEventListener('keydown', this.escHandler);
            }
            
            // Callback
            if (this.options.onClose) {
                this.options.onClose(this);
            }
        }, 250);
    }
    
    switchTab(tabId) {
        // Update tab buttons
        this.modal.querySelectorAll('.toss-modal-tab').forEach(tab => {
            if (tab.dataset.tabId === tabId) {
                tab.classList.add('active');
            } else {
                tab.classList.remove('active');
            }
        });
        
        // Update panels
        this.modal.querySelectorAll('.toss-modal-panel').forEach(panel => {
            if (panel.dataset.panelId === tabId) {
                panel.classList.add('active');
            } else {
                panel.classList.remove('active');
            }
        });
        
        this.activeTab = tabId;
    }
    
    setActiveTab(tabId) {
        this.switchTab(tabId);
    }
    
    // This method is no longer used as we attach event listeners directly
    // Kept for backward compatibility if needed
    handleButtonClick(index) {
        const button = this.options.buttons[index];
        if (button && button.onClick) {
            button.onClick(this);
        }
    }
    
    updateContent(content) {
        const body = this.modal.querySelector('.toss-modal-body');
        if (body) {
            body.innerHTML = this.options.centered ? 
                this.buildCenteredContent(content) : 
                content;
        }
    }
    
    updateTitle(title) {
        const titleElement = this.modal.querySelector('.toss-modal-title');
        if (titleElement) {
            titleElement.textContent = title;
        }
        this.options.title = title;
    }
    
    destroy() {
        // Remove event listeners
        if (this.escHandler) {
            document.removeEventListener('keydown', this.escHandler);
        }
        
        // Remove global reference
        delete window[this.options.id + '_instance'];
        
        // Remove from DOM
        if (this.overlay && this.overlay.parentNode) {
            this.overlay.parentNode.removeChild(this.overlay);
        }
        
        this.modal = null;
        this.overlay = null;
    }
}

// Export for use
window.TossModal = TossModal;