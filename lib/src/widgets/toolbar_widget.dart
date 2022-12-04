import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rich_text_editor/flutter_rich_text_editor.dart';
import 'package:flutter_rich_text_editor/src/models/custom_toolbar_buttons.dart';
import 'package:flutter_rich_text_editor/src/models/editor_settings.dart';
import 'package:flutter_rich_text_editor/src/widgets/custom_dropdown_button.dart';
import 'package:flutter_rich_text_editor/utils/utils.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'toolbar_expand_icon.dart';

// extensions
part 'toolbar_extensions/color_buttons.dart';
part 'toolbar_extensions/custom_buttons.dart';
part 'toolbar_extensions/dictation_buttons.dart';
part 'toolbar_extensions/font_buttons.dart';
part 'toolbar_extensions/font_settings_buttons.dart';
part 'toolbar_extensions/media_buttons.dart';
part 'toolbar_extensions/list_buttons.dart';
part 'toolbar_extensions/other_buttons.dart';
part 'toolbar_extensions/paragraph_buttons.dart';
part 'toolbar_extensions/style_buttons.dart';

/// Toolbar widget class
class ToolbarWidget extends StatefulWidget {
  /// The [HtmlEditorController] is mainly used to call the [execCommand] method
  final HtmlEditorController controller;
  HtmlToolbarOptions get toolbarOptions => controller.toolbarOptions!;
  Callbacks? get callbacks => controller.callbacks;

  const ToolbarWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToolbarWidgetState();
  }
}

/// Toolbar widget state
class ToolbarWidgetState extends State<ToolbarWidget> {
  /// List that controls which [ToggleButtons] are selected for
  /// bold/italic/underline/clear styles
  List<bool> _fontSelected = List<bool>.filled(4, false);

  /// List that controls which [ToggleButtons] are selected for
  /// strikthrough/superscript/subscript
  List<bool> _miscFontSelected = List<bool>.filled(3, false);

  /// List that controls which [ToggleButtons] are selected for
  /// forecolor/backcolor
  List<bool> _colorSelected = List<bool>.filled(2, false);

  /// List that controls which [ToggleButtons] are selected for
  /// ordered/unordered list
  List<bool> _listSelected = List<bool>.filled(2, false);

  List<bool> _insertSelected = List<bool>.filled(7, false);

  /// List that controls which [ToggleButtons] are selected for
  /// fullscreen, codeview, undo, redo, and help. Fullscreen and codeview
  /// are the only buttons that will ever be selected.
  List<bool> _miscSelected = List<bool>.filled(7, false);

  /// List that controls which [ToggleButtons] are selected for
  /// justify left/right/center/full.
  List<bool> _alignSelected = List<bool>.filled(4, false);

  List<bool> _textDirectionSelected = List<bool>.filled(2, false);

  /// Sets the selected item for the font style dropdown
  String _fontSelectedItem = 'p';

  String _fontNameSelectedItem = 'sans-serif';

  /// Sets the selected item for the font size dropdown
  double _fontSizeSelectedItem = 3;

  /// Keeps track of the current font size in px
  // ignore: prefer_final_fields
  double _actualFontSizeSelectedItem = 16;

  /// Sets the selected item for the font units dropdown
  // ignore: prefer_final_fields
  String _fontSizeUnitSelectedItem = 'pt';

  /// Sets the selected item for the foreground color dialog
  Color _foreColorSelected = Colors.black;

  /// to #2b2b2b on JS side
  final Color _preferredBodyColor =
      Colors.black; // Color.fromRGBO(0x2b, 0x2b, 0x2b, 1);

  /// Sets the selected item for the background color dialog
  Color _backColorSelected = Colors.yellow;

  /// Sets the selected item for the list style dropdown
  String? _listStyleSelectedItem;

  /// Sets the selected item for the line height dropdown
  double _lineHeightSelectedItem = 1;

  /// Masks the toolbar with a grey color if false
  bool _enabled = true;

  /// Tracks the expanded status of the toolbar
  bool _isExpanded = false;

