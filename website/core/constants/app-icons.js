/**
 * MyFinance Web Application Icons
 * Based on Font Awesome icons from the Flutter app (app_icons_fa.dart)
 * 
 * Usage:
 * ```javascript
 * // Get SVG icon
 * const dashboardIcon = AppIcons.getSVG('dashboard');
 * element.innerHTML = dashboardIcon;
 * 
 * // Get icon HTML
 * const moneyIcon = AppIcons.getIcon('money', { size: 24, color: '#0064FF' });
 * ```
 */

class AppIcons {
    constructor() {
        // Private constructor to prevent instantiation
    }

    // ==================== 1. Dashboard & Home Icons ====================
    static dashboard = 'chart-line';
    static dashboardAlt = 'gauge-high';
    static home = 'house';
    static homeAlt = 'house-chimney';
    static homeUser = 'house-user';
    static overview = 'eye';
    static summary = 'list-check';
    static workspace = 'desktop';
    static monitor = 'tv';

    // ==================== 2. Store & Business Icons ====================
    static store = 'shop';
    static storeAlt = 'store';
    static building = 'building';
    static company = 'sitemap';
    static business = 'business-time';
    static enterprise = 'city';

    // ==================== 3. Finance & Money Icons ====================
    static money = 'money-bill';
    static moneyWave = 'money-bill-wave';
    static cash = 'sack-dollar';
    static cashRegister = 'cash-register';
    static wallet = 'wallet';
    static piggyBank = 'piggy-bank';
    static coins = 'coins';
    static dollarSign = 'dollar-sign';
    static euroSign = 'euro-sign';
    static yenSign = 'yen-sign';
    static wonSign = 'won-sign';
    static creditCard = 'credit-card';

    // ==================== 4. Charts & Analytics Icons ====================
    static chartLine = 'chart-line';
    static chartBar = 'chart-column';
    static chartPie = 'chart-pie';
    static chartArea = 'chart-area';
    static analytics = 'magnifying-glass-chart';
    static trend = 'arrow-trend-up';
    static trendDown = 'arrow-trend-down';
    static performance = 'tachometer-alt';
    static gauge = 'gauge';

    // ==================== 5. Inventory & Products Icons ====================
    static inventory = 'boxes';
    static box = 'box';
    static package = 'cube';
    static packages = 'cubes';
    static product = 'tag';
    static products = 'tags';
    static barcode = 'barcode';
    static qrcode = 'qrcode';

    // ==================== 6. Shopping & Sales Icons ====================
    static cart = 'cart-shopping';
    static cartPlus = 'cart-plus';
    static basket = 'basket-shopping';
    static sale = 'percent';
    static discount = 'ticket-simple';
    static receipt = 'receipt';
    static invoice = 'file-invoice';
    static checkout = 'cash-register';

    // ==================== 7. Users & Employees Icons ====================
    static user = 'user';
    static userCircle = 'circle-user';
    static userTie = 'user-tie';
    static userShield = 'user-shield';
    static userCheck = 'user-check';
    static userClock = 'user-clock';
    static userPlus = 'user-plus';
    static users = 'users';
    static userGroup = 'user-group';

    // ==================== 8. Time & Schedule Icons ====================
    static clock = 'clock';
    static stopwatch = 'stopwatch';
    static calendar = 'calendar';
    static calendarDays = 'calendar-days';
    static calendarCheck = 'calendar-check';
    static businessTime = 'business-time';
    static history = 'clock-rotate-left';
    static schedule = 'calendar-days';

    // ==================== 9. Documents & Files Icons ====================
    static file = 'file';
    static fileAlt = 'file-lines';
    static fileContract = 'file-contract';
    static fileInvoice = 'file-invoice';
    static filePdf = 'file-pdf';
    static fileExcel = 'file-excel';
    static fileDownload = 'file-arrow-down';
    static fileUpload = 'file-arrow-up';
    static folder = 'folder';
    static folderOpen = 'folder-open';

    // ==================== 10. Communication & Messages Icons ====================
    static message = 'message';
    static comment = 'comment';
    static envelope = 'envelope';
    static phone = 'phone';
    static video = 'video';

