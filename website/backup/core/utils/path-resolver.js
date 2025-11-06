/**
 * Smart Path Resolution Utility
 * Dynamically resolves paths for both localhost/XAMPP and deployed environments
 */

class PathResolver {
    constructor() {
        this.isLocalhost = this.detectLocalhost();
        this.baseProjectPath = this.detectBaseProjectPath();
    }

    /**
     * Detect if running on localhost/XAMPP
     * @returns {boolean}
     */
    detectLocalhost() {
        const hostname = window.location.hostname;
        const isLocalhost = hostname === 'localhost' || 
                           hostname === '127.0.0.1' || 
                           hostname.endsWith('.local') ||
                           hostname.includes('xampp');
        
        console.log('PathResolver: Detected localhost:', isLocalhost);
        return isLocalhost;
    }

    /**
     * Detect the base project path for localhost environments
     * @returns {string}
     */
    detectBaseProjectPath() {
        const pathname = window.location.pathname;
        
        // For localhost/XAMPP, we need to include the full project path
        if (this.isLocalhost) {
            // Look for the pattern that includes our project structure
            const projectMatch = pathname.match(/^(.*?\/mysite\/mystorecluade\/website)/);
            if (projectMatch) {
                const basePath = projectMatch[1];
                console.log('PathResolver: Detected project base path:', basePath);
                return basePath;
            }
            
            // Fallback for XAMPP environments
            const xamppMatch = pathname.match(/^(.*?\/website)/);
            if (xamppMatch) {
                const basePath = xamppMatch[1];
                console.log('PathResolver: Detected XAMPP base path:', basePath);
                return basePath;
            }
        }
        
        // For deployed environments, use root
        console.log('PathResolver: Using root path for deployed environment');
        return '';
    }

    /**
     * Resolve an absolute path based on environment
     * @param {string} relativePath - Path relative to website root (e.g., 'pages/dashboard/index.html')
     * @returns {string} - Complete path for current environment
     */
    resolvePath(relativePath) {
        // Remove leading slash if present
        const cleanPath = relativePath.replace(/^\/+/, '');
        
        if (this.isLocalhost && this.baseProjectPath) {
            const fullPath = `${this.baseProjectPath}/${cleanPath}`;
            console.log(`PathResolver: Resolved ${relativePath} -> ${fullPath}`);
            return fullPath;
        }
        
        // For deployed environments, use simple root-relative paths
        const deployedPath = `/${cleanPath}`;
        console.log(`PathResolver: Resolved ${relativePath} -> ${deployedPath}`);
        return deployedPath;
    }

    /**
     * Resolve paths for common resources
     */
    resolveAssetPath(filename) {
        return this.resolvePath(`assets/${filename}`);
    }

    resolvePagePath(pagePath) {
        return this.resolvePath(`pages/${pagePath}`);
    }

    resolveCorePath(corePath) {
        return this.resolvePath(`core/${corePath}`);
    }

    resolveComponentPath(componentPath) {
        return this.resolvePath(`components/${componentPath}`);
    }

    /**
     * Calculate relative path prefix from current location to website root
     * Used for RELATIVE_PATH replacements in templates
     * @returns {string}
     */
    getRelativePrefix() {
        const pathname = window.location.pathname;
        
        // Count directory depth from website root
        let websiteRelativePath = '';
        
        if (this.isLocalhost && this.baseProjectPath) {
            // Remove the base path to get relative path within website
            websiteRelativePath = pathname.replace(this.baseProjectPath, '').replace(/^\/+/, '');
        } else {
            // For deployed, path is already relative to root
            websiteRelativePath = pathname.replace(/^\/+/, '');
        }
        
        // Count directory levels (excluding filename)
        const pathSegments = websiteRelativePath.split('/').filter(segment => {
            return segment.length > 0 && !segment.includes('.');
        });
        
        const levelsUp = pathSegments.length;
        const prefix = '../'.repeat(levelsUp);
        
        console.log(`PathResolver: Relative prefix from ${websiteRelativePath} -> ${prefix || './'}`);
        return prefix || './';
    }

    /**
     * Replace RELATIVE_PATH placeholders in HTML content
     * @param {string} htmlContent 
     * @returns {string}
     */
    processRelativePaths(htmlContent) {
        const relativePrefix = this.getRelativePrefix();
        return htmlContent.replace(/RELATIVE_PATH\//g, relativePrefix);
    }

    /**
     * Get login page path
     * @returns {string}
     */
    getLoginPath() {
        return this.resolvePagePath('auth/login.html');
    }

    /**
     * Get dashboard path
     * @returns {string}
     */
    getDashboardPath() {
        return this.resolvePagePath('dashboard/index.html');
    }
}

// Create global instance
window.pathResolver = new PathResolver();

// Export for modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PathResolver;
}