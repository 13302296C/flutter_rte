import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

/// Options that modify the editor and its behavior
class HtmlEditorOptions {
  HtmlEditorOptions({
    this.androidUseHybridComposition = true,
    this.adjustHeightForKeyboard = true,
    this.characterLimit,
//    this.customOptions = '',
    this.darkMode,
    this.height,
    this.minHeight,
    this.decoration,
    this.backgroundColor,
    this.backgroundDecoration,
    this.dictationPreviewDecoration,
    this.dictationPreviewTextColor,
    this.filePath,
    this.hint,
    this.hintStyle,
    this.initialText,
    this.inputType = HtmlInputType.text,
    this.mobileContextMenu,
    this.mobileLongPressDuration,
    this.mobileInitialScripts,
    this.webInitialScripts,
    this.shouldEnsureVisible = false,
    this.spellCheck = false,
  }) {
    if (backgroundColor != null && backgroundDecoration != null) {
      throw Exception(
          'Can\'t have both backgroundColor and backgroundDecoration. Please choose one.');
    }
  }

  /// The editor will automatically adjust its height when the keyboard is active
  /// to prevent the keyboard overlapping the editor.
  ///
  /// The default value is true. It is recommended to leave this as true because
  /// it significantly improves the UX.
  final bool adjustHeightForKeyboard;

  /// ALlows devs to set hybrid composition off in case they would like to
  /// prioritize animation smoothness over text input experience.
  ///
  /// The recommended value is `true`.
  final bool androidUseHybridComposition;

  /// Adds a character limit to the editor.
  ///
  /// NOTE: ONLY WORKS ON iOS AND WEB PLATFORMS!!
  final int? characterLimit;

  /// Set custom options for the summernote editor by using their syntax.
  ///
  /// Please ensure your syntax is correct (and add a comma at the end of your
  /// string!) otherwise the editor may not load.
  //final String customOptions;

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  final bool? darkMode;

  final Color? backgroundColor;
  final BoxDecoration? backgroundDecoration;

  // The BoxDecoration to use around the Html editor.
  BoxDecoration? decoration;

  /// Sets the height of the Html editor widget. This takes the toolbar into
  /// account when to toolbar is set to above or below editor and is always shown.
  ///
  /// If this value is `null` the editor's height is adjusted automatically.
  final double? height;

  /// If `height` attribute is not provided - the container will auto-adjust its
  /// height, but would not be less than `minHeight`, which defaults to 64
  /// if the value is not provided.
  final double? minHeight;

  /// Box decoration of voice-to-text popover widget
  final BoxDecoration? dictationPreviewDecoration;

  ///
  final Color? dictationPreviewTextColor;

  /// Specify the file path to your custom html editor code.
  ///
  /// Make sure to set the editor's HTML ID to be 'summernote-2'.
  ///
  /// If you plan to use this on Web, you must add comments in your HTML so the
  /// package can insert the relevant JS code to communicate between Dart and JS.
  /// See the README for more details on this.
  final String? filePath;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  String? hint;

  final TextStyle? hintStyle;

  /// The initial text that is be supplied to the Html editor.
  String? initialText;

  /// Changes the display of the virtual keyboard on mobile devices.
  ///
  /// See [HtmlInputType] for the supported modes.
  ///
  /// The default value is [HtmlInputType.text] (the standard virtual keyboard)
  final HtmlInputType inputType;

  /// Customize the context menu for selected text on mobile
  final ContextMenu? mobileContextMenu;

  /// Set the duration until a long-press is recognized.
  ///
  /// The default value is 500ms.
  final Duration? mobileLongPressDuration;

  /// Initial JS to inject into the editor.
  final UnmodifiableListView<UserScript>? mobileInitialScripts;

  /// Initial JS to add to the editor. These can be called at any time using
  /// [controller.evaluateJavascriptWeb]
  final UnmodifiableListView<WebScript>? webInitialScripts;

  /// Specifies whether the widget should scroll to reveal the HTML editor when
  /// it is focused or the text content is changed.
  /// See the README examples for the best way to implement this.
  ///
  /// Note: Your editor *must* be in a Scrollable type widget (e.g. ListView,
  /// SingleChildScrollView, etc.) for this to work. Otherwise, nothing will
  /// happen.
  final bool shouldEnsureVisible;

  /// Specify whether or not the editor should spellcheck its contents.
  ///
  /// Default value is false.
  final bool spellCheck;
}
