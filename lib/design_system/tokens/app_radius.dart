import 'package:flutter/widgets.dart';

/// Corner radii repeated across the audited mobile Figma frames.
abstract final class AppRadius {
  static const input = BorderRadius.all(Radius.circular(12));
  static const card = BorderRadius.all(Radius.circular(16));
  static const lessonCard = BorderRadius.all(Radius.circular(20));
  static const choice = BorderRadius.all(Radius.circular(30));
  static const button = BorderRadius.all(Radius.circular(40));
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(50));
}
