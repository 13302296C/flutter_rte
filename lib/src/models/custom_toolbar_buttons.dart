import 'package:flutter/material.dart';

/// Custom toolbar buttons for the HtmlEditor are grouped into CustomButtonGroup
/// objects. Each group is placed in the toolbar at the index specified by the
/// group's index property.
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

/// Custom toolbar buttons are a part of CustomButtonGroup objects. Each button
/// has an icon, an action to perform when the button is pressed, and a
/// highlight state.
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
