/// Manager Memo Entity
///
/// Represents a memo added by a manager to a shift.
/// v4: New entity for manager_memo jsonb array from RPC
class ManagerMemo {
  /// The type of memo (e.g., "note")
  final String type;

  /// The content of the memo
  final String content;

  /// When the memo was created (ISO8601 format)
  final String? createdAt;

  /// User ID of who created the memo
  final String? createdBy;

  const ManagerMemo({
    required this.type,
    required this.content,
    this.createdAt,
    this.createdBy,
  });

  @override
  String toString() {
    return 'ManagerMemo(type: $type, content: $content, createdAt: $createdAt)';
  }
}
