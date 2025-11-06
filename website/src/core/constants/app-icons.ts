/**
 * MyFinance Web Application Icons
 * Based on Font Awesome icons from the Flutter app (app_icons_fa.dart)
 * TypeScript implementation with type safety
 *
 * @example
 * ```typescript
 * import { AppIcons } from '@/core/constants/app-icons';
 *
 * // Get icon class name
 * const iconClass = AppIcons.getClass('dashboard');
 *
 * // Get icon element (React/JSX compatible)
 * const iconElement = AppIcons.getElement('money', { size: 24, color: '#0064FF' });
 * ```
 */

export interface IconOptions {
  size?: number | string;
  color?: string;
  className?: string;
}

export interface IconGrouping {
  dashboard: string[];
  finance: string[];
  inventory: string[];
  users: string[];
  sales: string[];
  charts: string[];
  actions: string[];
  navigation: string[];
  status: string[];
}

export type IconName = keyof typeof AppIcons;

/**
 * AppIcons class - Font Awesome icon mappings for the application
 */
export class AppIcons {
  // ==================== 1. Dashboard & Home Icons ====================
  static readonly dashboard = 'chart-line';
  static readonly dashboardAlt = 'gauge-high';
  static readonly home = 'house';
  static readonly homeAlt = 'house-chimney';
  static readonly homeUser = 'house-user';
  static readonly overview = 'eye';
  static readonly summary = 'list-check';
  static readonly workspace = 'desktop';
  static readonly monitor = 'tv';

  // ==================== 2. Store & Business Icons ====================
  static readonly store = 'shop';
  static readonly storeAlt = 'store';
  static readonly building = 'building';
  static readonly company = 'sitemap';
  static readonly business = 'business-time';
  static readonly enterprise = 'city';

  // ==================== 3. Finance & Money Icons ====================
  static readonly money = 'money-bill';
  static readonly moneyWave = 'money-bill-wave';
  static readonly cash = 'sack-dollar';
  static readonly cashRegister = 'cash-register';
  static readonly wallet = 'wallet';
  static readonly piggyBank = 'piggy-bank';
  static readonly coins = 'coins';
  static readonly dollarSign = 'dollar-sign';
  static readonly euroSign = 'euro-sign';
  static readonly yenSign = 'yen-sign';
  static readonly wonSign = 'won-sign';
  static readonly creditCard = 'credit-card';

  // ==================== 4. Charts & Analytics Icons ====================
  static readonly chartLine = 'chart-line';
  static readonly chartBar = 'chart-column';
  static readonly chartPie = 'chart-pie';
  static readonly chartArea = 'chart-area';
  static readonly analytics = 'magnifying-glass-chart';
  static readonly trend = 'arrow-trend-up';
  static readonly trendDown = 'arrow-trend-down';
  static readonly performance = 'tachometer-alt';
  static readonly gauge = 'gauge';

  // ==================== 5. Inventory & Products Icons ====================
  static readonly inventory = 'boxes';
  static readonly box = 'box';
  static readonly package = 'cube';
  static readonly packages = 'cubes';
  static readonly product = 'tag';
  static readonly products = 'tags';
  static readonly barcode = 'barcode';
  static readonly qrcode = 'qrcode';

  // ==================== 6. Shopping & Sales Icons ====================
  static readonly cart = 'cart-shopping';
  static readonly cartPlus = 'cart-plus';
  static readonly basket = 'basket-shopping';
  static readonly sale = 'percent';
  static readonly discount = 'ticket-simple';
  static readonly receipt = 'receipt';
  static readonly invoice = 'file-invoice';
  static readonly checkout = 'cash-register';

  // ==================== 7. Users & Employees Icons ====================
  static readonly user = 'user';
  static readonly userCircle = 'circle-user';
  static readonly userTie = 'user-tie';
  static readonly userShield = 'user-shield';
  static readonly userCheck = 'user-check';
  static readonly userClock = 'user-clock';
  static readonly userPlus = 'user-plus';
  static readonly users = 'users';
  static readonly userGroup = 'user-group';

  // ==================== 8. Time & Schedule Icons ====================
  static readonly clock = 'clock';
  static readonly stopwatch = 'stopwatch';
  static readonly calendar = 'calendar';
  static readonly calendarDays = 'calendar-days';
  static readonly calendarCheck = 'calendar-check';
  static readonly businessTime = 'business-time';
  static readonly history = 'clock-rotate-left';
  static readonly schedule = 'calendar-days';

  // ==================== 9. Documents & Files Icons ====================
  static readonly file = 'file';
  static readonly fileAlt = 'file-lines';
  static readonly fileContract = 'file-contract';
  static readonly fileInvoice = 'file-invoice';
  static readonly filePdf = 'file-pdf';
  static readonly fileExcel = 'file-excel';
  static readonly fileDownload = 'file-arrow-down';
  static readonly fileUpload = 'file-arrow-up';
  static readonly folder = 'folder';
  static readonly folderOpen = 'folder-open';

  // ==================== 10. Communication & Messages Icons ====================
  static readonly message = 'message';
  static readonly comment = 'comment';
  static readonly envelope = 'envelope';
  static readonly phone = 'phone';
  static readonly video = 'video';