    // ==================== 11. Security & Permissions Icons ====================
    static lock = 'lock';
    static lockOpen = 'lock-open';
    static unlock = 'unlock';
    static key = 'key';
    static shield = 'shield';
    static fingerprint = 'fingerprint';
    static idCard = 'id-card';

    // ==================== 12. Transportation & Delivery Icons ====================
    static truck = 'truck';
    static truckFast = 'truck-fast';
    static car = 'car';
    static plane = 'plane';
    static ship = 'ship';

    // ==================== 13. Actions & Operations Icons ====================
    static add = 'plus';
    static minus = 'minus';
    static times = 'xmark';
    static check = 'check';
    static checkCircle = 'circle-check';
    static edit = 'pen-to-square';
    static trash = 'trash';
    static save = 'floppy-disk';
    static copy = 'copy';
    static refresh = 'arrows-rotate';

    // ==================== 14. Navigation Icons ====================
    static arrowUp = 'arrow-up';
    static arrowDown = 'arrow-down';
    static arrowLeft = 'arrow-left';
    static arrowRight = 'arrow-right';
    static chevronUp = 'chevron-up';
    static chevronDown = 'chevron-down';
    static chevronLeft = 'chevron-left';
    static chevronRight = 'chevron-right';

    // ==================== 15. UI Components Icons ====================
    static bars = 'bars';
    static ellipsis = 'ellipsis';
    static grip = 'grip';
    static list = 'list';
    static table = 'table';
    static sliders = 'sliders';

    // ==================== 16. Status & Notifications Icons ====================
    static info = 'circle-info';
    static question = 'circle-question';
    static exclamation = 'circle-exclamation';
    static warning = 'triangle-exclamation';
    static bell = 'bell';
    static flag = 'flag';
    static star = 'star';
    static heart = 'heart';

    // ==================== 17. Tools & Settings Icons ====================
    static gear = 'gear';
    static gears = 'gears';
    static wrench = 'wrench';
    static toolbox = 'toolbox';
    static filter = 'filter';
    static sort = 'arrow-down-wide-short';

    // ==================== 18. Media Icons ====================
    static play = 'play';
    static pause = 'pause';
    static stop = 'stop';
    static volumeHigh = 'volume-high';
    static music = 'music';

    // ==================== 19. Other Useful Icons ====================
    static search = 'magnifying-glass';
    static print = 'print';
    static download = 'download';
    static upload = 'upload';
    static share = 'share';
    static link = 'link';
    static globe = 'globe';

    // ==================== Helper Methods ====================

    /**
     * Get Font Awesome class name for icon
     * @param {string} iconName - Name of the icon
     * @returns {string} Font Awesome class string
     */
    static getClass(iconName) {
        const iconValue = this[iconName];
        return iconValue ? `fa-solid fa-${iconValue}` : 'fa-solid fa-question';
    }

