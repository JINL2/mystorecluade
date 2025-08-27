/**
 * Toss Input Component JavaScript
 * Handles input interactions, validation, and enhanced UX
 */

class TossInput {
    constructor(element, options = {}) {
        this.element = element;
        this.options = {
            validateOnBlur: true,
            validateOnInput: false,
            showCharCount: false,
            maxLength: null,
            ...options
        };
        
        this.wrapper = this.element.closest('.toss-input-group');
        this.messageElement = this.wrapper?.querySelector('.toss-input-message');
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.setupPasswordToggle();
        this.setupCharacterCount();
        this.setupSearchClear();
        this.setupValidation();
    }
    
    setupEventListeners() {
        // Focus/blur effects
        this.element.addEventListener('focus', () => {
            this.wrapper?.classList.add('focused');
        });
        
        this.element.addEventListener('blur', () => {
            this.wrapper?.classList.remove('focused');
            if (this.options.validateOnBlur) {
                this.validate();
            }
        });
        
        // Input validation
        if (this.options.validateOnInput) {
            this.element.addEventListener('input', () => {
                this.validate();
            });
        }
        
        // Character count
        if (this.options.showCharCount || this.options.maxLength) {
            this.element.addEventListener('input', () => {
                this.updateCharacterCount();
            });
        }
    }
    
    setupPasswordToggle() {
        if (this.element.type === 'password') {
            const toggleButton = this.wrapper?.querySelector('.toss-input-icon');
            if (toggleButton) {
                toggleButton.addEventListener('click', () => {
                    this.togglePasswordVisibility();
                });
            }
        }
    }
    
    setupCharacterCount() {
        if (this.options.showCharCount || this.options.maxLength) {
            this.createCharacterCounter();
        }
    }
    
    setupSearchClear() {
        if (this.element.type === 'search' || this.element.classList.contains('toss-search-input')) {
            const clearButton = this.wrapper?.querySelector('.toss-search-clear');
            if (clearButton) {
                clearButton.addEventListener('click', () => {
                    this.element.value = '';
                    this.element.focus();
                    this.element.dispatchEvent(new Event('input', { bubbles: true }));
                });
                
                // Show/hide clear button based on content
                this.element.addEventListener('input', () => {
                    clearButton.style.display = this.element.value ? 'block' : 'none';
                });
                
                // Initial state
                clearButton.style.display = this.element.value ? 'block' : 'none';
            }
        }
    }
    
    setupValidation() {
        // Set up validation rules based on input type and attributes
        this.validationRules = [];
        
        if (this.element.required) {
            this.validationRules.push({
                test: (value) => value.trim().length > 0,
                message: 'This field is required'
            });
        }
        
        if (this.element.type === 'email') {
            this.validationRules.push({
                test: (value) => !value || /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
                message: 'Please enter a valid email address'
            });
        }
        
        if (this.element.type === 'password') {
            const minLength = this.element.getAttribute('minlength') || 8;
            this.validationRules.push({
                test: (value) => !value || value.length >= minLength,
                message: `Password must be at least ${minLength} characters`
            });
        }
        
        if (this.element.pattern) {
            const pattern = new RegExp(this.element.pattern);
            this.validationRules.push({
                test: (value) => !value || pattern.test(value),
                message: this.element.getAttribute('title') || 'Invalid format'
            });
        }
        
        if (this.options.maxLength || this.element.maxLength) {
            const maxLength = this.options.maxLength || this.element.maxLength;
            this.validationRules.push({
                test: (value) => value.length <= maxLength,
                message: `Must be ${maxLength} characters or less`
            });
        }
    }
    
    togglePasswordVisibility() {
        const isPassword = this.element.type === 'password';
        this.element.type = isPassword ? 'text' : 'password';
        
        const toggleButton = this.wrapper?.querySelector('.toss-input-icon');
        if (toggleButton) {
            const eyeOpen = toggleButton.querySelector('.eye-open');
            const eyeClosed = toggleButton.querySelector('.eye-closed');
            
            if (eyeOpen && eyeClosed) {
                eyeOpen.style.display = isPassword ? 'none' : 'block';
                eyeClosed.style.display = isPassword ? 'block' : 'none';
            }
        }
    }
    
