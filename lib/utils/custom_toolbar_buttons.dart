import 'package:flutter/material.dart';

class CustomButtonGroup {
  int? index;
  List<CustomToolbarButton> buttons = [];
}

class CustomToolbarButton {
  /// Icon to show in the toolbar
  IconData icon;

  /// Action called when user presses the icon
  Function()? action;

  /// Highlighted or not...
  bool isSelected;

  CustomToolbarButton({
    required this.icon,
    required this.action,
    required this.isSelected,
  });
}