  @override
  void initState() {
    widget.controller.toolbar = this;
    _isExpanded = widget.toolbarOptions.initiallyExpanded;
    for (var t in widget.toolbarOptions.defaultToolbarButtons) {
      if (t is FontButtons) {
        _fontSelected = List<bool>.filled(t.getIcons1().length, false);
        _miscFontSelected = List<bool>.filled(t.getIcons2().length, false);
      }
      if (t is ColorButtons) {
        _colorSelected = List<bool>.filled(t.getIcons().length, false);
      }
      if (t is ListButtons) {
        _listSelected = List<bool>.filled(t.getIcons().length, false);
      }
      if (t is InsertButtons) {
        _insertSelected = List<bool>.filled(t.getIcons().length, false);
      }
      if (t is OtherButtons) {
        _miscSelected = List<bool>.filled(
            t.getIcons1().length + t.getIcons2().length, false);
      }
      if (t is ParagraphButtons) {
        _alignSelected = List<bool>.filled(t.getIcons1().length, false);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.toolbarHeight = context.size?.height ?? 0;
    });
    super.initState();
  }

  void disable() {
    setState(mounted, this.setState, () {
      _enabled = false;
    });
  }

  void enable() {
    setState(mounted, this.setState, () {
      _enabled = true;
    });
  }

