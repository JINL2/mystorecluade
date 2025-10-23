import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Image Cache Helper
///
/// Provides utilities for preloading and caching images.
class ImageCacheHelper {
  /// Preload profile images for better performance
  ///
  /// Usage:
  /// ```dart
  /// ImageCacheHelper.preloadProfileImages(context, imageUrls);
  /// ```
  static void preloadProfileImages(
    BuildContext context,
    List<String> imageUrls,
  ) {
    for (final imageUrl in imageUrls) {
      if (imageUrl.isNotEmpty) {
        // Preload using CachedNetworkImage
        precacheImage(
          CachedNetworkImageProvider(imageUrl),
          context,
        );
      }
    }
  }

  /// Preload single image
  static void preloadImage(BuildContext context, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      precacheImage(
        CachedNetworkImageProvider(imageUrl),
        context,
      );
    }
  }

  /// Extract image URLs from data structure
  ///
  /// Utility to extract all profile image URLs from complex data structures
  static List<String> extractImageUrls(
    List<dynamic> data, {
    List<String> imageFields = const ['profile_image', 'avatar', 'image_url'],
  }) {
    final List<String> urls = [];

    void extractRecursive(dynamic item) {
      if (item is Map<String, dynamic>) {
        for (final field in imageFields) {
          if (item[field] is String && (item[field] as String).isNotEmpty) {
            urls.add(item[field] as String);
          }
        }
        // Recursively search nested maps and lists
        for (final value in item.values) {
          extractRecursive(value);
        }
      } else if (item is List) {
        for (final element in item) {
          extractRecursive(element);
        }
      }
    }

    for (final item in data) {
      extractRecursive(item);
    }

    return urls.toSet().toList(); // Remove duplicates
  }

  /// Preload images from shift data structure
  ///
  /// Specialized method for shift data with employees
  static void preloadShiftEmployeeImages(
    BuildContext context,
    List<dynamic> shiftData,
  ) {
    for (var dayData in shiftData) {
      final shifts = dayData['shifts'] as List<dynamic>? ?? [];
      for (var shift in shifts) {
        final pendingEmployees =
            shift['pending_employees'] as List<dynamic>? ?? [];
        final approvedEmployees =
            shift['approved_employees'] as List<dynamic>? ?? [];

        for (var employee in [...pendingEmployees, ...approvedEmployees]) {
          final profileImage = employee['profile_image'] as String?;
          if (profileImage != null && profileImage.isNotEmpty) {
            preloadImage(context, profileImage);
          }
        }
      }
    }
  }
}
