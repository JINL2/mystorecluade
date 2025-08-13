import 'package:flutter/material.dart';

/// Toss-style subtle shadow system
class TossShadows {
  // Private constructor
  TossShadows._();

  // Toss uses very subtle, layered shadows
  static const List<BoxShadow> shadow0 = [];

  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color(0x05000000), // 2% opacity
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x08000000), // 3% opacity
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  static const List<BoxShadow> shadow4 = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  // Special shadows for specific components
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> bottomSheetShadow = [
    BoxShadow(
      color: Color(0x15000000),
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x10000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}