import 'package:supabase_flutter/supabase_flutter.dart';

/// Helper class for Supabase Storage URL handling
///
/// Supabase Storage provides three access patterns:
/// 1. `/object/public/` - For public buckets (no auth needed)
/// 2. `/object/authenticated/` - For private buckets (requires auth header)
/// 3. Signed URLs - Time-limited URLs (generated server-side)
///
/// This helper converts public URLs to authenticated URLs for private buckets.
class StorageUrlHelper {
  /// Convert a public storage URL to an authenticated URL
  ///
  /// Changes `/object/public/` to `/object/authenticated/`
  /// Example:
  /// ```
  /// Input:  https://xxx.supabase.co/storage/v1/object/public/bucket/path/file.png
  /// Output: https://xxx.supabase.co/storage/v1/object/authenticated/bucket/path/file.png
  /// ```
  static String toAuthenticatedUrl(String? publicUrl) {
    if (publicUrl == null || publicUrl.isEmpty) {
      return '';
    }

    return publicUrl.replaceFirst(
      '/object/public/',
      '/object/authenticated/',
    );
  }

  /// Get the current auth token for storage requests
  ///
  /// Returns null if user is not authenticated
  static String? getAuthToken() {
    return Supabase.instance.client.auth.currentSession?.accessToken;
  }

  /// Get headers for authenticated storage requests
  ///
  /// Returns a map with Authorization header if user is authenticated
  static Map<String, String> getAuthHeaders() {
    final token = getAuthToken();
    if (token == null) {
      return {};
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }

  /// Check if a URL is a Supabase storage URL
  static bool isSupabaseStorageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    return url.contains('supabase.co/storage/v1/object');
  }

  /// Check if a URL is a public storage URL
  static bool isPublicUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    return url.contains('/object/public/');
  }

  /// Check if a URL is an authenticated storage URL
  static bool isAuthenticatedUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    return url.contains('/object/authenticated/');
  }
}
