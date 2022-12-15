library flutter_rte;

export 'package:flutter_rte/src/widgets/toolbar_widget.dart';
export 'package:flutter_rte/src/models/callbacks.dart';
export 'package:flutter_rte/src/models/toolbar.dart';
export 'package:flutter_rte/src/models/file_upload_model.dart';
export 'package:flutter_rte/src/models/html_editor_options.dart';
export 'package:flutter_rte/src/models/html_styling_options.dart';
export 'package:flutter_rte/src/models/html_toolbar_options.dart';
export 'package:flutter_rte/src/models/custom_toolbar_buttons.dart';
//export 'package:flutter_rte/utils/plugins.dart';
export 'package:flutter_rte/src/utils/utils.dart'
    hide setState, intersperse, getRandString;

export 'package:flutter_rte/src/widgets/editor_widget.dart';
export 'package:flutter_rte/src/controllers/editor_controller.dart';

/// Defines the 3 different cases for file insertion failing
enum UploadError { unsupportedFile, exceededMaxSize, jsException }

/// Manages the notification type for a notification displayed at the bottom of
/// the editor
enum NotificationType { info, warning, success, danger, plaintext }

/// Returns the type of file inserted in `onLinkInsertInt
enum InsertFileType { image, audio, video }

/// Sets how the virtual keyboard appears on mobile devices
enum HtmlInputType { decimal, email, numeric, tel, url, text }
