library flutter_rich_text_editor;

export 'package:flutter_rich_text_editor/src/widgets/toolbar_widget.dart';
export 'package:flutter_rich_text_editor/src/models/callbacks.dart';
export 'package:flutter_rich_text_editor/src/models/toolbar.dart';
export 'package:flutter_rich_text_editor/src/models/file_upload_model.dart';
export 'package:flutter_rich_text_editor/src/models/html_editor_options.dart';
export 'package:flutter_rich_text_editor/src/models/html_toolbar_options.dart';
export 'package:flutter_rich_text_editor/src/models/custom_toolbar_buttons.dart';
export 'package:flutter_rich_text_editor/utils/plugins.dart';
export 'package:flutter_rich_text_editor/utils/utils.dart'
    hide setState, intersperse, getRandString;

export 'package:flutter_rich_text_editor/src/editor.dart';
export 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

export 'package:flutter_rich_text_editor/utils/shims/flutter_inappwebview_fake.dart'
    if (dart.library.io) 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Defines the 3 different cases for file insertion failing
enum UploadError { unsupportedFile, exceededMaxSize, jsException }

/// Manages the notification type for a notification displayed at the bottom of
/// the editor
enum NotificationType { info, warning, success, danger, plaintext }

/// Manages the way the toolbar displays:
/// [nativeGrid] - a grid view (non scrollable) of all the buttons
/// [nativeScrollable] - a scrollable one-line view of all the buttons
/// [nativeExpandable] - has an icon to switch between grid and scrollable formats
/// on the fly
enum ToolbarType { nativeGrid, nativeScrollable, nativeExpandable }

/// Manages the position of the toolbar, whether above or below the editor
/// [custom] - removes the toolbar. This is useful when you want to implement the
/// toolbar in a custom location using [ToolbarWidget]
enum ToolbarPosition { aboveEditor, belowEditor, custom }

/// Returns the type of button pressed in the `onButtonPressed` function
enum ButtonType {
  style,
  bold,
  italic,
  underline,
  clearFormatting,
  strikethrough,
  superscript,
  subscript,
  foregroundColor,
  highlightColor,
  ul,
  ol,
  alignLeft,
  alignCenter,
  alignRight,
  alignJustify,
  increaseIndent,
  decreaseIndent,
  ltr,
  rtl,
  link,
  picture,
  audio,
  video,
  otherFile,
  table,
  hr,
  fullscreen,
  codeview,
  undo,
  redo,
  help,
  copy,
  paste
}

/// Returns the type of dropdown changed in the `onDropdownChanged` function
enum DropdownType {
  style,
  fontName,
  fontSize,
  fontSizeUnit,
  listStyles,
  lineHeight,
  caseConverter
}

/// Sets the direction the dropdown menu opens
enum DropdownMenuDirection { down, up }

/// Returns the type of file inserted in `onLinkInsertInt
enum InsertFileType { image, audio, video }

/// Sets how the virtual keyboard appears on mobile devices
enum HtmlInputType { decimal, email, numeric, tel, url, text }
