// Adapter: XFileImageAdapter
// ⚠️ DEPRECATED: This file has been moved to presentation/adapters/
// Use: import '../adapters/xfile_image_adapter.dart'; from presentation layer
// This file is kept temporarily for backward compatibility

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../domain/value_objects/image_file.dart';

/// @deprecated Use presentation/adapters/xfile_image_adapter.dart instead
/// Adapter that wraps image_picker's XFile to implement Domain's ImageFile interface
/// This allows Presentation layer to use XFile while Domain remains pure
@Deprecated('Moved to presentation/adapters/. Will be removed in next version.')
class XFileImageAdapter implements ImageFile {
  final XFile _xFile;

  XFileImageAdapter(this._xFile);

  @override
  String get path => _xFile.path;

  @override
  String get name => _xFile.name;

  @override
  Future<Uint8List> readAsBytes() => _xFile.readAsBytes();

  @override
  Future<int> length() => _xFile.length();

  /// Factory to convert list of XFiles to list of ImageFiles
  static List<ImageFile> fromXFiles(List<XFile> xFiles) {
    return xFiles.map((xFile) => XFileImageAdapter(xFile)).toList();
  }
}
