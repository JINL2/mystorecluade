import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/tag.dart';

/// Tag Model (DTO + Mapper)
///
/// Data Transfer Object for Tag entity with JSON serialization.
/// Handles conversion between JSON (from API) and domain entity.
class TagModel {
  final String tagId;
  final String cardId;
  final String tagType;
  final String tagContent;
  final String createdAt;
  final String createdBy;

  const TagModel({
    required this.tagId,
    required this.cardId,
    required this.tagType,
    required this.tagContent,
    required this.createdAt,
    required this.createdBy,
  });

  /// Create from JSON
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      // Support both snake_case (tag_id) and camelCase (id) from RPC
      tagId: json['tag_id'] as String? ?? json['id'] as String? ?? '',
      cardId: json['card_id'] as String? ?? json['cardId'] as String? ?? '',
      tagType: json['tag_type'] as String? ?? json['type'] as String? ?? '',
      tagContent: json['tag_content'] as String? ?? json['content'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'tag_id': tagId,
      'card_id': cardId,
      'tag_type': tagType,
      'tag_content': tagContent,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }

  /// Map to Domain Entity
  Tag toEntity() {
    return Tag(
      tagId: tagId,
      cardId: cardId,
      tagType: tagType,
      tagContent: tagContent,
      createdAt: DateTimeUtils.toLocal(createdAt),
      createdBy: createdBy,
    );
  }

  /// Create from Domain Entity
  factory TagModel.fromEntity(Tag entity) {
    return TagModel(
      tagId: entity.tagId,
      cardId: entity.cardId,
      tagType: entity.tagType,
      tagContent: entity.tagContent,
      createdAt: DateTimeUtils.toUtc(entity.createdAt),
      createdBy: entity.createdBy,
    );
  }
}