  /// Updates the toolbar from the JS handler on mobile and the onMessage
  /// listener on web
  void updateToolbar(Map<String, dynamic> json) {
    //get parent element
    String parentElem = json['style'] ?? '';
    //get font name
    var fontName = (json['fontName'] ?? '').toString().replaceAll('"', '');
    //get font size
    var fontSize = double.tryParse(json['fontSize']) ?? 3;
    //get bold/underline/italic status
    var fontList = (json['font'] as List<dynamic>).cast<bool?>();
    //get superscript/subscript/strikethrough status
    var miscFontList = (json['miscFont'] as List<dynamic>).cast<bool?>();
    //get forecolor/backcolor
    var colorList = (json['color'] as List<dynamic>).cast<String?>();
    //get ordered/unordered list status
    var paragraphList = (json['paragraph'] as List<dynamic>).cast<bool?>();
    //get justify status
    var alignList = (json['align'] as List<dynamic>).cast<bool?>();

    bool isLink = json['link'];

    //get line height
    String lineHeight = json['lineHeight'] ?? '';
    //get list icon type
    String listType = json['listStyle'] ?? '';
    //get text direction
    String textDir = json['direction'] ?? 'ltr';
    //check the parent element if it matches one of the predetermined styles and update the toolbar
    if (['pre', 'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']
        .contains(parentElem)) {
      setState(mounted, this.setState, () {
        _fontSelectedItem = parentElem;
      });
    } else {
      setState(mounted, this.setState, () {
        _fontSelectedItem = 'p';
      });
    }
    //check the font name if it matches one of the predetermined fonts and update the toolbar
    if (['Courier New', 'sans-serif', 'Times New Roman'].contains(fontName)) {
      setState(mounted, this.setState, () {
        _fontNameSelectedItem = fontName;
      });
    } else {
      setState(mounted, this.setState, () {
        _fontNameSelectedItem = 'sans-serif';
      });
    }
    //update the fore/back selected color if necessary
    if (colorList[0] != null && colorList[0]!.isNotEmpty) {
      setState(mounted, this.setState, () {
        var rgb = colorList[0]!.replaceAll('rgb(', '').replaceAll(')', '');
        var rgbList = rgb.split(', ');
        _foreColorSelected = Color.fromRGBO(int.parse(rgbList[0]),
            int.parse(rgbList[1]), int.parse(rgbList[2]), 1);
        if (_foreColorSelected != _preferredBodyColor) {
          _colorSelected[0] = true;
        } else {
          _colorSelected[0] = false;
        }
      });
    } else {
      setState(mounted, this.setState, () {
        _foreColorSelected = _preferredBodyColor;
      });
    }
    if (colorList[1] != null && colorList[1]!.isNotEmpty) {
      setState(mounted, this.setState, () {
        if (colorList[1]!.contains('rgba(')) {
          if (colorList[1]! == 'rgba(0, 0, 0, 0)') {
            _colorSelected[1] = false;
          } else {
            _colorSelected[1] = true;
          }
          var rgba = colorList[1]!
              .replaceAll('rgba(', '')
              .replaceAll(' ', '')
              .replaceAll(')', '');
          var rgbaList = rgba.split(',');
          try {
            _backColorSelected = Color.fromARGB(
                double.parse(rgbaList[3] * 255).round(),
                int.parse(rgbaList[0]),
                int.parse(rgbaList[1]),
                int.parse(rgbaList[2]));
          } catch (e) {
            _backColorSelected = Color.fromARGB(0, 0, 0, 0);
          }
        } else if (colorList[1]!.contains('rgb(')) {
          _colorSelected[1] = true;
          var rgb = colorList[1]!.replaceAll('rgb(', '').replaceAll(')', '');
          var rgbList = rgb.split(', ');
          _foreColorSelected = Color.fromRGBO(int.parse(rgbList[1]),
              int.parse(rgbList[1]), int.parse(rgbList[2]), 1);
        } else {
          _backColorSelected =
              Color(int.parse(colorList[1]!, radix: 16) + 0xFF000000);
        }
      });
    } else {
      setState(mounted, this.setState, () {
        _backColorSelected = Colors.yellow;
      });
    }
    //check the list style if it matches one of the predetermined styles and update the toolbar
    if ([
      'decimal',
      'lower-alpha',
      'upper-alpha',
      'lower-roman',
      'upper-roman',
      'disc',
      'circle',
      'square'
    ].contains(listType)) {
      setState(mounted, this.setState, () {
        _listStyleSelectedItem = listType;
      });
    } else {
      _listStyleSelectedItem = null;
    }
    //update the lineheight selected item if necessary
    if (lineHeight.isNotEmpty && lineHeight.endsWith('px')) {
      var lineHeightDouble =
          double.tryParse(lineHeight.replaceAll('px', '')) ?? 16;
      var lineHeights = <double>[1, 1.2, 1.4, 1.5, 1.6, 1.8, 2, 3];
      lineHeights =
          lineHeights.map((e) => e * _actualFontSizeSelectedItem).toList();
      if (lineHeights.contains(lineHeightDouble)) {
        setState(mounted, this.setState, () {
          _lineHeightSelectedItem =
              lineHeightDouble / _actualFontSizeSelectedItem;
        });
      }
    } else if (lineHeight == 'normal') {
      setState(mounted, this.setState, () {
        _lineHeightSelectedItem = 1.0;
      });
    }
    //check if the font size matches one of the predetermined sizes and update the toolbar
    if ([1, 2, 3, 4, 5, 6, 7].contains(fontSize)) {
      setState(mounted, this.setState, () {
        _fontSizeSelectedItem = fontSize;
      });
    }
    if (textDir == 'ltr') {
      setState(mounted, this.setState, () {
        _textDirectionSelected = [true, false];
      });
    } else if (textDir == 'rtl') {
      setState(mounted, this.setState, () {
        _textDirectionSelected = [false, true];
      });
    }
    //use the remaining bool lists to update the selected items accordingly
    setState(mounted, this.setState, () {
      for (var t in widget.toolbarOptions.defaultToolbarButtons) {
        if (t is FontButtons) {
          for (var i = 0; i < _fontSelected.length; i++) {
            if (t.getIcons1()[i].icon == Icons.format_bold) {
              _fontSelected[i] = fontList[0] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_italic) {
              _fontSelected[i] = fontList[1] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_underline) {
              _fontSelected[i] = fontList[2] ?? false;
            }
          }
          for (var i = 0; i < _miscFontSelected.length; i++) {
            if (t.getIcons2()[i].icon == Icons.format_strikethrough) {
              _miscFontSelected[i] = miscFontList[0] ?? false;
            }
            if (t.getIcons2()[i].icon == Icons.superscript) {
              _miscFontSelected[i] = miscFontList[1] ?? false;
            }
            if (t.getIcons2()[i].icon == Icons.subscript) {
              _miscFontSelected[i] = miscFontList[2] ?? false;
            }
          }
        }
        if (t is ListButtons) {
          for (var i = 0; i < _listSelected.length; i++) {
            if (t.getIcons()[i].icon == Icons.format_list_bulleted) {
              _listSelected[i] = paragraphList[0] ?? false;
            }
            if (t.getIcons()[i].icon == Icons.format_list_numbered) {
              _listSelected[i] = paragraphList[1] ?? false;
            }
          }
        }
        if (t is ParagraphButtons) {
          for (var i = 0; i < _alignSelected.length; i++) {
            if (t.getIcons1()[i].icon == Icons.format_align_left) {
              _alignSelected[i] = alignList[0] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_center) {
              _alignSelected[i] = alignList[1] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_right) {
              _alignSelected[i] = alignList[2] ?? false;
            }
            if (t.getIcons1()[i].icon == Icons.format_align_justify) {
              _alignSelected[i] = alignList[3] ?? false;
            }
          }
        }
        if (t is InsertButtons) {
          for (var i = 0; i < _insertSelected.length; i++) {
            if (t.getIcons()[i].icon == Icons.link) {
              _insertSelected[i] = isLink;
            }
          }
        }
      }
    });
    if (widget.callbacks?.onChangeSelection != null) {
      widget.callbacks!.onChangeSelection!.call(EditorSettings(
          parentElement: parentElem,
          fontName: fontName,
          fontSize: fontSize,
          isBold: fontList[0] ?? false,
          isItalic: fontList[1] ?? false,
          isUnderline: fontList[2] ?? false,
          isStrikethrough: miscFontList[0] ?? false,
          isSuperscript: miscFontList[1] ?? false,
          isSubscript: miscFontList[2] ?? false,
          foregroundColor: _foreColorSelected,
          backgroundColor: _backColorSelected,
          isUl: paragraphList[0] ?? false,
          isOl: paragraphList[1] ?? false,
          isLink: isLink,
          isAlignLeft: alignList[0] ?? false,
          isAlignCenter: alignList[1] ?? false,
          isAlignRight: alignList[2] ?? false,
          isAlignJustify: alignList[3] ?? false,
          lineHeight: _lineHeightSelectedItem,
          textDirection:
              textDir == 'rtl' ? TextDirection.rtl : TextDirection.ltr));
    }
  }

