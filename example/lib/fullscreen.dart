import 'dart:async';
import 'package:example/expandable_fab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

enum DemoType { boxed, floatingToolbar, fullscreen }

final List<String> strings = List.filled(5, '');

class Fullscreen extends StatefulWidget {
  const Fullscreen({Key? key, this.demoType}) : super(key: key);

  final DemoType? demoType;

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> with TickerProviderStateMixin {
  late DemoType _demoType;

  final List<String> _sections = [
    'Hypothesis',
    'Equipment and Materials Used',
    'Procedure',
    'Results',
    'Conclusion'
  ];

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  final Color? _tbBgd = Colors.blueGrey[50];
  final List<HtmlEditorController> _controllers = [];
  HtmlEditorController? _currentController;

  @override
  void initState() {
    _demoType = widget.demoType ?? DemoType.floatingToolbar;
    // ignore: unused_local_variable
    for (var s in _sections) {
      _controllers.add(HtmlEditorController(
        toolbarOptions: HtmlToolbarOptions(
            toolbarType: ToolbarType.nativeScrollable,
            backgroundColor: _tbBgd!,
            toolbarPosition: ToolbarPosition.custom),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentController != null) {
      _controller.animateTo(1, duration: const Duration(seconds: 1));
    }

    List sections = [];
    for (var e in _sections) {
      Widget? editor;
      if (_demoType == DemoType.floatingToolbar ||
          _demoType == DemoType.fullscreen) {
        editor = HtmlEditor(
          initialValue: strings[_sections.indexOf(e)],
          onChanged: (s) {
            strings[_sections.indexOf(e)] = s ?? '';
          },
          controller: _controllers[_sections.indexOf(e)]
            ..toolbarOptions?.toolbarPosition = ToolbarPosition.custom,
          callbacks: Callbacks(onFocus: () {
            setState(() {
              resetTimeout();
              _currentController = _controllers[_sections.indexOf(e)];
            });
          }, onBlur: () {
            setTimeout();
          }),
        );
      } else if (_demoType == DemoType.boxed) {
        editor = ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: HtmlEditor(
            initialValue: strings[_sections.indexOf(e)],
            onChanged: (s) {
              strings[_sections.indexOf(e)] = s ?? '';
            },
            controller: _controllers[_sections.indexOf(e)]
              ..toolbarOptions?.toolbarPosition = ToolbarPosition.aboveEditor
              ..toolbarOptions?.backgroundColor = _tbBgd
              ..editorOptions?.decoration = BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: _tbBgd!, width: 2)),
            height: 250,
          ),
        );
      }
      sections.addAll([
        const SizedBox(height: 8),
        Row(
          children: [
            Text('$e:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        editor,
        const SizedBox(height: 24),
        const Divider(height: 2, thickness: 2),
        const SizedBox(height: 8),
      ]);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter HTML Editor Example'),
          elevation: 0,
          bottom: _demoType == DemoType.fullscreen
              ? PreferredSize(
                  preferredSize: Size(
                      kIsWeb ? 900 : MediaQuery.of(context).size.width, 60),
                  child: _currentController != null
                      ? ToolbarWidget(controller: _currentController!)
                      : const SizedBox())
              : null,
        ),
        floatingActionButton: ExpandableFabClass(
          distanceBetween: 112.0,
          subChildren: [
            // ActionButton(
            //   onPressed: () => setState(() {
            //     _demoType = DemoType.autoHideToolbar;
            //   }),
            //   label: 'Auto-hide toolbar',
            //   icon: const Icon(Icons.center_focus_strong_outlined),
            // ),
            ActionButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const Fullscreen(demoType: DemoType.floatingToolbar),
              )),
              label: 'Floating toolbar',
              icon: const Icon(Icons.blur_on_outlined),
            ),
            ActionButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const Fullscreen(demoType: DemoType.boxed),
              )),
              label: 'Boxed layout',
              icon: const Icon(Icons.bento),
            ),
            ActionButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const Fullscreen(demoType: DemoType.fullscreen),
              )),
              label: 'Fullscreen',
              icon: const Icon(Icons.fullscreen),
            ),
          ],
        ),
        body: Container(
          width: kIsWeb ? null : MediaQuery.of(context).size.width,
          height: kIsWeb ? null : MediaQuery.of(context).size.height,
          decoration: _demoType == DemoType.fullscreen
              ? null
              : BoxDecoration(
                  image: DecorationImage(
                      image: Image.asset('${kIsWeb ? '' : 'assets/'}bgd.png')
                          .image,
                      fit: BoxFit.fill),
                ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: kIsWeb
                      ? const EdgeInsets.fromLTRB(16, 32, 16, 16)
                      : const EdgeInsets.all(8),
                  child: Center(
                    child: FittedBox(
                        child: Container(
                      decoration: BoxDecoration(
                          color: _demoType == DemoType.fullscreen
                              ? null
                              : Colors.white,
                          boxShadow: _demoType == DemoType.fullscreen
                              ? null
                              : [
                                  BoxShadow(
                                      color: Colors.grey[600]!,
                                      spreadRadius: 0,
                                      blurRadius: 15),
                                ]),
                      constraints: const BoxConstraints(
                        minHeight: kIsWeb ? 1500 : 800,
                        minWidth: kIsWeb ? 1024 : 500,
                        maxWidth: kIsWeb ? 1024 : 500,
                      ),
                      child: Padding(
                        padding: _demoType == DemoType.fullscreen
                            ? EdgeInsets.zero
                            : const EdgeInsets.symmetric(
                                horizontal: kIsWeb ? 96.0 : 16,
                                vertical: kIsWeb ? 96.0 : 16),
                        child: Column(
                          children: [
                            Text('Science Experiment',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 32),
                            Row(
                              children: const [
                                Expanded(
                                    child: TextField(
                                  decoration: InputDecoration(hintText: 'Name'),
                                )),
                                VerticalDivider(width: 16),
                                Expanded(
                                    child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Department'),
                                )),
                                VerticalDivider(width: 16),
                                Expanded(
                                    child: TextField(
                                  decoration: InputDecoration(hintText: 'Date'),
                                )),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Divider(height: 2, thickness: 2),
                            ...sections,
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ),
              if (_demoType == DemoType.floatingToolbar) _popupToolbox(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _popupToolbox() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: _currentController == null
          ? const SizedBox()
          : ScaleTransition(
              scale: _animation,
              child: FadeTransition(
                opacity: _animation,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    decoration: BoxDecoration(
                      color: _tbBgd,
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      boxShadow: const [
                        BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 10,
                            color: Colors.black38)
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AnimatedBuilder(
                            animation: _currentController!,
                            builder: (context, _) {
                              return ToolbarWidget(
                                  controller: _currentController!);
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Timer? timer;

  ///
  void resetTimeout() {
    timer?.cancel();
    timer = null;
  }

  ///
  void setTimeout() {
    timer = Timer(const Duration(seconds: 5), () {
      _controller.reverse(from: 1).then((_) {
        _currentController = null;
        if (mounted) setState(() {});
      });
    });
  }
}
