/**
 * Toss Alert Component JavaScript
 * Handles alert interactions, toast notifications, and feedback management
 */

class TossAlert {
    constructor(element, options = {}) {
        this.element = element;
        this.options = {
            autoClose: false,
            duration: 5000,
            closable: true,
            onClose: null,
            onShow: null,
            ...options
        };
        
        this.isVisible = true;
        this.closeTimer = null;
        
        this.init();
    }
    
    init() {
        this.setupCloseButton();
        this.setupAutoClose();
        this.setupAccessibility();
        
        if (this.options.onShow) {
            this.options.onShow(this);
        }
    }
    
    setupCloseButton() {
        const closeButton = this.element.querySelector('.toss-alert-close');
        if (closeButton) {
            closeButton.addEventListener('click', () => {
                this.close();
            });
        }
    }
    
    setupAutoClose() {
        if (this.options.autoClose && this.options.duration > 0) {
            this.closeTimer = setTimeout(() => {
                this.close();
            }, this.options.duration);
            
            // Pause timer on hover
            this.element.addEventListener('mouseenter', () => {
                if (this.closeTimer) {
                    clearTimeout(this.closeTimer);
                }
            });
            
            // Resume timer on mouse leave
            this.element.addEventListener('mouseleave', () => {
                if (this.isVisible && this.options.autoClose) {
                    this.closeTimer = setTimeout(() => {
                        this.close();
                    }, 1000); // Shorter time after hover
                }
            });
        }
    }
    
    setupAccessibility() {
        // Add ARIA attributes
        this.element.setAttribute('role', 'alert');
        this.element.setAttribute('aria-live', 'assertive');
        
        // Focus management for important alerts
        if (this.element.classList.contains('toss-alert-error')) {
            this.element.setAttribute('tabindex', '-1');
            this.element.focus();
        }
    }
    
    close() {
        if (!this.isVisible) return;
        
        this.isVisible = false;
        
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
        }
        
        // Add closing animation
        this.element.style.animation = 'alertSlideOut 0.3s ease-out forwards';
        
        setTimeout(() => {
            if (this.element.parentNode) {
                this.element.parentNode.removeChild(this.element);
            }
            
            if (this.options.onClose) {
                this.options.onClose(this);
            }
        }, 300);
    }
    
    show() {
        if (this.isVisible) return;
        
        this.isVisible = true;
        this.element.style.display = 'flex';
        this.element.style.animation = 'alertSlideIn 0.3s ease-out forwards';
        
        this.setupAutoClose();
        
        if (this.options.onShow) {
            this.options.onShow(this);
        }
    }
    
    setText(content) {
        const contentElement = this.element.querySelector('.toss-alert-content');
        if (contentElement) {
            if (typeof content === 'string') {
                contentElement.innerHTML = content;
            } else {
                contentElement.innerHTML = '';
                contentElement.appendChild(content);
            }
        }
    }
    
    setType(type) {
        // Remove existing type classes
        this.element.classList.remove(
            'toss-alert-info',
            'toss-alert-success', 
            'toss-alert-warning',
            'toss-alert-error'
        );
        
        // Add new type class
        this.element.classList.add(`toss-alert-${type}`);
        
        // Update icon
        this.updateIcon(type);
    }
    
    updateIcon(type) {
        const iconElement = this.element.querySelector('.toss-alert-icon');
        if (iconElement) {
            const icons = {
                info: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-6h2v6zm0-8h-2V5h2v2z"/>',
                success: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm-1 13l-4-4 1.41-1.41L9 12.17l6.59-6.59L17 7l-8 8z"/>',
                warning: '<path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>',
                error: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-2h2v2zm0-4h-2V7h2v4z"/>'
            };
            
            iconElement.innerHTML = icons[type] || icons.info;
        }
    }
}

class TossToast {
    constructor(options = {}) {
        this.options = {
            type: 'info',
            message: '',
            duration: 4000,
            closable: true,
            showProgress: true,
            position: 'top-right',
            onClose: null,
            onShow: null,
            ...options
        };
        
        this.element = null;
        this.progressElement = null;
        this.isVisible = false;
        this.closeTimer = null;
        this.progressTimer = null;
        
        this.create();
        this.show();
    }
    
