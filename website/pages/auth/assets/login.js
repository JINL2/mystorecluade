/**
 * Login Page JavaScript
 * Handles authentication logic for login/signup
 */

// Login page functionality
let isSignUpMode = false;

// Initialize page
document.addEventListener('DOMContentLoaded', async () => {
    // Initialize official icons
    initializeIcons();
    
    // Check if user is already logged in
    await checkAuthState();
    
    // Setup form submission
    document.getElementById('loginForm').addEventListener('submit', handleFormSubmit);
    
    // Clear any existing error states
    clearErrors();
    
    console.log('Login page initialized');
});

// Initialize icons with official app icons
function initializeIcons() {
    // No longer replacing the logo image with SVG icons
    // The HTML img tag will display the actual app icon image
    console.log('Icons initialization skipped - using image logo');
}

// Get correct dashboard path - COMPLETELY REWRITTEN FOR ABSOLUTE URLS
function getDashboardPath() {
    // Get current location info
    const origin = window.location.origin;  // http://localhost
    const pathname = window.location.pathname;  // /mcparrange-main/myFinance_claude/website/pages/auth/login.html
    
    console.log('getDashboardPath - Origin:', origin);
    console.log('getDashboardPath - Pathname:', pathname);
    
    // Build the FULL URL - no ambiguity possible
    let dashboardUrl = '';
    
    // Primary path for XAMPP mcparrange-main structure - explicitly include index.html
    dashboardUrl = origin + '/mcparrange-main/myFinance_claude/website/pages/dashboard/index.html';
    console.log('getDashboardPath - Built dashboard URL:', dashboardUrl);
    return dashboardUrl;
}

// Check authentication state
async function checkAuthState() {
    try {
        const { data: { session }, error } = await supabase.auth.getSession();
        
        if (session) {
            // User is already logged in, redirect to dashboard
            console.log('checkAuthState - User already logged in, redirecting...');
            TossAlertUtils.showSuccess('Already logged in. Redirecting...');
            const dashboardUrl = getDashboardPath();
            console.log('checkAuthState - Dashboard URL:', dashboardUrl);
            
            // Set flag to prevent AuthManager interference
            sessionStorage.setItem('loginPageRedirecting', 'true');
            
            setTimeout(() => {
                // Clear flag and use replace for clean navigation
                sessionStorage.removeItem('loginPageRedirecting');
                window.location.replace(dashboardUrl);
            }, 1500);
        }
    } catch (error) {
        console.error('Error checking auth state:', error);
    }
}

// Handle form submission
async function handleFormSubmit(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    const email = formData.get('email');
    const password = formData.get('password');
    
    // Clear previous errors
    clearErrors();
    
    // Validate form
    if (!validateForm(email, password)) {
        return;
    }
    
    // Show loading state
    setLoadingState(true);
    
    try {
        if (isSignUpMode) {
            await handleSignUp(email, password);
        } else {
            await handleSignIn(email, password);
        }
    } catch (error) {
        console.error('Form submission error:', error);
        showError('An unexpected error occurred. Please try again.');
    } finally {
        setLoadingState(false);
    }
}

// Track if redirect is in progress to prevent double redirects
let isRedirecting = false;

