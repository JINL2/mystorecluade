// Value Object: ImageFile
// Abstract interface for image file operations
// Allows Domain layer to remain independent of external libraries (e.g., image_picker)

import 'dart:typed_data';

/// Abstract interface for image file operations
/// This abstraction allows the Domain layer to remain pure and independent
/// of external libraries like image_picker
abstract class ImageFile {
  /// The path to the image file
  String get path;

  /// The name of the image file
  String get name;

  /// Read the image file as bytes
  Future<Uint8List> readAsBytes();

  /// Get the file size in bytes
  Future<int> length();
}
