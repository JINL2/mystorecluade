/**
 * Toss Button Component JavaScript
 * Interactive behaviors and utilities
 */

class TossButton {
    constructor(element) {
        this.element = element;
        this.init();
    }

    init() {
        // Add ripple effect on click
        this.element.addEventListener('click', this.createRipple.bind(this));
        
        // Handle loading state
        if (this.element.dataset.loading) {
            this.setLoading(true);
        }
    }

    /**
     * Create ripple effect on button click
     */
    createRipple(event) {
        if (this.element.disabled) return;
        
        const button = event.currentTarget;
        const ripple = document.createElement('span');
        const rect = button.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = event.clientX - rect.left - size / 2;
        const y = event.clientY - rect.top - size / 2;
        
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = x + 'px';
        ripple.style.top = y + 'px';
        ripple.classList.add('toss-ripple');
        
        button.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    }

    /**
     * Set loading state
     */
    setLoading(isLoading) {
        if (isLoading) {
            this.element.classList.add('toss-btn-loading');
            this.element.disabled = true;
            
            // Add spinner if not exists
            if (!this.element.querySelector('.toss-spinner')) {
                const spinner = document.createElement('span');
                spinner.className = 'toss-spinner';
                this.element.appendChild(spinner);
            }
        } else {
            this.element.classList.remove('toss-btn-loading');
            this.element.disabled = false;
            
            // Remove spinner
            const spinner = this.element.querySelector('.toss-spinner');
            if (spinner) {
                spinner.remove();
            }
        }
    }

    /**
     * Enable the button
     */
    enable() {
        this.element.disabled = false;
        this.element.classList.remove('disabled');
    }

    /**
     * Disable the button
     */
    disable() {
        this.element.disabled = true;
        this.element.classList.add('disabled');
    }

    /**
     * Update button text
     */
    setText(text) {
        const textNodes = Array.from(this.element.childNodes).filter(
            node => node.nodeType === Node.TEXT_NODE
        );
        if (textNodes.length > 0) {
            textNodes[0].textContent = text;
        } else {
            this.element.appendChild(document.createTextNode(text));
        }
    }

    /**
     * Update button variant
     */
    setVariant(variant) {
        // Remove existing variant classes
        const variants = ['primary', 'secondary', 'outline', 'ghost', 'text', 'success', 'error', 'warning', 'info'];
        variants.forEach(v => {
            this.element.classList.remove(`toss-btn-${v}`);
        });
        
        // Add new variant
        this.element.classList.add(`toss-btn-${variant}`);
    }
}

/**
 * Button Group Component
 */
class TossButtonGroup {
    constructor(element) {
        this.element = element;
        this.buttons = Array.from(element.querySelectorAll('.toss-btn'));
        this.init();
    }

    init() {
        this.buttons.forEach((button, index) => {
            button.addEventListener('click', () => {
                this.setActive(index);
            });
        });
    }

    setActive(index) {
        this.buttons.forEach((button, i) => {
            if (i === index) {
                button.classList.add('active');
            } else {
                button.classList.remove('active');
            }
        });
    }
}

/**
 * Floating Action Button Component
 */
class TossFAB {
    constructor(element) {
        this.element = element;
        this.isExpanded = false;
        this.init();
    }

    init() {
        // Handle extended FAB
        if (this.element.classList.contains('toss-fab-extended')) {
            this.element.addEventListener('click', this.toggleExpanded.bind(this));
        }
        
        // Handle scroll behavior
        this.handleScroll();
    }

    toggleExpanded() {
        this.isExpanded = !this.isExpanded;
        if (this.isExpanded) {
            this.element.classList.add('expanded');
        } else {
            this.element.classList.remove('expanded');
        }
    }

    handleScroll() {
        let lastScrollTop = 0;
        
        window.addEventListener('scroll', () => {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            
            if (scrollTop > lastScrollTop && scrollTop > 100) {
                // Scrolling down
                this.element.style.transform = 'translateY(100px)';
            } else {
                // Scrolling up
                this.element.style.transform = 'translateY(0)';
            }
            
            lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
        });
    }
}

/**
 * Button utilities
 */
const TossButtonUtils = {
    /**
     * Create a button programmatically
     */
    create(options = {}) {
        const button = document.createElement('button');
        button.className = 'toss-btn';
        
        // Set variant
        if (options.variant) {
            button.classList.add(`toss-btn-${options.variant}`);
        } else {
            button.classList.add('toss-btn-primary');
        }
        
        // Set size
        if (options.size) {
            button.classList.add(`toss-btn-${options.size}`);
        }
        
        // Set text
        if (options.text) {
            button.textContent = options.text;
        }
        
        // Add icon
        if (options.icon) {
            const icon = document.createElement('span');
            icon.innerHTML = options.icon;
            icon.className = 'toss-icon';
            button.prepend(icon);
        }
        
        // Set full width
        if (options.fullWidth) {
            button.classList.add('toss-btn-full');
        }
        
        // Set disabled
        if (options.disabled) {
            button.disabled = true;
        }
        
        // Add click handler
        if (options.onClick) {
            button.addEventListener('click', options.onClick);
        }
        
        return button;
    },

    /**
     * Show loading state for a button
     */
    showLoading(button, text = 'Loading...') {
        const tossBtn = new TossButton(button);
        tossBtn.setLoading(true);
        if (text) {
            tossBtn.setText(text);
        }
        return tossBtn;
    },

    /**
     * Hide loading state for a button
     */
    hideLoading(button, text) {
        const tossBtn = new TossButton(button);
        tossBtn.setLoading(false);
        if (text) {
            tossBtn.setText(text);
        }
        return tossBtn;
    },

    /**
     * Create a confirmation button
     */
    createConfirmButton(options = {}) {
        const button = this.create({
            ...options,
            onClick: async (e) => {
                const confirmed = await this.confirm(options.confirmMessage || 'Are you sure?');
                if (confirmed && options.onConfirm) {
                    options.onConfirm(e);
                }
            }
        });
        return button;
    },

    /**
     * Simple confirm dialog (can be replaced with modal)
     */
    async confirm(message) {
        return window.confirm(message);
    }
};

// Initialize buttons on page load
document.addEventListener('DOMContentLoaded', () => {
    // Initialize all buttons
    document.querySelectorAll('.toss-btn').forEach(button => {
        new TossButton(button);
    });
    
    // Initialize button groups
    document.querySelectorAll('.toss-btn-group').forEach(group => {
        new TossButtonGroup(group);
    });
    
    // Initialize FABs
    document.querySelectorAll('.toss-fab').forEach(fab => {
        new TossFAB(fab);
    });
});

// Add ripple effect styles dynamically
const style = document.createElement('style');
style.textContent = `
    .toss-ripple {
        position: absolute;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.7);
        transform: scale(0);
        animation: toss-ripple-animation 0.6s ease-out;
        pointer-events: none;
    }
    
    @keyframes toss-ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { TossButton, TossButtonGroup, TossFAB, TossButtonUtils };
}