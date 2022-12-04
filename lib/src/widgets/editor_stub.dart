import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

class HtmlEditorWidget extends StatelessWidget {
  const HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.height,
    this.minHeight,
    required this.initBC,
  }) : super(key: key);

  final HtmlEditorController controller;
  final double? height;
  final double? minHeight;
  final BuildContext initBC;

  @override
  Widget build(BuildContext context) {
    return Text('Platfrom not supported');
  }
}
