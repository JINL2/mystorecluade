// Domain Constants: Inventory Management
// Application-wide constants for inventory feature

/// Inventory feature constants
class InventoryConstants {
  // Private constructor to prevent instantiation
  const InventoryConstants._();

  /// Search debounce delay (milliseconds)
  static const Duration searchDebounceDelay = Duration(milliseconds: 300);

  /// Default timeout for API requests
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Maximum image file size (5MB)
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  /// Maximum number of images per product
  static const int maxImagesPerProduct = 5;

  /// Image cache dimensions
  static const int imageCacheWidth = 200;
  static const int imageCacheHeight = 200;
  static const int imageDiskCacheWidth = 400;
  static const int imageDiskCacheHeight = 400;
}