    createCharacterCounter() {
        if (!this.wrapper?.querySelector('.toss-char-count')) {
            const counter = document.createElement('div');
            counter.className = 'toss-char-count';
            counter.style.cssText = `
                font-size: var(--font-small);
                color: var(--text-tertiary);
                text-align: right;
                margin-top: var(--space-1);
            `;
            
            this.wrapper.appendChild(counter);
            this.updateCharacterCount();
        }
    }
    
    updateCharacterCount() {
        const counter = this.wrapper?.querySelector('.toss-char-count');
        if (counter) {
            const current = this.element.value.length;
            const max = this.options.maxLength || this.element.maxLength;
            
            if (max) {
                counter.textContent = `${current}/${max}`;
                counter.style.color = current > max ? 'var(--toss-error)' : 'var(--text-tertiary)';
            } else {
                counter.textContent = current.toString();
            }
        }
    }
    
    validate() {
        const value = this.element.value;
        let isValid = true;
        let errorMessage = '';
        
        for (const rule of this.validationRules) {
            if (!rule.test(value)) {
                isValid = false;
                errorMessage = rule.message;
                break;
            }
        }
        
        this.setValidationState(isValid, errorMessage);
        return isValid;
    }
    
    setValidationState(isValid, message = '') {
        // Remove existing state classes
        this.element.classList.remove('toss-input-success', 'toss-input-error');
        
        if (this.messageElement) {
            this.messageElement.classList.remove(
                'toss-input-message-success', 
                'toss-input-message-error'
            );
        }
        
        if (isValid && this.element.value) {
            // Show success state only if field has value
            this.element.classList.add('toss-input-success');
            if (this.messageElement) {
                this.messageElement.classList.add('toss-input-message-success');
                this.messageElement.textContent = ''; // Clear error message
            }
        } else if (!isValid) {
            // Show error state
            this.element.classList.add('toss-input-error');
            if (this.messageElement) {
                this.messageElement.classList.add('toss-input-message-error');
                this.messageElement.textContent = message;
            }
        } else {
            // Neutral state
            if (this.messageElement) {
                this.messageElement.textContent = '';
            }
        }
    }
    
    setValue(value) {
        this.element.value = value;
        this.element.dispatchEvent(new Event('input', { bubbles: true }));
        if (this.options.validateOnInput) {
            this.validate();
        }
        this.updateCharacterCount();
    }
    
    getValue() {
        return this.element.value;
    }
    
    focus() {
        this.element.focus();
    }
    
    blur() {
        this.element.blur();
    }
    
    setError(message) {
        this.setValidationState(false, message);
    }
    
    clearError() {
        this.setValidationState(true);
    }
    
    setDisabled(disabled) {
        this.element.disabled = disabled;
        this.wrapper?.classList.toggle('disabled', disabled);
    }
    
    destroy() {
        // Clean up event listeners and elements
        this.element.removeEventListener('focus', this.handleFocus);
        this.element.removeEventListener('blur', this.handleBlur);
        this.element.removeEventListener('input', this.handleInput);
        
        const charCount = this.wrapper?.querySelector('.toss-char-count');
        if (charCount) {
            charCount.remove();
        }
    }
}

