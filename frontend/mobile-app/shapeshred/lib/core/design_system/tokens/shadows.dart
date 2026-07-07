import 'package:flutter/material.dart';

/// Premium Shadow System
/// Subtle, elegant shadows for depth without breaking the minimalist aesthetic
class AppShadows {
  AppShadows._();

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Subtle shadow - for cards, containers
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow - for elevated cards
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Strong shadow - for modals, dialogs
  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Premium shadow - for hero elements
  static const List<BoxShadow> premium = [
    BoxShadow(
      color: Color(0x29000000), // 16% opacity
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
