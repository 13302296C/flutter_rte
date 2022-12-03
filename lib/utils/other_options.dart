import 'package:flutter/material.dart';

/// Other options such as the height of the widget and the decoration surrounding it
class OtherOptions {
  OtherOptions({
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border:
          Border.fromBorderSide(BorderSide(color: Color(0xffececec), width: 1)),
    ),
    this.height,
  });

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  final BoxDecoration decoration;

  /// Sets the height of the Html editor widget. This takes the toolbar into
  /// account (i.e. this sets the height of the entire widget rather than the
  /// editor space)
  ///
  /// The default value is 400. If this value is `null` the editor's height is
  /// adjusted automatically
  double? height;
}