    create() {
        this.element = document.createElement('div');
        this.element.className = `toss-toast toss-toast-${this.options.type}`;
        
        // Create icon
        const icon = document.createElement('svg');
        icon.className = 'toss-toast-icon';
        icon.setAttribute('width', '20');
        icon.setAttribute('height', '20');
        icon.setAttribute('viewBox', '0 0 20 20');
        icon.setAttribute('fill', 'currentColor');
        
        const icons = {
            info: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-6h2v6zm0-8h-2V5h2v2z"/>',
            success: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm-1 13l-4-4 1.41-1.41L9 12.17l6.59-6.59L17 7l-8 8z"/>',
            warning: '<path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>',
            error: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-2h2v2zm0-4h-2V7h2v4z"/>'
        };
        
        icon.innerHTML = icons[this.options.type] || icons.info;
        
        // Create content
        const content = document.createElement('div');
        content.className = 'toss-toast-content';
        content.textContent = this.options.message;
        
        // Create close button if closable
        let closeButton = null;
        if (this.options.closable) {
            closeButton = document.createElement('button');
            closeButton.className = 'toss-toast-close';
            closeButton.setAttribute('aria-label', 'Close notification');
            closeButton.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M8 6.59L5.41 4 4 5.41 6.59 8 4 10.59 5.41 12 8 9.41 10.59 12 12 10.59 9.41 8 12 5.41 10.59 4 8 6.59z"/>
                </svg>
            `;
            
            closeButton.addEventListener('click', () => {
                this.close();
            });
        }
        
        // Create progress bar
        if (this.options.showProgress && this.options.duration > 0) {
            this.progressElement = document.createElement('div');
            this.progressElement.className = 'toss-toast-progress';
            this.progressElement.style.animationDuration = `${this.options.duration}ms`;
        }
        
        // Assemble toast
        this.element.appendChild(icon);
        this.element.appendChild(content);
        if (closeButton) {
            this.element.appendChild(closeButton);
        }
        if (this.progressElement) {
            this.element.appendChild(this.progressElement);
        }
        
        // Add accessibility attributes
        this.element.setAttribute('role', 'alert');
        this.element.setAttribute('aria-live', 'polite');
        if (this.options.type === 'error') {
            this.element.setAttribute('aria-live', 'assertive');
        }
    }
    
    show() {
        if (this.isVisible) return;
        
        this.isVisible = true;
        
        // Get or create toast container
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toss-toast-container';
            document.body.appendChild(container);
        }
        
        container.appendChild(this.element);
        
        // Auto-close timer
        if (this.options.duration > 0) {
            this.closeTimer = setTimeout(() => {
                this.close();
            }, this.options.duration);
            
            // Pause on hover
            this.element.addEventListener('mouseenter', () => {
                if (this.closeTimer) {
                    clearTimeout(this.closeTimer);
                }
                if (this.progressElement) {
                    this.progressElement.style.animationPlayState = 'paused';
                }
            });
            
            // Resume on mouse leave
            this.element.addEventListener('mouseleave', () => {
                if (this.isVisible) {
                    this.closeTimer = setTimeout(() => {
                        this.close();
                    }, 1000);
                    if (this.progressElement) {
                        this.progressElement.style.animationPlayState = 'running';
                    }
                }
            });
        }
        
        if (this.options.onShow) {
            this.options.onShow(this);
        }
    }
    
    close() {
        if (!this.isVisible) return;
        
        this.isVisible = false;
        
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
        }
        
        // Add closing animation
        this.element.style.animation = 'toastSlideOut 0.3s ease-out forwards';
        
        setTimeout(() => {
            if (this.element.parentNode) {
                this.element.parentNode.removeChild(this.element);
            }
            
            if (this.options.onClose) {
                this.options.onClose(this);
            }
        }, 300);
    }
}

// Utility functions for alert management
const TossAlertUtils = {
    /**
     * Initialize all alerts on the page
     */
    initializeAll(options = {}) {
        document.querySelectorAll('.toss-alert').forEach(alert => {
            if (!alert._tossAlert) {
                alert._tossAlert = new TossAlert(alert, options);
            }
        });
    },
    
    /**
     * Create an alert programmatically
     */
    createAlert(config) {
        const alert = document.createElement('div');
        alert.className = `toss-alert toss-alert-${config.type || 'info'}`;
        
        if (config.dismissible) {
            alert.classList.add('toss-alert-dismissible');
        }
        
        if (config.compact) {
            alert.classList.add('toss-alert-compact');
        }
        
        // Create icon
        const icon = document.createElement('svg');
        icon.className = 'toss-alert-icon';
        icon.setAttribute('width', config.compact ? '16' : '20');
        icon.setAttribute('height', config.compact ? '16' : '20');
        icon.setAttribute('viewBox', '0 0 20 20');
        icon.setAttribute('fill', 'currentColor');
        
        const icons = {
            info: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-6h2v6zm0-8h-2V5h2v2z"/>',
            success: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm-1 13l-4-4 1.41-1.41L9 12.17l6.59-6.59L17 7l-8 8z"/>',
            warning: '<path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>',
            error: '<path d="M10 2C5.58 2 2 5.58 2 10s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm1 13h-2v-2h2v2zm0-4h-2V7h2v4z"/>'
        };
        
        icon.innerHTML = icons[config.type] || icons.info;
        
        // Create content
        const content = document.createElement('div');
        content.className = 'toss-alert-content';
        
        if (config.title) {
            const title = document.createElement('strong');
            title.textContent = config.title;
            content.appendChild(title);
        }
        
        if (config.message) {
            const message = document.createElement('div');
            message.textContent = config.message;
            content.appendChild(message);
        }
        
        // Create close button if dismissible
        let closeButton = null;
        if (config.dismissible) {
            closeButton = document.createElement('button');
            closeButton.className = 'toss-alert-close';
            closeButton.setAttribute('aria-label', 'Close alert');
            closeButton.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M8 6.59L5.41 4 4 5.41 6.59 8 4 10.59 5.41 12 8 9.41 10.59 12 12 10.59 9.41 8 12 5.41 10.59 4 8 6.59z"/>
                </svg>
            `;
        }
        
        // Assemble alert
        alert.appendChild(icon);
        alert.appendChild(content);
        if (closeButton) {
            alert.appendChild(closeButton);
        }
        
        // Initialize alert behavior
        const tossAlert = new TossAlert(alert, config.options || {});
        
        return { element: alert, alert: tossAlert };
    },
    
