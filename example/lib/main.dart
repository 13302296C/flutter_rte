import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'embedded.dart';
import 'fullscreen.dart';

enum Demos { embedded, fullscreen }

void main() => runApp(const HtmlEditorExampleApp());

class HtmlEditorExampleApp extends StatelessWidget {
  const HtmlEditorExampleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: const HtmlEditorExample(title: 'Flutter HTML Editor Example'),
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  const HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HtmlEditorExample> createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  Demos _demo = Demos.fullscreen;
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!kIsWeb) {
            controller.clearFocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              elevation: 0,
              actions: [
                IconButton(
                    icon: const Icon(Icons.fullscreen_exit),
                    onPressed: () {
                      setState(() {
                        _demo = Demos.embedded;
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: () {
                      setState(() {
                        _demo = Demos.fullscreen;
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      if (kIsWeb) {
                        controller.reloadWeb();
                      } else {
                        controller.editorController!.reload();
                      }
                    })
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.toggleCodeView();
              },
              child: const Text(r'<\>',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            body: _demo == Demos.embedded
                ? Embedded(controller: controller)
                : const Fullscreen()));
  }
}