// Handle sign in
async function handleSignIn(email, password) {
    // Prevent multiple simultaneous login attempts
    if (isRedirecting) {
        console.log('BLOCKED: Redirect already in progress');
        return;
    }
    
    // Check remember me checkbox
    const rememberMeCheckbox = document.getElementById('rememberMe');
    const rememberMe = rememberMeCheckbox ? rememberMeCheckbox.checked : false;
    
    // Set remember me preference before sign in
    localStorage.setItem('rememberMe', rememberMe ? 'true' : 'false');
    
    // Set a flag to prevent AuthManager from redirecting
    sessionStorage.setItem('loginPageRedirecting', 'true');
    
    console.log('=== BEFORE SUPABASE SIGN IN ===');
    console.log('Current URL:', window.location.href);
    console.log('About to call SupabaseAuth.signIn');
    console.log('================================');
    
    const result = await SupabaseAuth.signIn(email, password);
    
    console.log('=== AFTER SUPABASE SIGN IN ===');
    console.log('Sign in result:', result);
    console.log('Current URL now:', window.location.href);
    console.log('================================');
    
    if (result.success) {
        // Mark that we're redirecting
        isRedirecting = true;
        
        // Store auth data using appropriate storage
        if (typeof storageManager !== 'undefined') {
            storageManager.setAuthToken(result.session.access_token, rememberMe);
            storageManager.setSession(result.session, rememberMe);
            storageManager.setUserData(result.user);
        }
        
        // IMPORTANT: Don't manually store in Supabase's key - let Supabase handle it
        // Removing this as it may interfere with Supabase's internal storage
        // const supabaseStorageKey = `sb-atkekzwgukdvucqntryo-auth-token`;
        // localStorage.setItem(supabaseStorageKey, result.session.access_token);
        console.log('Auth data stored via storageManager');
        
        TossAlertUtils.showSuccess('Login successful! Redirecting...');
        
        // Get dashboard path IMMEDIATELY
        const dashboardPath = getDashboardPath();
        console.log('=== LOGIN REDIRECT DEBUG ===');
        console.log('Current URL:', window.location.href);
        console.log('Current pathname:', window.location.pathname);
        console.log('Calculated dashboard path:', dashboardPath);
        console.log('Redirecting in 1.5 seconds...');
        console.log('===========================');
        
        // Redirect to dashboard after short delay
        setTimeout(() => {
            console.log('=== FINAL REDIRECT ===');
            console.log('Dashboard path:', dashboardPath);
            console.log('Current location:', window.location.href);
            
            // DO NOT clear the flag - let the dashboard page clear it after successful initialization
            // sessionStorage.removeItem('loginPageRedirecting');
            
            // Force redirect using href for immediate navigation
            console.log('Using window.location.href for immediate redirect');
            window.location.href = dashboardPath;
            console.log('======================')
        }, 1500);
    } else {
        // Clear the flag on error
        sessionStorage.removeItem('loginPageRedirecting');
        showError(getAuthErrorMessage(result.error));
    }
}

// Handle sign up
async function handleSignUp(email, password) {
    const result = await SupabaseAuth.signUp(email, password, {
        full_name: email.split('@')[0], // Use part of email as default name
    });
    
    if (result.success) {
        TossAlertUtils.showSuccess('Account created successfully! Please check your email for verification.');
        
        // Switch back to sign in mode
        setTimeout(() => {
            toggleSignUpMode();
        }, 2000);
    } else {
        showError(getAuthErrorMessage(result.error));
    }
}

// Handle forgot password
async function handleForgotPassword() {
    const email = document.getElementById('email').value;
    
    if (!email) {
        showError('Please enter your email address first.');
        document.getElementById('email').focus();
        return;
    }
    
    setLoadingState(true);
    
    const result = await SupabaseAuth.resetPassword(email);
    
    if (result.success) {
        TossAlertUtils.showSuccess('Password reset email sent! Check your inbox.');
    } else {
        showError(getAuthErrorMessage(result.error));
    }
    
    setLoadingState(false);
}

// Toggle between sign in and sign up modes
function toggleSignUpMode() {
    isSignUpMode = !isSignUpMode;
    
    const loginTitle = document.querySelector('.login-title');
    const loginSubtitle = document.querySelector('.login-subtitle');
    const submitButton = document.getElementById('loginButton');
    const toggleButton = document.querySelector('.toss-btn-outline');
    
    if (isSignUpMode) {
        loginTitle.textContent = 'Create Your Account';
        loginSubtitle.textContent = 'Join Store Base to start managing your store';
        submitButton.querySelector('.btn-text').textContent = 'Create Account';
        toggleButton.textContent = 'Already have an account? Sign In';
    } else {
        loginTitle.textContent = 'Welcome to Store Base';
        loginSubtitle.textContent = 'Sign in to manage your store';
        submitButton.querySelector('.btn-text').textContent = 'Sign In';
        toggleButton.textContent = 'Create New Account';
    }
    
    clearErrors();
}