    /**
     * Get SVG icon HTML string
     * @param {string} iconName - Name of the icon
     * @param {Object} options - Icon options (size, color, class)
     * @returns {string} SVG HTML string
     */
    static getSVG(iconName, options = {}) {
        const {
            size = 24,
            color = 'currentColor',
            className = ''
        } = options;

        const iconMappings = {
            // Common icons with their SVG paths
            'dashboard': '<path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>',
            'home': '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>',
            'money': '<path d="M7 15h2c0 1.08.81 2 2 2h2c1.19 0 2-.81 2-2s-.81-2-2-2h-2c-1.19 0-2-.81-2-2s.81-2 2-2h2c1.19 0 2 .92 2 2h2c0-1.08-.81-2-2-2V9h-2v2h-2c-1.19 0-2 .81-2 2s.81 2 2 2h2c1.19 0 2 .81 2 2s-.81 2-2 2h-2c-1.19 0-2-.92-2-2H7v2z"/>',
            'user': '<path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>',
            'search': '<path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>',
            'plus': '<path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>',
            'check': '<path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/>',
            'times': '<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>',
            'gear': '<path d="M19.14,12.94c0.04-0.3,0.06-0.61,0.06-0.94c0-0.32-0.02-0.64-0.07-0.94l2.03-1.58c0.18-0.14,0.23-0.41,0.12-0.61 l-1.92-3.32c-0.12-0.22-0.37-0.29-0.59-0.22l-2.39,0.96c-0.5-0.38-1.03-0.7-1.62-0.94L14.4,2.81c-0.04-0.24-0.24-0.41-0.48-0.41 h-3.84c-0.24,0-0.43,0.17-0.47,0.41L9.25,5.35C8.66,5.59,8.12,5.92,7.63,6.29L5.24,5.33c-0.22-0.08-0.47,0-0.59,0.22L2.74,8.87 C2.62,9.08,2.66,9.34,2.86,9.48l2.03,1.58C4.84,11.36,4.8,11.69,4.8,12s0.02,0.64,0.07,0.94l-2.03,1.58 c-0.18,0.14-0.23,0.41-0.12,0.61l1.92,3.32c0.12,0.22,0.37,0.29,0.59,0.22l2.39-0.96c0.5,0.38,1.03,0.7,1.62,0.94l0.36,2.54 c0.05,0.24,0.24,0.41,0.48,0.41h3.84c0.24,0,0.44-0.17,0.47-0.41l0.36-2.54c0.59-0.24,1.13-0.56,1.62-0.94l2.39,0.96 c0.22,0.08,0.47,0,0.59-0.22l1.92-3.32c0.12-0.22,0.07-0.47-0.12-0.61L19.14,12.94z M12,15.6c-1.98,0-3.6-1.62-3.6-3.6 s1.62-3.6,3.6-3.6s3.6,1.62,3.6,3.6S13.98,15.6,12,15.6z"/>',
            'bars': '<path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/>'
        };

        const defaultPath = '<path d="M11 15h2v2h-2zm0-8h2v6h-2zm.99-5C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/>';
        const path = iconMappings[iconName] || defaultPath;

        return `<svg class="app-icon ${className}" width="${size}" height="${size}" viewBox="0 0 24 24" fill="${color}">
            ${path}
        </svg>`;
    }

    /**
     * Get icon as HTML element
     * @param {string} iconName - Name of the icon
     * @param {Object} options - Icon options
     * @returns {HTMLElement} Icon HTML element
     */
    static getElement(iconName, options = {}) {
        const div = document.createElement('div');
        div.innerHTML = this.getSVG(iconName, options);
        return div.firstChild;
    }

    /**
     * Get Font Awesome icon HTML
     * @param {string} iconName - Name of the icon
     * @param {Object} options - Icon options
     * @returns {string} Font Awesome HTML string
     */
    static getFontAwesome(iconName, options = {}) {
        const {
            size = '',
            color = '',
            className = ''
        } = options;

        const sizeClass = size ? `fa-${size}` : '';
        const style = color ? `style="color: ${color}"` : '';
        const faClass = this.getClass(iconName);

        return `<i class="${faClass} ${sizeClass} ${className}" ${style}></i>`;
    }

    /**
     * Icon category groups for easy navigation
     */
    static iconGroups = {
        dashboard: ['dashboard', 'home', 'overview', 'monitor'],
        finance: ['money', 'cash', 'wallet', 'creditCard', 'wonSign'],
        inventory: ['inventory', 'box', 'warehouse', 'barcode'],
        users: ['user', 'users', 'userTie', 'userClock'],
        sales: ['cart', 'sale', 'receipt', 'cashRegister'],
        charts: ['chartLine', 'chartBar', 'chartPie', 'analytics'],
        actions: ['add', 'edit', 'trash', 'save', 'check'],
        navigation: ['arrowUp', 'arrowDown', 'chevronLeft', 'chevronRight'],
        status: ['info', 'warning', 'bell', 'star']
    };

    /**
     * Common icons mapping for quick access
     */
    static commonIcons = {
        // Navigation
        home: 'home',
        dashboard: 'dashboard',
        settings: 'gear',
        menu: 'bars',
        
        // CRUD
        add: 'add',
        edit: 'edit',
        delete: 'trash',
        save: 'save',
        
        // Search & Filter
        search: 'search',
        filter: 'filter',
        sort: 'sort',
        
        // Actions
        refresh: 'refresh',
        download: 'download',
        upload: 'upload',
        share: 'share',
        print: 'print',

        // Finance specific
        money: 'money',
        won: 'wonSign',
        wallet: 'wallet',
        transaction: 'receipt'
    };
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AppIcons;
}

// Global availability
if (typeof window !== 'undefined') {
    window.AppIcons = AppIcons;
}