export 'dart:html';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/utils/utils.dart';

/// The HTML Editor widget itself, for web (uses IFrameElement)
class HtmlEditorWidget extends StatelessWidget {
  HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.height,
    this.minHeight,
    required this.initBC,
  })  : _viewId = getRandString(10).substring(0, 14),
        super(key: key) {
    controller.viewId = _viewId;
  }

  final HtmlEditorController controller;
  final double? height;
  final double? minHeight;
  final String _viewId;
  final BuildContext initBC;

  /// Tracks whether the editor was disabled onInit (to avoid re-disabling on reload)
  //bool alreadyDisabled = false;

  Callbacks? get callbacks => controller.callbacks;
  List<Plugins> get plugins => controller.plugins;
  HtmlEditorOptions get htmlEditorOptions => controller.htmlEditorOptions;
  OtherOptions get otherOptions => controller.otherOptions;
  HtmlToolbarOptions get htmlToolbarOptions => controller.htmlToolbarOptions;

  /// if height if fixed = return fixed height, otherwise return
  /// greatest of `minHeight` and `contentHeight`.
  double get _height =>
      otherOptions.height ??
      math.max(minHeight ?? 0,
          controller.contentHeight.value + (controller.toolbarHeight ?? 0));

  @override
  Widget build(BuildContext context) {
    //log('isReadOnly: ${controller.isReadOnly}');
    //log('toolbarHeight: ${controller.toolbarHeight}');
    if (controller.toolbarHeight == null) {
      if (controller.isReadOnly) {
        controller.toolbarHeight = 0;
        if (!controller.initialized) {
          controller.initEditor(initBC, otherOptions.height ?? _height);
        }
        log('======toolbar height = ${controller.toolbarHeight}');
      } else {
        //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //setState(mounted, this.setState, () {

        if (!controller.initialized) {
          controller.initEditor(initBC, _height - controller.toolbarHeight!);
        }
        controller.toolbarHeight = controller.isReadOnly ? 0 : 51;
        log('======toolbar height = ${controller.toolbarHeight}');
        //});
        //});
      }
    }
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          //log('controllerInited: ${controller.initialized}');
          return Container(
            height: _height + 51,
            child: Column(
              children: <Widget>[
                if (htmlToolbarOptions.toolbarPosition ==
                    ToolbarPosition.aboveEditor)
                  ToolbarWidget(
                      key: controller.toolbarKey,
                      controller: controller,
                      htmlToolbarOptions: htmlToolbarOptions,
                      callbacks: callbacks),
                Expanded(
                    child: Directionality(
                  textDirection: TextDirection.ltr,
                  child:
                      controller.initialized && controller.toolbarHeight != null
                          ? HtmlElementView(
                              viewType: _viewId,
                            )
                          : SizedBox(),
                )),
                if (htmlToolbarOptions.toolbarPosition ==
                    ToolbarPosition.belowEditor)
                  ToolbarWidget(
                      key: controller.toolbarKey,
                      controller: controller,
                      htmlToolbarOptions: htmlToolbarOptions,
                      callbacks: callbacks),
              ],
            ),
          );
        });
  }
}
