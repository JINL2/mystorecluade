import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_memo.freezed.dart';

/// Manager Memo Entity - 매니저가 시프트에 남긴 메모
///
/// manager_memo_v2 JSONB array에서 매핑됨
///
/// Note: JSON serialization is handled by ManagerMemoModel in data layer
@freezed
class ManagerMemo with _$ManagerMemo {
  const ManagerMemo._();

  const factory ManagerMemo({
    String? id,
    @Default('') String content,
    String? createdAt,
    String? createdBy,
  }) = _ManagerMemo;

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static ManagerMemo mock() => const ManagerMemo(
        id: 'mock-memo-id',
        content: 'Manager memo content',
        createdAt: '2025-01-01T10:00:00',
        createdBy: 'Manager Name',
      );

  static List<ManagerMemo> mockList([int count = 2]) =>
      List.generate(count, (_) => mock());
}
