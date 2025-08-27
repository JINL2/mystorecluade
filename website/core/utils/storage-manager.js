/**
 * Storage Manager
 * Hybrid storage management for security and user experience
 * - SessionStorage: Auth tokens (secure, auto-logout on tab close)
 * - LocalStorage: User preferences and non-sensitive data
 */

class StorageManager {
    constructor() {
        // Define what goes where
        this.sessionKeys = [
            'sb-atkekzwgukdvucqntryo-auth-token',
            'session',
            'access_token',
            'refresh_token'
        ];
        
        this.localKeys = [
            'user',           // User profile (without sensitive data)
            'companyChoosen',
            'storeChoosen', 
            'categoryFeatures',
            'lastDataRefresh',
            'rememberMe'      // Remember me preference
        ];
    }

    /**
     * Get item from appropriate storage
     */
    getItem(key) {
        // Check if it's a session key
        if (this.isSessionKey(key)) {
            return sessionStorage.getItem(key);
        }
        // Default to localStorage for everything else
        return localStorage.getItem(key);
    }

    /**
     * Set item in appropriate storage
     */
    setItem(key, value) {
        // Store in sessionStorage if it's auth-related
        if (this.isSessionKey(key)) {
            sessionStorage.setItem(key, value);
        } else {
            localStorage.setItem(key, value);
        }
    }

    /**
     * Remove item from both storages
     */
    removeItem(key) {
        sessionStorage.removeItem(key);
        localStorage.removeItem(key);
    }

    /**
     * Check if key should be in sessionStorage
     */
    isSessionKey(key) {
        return this.sessionKeys.some(sessionKey => 
            key.includes(sessionKey) || sessionKey.includes(key)
        );
    }

    /**
     * Get authentication token
     */
    getAuthToken() {
        // Check "Remember Me" preference
        const rememberMe = localStorage.getItem('rememberMe') === 'true';
        
        if (rememberMe) {
            // If remember me, check localStorage first (for persistent login)
            const localToken = localStorage.getItem('sb-atkekzwgukdvucqntryo-auth-token');
            if (localToken) return localToken;
        }
        
        // Default to sessionStorage (secure)
        return sessionStorage.getItem('sb-atkekzwgukdvucqntryo-auth-token');
    }

    /**
     * Set authentication token based on remember me preference
     */
    setAuthToken(token, rememberMe = false) {
        if (rememberMe) {
            // Store in both for compatibility
            localStorage.setItem('sb-atkekzwgukdvucqntryo-auth-token', token);
            localStorage.setItem('rememberMe', 'true');
        } else {
            // Store only in sessionStorage (secure)
            sessionStorage.setItem('sb-atkekzwgukdvucqntryo-auth-token', token);
            localStorage.setItem('rememberMe', 'false');
            // Remove from localStorage if exists
            localStorage.removeItem('sb-atkekzwgukdvucqntryo-auth-token');
        }
    }

    /**
     * Get session data
     */
    getSession() {
        const sessionStr = sessionStorage.getItem('session') || localStorage.getItem('session');
        if (!sessionStr) return null;
        
        try {
            return JSON.parse(sessionStr);
        } catch (error) {
            console.error('Error parsing session:', error);
            return null;
        }
    }

    /**
     * Set session data
     */
    setSession(sessionData, rememberMe = false) {
        const sessionStr = JSON.stringify(sessionData);
        
        if (rememberMe) {
            localStorage.setItem('session', sessionStr);
        } else {
            sessionStorage.setItem('session', sessionStr);
            localStorage.removeItem('session');
        }
    }

    /**
     * Get user data (non-sensitive)
     */
    getUserData() {
        try {
            const userData = localStorage.getItem('user');
            return userData ? JSON.parse(userData) : null;
        } catch (error) {
            console.error('Error parsing user data:', error);
            return null;
        }
    }

    /**
     * Set user data (remove sensitive info)
     */
    setUserData(userData) {
        try {
            // Remove sensitive data before storing
            const safeUserData = { ...userData };
            
            // Remove tokens if they exist in user data
            delete safeUserData.access_token;
            delete safeUserData.refresh_token;
            delete safeUserData.token;
            
            localStorage.setItem('user', JSON.stringify(safeUserData));
        } catch (error) {
            console.error('Error storing user data:', error);
        }
    }

    /**
     * Clear all authentication data
     */
    clearAuth() {
        // Clear from both storages
        this.sessionKeys.forEach(key => {
            sessionStorage.removeItem(key);
            localStorage.removeItem(key);
        });
        
        // Also clear the actual Supabase token key
        sessionStorage.removeItem('sb-atkekzwgukdvucqntryo-auth-token');
        localStorage.removeItem('sb-atkekzwgukdvucqntryo-auth-token');
    }

    /**
     * Clear all data (logout)
     */
    clearAll() {
        // Clear auth
        this.clearAuth();
        
        // Clear user preferences
        localStorage.removeItem('user');
        localStorage.removeItem('companyChoosen');
        localStorage.removeItem('storeChoosen');
        localStorage.removeItem('categoryFeatures');
        localStorage.removeItem('lastDataRefresh');
        
        // Clear session storage completely
        sessionStorage.clear();
    }

    /**
     * Check if user is authenticated
     */
    isAuthenticated() {
        return !!this.getAuthToken() && !!this.getUserData();
    }

    /**
     * Migrate old data to new storage system
     */
    migrateStorage() {
        // Check if we have auth token in localStorage (old system)
        const oldToken = localStorage.getItem('sb-atkekzwgukdvucqntryo-auth-token');
        const rememberMe = localStorage.getItem('rememberMe');
        
        if (oldToken && rememberMe !== 'true') {
            // Migrate to sessionStorage if not remember me
            sessionStorage.setItem('sb-atkekzwgukdvucqntryo-auth-token', oldToken);
            localStorage.removeItem('sb-atkekzwgukdvucqntryo-auth-token');
            console.log('Migrated auth token to sessionStorage');
        }
        
        // Migrate session data
        const oldSession = localStorage.getItem('session');
        if (oldSession && rememberMe !== 'true') {
            sessionStorage.setItem('session', oldSession);
            localStorage.removeItem('session');
            console.log('Migrated session to sessionStorage');
        }
    }
}

// Create singleton instance
const storageManager = new StorageManager();

// Run migration on load
storageManager.migrateStorage();

// Export for use
if (typeof module !== 'undefined' && module.exports) {
    module.exports = storageManager;
}

// Make available globally
window.storageManager = storageManager;