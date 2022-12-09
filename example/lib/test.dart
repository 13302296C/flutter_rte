import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final c = HtmlEditorController(
      toolbarOptions: HtmlToolbarOptions(
          backgroundColor: Colors.blueGrey[100],
          initiallyExpanded: false,
          toolbarType: ToolbarType.nativeExpandable),
      editorOptions: HtmlEditorOptions(
        backgroundDecoration: BoxDecoration(color: Colors.green[100]),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: SafeArea(
          child: HtmlEditor(
        expandFullHeight: true,
        controller: c,
      )),
    );
  }
}
