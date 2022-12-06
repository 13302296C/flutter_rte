library flutter_rich_text_editor;

export 'package:flutter_rich_text_editor/src/widgets/toolbar_widget.dart';
export 'package:flutter_rich_text_editor/src/models/callbacks.dart';
export 'package:flutter_rich_text_editor/src/models/toolbar.dart';
export 'package:flutter_rich_text_editor/src/models/file_upload_model.dart';
export 'package:flutter_rich_text_editor/src/models/html_editor_options.dart';
export 'package:flutter_rich_text_editor/src/models/html_toolbar_options.dart';
export 'package:flutter_rich_text_editor/src/models/custom_toolbar_buttons.dart';
//export 'package:flutter_rich_text_editor/utils/plugins.dart';
export 'package:flutter_rich_text_editor/utils/utils.dart'
    hide setState, intersperse, getRandString;

export 'package:flutter_rich_text_editor/src/widgets/editor_widget.dart';
export 'package:flutter_rich_text_editor/src/controllers/editor_controller.dart';

/// Defines the 3 different cases for file insertion failing
enum UploadError { unsupportedFile, exceededMaxSize, jsException }

/// Manages the notification type for a notification displayed at the bottom of
/// the editor
enum NotificationType { info, warning, success, danger, plaintext }

/// Returns the type of file inserted in `onLinkInsertInt
enum InsertFileType { image, audio, video }

/// Sets how the virtual keyboard appears on mobile devices
enum HtmlInputType { decimal, email, numeric, tel, url, text }
