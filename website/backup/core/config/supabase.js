/**
 * Supabase Configuration
 * Authentication and database connection setup
 */

// Supabase configuration - Replace with your actual Supabase credentials
const SUPABASE_URL = 'https://atkekzwgukdvucqntryo.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8';

// Import Supabase client (will be loaded from CDN)
let supabase;

// Initialize Supabase client
function initializeSupabase() {
    if (typeof window.supabase !== 'undefined') {
        supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
            auth: {
                persistSession: true,
                autoRefreshToken: true,
                detectSessionInUrl: true,
                storage: window.localStorage  // 명시적으로 localStorage 사용
            }
        });
        
        // Make supabase client globally available
        window.supabaseClient = supabase;
        
        console.log('Supabase initialized successfully with persistence');
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
        try {
            // Clear the supabase session
            const { error } = await supabase.auth.signOut();
            
            if (error) {
                console.warn('Supabase signout error:', error);
                // Don't throw error - still clear local data and redirect
            }

            // Clear all local storage data regardless of supabase response
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();

            return { success: true };
        } catch (error) {
            console.error('Logout error:', error);
            
            // Even if there's an error, clear local data
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
        return supabase.auth.onAuthStateChange((event, session) => {
            callback(event, session);
        });
    },

    /**
     * Reset password
     */
    async resetPassword(email) {
        try {
            // Use pathResolver to build proper reset password URL
            let resetPasswordUrl;
            
            if (typeof window !== 'undefined' && window.pathResolver) {
                resetPasswordUrl = `${window.location.origin}${window.pathResolver.resolvePagePath('auth/reset-password.html')}`;
            } else {
                // Fallback if pathResolver is not available
                resetPasswordUrl = `${window.location.origin}/pages/auth/reset-password.html`;
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
        console.log('AuthManager.handleSignIn called - User signed in:', session.user);
        
        // Use StorageManager for hybrid storage
        if (typeof storageManager !== 'undefined') {
            // Check if remember me is enabled (will be set by login page)
            const rememberMe = localStorage.getItem('rememberMe') === 'true';
            
            // Store auth token appropriately
            storageManager.setAuthToken(session.access_token, rememberMe);
            storageManager.setSession(session, rememberMe);
            
            // Store user data (non-sensitive) in localStorage
            storageManager.setUserData(session.user);
        } else {
            // Fallback to old method if StorageManager not loaded
            localStorage.setItem('user', JSON.stringify(session.user));
            sessionStorage.setItem('session', JSON.stringify(session));
        }

        // IMPORTANT: AuthManager should NEVER handle redirects after login
        // The login page (login.js) handles all redirect logic with proper path calculation
        
        // Check if we're being called from login page redirect flow
        const isLoginPageRedirecting = sessionStorage.getItem('loginPageRedirecting') === 'true';
        if (isLoginPageRedirecting) {
            console.log('=== AUTHMANAGER: LOGIN PAGE IS HANDLING REDIRECT ===');
            console.log('AuthManager will not interfere with redirect');
            return;
        }
        
        // Also check if we're on any auth page
        const currentPath = window.location.pathname;
        if (currentPath.includes('/auth/') || currentPath.includes('/login.html')) {
            console.log('=== AUTHMANAGER: ON AUTH PAGE - NO REDIRECT ===');
            console.log('Auth pages handle their own redirects');
            return;
        }
        
        // For all other cases, still don't redirect to avoid any conflicts
        console.log('AuthManager: Redirect disabled to prevent path issues');
        return;
    },

    /**
     * Handle sign out
     */
    handleSignOut() {
        console.log('User signed out');
        
        // Use StorageManager to clear all data
        if (typeof storageManager !== 'undefined') {
            storageManager.clearAll();
        } else {
            // Fallback to old method
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            sessionStorage.clear();
        }

        // Navigate to login page with proper path calculation
        this.navigateToLogin();
    },
    
    /**
     * Navigate to login page with proper path calculation
     */
    navigateToLogin() {
        const currentPath = window.location.pathname;
        let loginPath;
        
        console.log('🔄 AuthManager navigating from path:', currentPath);
        
        // Use pathResolver for consistent path resolution
        if (typeof window !== 'undefined' && window.pathResolver) {
            loginPath = window.pathResolver.getLoginPath();
            console.log('🎯 Using pathResolver login path:', loginPath);
        } else {
            // Fallback to absolute path if pathResolver is not available
            loginPath = '/pages/auth/login.html';
            console.log('🎯 Using fallback login path:', loginPath);
        }
        
        console.log('✅ Final login path:', loginPath);
        
        // Use replace to prevent back button issues and ensure clean logout
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