// Utility functions for common input operations
const TossInputUtils = {
    /**
     * Initialize all inputs on the page
     */
    initializeAll(options = {}) {
        document.querySelectorAll('.toss-input, .toss-textarea').forEach(input => {
            if (!input._tossInput) {
                input._tossInput = new TossInput(input, options);
            }
        });
    },
    
    /**
     * Create an input programmatically
     */
    create(config) {
        const group = document.createElement('div');
        group.className = 'toss-input-group';
        
        if (config.label) {
            const label = document.createElement('label');
            label.className = 'toss-label';
            label.textContent = config.label;
            if (config.required) label.classList.add('required');
            group.appendChild(label);
        }
        
        const wrapper = document.createElement('div');
        wrapper.className = 'toss-input-wrapper';
        
        if (config.iconLeft) {
            const icon = document.createElement('div');
            icon.className = 'toss-input-icon-left';
            icon.innerHTML = config.iconLeft;
            wrapper.appendChild(icon);
        }
        
        const input = document.createElement(config.type === 'textarea' ? 'textarea' : 'input');
        input.className = config.type === 'textarea' ? 'toss-textarea' : 'toss-input';
        
        if (config.type && config.type !== 'textarea') input.type = config.type;
        if (config.placeholder) input.placeholder = config.placeholder;
        if (config.required) input.required = true;
        if (config.disabled) input.disabled = true;
        if (config.value) input.value = config.value;
        if (config.name) input.name = config.name;
        if (config.id) input.id = config.id;
        
        // Add size class
        if (config.size) {
            input.classList.add(`toss-input-${config.size}`);
        }
        
        // Add icon padding classes
        if (config.iconLeft) {
            input.classList.add('toss-input-with-icon-left');
        }
        if (config.iconRight || config.type === 'password') {
            input.classList.add('toss-input-with-icon-right');
        }
        
        wrapper.appendChild(input);
        
        if (config.iconRight || config.type === 'password') {
            const icon = document.createElement('button');
            icon.type = 'button';
            icon.className = 'toss-input-icon';
            
            if (config.type === 'password') {
                icon.innerHTML = `
                    <svg class="eye-open" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10 3C5 3 1.73 7.11 1 10c.73 2.89 4 7 9 7s8.27-4.11 9-7c-.73-2.89-4-7-9-7z"/>
                        <circle cx="10" cy="10" r="3"/>
                    </svg>
                    <svg class="eye-closed" width="20" height="20" viewBox="0 0 20 20" fill="currentColor" style="display: none;">
                        <path d="M2 2l16 16M6.71 6.71A9.78 9.78 0 0010 6c5 0 8.27 4.11 9 7a13.16 13.16 0 01-1.67 2.68"/>
                        <path d="M12 12a3 3 0 11-4.24-4.24"/>
                        <path d="M6.61 6.61A13.526 13.526 0 001 10s3.27 7 9 7a9.74 9.74 0 005.39-1.61"/>
                    </svg>
                `;
            } else {
                icon.innerHTML = config.iconRight;
            }
            
            wrapper.appendChild(icon);
        }
        
        group.appendChild(wrapper);
        
        if (config.message) {
            const message = document.createElement('span');
            message.className = 'toss-input-message';
            message.textContent = config.message;
            group.appendChild(message);
        }
        
        // Initialize the input component
        const tossInput = new TossInput(input, config.options || {});
        
        return { group, input: tossInput };
    },
    
    /**
     * Validate all inputs in a form
     */
    validateForm(formElement) {
        const inputs = formElement.querySelectorAll('.toss-input, .toss-textarea');
        let isFormValid = true;
        
        inputs.forEach(input => {
            if (input._tossInput) {
                const isValid = input._tossInput.validate();
                if (!isValid) isFormValid = false;
            }
        });
        
        return isFormValid;
    },
    
    /**
     * Get form data from Toss inputs
     */
    getFormData(formElement) {
        const formData = {};
        const inputs = formElement.querySelectorAll('.toss-input, .toss-textarea');
        
        inputs.forEach(input => {
            if (input.name) {
                formData[input.name] = input.value;
            }
        });
        
        return formData;
    },
    
    /**
     * Clear all form errors
     */
    clearFormErrors(formElement) {
        const inputs = formElement.querySelectorAll('.toss-input, .toss-textarea');
        inputs.forEach(input => {
            if (input._tossInput) {
                input._tossInput.clearError();
            }
        });
    }
};

// Auto-initialize inputs when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    TossInputUtils.initializeAll();
});

// Password visibility toggle function (for backward compatibility)
function togglePasswordVisibility(inputId, button) {
    const input = document.getElementById(inputId);
    if (input && input._tossInput) {
        input._tossInput.togglePasswordVisibility();
    }
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { TossInput, TossInputUtils };
}