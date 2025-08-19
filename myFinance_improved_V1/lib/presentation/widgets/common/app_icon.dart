import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';

/// Reusable icon widget that displays either Font Awesome icons (via iconKey)
/// or network images (via iconUrl) with consistent styling
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.iconKey,
    this.iconUrl,
    this.size = UIConstants.iconSizeLarge,
    this.color,
    this.backgroundColor,
    this.borderRadius = UIConstants.borderRadiusSmall,
    this.showContainer = true,
    this.useDefaultColor = true,
  });

  /// Font Awesome icon key from database
  final String? iconKey;
  
  /// Fallback network image URL
  final String? iconUrl;
  
  /// Icon size
  final double size;
  
  /// Icon color (overrides default color)
  final Color? color;
  
  /// Background color for container
  final Color? backgroundColor;
  
  /// Border radius for container
  final double borderRadius;
  
  /// Whether to show background container
  final bool showContainer;
  
  /// Whether to use IconMapper's default color
  final bool useDefaultColor;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size;
    final containerSize = effectiveSize + (showContainer ? 8.0 : 0.0);
    
    Widget iconWidget;
    
    // Prefer iconKey over iconUrl for better performance and consistency
    if (iconKey != null && iconKey!.isNotEmpty) {
      iconWidget = DynamicIcon(
        iconKey: iconKey,
        size: effectiveSize,
        color: color,
        useDefaultColor: useDefaultColor && color == null,
      );
    } else if (iconUrl != null && iconUrl!.isNotEmpty && _isValidUrl(iconUrl!)) {
      iconWidget = _buildNetworkIcon(effectiveSize);
    } else {
      // Fallback icon
      iconWidget = Icon(
        Icons.apps,
        size: effectiveSize,
        color: color ?? TossColors.primary,
      );
    }
    
    if (!showContainer) {
      return iconWidget;
    }
    
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(child: iconWidget),
    );
  }
  
  Widget _buildNetworkIcon(double effectiveSize) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        iconUrl!,
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.apps,
            size: effectiveSize,
            color: color ?? TossColors.primary,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color ?? TossColors.primary,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
  
  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}

/// Specialized app icon for feature lists
class FeatureIcon extends StatelessWidget {
  const FeatureIcon({
    super.key,
    this.iconKey,
    this.iconUrl,
    this.size = FeatureIconSize.medium,
  });

  final String? iconKey;
  final String? iconUrl;
  final FeatureIconSize size;

  @override
  Widget build(BuildContext context) {
    final iconSize = _getIconSize(size);
    final containerSize = _getContainerSize(size);
    final borderRadius = _getBorderRadius(size);
    
    return AppIcon(
      iconKey: iconKey,
      iconUrl: iconUrl,
      size: iconSize,
      color: TossColors.primary,
      backgroundColor: TossColors.primary.withOpacity(0.1),
      borderRadius: borderRadius,
      showContainer: true,
      useDefaultColor: false,
    );
  }
  
  double _getIconSize(FeatureIconSize size) {
    switch (size) {
      case FeatureIconSize.small:
        return UIConstants.featureIconCompact;
      case FeatureIconSize.medium:
        return UIConstants.featureIconSize;
      case FeatureIconSize.large:
        return UIConstants.iconSizeXL;
    }
  }
  
  double _getContainerSize(FeatureIconSize size) {
    switch (size) {
      case FeatureIconSize.small:
        return UIConstants.featureIconContainerCompact;
      case FeatureIconSize.medium:
        return UIConstants.featureIconContainerSize;
      case FeatureIconSize.large:
        return UIConstants.featureIconContainerLarge;
    }
  }
  
  double _getBorderRadius(FeatureIconSize size) {
    switch (size) {
      case FeatureIconSize.small:
        return UIConstants.borderRadiusSmall;
      case FeatureIconSize.medium:
        return UIConstants.borderRadiusSmall;
      case FeatureIconSize.large:
        return UIConstants.borderRadiusMedium;
    }
  }
}

/// Predefined feature icon sizes
enum FeatureIconSize {
  small,   // For list items and compact layouts
  medium,  // For quick access grids
  large,   // For main feature cards
}