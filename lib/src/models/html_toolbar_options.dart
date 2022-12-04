import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/src/models/custom_toolbar_buttons.dart';

/// Options that modify the toolbar and its behavior
class HtmlToolbarOptions {
  HtmlToolbarOptions({
    // this.audioExtensions,
    this.customButtonGroups = const [],
    this.defaultToolbarButtons = const [
      VoiceToTextButtons(),
      OtherButtons(
          fullscreen: false,
          codeview: false,
          help: false,
          copy: false,
          paste: false),
      FontButtons(strikethrough: false, subscript: false, superscript: false),
      ColorButtons(),
      ParagraphButtons(
          textDirection: false, lineHeight: false, caseConverter: false),
      ListButtons(listStyles: false),
      InsertButtons(
          video: false,
          audio: false,
          table: false,
          otherFile: false,
          picture: false),
      OtherButtons(
          undo: false,
          redo: false,
          fullscreen: false,
          codeview: false,
          help: false),
    ],
    // this.otherFileExtensions,
    // this.imageExtensions,
    this.initiallyExpanded = false,
    this.linkInsertInterceptor,
    // this.mediaLinkInsertInterceptor,
    // this.mediaUploadInterceptor,
    this.onButtonPressed,
    this.onDropdownChanged,
    // this.onOtherFileLinkInsert,
    // this.onOtherFileUpload,
    this.toolbarType = ToolbarType.nativeScrollable,
    this.toolbarPosition = ToolbarPosition.aboveEditor,
    // this.videoExtensions,
    this.dropdownElevation = 8,
    this.dropdownIcon,
    this.dropdownIconColor,
    this.dropdownIconSize = 24,
    this.dropdownItemHeight = kMinInteractiveDimension,
    this.dropdownFocusColor,
    this.dropdownBackgroundColor,
    this.dropdownMenuDirection,
    this.dropdownMenuMaxHeight,
    this.dropdownBoxDecoration,
    this.toolbarDecoration,
    this.backgroundColor,
    this.buttonColor,
    this.buttonSelectedColor,
    this.buttonFillColor,
    this.buttonFocusColor,
    this.buttonHighlightColor,
    this.buttonHoverColor,
    this.buttonSplashColor,
    this.buttonBorderColor,
    this.buttonSelectedBorderColor,
    this.buttonBorderRadius,
    this.buttonBorderWidth,
    this.renderBorder = false,
    this.textStyle,
    this.separatorWidget =
        const VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey),
    this.renderSeparatorWidget = true,
    this.toolbarItemHeight = 36,
    this.gridViewHorizontalSpacing = 5,
    this.gridViewVerticalSpacing = 5,
  });

  /// Allows you to set the allowed extensions when a user inserts an audio file
  ///
  /// By default any audio extension is allowed.
  // final List<String>? audioExtensions;

  /// Adds custom groups of buttons to the toolbar
  final List<CustomButtonGroup> customButtonGroups;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> defaultToolbarButtons;

  /// Allows you to set the allowed extensions when a user inserts an image
  ///
  /// By default any image extension is allowed.
  // final List<String>? imageExtensions;

  /// Allows you to set whether the toolbar starts out expanded (in gridview)
  /// or contracted (in scrollview).
  ///
  /// By default it starts out contracted.
  ///
  /// This option only works when you have set [toolbarType] to
  /// [ToolbarType.nativeExpandable].
  final bool initiallyExpanded;

  /// Allows you to intercept any links being inserted into the editor. The
  /// function passes the display text, the URL itself, and whether the
  /// URL should open a new tab.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(String, String, bool)? linkInsertInterceptor;

  /// Allows you to intercept any image/video/audio inserted as a link into the editor.
  /// The function passes the URL of the media inserted.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  // final FutureOr<bool> Function(String, InsertFileType)?
  //     mediaLinkInsertInterceptor;

  /// Allows you to intercept any image/video/audio files being inserted into the editor.
  /// The function passes the PlatformFile class, which contains all the file data
  /// including name, size, type, Uint8List bytes, etc.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video/audio upload by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  //final FutureOr<bool> Function(PlatformFile, InsertFileType)?
  //    mediaUploadInterceptor;

  /// Allows you to intercept any button press. The function passes the ButtonType
  /// enum, which tells you which button was pressed, the current selected status of
  /// the button, and a function to reverse the status (in case you decide to handle
  /// the button press yourself).
  ///
  /// Note: In some cases, the button is never active (e.g. copy/paste buttons)
  /// so null will be returned for both the selected status and the function.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the button press by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(ButtonType, bool?, Function?)? onButtonPressed;

  /// Allows you to intercept any dropdown changes. The function passes the
  /// DropdownType enum, which tells you which dropdown was changed,
  /// the changed value to indicate what the dropdown was changed to, and the
  /// function to update the changed value (in case you decide to handle the
  /// dropdown change yourself). The function is null in some cases because
  /// the dropdown does not update its value.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the dropdown change by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(DropdownType, dynamic, void Function(dynamic)?)?
      onDropdownChanged;

  /// Called when a link is inserted for a file using the "other file" button.
  ///
  /// The package does not have a built in handler for these files, so you should
  /// provide this callback when using the button.
  ///
  /// The function passes the URL of the file inserted.
  //final void Function(String)? onOtherFileLinkInsert;

  /// Called when a file is uploaded using the "other file" button.
  ///
  /// The package does not have a built in handler for these files, so if you use
  /// the button you should provide this callback.
  ///
  /// The function passes the PlatformFile class, which contains all the file data
  /// including name, size, type, Uint8List bytes, etc.
  //final void Function(PlatformFile)? onOtherFileUpload;

  /// Allows you to set the allowed extensions when a user inserts a file other
  /// than image/audio/video
  ///
  /// By default any other extension is allowed.
  //final List<String>? otherFileExtensions;

  /// Controls how the toolbar displays. See [ToolbarType] for more details.
  ///
  /// By default the toolbar is rendered as a scrollable one-line list.
  ToolbarType toolbarType;

  /// Controls where the toolbar is positioned. See [ToolbarPosition] for more details.
  ///
  /// By default the toolbar is above the editor.
  ToolbarPosition toolbarPosition;

  /// If `true`, the toolbar will always be visible when the toolbar is set to
  /// above or below editor. If `false` it will collapse on blur.
  bool fixedToolbar = true;

  /// Delay before the toolbar becomes hidden.
  final Duration collapseDelay = Duration(seconds: 1);

  /// Allows you to set the allowed extensions when a user inserts a video.
  ///
  /// By default any video extension is allowed.
  //final List<String>? videoExtensions;

  /// Styling options for the toolbar:

  /// Determines whether a border is rendered around all toolbar widgets
  ///
  /// The default value is false. True is recommended for [ToolbarType.nativeGrid].
  final bool renderBorder;

  /// Sets the text style for all toolbar widgets
  final TextStyle? textStyle;

  /// Sets the separator widget between toolbar sections. This widget is only
  /// used in [ToolbarType.nativeScrollable].
  ///
  /// The default widget is [VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey)]
  final Widget separatorWidget;

  /// Determines whether the separator widget is rendered
  ///
  /// The default value is true
  final bool renderSeparatorWidget;

  /// Sets the height of the toolbar items
  ///
  /// Button width is affected by this parameter, however dropdown widths are
  /// not affected. The plugin will maintain a square shape for all buttons.
  ///
  /// The default value is 36
  final double toolbarItemHeight;

  /// Sets the vertical spacing between rows when using [ToolbarType.nativeGrid]
  ///
  /// The default value is 5
  final double gridViewVerticalSpacing;

  /// Sets the horizontal spacing between items when using [ToolbarType.nativeGrid]
  ///
  /// The default value is 5
  final double gridViewHorizontalSpacing;

  /// Styling options that only apply to dropdowns:
  /// (See the [DropdownButton] class for more information)

  final int dropdownElevation;
  final Widget? dropdownIcon;
  final Color? dropdownIconColor;
  final double dropdownIconSize;
  final double dropdownItemHeight;
  final Color? dropdownFocusColor;
  final Color? dropdownBackgroundColor;
  Color? backgroundColor;

  /// Set the menu opening direction for the dropdown. Only useful when using
  /// [ToolbarPosition.custom] since the toolbar otherwise automatically
  /// determines the correct direction.
  final DropdownMenuDirection? dropdownMenuDirection;
  final double? dropdownMenuMaxHeight;
  final BoxDecoration? dropdownBoxDecoration;

  /// Defines decoration of toolbar container
  BoxDecoration? toolbarDecoration;

  /// Styling options that only apply to the buttons:
  /// (See the [ToggleButtons] class for more information)

  final Color? buttonColor;
  final Color? buttonSelectedColor;
  final Color? buttonFillColor;
  final Color? buttonFocusColor;
  final Color? buttonHighlightColor;
  final Color? buttonHoverColor;
  final Color? buttonSplashColor;
  final Color? buttonBorderColor;
  final Color? buttonSelectedBorderColor;
  final BorderRadius? buttonBorderRadius;
  final double? buttonBorderWidth;
}
