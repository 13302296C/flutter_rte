import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';

class Fullscreen extends StatefulWidget {
  const Fullscreen({Key? key}) : super(key: key);

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  bool _withinHypothesisRegion = false;
  bool _withinEquipmentRegion = false;
  HtmlEditorController? _c;
  HtmlEditorController? _e;
  String _hypo = '<p></p>';
  String _eqpt = '<p></p>';
  @override
  void initState() {
    _c ??= HtmlEditorController();
    _e ??= HtmlEditorController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset('bgd.png').image, fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kIsWeb ? 24.0 : 8),
            child: Center(
              child: FittedBox(
                  child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey[600]!,
                      spreadRadius: 0,
                      blurRadius: 15),
                ]),
                constraints: const BoxConstraints(
                  minHeight: 1500,
                  minWidth: 1024,
                  maxWidth: 1024,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    children: [
                      // Text('Science Experiment',
                      //     style: Theme.of(context).textTheme.headline4),
                      // SizedBox(height: 48),
                      // Divider(),
                      // MouseRegion(
                      //   onEnter: (e) {
                      //     _withinHypothesisRegion = true;
                      //     if (mounted) setState(() {});
                      //   },
                      //   onExit: (e) {
                      //     _withinHypothesisRegion = false;
                      //     if (mounted) setState(() {});
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Text('Hypothesis:',
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .headline6!
                      //                     .copyWith(
                      //                         decoration:
                      //                             TextDecoration.underline)),
                      //           ],
                      //         ),
                      //         HtmlEditor(
                      //           controller: _c!,
                      //           initialValue: _hypo,
                      //           minHeight: 100,
                      //           isReadOnly: !_withinHypothesisRegion,
                      //           onChanged: (s) {
                      //             _hypo = s!;
                      //           },
                      //           htmlToolbarOptions: HtmlToolbarOptions(
                      //               backgroundColor: Colors.grey[200]),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 48),
                      const Divider(),
                      MouseRegion(
                        // onEnter: (e) {
                        //   // _withinEquipmentRegion = true;
                        //   // if (mounted) setState(() {});
                        //   _e!.enable();
                        // },
                        // onExit: (e) {
                        //   // _withinEquipmentRegion = false;
                        //   // if (mounted) setState(() {});
                        //   _e!.disable();
                        // },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Equipment and Materials Used:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline)),
                                ],
                              ),
                              HtmlEditor(
                                controller: _e!,
                                minHeight: 100,
                                isReadOnly: !_withinEquipmentRegion,
                                onChanged: (s) {
                                  _eqpt = s!;
                                },
                                // htmlEditorOptions: HtmlEditorOptions(
                                //     hint: 'Your text here ...',
                                //     initialText: _eqpt),
                                htmlToolbarOptions:
                                    HtmlToolbarOptions(defaultToolbarButtons: [
                                  const FontButtons(),
                                  const ListButtons(listStyles: false),
                                  const ColorButtons(),
                                  const ParagraphButtons(
                                      caseConverter: false,
                                      textDirection: false,
                                      decreaseIndent: kIsWeb,
                                      lineHeight: false,
                                      increaseIndent: kIsWeb),
                                  //const StyleButtons(),
                                  if (kIsWeb)
                                    const InsertButtons(
                                        picture: false,
                                        audio: false,
                                        video: false,
                                        otherFile: false),
                                  if (kDebugMode && kIsWeb)
                                    const OtherButtons(fullscreen: false),
                                ], toolbarType: ToolbarType.nativeExpandable),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // //
                      // SizedBox(height: 48),
                      // Divider(),
                      // Row(
                      //   children: [
                      //     Text('Procedure:',
                      //         style: Theme.of(context).textTheme.headline6),
                      //   ],
                      // ),
                      // HtmlEditor(
                      //   htmlToolbarOptions: HtmlToolbarOptions(
                      //       backgroundColor: Colors.grey[200]),
                      //   htmlEditorOptions: HtmlEditorOptions(
                      //       darkMode: false, hint: 'Enter text here ...'),
                      // ),
                      // //
                      // SizedBox(height: 48),
                      // Divider(),
                      // Row(
                      //   children: [
                      //     Text('Result:',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headline6!
                      //             .copyWith(color: Colors.black)),
                      //   ],
                      // ),
                      // HtmlEditor(
                      //   htmlToolbarOptions: HtmlToolbarOptions(
                      //       backgroundColor: Colors.grey[200]),
                      //   htmlEditorOptions: HtmlEditorOptions(
                      //       darkMode: false, hint: 'Enter text here ...'),
                      // ),
                      // //
                      // SizedBox(height: 48),
                      // Divider(),
                      // Row(
                      //   children: [
                      //     Text('Conclusion:',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headline6!
                      //             .copyWith(color: Colors.black)),
                      //   ],
                      // ),
                      // HtmlEditor(
                      //   htmlToolbarOptions: HtmlToolbarOptions(
                      //       backgroundColor: Colors.grey[200]),
                      //   htmlEditorOptions: HtmlEditorOptions(
                      //       darkMode: false, hint: 'Enter text here ...'),
                      // ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
