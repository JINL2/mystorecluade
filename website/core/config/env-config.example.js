/**
 * Environment Configuration Example
 * Copy this file to env-config.js and fill in your actual values
 * DO NOT COMMIT env-config.js TO VERSION CONTROL
 */

// Example configuration structure
window.ENV = {
    // Supabase Configuration
    SUPABASE_URL: 'your_supabase_url_here',
    SUPABASE_ANON_KEY: 'your_supabase_anon_key_here',
    
    // Application Environment
    ENVIRONMENT: 'development', // 'development' | 'staging' | 'production'
    
    // Feature Flags
    DEBUG_MODE: false
};

// Instructions:
// 1. Copy this file to env-config.js
// 2. Replace the placeholder values with your actual Supabase credentials
// 3. Never commit env-config.js to version control
// 4. Include env-config.js before supabase.js in your HTML files
