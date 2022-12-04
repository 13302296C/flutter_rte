import 'package:flutter/material.dart';

class CustomButtonGroup {
  /// index in the toolbar at which to place the group
  int? index;

  /// list of buttons for this group
  List<CustomToolbarButton> buttons;

  CustomButtonGroup({
    this.index,
    required this.buttons,
  });
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