  /// Wraps every type of toolbar
  Widget _toolbarWrapper({required Widget child}) {
    return Container(
      color: widget.toolbarOptions.backgroundColor,
      decoration: widget.toolbarOptions.toolbarDecoration,
      child: PointerInterceptor(
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: _enabled &&
                      widget.controller.toolbarOptions!.toolbarPosition ==
                          ToolbarPosition.custom ||
                  (_enabled &&
                      widget.controller.toolbarOptions!.fixedToolbar &&
                      (widget.controller.toolbarOptions!.toolbarPosition !=
                          ToolbarPosition.custom)) ||
                  (_enabled &&
                      widget.controller.toolbarOptions!.toolbarPosition !=
                          ToolbarPosition.custom &&
                      !widget.controller.toolbarOptions!.fixedToolbar)
              ? child
              : SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.toolbarOptions.toolbarType == ToolbarType.nativeGrid) {
      return _toolbarWrapper(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Wrap(
            runSpacing: widget.toolbarOptions.gridViewVerticalSpacing,
            spacing: widget.toolbarOptions.gridViewHorizontalSpacing,
            children: _buildChildren(),
          ),
        ),
      );
    } else if (widget.toolbarOptions.toolbarType ==
        ToolbarType.nativeScrollable) {
      return _toolbarWrapper(
        child: Container(
          height: widget.toolbarOptions.toolbarItemHeight + 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildChildren(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.toolbarOptions.toolbarType ==
        ToolbarType.nativeExpandable) {
      return _toolbarWrapper(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: _isExpanded
                ? MediaQuery.of(context).size.height
                : widget.toolbarOptions.toolbarItemHeight + 15,
          ),
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 8.0),
                  child: Wrap(
                    runSpacing: widget.toolbarOptions.gridViewVerticalSpacing,
                    spacing: widget.toolbarOptions.gridViewHorizontalSpacing,
                    children: _buildChildren()
                      ..insert(
                          0,
                          Container(
                            height: widget.toolbarOptions.toolbarItemHeight,
                            child: IconButton(
                              icon: Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                setState(mounted, this.setState, () {
                                  _isExpanded = !_isExpanded;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    widget.controller.toolbarHeight =
                                        context.size!.height;
                                  });
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 100));
                                if (kIsWeb) {
                                  await widget.controller.recalculateHeight();
                                } else {
                                  await widget.controller.editorController!
                                      .evaluateJavascript(
                                          source:
                                              "var height = \$('div.note-editable').outerHeight(true); window.flutter_inappwebview.callHandler('setHeight', height);");
                                }
                              },
                            ),
                          )),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ExpandIconDelegate(
                            widget.toolbarOptions.toolbarItemHeight,
                            _isExpanded, () async {
                          setState(mounted, this.setState, () {
                            _isExpanded = !_isExpanded;
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              widget.controller.toolbarHeight =
                                  context.size!.height;
                            });
                          });
                          await Future.delayed(Duration(milliseconds: 100));
                          if (kIsWeb) {
                            await widget.controller.recalculateHeight();
                          } else {
                            await widget.controller.editorController!
                                .evaluateJavascript(
                                    source:
                                        "var height = \$('div.note-editable').outerHeight(true); window.flutter_inappwebview.callHandler('setHeight', height);");
                          }
                        }),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _buildChildren(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }
    return SizedBox();
  }

  ///
  List<Widget> _buildChildren() {
    var toolbarChildren = <Widget>[];
    for (var t in widget.toolbarOptions.defaultToolbarButtons) {
      if (t is VoiceToTextButtons) {
        toolbarChildren.add(_dictationButtons(t));
      }
      if (t is StyleButtons && t.style) {
        toolbarChildren.add(_styleButtons(t));
      }
      if (t is FontSettingButtons) {
        if (t.fontName) {
          toolbarChildren.add(_fontName(t));
        }
        if (t.fontSize) {
          toolbarChildren.add(_fontSize(t));
        }
        if (t.fontSizeUnit) {
          toolbarChildren.add(_fontSizeUnit(t));
        }
      }
      if (t is FontButtons) {
        if (t.bold || t.italic || t.underline || t.clearAll) {
          toolbarChildren.add(_boldItalic(t));
        }
        if (t.strikethrough || t.superscript || t.subscript) {
          toolbarChildren.add(_strikeThrough(t));
        }
      }
      if (t is ColorButtons && (t.foregroundColor || t.highlightColor)) {
        toolbarChildren.add(_colorButtons(t));
      }
      if (t is ListButtons) {
        if (t.ul || t.ol) {
          toolbarChildren.add(_ulOl(t));
        }
        if (t.listStyles) {
          toolbarChildren.add(_listStyles(t));
        }
      }
      if (t is ParagraphButtons) {
        if (t.alignLeft || t.alignCenter || t.alignRight || t.alignJustify) {
          toolbarChildren.add(_paragraphButtons(t));
        }
        if (t.increaseIndent || t.decreaseIndent) {
          toolbarChildren.add(_indent(t));
        }
        if (t.lineHeight) {
          toolbarChildren.add(_lineHeight(t));
        }
        if (t.textDirection) {
          toolbarChildren.add(_textDirection(t));
        }
        if (t.caseConverter) {
          toolbarChildren.add(_caseConverter(t));
        }
      }
      if (t is InsertButtons &&
          (t.audio ||
              t.video ||
              t.otherFile ||
              t.picture ||
              t.link ||
              t.hr ||
              t.table)) {
        toolbarChildren.add(_mediaButtons(t));
      }
      if (t is OtherButtons) {
        if (t.fullscreen || t.codeview || t.undo || t.redo || t.help) {
          toolbarChildren.add(_otherButtons(t));
        }
        if (t.copy || t.paste) {
          toolbarChildren.add(_copyPaste(t));
        }
      }
    }

    if (widget.toolbarOptions.customButtonGroups.isNotEmpty) {
      toolbarChildren = _customButtons(
          toolbarChildren, widget.toolbarOptions.customButtonGroups);
    }

    if (widget.toolbarOptions.renderSeparatorWidget) {
      toolbarChildren =
          intersperse(widget.toolbarOptions.separatorWidget, toolbarChildren)
              .toList();
    }

    return toolbarChildren;
  }
}
