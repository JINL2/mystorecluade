/**
 * Supabase Configuration - Safe Version
 * This file uses environment variables instead of hardcoded credentials
 * Credentials should be loaded from env-config.js
 */

// Get configuration from environment
const SUPABASE_URL = window.ENV?.SUPABASE_URL || '';
const SUPABASE_ANON_KEY = window.ENV?.SUPABASE_ANON_KEY || '';

// Validate configuration
if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    console.error('⚠️ Supabase credentials not configured.');
    console.error('Please ensure env-config.js is loaded and contains valid credentials.');
    console.error('For local development, create env-config.js from env-config.example.js');
}

// Import Supabase client (will be loaded from CDN)
let supabase;

// Initialize Supabase client
function initializeSupabase() {
    if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
        console.error('Cannot initialize Supabase: Missing credentials');
        return null;
    }
    
    if (typeof window.supabase !== 'undefined') {
        supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
            auth: {
                persistSession: true,
                autoRefreshToken: true,
                detectSessionInUrl: true,
                storage: window.localStorage
            }
        });
        console.log('Supabase initialized successfully');
        return supabase;
    } else {
        console.error('Supabase library not loaded. Make sure to include the Supabase CDN script.');
        return null;
    }
}

// Authentication helper functions
const SupabaseAuth = {
    /**
     * Sign in with email and password
     */
    async signIn(email, password) {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email: email,
                password: password
            });

            if (error) {
                throw error;
            }

            return { success: true, user: data.user, session: data.session };
        } catch (error) {
            console.error('Login error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Sign up with email and password
     */
    async signUp(email, password, additionalData = {}) {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data, error } = await supabase.auth.signUp({
                email: email,
                password: password,
                options: {
                    data: additionalData
                }
            });

            if (error) {
                throw error;
            }

            return { success: true, user: data.user, session: data.session };
        } catch (error) {
            console.error('Signup error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Sign out
     */
    async signOut() {
        if (!supabase) {
            // Still clear local storage even if supabase not initialized
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();
            return { success: true };
        }
        
        try {
            const { error } = await supabase.auth.signOut();
            
            if (error) {
                console.warn('Supabase signout error:', error);
            }

            // Clear all local storage data
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();

            return { success: true };
        } catch (error) {
            console.error('Logout error:', error);
            
            // Clear local data anyway
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();
            
            return { success: false, error: error.message };
        }
    },

    /**
     * Get current user
     */
    async getCurrentUser() {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data: { user }, error } = await supabase.auth.getUser();
            
            if (error) {
                throw error;
            }

            return { success: true, user: user };
        } catch (error) {
            console.error('Get user error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Get current session
     */
    async getCurrentSession() {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data: { session }, error } = await supabase.auth.getSession();
            
            if (error) {
                throw error;
            }

            return { success: true, session: session };
        } catch (error) {
            console.error('Get session error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Listen to auth state changes
     */
    onAuthStateChange(callback) {
        if (!supabase) {
            console.error('Cannot set auth listener: Supabase not initialized');
            return { unsubscribe: () => {} };
        }
        
        return supabase.auth.onAuthStateChange((event, session) => {
            callback(event, session);
        });
    },

    /**
     * Reset password
     */
    async resetPassword(email) {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const currentPath = window.location.pathname;
            let resetPasswordUrl = '';
            
            if (currentPath.includes('/mcparrange-main/')) {
                resetPasswordUrl = `${window.location.origin}/mcparrange-main/myFinance_claude/website/pages/auth/reset-password.html`;
            } else if (currentPath.includes('/myFinance_claude/website/')) {
                const basePath = currentPath.substring(0, currentPath.indexOf('/pages/auth/'));
                resetPasswordUrl = `${window.location.origin}${basePath}/pages/auth/reset-password.html`;
            } else {
                const authPath = currentPath.substring(0, currentPath.lastIndexOf('/') + 1);
                resetPasswordUrl = `${window.location.origin}${authPath}reset-password.html`;
            }
            
            const { error } = await supabase.auth.resetPasswordForEmail(email, {
                redirectTo: resetPasswordUrl
            });

            if (error) {
                throw error;
            }

            return { success: true };
        } catch (error) {
            console.error('Reset password error:', error);
            return { success: false, error: error.message };
        }
    }
};

// Database helper functions
const SupabaseDB = {
    /**
     * Get user companies and stores
     */
    async getUserCompaniesAndStores() {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data, error } = await supabase.rpc('get_user_companies_and_stores');

            if (error) {
                throw error;
            }

            return { success: true, data: data };
        } catch (error) {
            console.error('Get companies error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Get categories with features
     */
    async getCategoriesWithFeatures(companyId) {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            const { data, error } = await supabase.rpc('get_categories_with_features', {
                p_company_id: companyId
            });

            if (error) {
                throw error;
            }

            return { success: true, data: data };
        } catch (error) {
            console.error('Get categories error:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Generic query function
     */
    async query(table, options = {}) {
        if (!supabase) {
            return { success: false, error: 'Supabase not initialized' };
        }
        
        try {
            let query = supabase.from(table).select(options.select || '*');

            // Apply filters
            if (options.filters) {
                Object.keys(options.filters).forEach(key => {
                    query = query.eq(key, options.filters[key]);
                });
            }

            // Apply ordering
            if (options.orderBy) {
                query = query.order(options.orderBy.column, { 
                    ascending: options.orderBy.ascending !== false 
                });
            }

            // Apply limit
            if (options.limit) {
                query = query.limit(options.limit);
            }

            const { data, error } = await query;

            if (error) {
                throw error;
            }

            return { success: true, data: data };
        } catch (error) {
            console.error('Query error:', error);
            return { success: false, error: error.message };
        }
    }
};

// Authentication state management
const AuthManager = {
    currentUser: null,
    currentSession: null,
    authCallbacks: [],

    /**
     * Initialize auth manager
     */
    async init() {
        if (!supabase) {
            console.warn('AuthManager: Supabase not initialized');
            return;
        }
        
        // Get current session
        const sessionResult = await SupabaseAuth.getCurrentSession();
        if (sessionResult.success) {
            this.currentSession = sessionResult.session;
            if (sessionResult.session) {
                this.currentUser = sessionResult.session.user;
            }
        }

        // Listen to auth changes
        SupabaseAuth.onAuthStateChange((event, session) => {
            console.log('Auth state changed:', event, session);
            
            this.currentSession = session;
            this.currentUser = session ? session.user : null;

            // Trigger callbacks
            this.authCallbacks.forEach(callback => {
                callback(event, session, this.currentUser);
            });

            // Handle different auth events
            switch (event) {
                case 'SIGNED_IN':
                    this.handleSignIn(session);
                    break;
                case 'SIGNED_OUT':
                    this.handleSignOut();
                    break;
                case 'TOKEN_REFRESHED':
                    console.log('Token refreshed');
                    break;
            }
        });
    },

    /**
     * Handle successful sign in
     */
    handleSignIn(session) {
        console.log('User signed in:', session.user);
        
        // Store session data
        if (typeof storageManager !== 'undefined') {
            const rememberMe = localStorage.getItem('rememberMe') === 'true';
            storageManager.setAuthToken(session.access_token, rememberMe);
            storageManager.setSession(session, rememberMe);
            storageManager.setUserData(session.user);
        } else {
            localStorage.setItem('user', JSON.stringify(session.user));
            sessionStorage.setItem('session', JSON.stringify(session));
        }

        // Check if we're being called from login page
        const isLoginPageRedirecting = sessionStorage.getItem('loginPageRedirecting') === 'true';
        if (isLoginPageRedirecting) {
            console.log('Login page is handling redirect');
            return;
        }
        
        // Check if we're on any auth page
        const currentPath = window.location.pathname;
        if (currentPath.includes('/auth/') || currentPath.includes('/login.html')) {
            console.log('On auth page - no redirect');
            return;
        }
    },

    /**
     * Handle sign out
     */
    handleSignOut() {
        console.log('User signed out');
        
        // Clear storage
        if (typeof storageManager !== 'undefined') {
            storageManager.clearAll();
        } else {
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();
        }

        // Navigate to login page
        this.navigateToLogin();
    },
    
    /**
     * Navigate to login page with proper path calculation
     */
    navigateToLogin() {
        const currentPath = window.location.pathname;
        let loginPath;
        
        if (currentPath.includes('/mcparrange-main/')) {
            const baseMatch = currentPath.match(/(.*\/mcparrange-main\/)/);
            if (baseMatch) {
                loginPath = baseMatch[1] + 'myFinance_claude/website/pages/auth/login.html';
            } else {
                loginPath = '/mcparrange-main/myFinance_claude/website/pages/auth/login.html';
            }
        } else if (currentPath.includes('/pages/')) {
            const afterPages = currentPath.split('/pages/')[1];
            const segments = afterPages.split('/').filter(p => p && p !== 'index.html');
            
            if (segments.length >= 2) {
                loginPath = '../../auth/login.html';
            } else if (segments.length === 1) {
                loginPath = '../auth/login.html';
            } else {
                loginPath = 'auth/login.html';
            }
        } else {
            loginPath = '/mcparrange-main/myFinance_claude/website/pages/auth/login.html';
        }
        
        window.location.replace(loginPath);
    },

    /**
     * Check if user is authenticated
     */
    isAuthenticated() {
        return this.currentUser !== null && this.currentSession !== null;
    },

    /**
     * Add auth state change callback
     */
    onAuthChange(callback) {
        this.authCallbacks.push(callback);
    },

    /**
     * Get current user
     */
    getCurrentUser() {
        return this.currentUser;
    },

    /**
     * Get current session
     */
    getCurrentSession() {
        return this.currentSession;
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', async () => {
    // Initialize Supabase
    initializeSupabase();
    
    // Initialize Auth Manager
    if (supabase) {
        await AuthManager.init();
    }
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { 
        SupabaseAuth, 
        SupabaseDB, 
        AuthManager,
        initializeSupabase 
    };
}
