import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

enum DemoType { boxed, autoHideToolbar, floatingToolbar }

class Fullscreen extends StatefulWidget {
  const Fullscreen({Key? key}) : super(key: key);

  @override
  State<Fullscreen> createState() => _FullscreenState();

  static const String example = '''
<p style="box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; color74, 74, 74); font-family: Roboto, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><br></p><p style="text-indent: 3.5em; border: none; text-align: justify;" class=" align-justify">You can build apps with Flutter using any text editor combined with Flutter’s command-line tools. However, we recommend using one of our editor plugins for an even better experience. These plugins provide you with code completion, syntax highlighting, widget editing assists, run &amp; debug support, and more.<br></p><p style="text-indent:3.5em; border: none;"><br></p><div><hr><br></div><blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul><blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul><blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul><blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul></blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul></blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul></blockquote><ul><li class=" align-left" style="text-align: left;">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></li></ul></blockquote><p style="text-indent:3.5em; border: none;"><br></p><div><hr><br></div><p style="text-indent: 3.5em; border: none; text-align: justify;" class=" align-justify">You can build apps with Flutter using any text editor combined with Flutter’s command-line tools. However, we recommend using one of our editor plugins for an even better experience. These plugins provide you with code completion, syntax highlighting, widget editing assists, run &amp; debug support, and more.<br></p><p style="box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; color: rgb(74, 74, 74); font-family: Roboto, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;" class=" align-justify">Use the following steps to add an editor plugin for VS Code, Android Studio, IntelliJ, or Emacs. If you want to use a different editor, that’s OK, skip ahead to the<span>&nbsp;</span><a href="https://docs.flutter.dev/get-started/test-drive" style="box-sizing: border-box; color: rgb(19, 137, 253); text-decoration: none; background-color: transparent;">next step: Test drive</a>.<br></p><p style="text-indent:3.5em; border: none;"><br></p>
''';
}

class _FullscreenState extends State<Fullscreen> with TickerProviderStateMixin {
  DemoType _demoType = DemoType.floatingToolbar;

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
  final List<String> _strings = List.filled(5, '');
  HtmlEditorController? _currentController;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    if (_currentController != null) {
      _controller.animateTo(1, duration: const Duration(seconds: 1));
    }

    List sections = [];
    for (var e in _sections) {
      Widget? editor;
      if (_demoType == DemoType.floatingToolbar) {
        editor = HtmlEditor(
          initialValue: _strings[_sections.indexOf(e)],
          onChanged: (s) {
            _strings[_sections.indexOf(e)] = s ?? '';
          },
          controller: _controllers[_sections.indexOf(e)]
            ..toolbarOptions?.toolbarPosition = ToolbarPosition.custom
            ..toolbarOptions?.fixedToolbar = true
            ..toolbarOptions?.toolbarDecoration = null
            ..toolbarOptions?.backgroundColor = null
            ..editorOptions?.height = null
            ..editorOptions?.decoration = null,
          callbacks: Callbacks(onFocus: () {
            setState(() {
              resetTimeout();
              _currentController = _controllers[_sections.indexOf(e)];
            });
          }, onBlur: () {
            setTimeout();
          }),
        );
      } else if (_demoType == DemoType.autoHideToolbar) {
        editor = HtmlEditor(
          initialValue: _strings[_sections.indexOf(e)],
          onChanged: (s) {
            _strings[_sections.indexOf(e)] = s ?? '';
          },
          controller: _controllers[_sections.indexOf(e)]
            ..toolbarOptions?.toolbarPosition = ToolbarPosition.aboveEditor
            ..toolbarOptions?.backgroundColor = null
            ..toolbarOptions?.toolbarDecoration = BoxDecoration(
              color: _tbBgd,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
            )
            ..editorOptions?.decoration = null
            ..editorOptions?.height = null
            ..toolbarOptions?.fixedToolbar = false,
        );
      } else if (_demoType == DemoType.boxed) {
        editor = ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: HtmlEditor(
            initialValue: _strings[_sections.indexOf(e)],
            onChanged: (s) {
              _strings[_sections.indexOf(e)] = s ?? '';
            },
            controller: _controllers[_sections.indexOf(e)]
              ..toolbarOptions?.toolbarPosition = ToolbarPosition.aboveEditor
              ..toolbarOptions?.toolbarDecoration = null
              ..toolbarOptions?.backgroundColor = _tbBgd
              ..editorOptions?.decoration = BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: _tbBgd!, width: 2))
              ..toolbarOptions?.fixedToolbar = true,
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
        floatingActionButton: ExpandableFabClass(
          distanceBetween: 112.0,
          subChildren: [
            ActionButton(
              onPressed: () => setState(() {
                _demoType = DemoType.autoHideToolbar;
              }),
              label: 'Auto-hide toolbar',
              icon: const Icon(Icons.center_focus_strong_outlined),
            ),
            ActionButton(
              onPressed: () => setState(() {
                _demoType = DemoType.floatingToolbar;
              }),
              label: 'Floating toolbar',
              icon: const Icon(Icons.blur_on_outlined),
            ),
            ActionButton(
              onPressed: () => setState(() {
                _demoType = DemoType.boxed;
              }),
              label: 'Boxed layout',
              icon: const Icon(Icons.bento),
            ),
          ],
        ),
        body: Container(
          height: kIsWeb ? null : MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset('${kIsWeb ? '' : 'assets/'}bgd.png').image,
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
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey[600]!,
                            spreadRadius: 0,
                            blurRadius: 15),
                      ]),
                      constraints: const BoxConstraints(
                        minHeight: kIsWeb ? 1500 : 700,
                        minWidth: kIsWeb ? 1024 : 400,
                        maxWidth: kIsWeb ? 1024 : 400,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
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
                            // HtmlEditor(
                            //   controller: HtmlEditorController()
                            //     ..toolbarOptions!.customButtonGroups = [
                            //       CustomButtonGroup(index: 0, buttons: [
                            //         CustomToolbarButton(
                            //             icon: Icons.save_outlined,
                            //             action: () => setState(() {}),
                            //             isSelected: false)
                            //       ])
                            //     ],
                            // ),
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
              _popupToolbox(),
            ],
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

  void setTimeout() {
    timer = Timer(const Duration(seconds: 2), () {
      _controller.reverse(from: 1).then((_) {
        _currentController = null;
        setState(() {});
      });
    });
  }
}

@immutable
class ExpandableFabClass extends StatefulWidget {
  const ExpandableFabClass({
    Key? key,
    this.isInitiallyOpen,
    required this.distanceBetween,
    required this.subChildren,
  }) : super(key: key);

  final bool? isInitiallyOpen;
  final double distanceBetween;
  final List<Widget> subChildren;

  @override
  State<ExpandableFabClass> createState() => _ExpandableFabClassState();
}

class _ExpandableFabClassState extends State<ExpandableFabClass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _expandAnimationFab;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.isInitiallyOpen ?? false;
    _animationController = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimationFab = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.subChildren.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distanceBetween,
          progress: _expandAnimationFab,
          child: widget.subChildren[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: theme.colorScheme.secondary,
          elevation: 4.0,
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}
