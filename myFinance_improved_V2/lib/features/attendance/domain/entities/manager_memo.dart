import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_memo.freezed.dart';
part 'manager_memo.g.dart';

/// Manager Memo Entity - 매니저가 시프트에 남긴 메모
///
/// manager_memo_v2 JSONB array에서 매핑됨
@freezed
class ManagerMemo with _$ManagerMemo {
  const ManagerMemo._();

  const factory ManagerMemo({
    String? id,
    @Default('') String content,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _ManagerMemo;

  factory ManagerMemo.fromJson(Map<String, dynamic> json) =>
      _$ManagerMemoFromJson(json);
}