    /**
     * Show a toast notification
     */
    showToast(options) {
        return new TossToast(options);
    },
    
    /**
     * Show success message
     */
    showSuccess(message, options = {}) {
        return this.showToast({
            type: 'success',
            message: message,
            ...options
        });
    },
    
    /**
     * Show error message
     */
    showError(message, options = {}) {
        return this.showToast({
            type: 'error',
            message: message,
            duration: 6000, // Longer duration for errors
            ...options
        });
    },
    
    /**
     * Show warning message
     */
    showWarning(message, options = {}) {
        return this.showToast({
            type: 'warning',
            message: message,
            ...options
        });
    },
    
    /**
     * Show info message
     */
    showInfo(message, options = {}) {
        return this.showToast({
            type: 'info',
            message: message,
            ...options
        });
    },
    
    /**
     * Close all alerts of a specific type
     */
    closeAllAlerts(type = null) {
        const selector = type ? `.toss-alert-${type}` : '.toss-alert';
        document.querySelectorAll(selector).forEach(alert => {
            if (alert._tossAlert) {
                alert._tossAlert.close();
            }
        });
    },
    
    /**
     * Close all toasts
     */
    closeAllToasts() {
        document.querySelectorAll('.toss-toast').forEach(toast => {
            if (toast._tossToast) {
                toast._tossToast.close();
            }
        });
    }
};

// Auto-initialize alerts when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    TossAlertUtils.initializeAll();
});

// Handle keyboard navigation
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        // Close focused toast or alert
        const focusedElement = document.activeElement;
        if (focusedElement && focusedElement.closest('.toss-toast, .toss-alert')) {
            const container = focusedElement.closest('.toss-toast, .toss-alert');
            if (container._tossAlert) {
                container._tossAlert.close();
            } else if (container._tossToast) {
                container._tossToast.close();
            }
        }
    }
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { TossAlert, TossToast, TossAlertUtils };
}