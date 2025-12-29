// lib/features/sales_invoice/presentation/providers/invoice_detail_provider.dart
//
// Invoice Detail Provider migrated to @riverpod
// Following Clean Architecture 2025

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/sales_invoice_providers.dart';
import '../../domain/entities/invoice_detail.dart';

part 'invoice_detail_provider.g.dart';

/// State for invoice detail
class InvoiceDetailState {
  final InvoiceDetail? detail;
  final bool isLoading;
  final String? error;

  const InvoiceDetailState({
    this.detail,
    this.isLoading = false,
    this.error,
  });

  InvoiceDetailState copyWith({
    InvoiceDetail? detail,
    bool? isLoading,
    String? error,
  }) {
    return InvoiceDetailState(
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Invoice detail notifier using @riverpod
@riverpod
class InvoiceDetailNotifier extends _$InvoiceDetailNotifier {
  @override
  InvoiceDetailState build() => const InvoiceDetailState();

  /// Load invoice detail
  Future<void> loadDetail(String invoiceId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(invoiceRepositoryProvider);
      final detail = await repository.getInvoiceDetail(invoiceId: invoiceId);
      state = state.copyWith(detail: detail, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear state
  void clear() {
    state = const InvoiceDetailState();
  }
}