// Validate form inputs
function validateForm(email, password) {
    let isValid = true;
    
    // Clear previous errors first
    clearErrors();
    
    // Email validation
    if (!email) {
        showFieldError('email', 'Email is required');
        isValid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        showFieldError('email', 'Please enter a valid email address');
        isValid = false;
    }
    
    // Password validation  
    if (!password) {
        showFieldError('password', 'Password is required');
        isValid = false;
    } else if (password.length < 6) {
        showFieldError('password', 'Password must be at least 6 characters');
        isValid = false;
    }
    
    return isValid;
}

// Show field-specific error
function showFieldError(fieldName, message) {
    const field = document.getElementById(fieldName);
    const errorElement = document.getElementById(`${fieldName}-error`);
    
    field.classList.add('toss-input-error');
    errorElement.textContent = message;
    errorElement.classList.add('toss-input-message-error');
}

// Show general error
function showError(message) {
    const alertsContainer = document.getElementById('login-alerts');
    
    // Clear existing alerts
    alertsContainer.innerHTML = '';
    
    // Create error alert
    const { element } = TossAlertUtils.createAlert({
        type: 'error',
        message: message,
        dismissible: true,
        compact: true
    });
    
    element.classList.add('login-error');
    alertsContainer.appendChild(element);
}

// Clear all errors
function clearErrors() {
    // Clear field errors
    document.querySelectorAll('.toss-input').forEach(input => {
        input.classList.remove('toss-input-error');
    });
    
    document.querySelectorAll('.toss-input-message').forEach(message => {
        message.textContent = '';
        message.classList.remove('toss-input-message-error');
    });
    
    // Clear general alerts
    document.getElementById('login-alerts').innerHTML = '';
}

// Set loading state
function setLoadingState(isLoading) {
    const form = document.getElementById('loginForm');
    const submitButton = document.getElementById('loginButton');
    const toggleButton = document.querySelector('.toss-btn-outline');
    
    if (isLoading) {
        form.classList.add('loading');
        submitButton.classList.add('toss-btn-loading');
        submitButton.disabled = true;
        toggleButton.disabled = true;
    } else {
        form.classList.remove('loading');
        submitButton.classList.remove('toss-btn-loading');
        submitButton.disabled = false;
        toggleButton.disabled = false;
    }
}

// Get user-friendly error message
function getAuthErrorMessage(error) {
    const errorMap = {
        'Invalid login credentials': 'Invalid email or password. Please check your credentials and try again.',
        'Email not confirmed': 'Please check your email and click the confirmation link before signing in.',
        'User already registered': 'An account with this email already exists. Please sign in instead.',
        'Password should be at least 6 characters': 'Password must be at least 6 characters long.',
        'Invalid email': 'Please enter a valid email address.',
        'Network error': 'Network connection error. Please check your internet connection and try again.',
        'Database error': 'Service temporarily unavailable. Please try again later.'
    };
    
    return errorMap[error] || `Authentication error: ${error}`;
}

// Password visibility toggle (defined globally for onclick handler)
function togglePasswordVisibility(inputId, button) {
    const input = document.getElementById(inputId);
    const eyeOpen = button.querySelector('.eye-open');
    const eyeClosed = button.querySelector('.eye-closed');
    
    if (input.type === 'password') {
        input.type = 'text';
        eyeOpen.style.display = 'none';
        eyeClosed.style.display = 'block';
    } else {
        input.type = 'password';
        eyeOpen.style.display = 'block';
        eyeClosed.style.display = 'none';
    }
}

// Handle keyboard shortcuts
document.addEventListener('keydown', (event) => {
    // Enter key on form elements
    if (event.key === 'Enter' && event.target.tagName !== 'BUTTON') {
        event.preventDefault();
        document.getElementById('loginForm').dispatchEvent(new Event('submit'));
    }
    
    // Escape key clears errors
    if (event.key === 'Escape') {
        clearErrors();
    }
});