  // ==================== 11. Security & Permissions Icons ====================
  static readonly lock = 'lock';
  static readonly lockOpen = 'lock-open';
  static readonly unlock = 'unlock';
  static readonly key = 'key';
  static readonly shield = 'shield';
  static readonly fingerprint = 'fingerprint';
  static readonly idCard = 'id-card';

  // ==================== 12. Transportation & Delivery Icons ====================
  static readonly truck = 'truck';
  static readonly truckFast = 'truck-fast';
  static readonly car = 'car';
  static readonly plane = 'plane';
  static readonly ship = 'ship';

  // ==================== 13. Actions & Operations Icons ====================
  static readonly add = 'plus';
  static readonly minus = 'minus';
  static readonly times = 'xmark';
  static readonly check = 'check';
  static readonly checkCircle = 'circle-check';
  static readonly edit = 'pen-to-square';
  static readonly trash = 'trash';
  static readonly save = 'floppy-disk';
  static readonly copy = 'copy';
  static readonly refresh = 'arrows-rotate';

  // ==================== 14. Navigation Icons ====================
  static readonly arrowUp = 'arrow-up';
  static readonly arrowDown = 'arrow-down';
  static readonly arrowLeft = 'arrow-left';
  static readonly arrowRight = 'arrow-right';
  static readonly chevronUp = 'chevron-up';
  static readonly chevronDown = 'chevron-down';
  static readonly chevronLeft = 'chevron-left';
  static readonly chevronRight = 'chevron-right';

  // ==================== 15. UI Components Icons ====================
  static readonly bars = 'bars';
  static readonly ellipsis = 'ellipsis';
  static readonly grip = 'grip';
  static readonly list = 'list';
  static readonly table = 'table';
  static readonly sliders = 'sliders';

  // ==================== 16. Status & Notifications Icons ====================
  static readonly info = 'circle-info';
  static readonly question = 'circle-question';
  static readonly exclamation = 'circle-exclamation';
  static readonly warning = 'triangle-exclamation';
  static readonly bell = 'bell';
  static readonly flag = 'flag';
  static readonly star = 'star';
  static readonly heart = 'heart';

  // ==================== 17. Tools & Settings Icons ====================
  static readonly gear = 'gear';
  static readonly gears = 'gears';
  static readonly wrench = 'wrench';
  static readonly toolbox = 'toolbox';
  static readonly filter = 'filter';
  static readonly sort = 'arrow-down-wide-short';

  // ==================== 18. Media Icons ====================
  static readonly play = 'play';
  static readonly pause = 'pause';
  static readonly stop = 'stop';
  static readonly volumeHigh = 'volume-high';
  static readonly music = 'music';

  // ==================== 19. Other Useful Icons ====================
  static readonly search = 'magnifying-glass';
  static readonly print = 'print';
  static readonly download = 'download';
  static readonly upload = 'upload';
  static readonly share = 'share';
  static readonly link = 'link';
  static readonly globe = 'globe';

  // ==================== Helper Methods ====================

  /**
   * Get Font Awesome class name for icon
   * @param iconName - Name of the icon property
   * @returns Font Awesome class string
   */
  static getClass(iconName: string): string {
    const iconValue = (AppIcons as any)[iconName];
    return iconValue ? `fa-solid fa-${iconValue}` : 'fa-solid fa-question';
  }

  /**
   * Get Font Awesome icon element (React/JSX compatible)
   * @param iconName - Name of the icon property
   * @param options - Icon options (size, color, className)
   * @returns JSX-compatible object
   */
  static getElement(iconName: string, options: IconOptions = {}) {
    const { size = '', color = '', className = '' } = options;

    const sizeClass = size ? `fa-${size}` : '';
    const style = color ? { color } : undefined;
    const faClass = this.getClass(iconName);

    return {
      className: `${faClass} ${sizeClass} ${className}`.trim(),
      style,
    };
  }

  /**
   * Icon category groups for easy navigation
   */
  static readonly iconGroups: IconGrouping = {
    dashboard: ['dashboard', 'home', 'overview', 'monitor'],
    finance: ['money', 'cash', 'wallet', 'creditCard', 'wonSign'],
    inventory: ['inventory', 'box', 'package', 'barcode'],
    users: ['user', 'users', 'userTie', 'userClock'],
    sales: ['cart', 'sale', 'receipt', 'cashRegister'],
    charts: ['chartLine', 'chartBar', 'chartPie', 'analytics'],
    actions: ['add', 'edit', 'trash', 'save', 'check'],
    navigation: ['arrowUp', 'arrowDown', 'chevronLeft', 'chevronRight'],
    status: ['info', 'warning', 'bell', 'star'],
  };

  /**
   * Common icons mapping for quick access
   */
  static readonly commonIcons = {
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
    transaction: 'receipt',
  };
}

/**
 * Icon utilities for React components
 */
export const IconUtils = {
  /**
   * Get icon props for React/JSX
   */
  getIconProps(iconName: string, options?: IconOptions) {
    return AppIcons.getElement(iconName, options);
  },

  /**
   * Get icon class string
   */
  getIconClass(iconName: string): string {
    return AppIcons.getClass(iconName);
  },

  /**
   * Check if icon exists
   */
  hasIcon(iconName: string): boolean {
    return iconName in AppIcons;
  },
};

export default AppIcons;
