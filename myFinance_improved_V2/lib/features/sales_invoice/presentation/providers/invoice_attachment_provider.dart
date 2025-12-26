import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../journal_input/data/datasources/journal_entry_datasource.dart';
import '../../../journal_input/domain/entities/journal_attachment.dart';

/// State for invoice attachment management
class InvoiceAttachmentState {
  final List<JournalAttachment> pendingAttachments;
  final bool isUploading;
  final bool isPickingImages;
  final String? errorMessage;

  const InvoiceAttachmentState({
    this.pendingAttachments = const [],
    this.isUploading = false,
    this.isPickingImages = false,
    this.errorMessage,
  });

  InvoiceAttachmentState copyWith({
    List<JournalAttachment>? pendingAttachments,
    bool? isUploading,
    bool? isPickingImages,
    String? errorMessage,
  }) {
    return InvoiceAttachmentState(
      pendingAttachments: pendingAttachments ?? this.pendingAttachments,
      isUploading: isUploading ?? this.isUploading,
      isPickingImages: isPickingImages ?? this.isPickingImages,
      errorMessage: errorMessage,
    );
  }

  /// Check if there are pending attachments to upload
  bool get hasPendingAttachments => pendingAttachments.isNotEmpty;

  /// Number of pending attachments
  int get attachmentCount => pendingAttachments.length;

  /// Maximum number of attachments allowed
  static const int maxAttachments = 5;

  /// Check if more attachments can be added
  bool get canAddMoreAttachments => pendingAttachments.length < maxAttachments;
}

/// Invoice attachment notifier
class InvoiceAttachmentNotifier extends StateNotifier<InvoiceAttachmentState> {
  final JournalEntryDataSource _dataSource;

  InvoiceAttachmentNotifier(this._dataSource)
      : super(const InvoiceAttachmentState());

  /// Add attachments to pending list
  void addAttachments(List<JournalAttachment> attachments) {
    final currentCount = state.pendingAttachments.length;
    final availableSlots = InvoiceAttachmentState.maxAttachments - currentCount;

    if (availableSlots <= 0) return;

    final toAdd = attachments.take(availableSlots).toList();
    state = state.copyWith(
      pendingAttachments: [...state.pendingAttachments, ...toAdd],
    );
  }

  /// Remove attachment at index
  void removeAttachment(int index) {
    if (index < 0 || index >= state.pendingAttachments.length) return;

    final updated = List<JournalAttachment>.from(state.pendingAttachments)
      ..removeAt(index);
    state = state.copyWith(pendingAttachments: updated);
  }

  /// Set picking images state
  void setPickingImages(bool value) {
    state = state.copyWith(isPickingImages: value);
  }

  /// Upload all pending attachments
  Future<bool> uploadAttachments({
    required String companyId,
    required String journalId,
    required String userId,
  }) async {
    if (state.pendingAttachments.isEmpty) return true;

    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      final files = state.pendingAttachments
          .where((a) => a.localFile != null)
          .map((a) => a.localFile!)
          .toList();

      if (files.isEmpty) {
        state = state.copyWith(isUploading: false);
        return true;
      }

      await _dataSource.uploadAttachments(
        companyId: companyId,
        journalId: journalId,
        uploadedBy: userId,
        files: files,
      );

      // Clear pending attachments on success
      state = state.copyWith(
        pendingAttachments: [],
        isUploading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Failed to upload images: $e',
      );
      return false;
    }
  }

  /// Reset state
  void reset() {
    state = const InvoiceAttachmentState();
  }
}

/// Supabase client provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Journal entry data source provider (reuse from journal_input)
final _journalEntryDataSourceProvider = Provider<JournalEntryDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return JournalEntryDataSource(client);
});

/// Invoice attachment provider
final invoiceAttachmentProvider =
    StateNotifierProvider<InvoiceAttachmentNotifier, InvoiceAttachmentState>(
        (ref) {
  final dataSource = ref.watch(_journalEntryDataSourceProvider);
  return InvoiceAttachmentNotifier(dataSource);
});

/// Helper function to process picked files into JournalAttachment list
Future<List<JournalAttachment>> processPickedFiles(List<XFile> files) async {
  final attachments = <JournalAttachment>[];

  for (final file in files) {
    final fileSize = await file.length();
    attachments.add(
      JournalAttachment(
        localFile: file,
        fileName: file.name,
        fileSizeBytes: fileSize,
        mimeType: _getMimeType(file.name),
      ),
    );
  }

  return attachments;
}

String _getMimeType(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    case 'gif':
      return 'image/gif';
    default:
      return 'image/jpeg';
  }
}
