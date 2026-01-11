import 'package:flutter/material.dart';

/// Generic selection item model used across all selection bottom sheets
class SelectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? avatarUrl;
  final Map<String, dynamic>? data;
  final Widget? trailing;

  const SelectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.avatarUrl,
    this.data,
    this.trailing,
  });

  /// Copy with method for immutability
  SelectionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    String? avatarUrl,
    Map<String, dynamic>? data,
    Widget? trailing,
  }) {
    return SelectionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      data: data ?? this.data,
      trailing: trailing ?? this.trailing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectionItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
