// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarParagraphButtons on ToolbarWidgetState {
  ///
  Widget _caseConverter(ParagraphButtons t) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      height: widget.toolbarOptions.toolbarItemHeight,
      decoration: !widget.toolbarOptions.renderBorder
          ? null
          : widget.toolbarOptions.dropdownBoxDecoration ??
              BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.12))),
      child: CustomDropdownButtonHideUnderline(
        child: CustomDropdownButton<String>(
          elevation: widget.toolbarOptions.dropdownElevation,
          icon: widget.toolbarOptions.dropdownIcon,
          iconEnabledColor: widget.toolbarOptions.dropdownIconColor,
          iconSize: widget.toolbarOptions.dropdownIconSize,
          itemHeight: widget.toolbarOptions.dropdownItemHeight,
          focusColor: widget.toolbarOptions.dropdownFocusColor,
          dropdownColor: widget.toolbarOptions.dropdownBackgroundColor,
          menuDirection: widget.toolbarOptions.dropdownMenuDirection ??
              (widget.toolbarOptions.toolbarPosition ==
                      ToolbarPosition.belowEditor
                  ? DropdownMenuDirection.up
                  : DropdownMenuDirection.down),
          menuMaxHeight: widget.toolbarOptions.dropdownMenuMaxHeight ??
              MediaQuery.of(context).size.height / 3,
          style: widget.toolbarOptions.textStyle,
          items: [
            CustomDropdownMenuItem(
              value: 'lower',
              child: PointerInterceptor(child: Text('lowercase')),
            ),
            CustomDropdownMenuItem(
              value: 'sentence',
              child: PointerInterceptor(child: Text('Sentence case')),
            ),
            CustomDropdownMenuItem(
              value: 'title',
              child: PointerInterceptor(child: Text('Title Case')),
            ),
            CustomDropdownMenuItem(
              value: 'upper',
              child: PointerInterceptor(child: Text('UPPERCASE')),
            ),
          ],
          hint: const Text('Change case'),
          value: null,
          onChanged: (String? changed) async {
            if (changed != null) {
              var proceed = await widget.toolbarOptions.onDropdownChanged
                      ?.call(DropdownType.caseConverter, changed, null) ??
                  true;
              if (proceed) {
                if (kIsWeb) {
                  //widget.controller.changeCase(changed);
                } else {
                  // await widget.controller.editorController!
                  //     .evaluateJavascript(source: """
                  //         var selected = \$('#summernote-2').summernote('createRange');
                  //         if(selected.toString()){
                  //             var texto;
                  //             var count = 0;
                  //             var value = "$changed";
                  //             var nodes = selected.nodes();
                  //             for (var i=0; i< nodes.length; ++i) {
                  //                 if (nodes[i].nodeName == "#text") {
                  //                     count++;
                  //                     texto = nodes[i].nodeValue.toLowerCase();
                  //                     nodes[i].nodeValue = texto;
                  //                     if (value == 'upper') {
                  //                        nodes[i].nodeValue = texto.toUpperCase();
                  //                     }
                  //                     else if (value == 'sentence' && count==1) {
                  //                        nodes[i].nodeValue = texto.charAt(0).toUpperCase() + texto.slice(1).toLowerCase();
                  //                     } else if (value == 'title') {
                  //                       var sentence = texto.split(" ");
                  //                       for(var j = 0; j< sentence.length; j++){
                  //                          sentence[j] = sentence[j][0].toUpperCase() + sentence[j].slice(1);
                  //                       }
                  //                       nodes[i].nodeValue = sentence.join(" ");
                  //                     }
                  //                 }
                  //             }
                  //         }
                  //       """);
                }
              }
            }
          },
        ),
      ),
    );
  }

  ///
  ToggleButtons _textDirection(ParagraphButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.toolbarOptions.toolbarItemHeight - 2,
        height: widget.toolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.toolbarOptions.buttonColor,
      selectedColor: widget.toolbarOptions.buttonSelectedColor,
      fillColor: widget.toolbarOptions.buttonFillColor,
      focusColor: widget.toolbarOptions.buttonFocusColor,
      highlightColor: widget.toolbarOptions.buttonHighlightColor,
      hoverColor: widget.toolbarOptions.buttonHoverColor,
      splashColor: widget.toolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.toolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.toolbarOptions.buttonBorderColor,
      borderRadius: widget.toolbarOptions.buttonBorderRadius,
      borderWidth: widget.toolbarOptions.buttonBorderWidth,
      renderBorder: widget.toolbarOptions.renderBorder,
      textStyle: widget.toolbarOptions.textStyle,
      onPressed: (int index) async {
        void updateStatus() {
          _textDirectionSelected = List<bool>.filled(2, false);
          setState(mounted, this.setState, () {
            _textDirectionSelected[index] = !_textDirectionSelected[index];
          });
        }

        var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                index == 0 ? ButtonType.ltr : ButtonType.rtl,
                _alignSelected[index],
                updateStatus) ??
            true;
        if (proceed) {
          if (kIsWeb) {
            //widget.controller.changeTextDirection(index == 0 ? 'ltr' : 'rtl');
          } else {
            // await widget.controller.editorController!
            //     .evaluateJavascript(source: """
            //       var s=document.getSelection();
            //       if(s==''){
            //           document.execCommand("insertHTML", false, "<p dir='${index == 0 ? "ltr" : "rtl"}'></p>");
            //       }else{
            //           document.execCommand("insertHTML", false, "<div dir='${index == 0 ? "ltr" : "rtl"}'>"+ document.getSelection()+"</div>");
            //       }
            //     """);
          }
          updateStatus();
        }
      },
      isSelected: _textDirectionSelected,
      children: const [
        Icon(Icons.format_textdirection_l_to_r),
        Icon(Icons.format_textdirection_r_to_l),
      ],
    );
  }

  ///
  Widget _lineHeight(ParagraphButtons t) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      height: widget.toolbarOptions.toolbarItemHeight,
      decoration: !widget.toolbarOptions.renderBorder
          ? null
          : widget.toolbarOptions.dropdownBoxDecoration ??
              BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.12))),
      child: CustomDropdownButtonHideUnderline(
        child: CustomDropdownButton<double>(
          elevation: widget.toolbarOptions.dropdownElevation,
          icon: widget.toolbarOptions.dropdownIcon,
          iconEnabledColor: widget.toolbarOptions.dropdownIconColor,
          iconSize: widget.toolbarOptions.dropdownIconSize,
          itemHeight: widget.toolbarOptions.dropdownItemHeight,
          focusColor: widget.toolbarOptions.dropdownFocusColor,
          dropdownColor: widget.toolbarOptions.dropdownBackgroundColor,
          menuDirection: widget.toolbarOptions.dropdownMenuDirection ??
              (widget.toolbarOptions.toolbarPosition ==
                      ToolbarPosition.belowEditor
                  ? DropdownMenuDirection.up
                  : DropdownMenuDirection.down),
          menuMaxHeight: widget.toolbarOptions.dropdownMenuMaxHeight ??
              MediaQuery.of(context).size.height / 3,
          style: widget.toolbarOptions.textStyle,
          items: [
            CustomDropdownMenuItem(
                value: 1, child: PointerInterceptor(child: Text('1.0'))),
            CustomDropdownMenuItem(
              value: 1.2,
              child: PointerInterceptor(child: Text('1.2')),
            ),
            CustomDropdownMenuItem(
              value: 1.4,
              child: PointerInterceptor(child: Text('1.4')),
            ),
            CustomDropdownMenuItem(
              value: 1.5,
              child: PointerInterceptor(child: Text('1.5')),
            ),
            CustomDropdownMenuItem(
              value: 1.6,
              child: PointerInterceptor(child: Text('1.6')),
            ),
            CustomDropdownMenuItem(
              value: 1.8,
              child: PointerInterceptor(child: Text('1.8')),
            ),
            CustomDropdownMenuItem(
              value: 2,
              child: PointerInterceptor(child: Text('2.0')),
            ),
            CustomDropdownMenuItem(
                value: 3, child: PointerInterceptor(child: Text('3.0'))),
          ],
          value: _lineHeightSelectedItem,
          onChanged: (double? changed) async {
            void updateSelectedItem(dynamic changed) {
              if (changed is double) {
                setState(mounted, this.setState, () {
                  _lineHeightSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var proceed = await widget.toolbarOptions.onDropdownChanged?.call(
                      DropdownType.lineHeight, changed, updateSelectedItem) ??
                  true;
              if (proceed) {
                if (kIsWeb) {
                  //widget.controller.changeLineHeight(changed.toString());
                } else {
                  // await widget.controller.editorController!.evaluateJavascript(
                  //     source:
                  //         "\$('#summernote-2').summernote('lineHeight', '$changed');");
                }
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }

  /// [ `>` | `<` ]
  ToggleButtons _indent(ParagraphButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.toolbarOptions.toolbarItemHeight - 2,
        height: widget.toolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.toolbarOptions.buttonColor,
      selectedColor: widget.toolbarOptions.buttonSelectedColor,
      fillColor: widget.toolbarOptions.buttonFillColor,
      focusColor: widget.toolbarOptions.buttonFocusColor,
      highlightColor: widget.toolbarOptions.buttonHighlightColor,
      hoverColor: widget.toolbarOptions.buttonHoverColor,
      splashColor: widget.toolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.toolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.toolbarOptions.buttonBorderColor,
      borderRadius: widget.toolbarOptions.buttonBorderRadius,
      borderWidth: widget.toolbarOptions.buttonBorderWidth,
      renderBorder: widget.toolbarOptions.renderBorder,
      textStyle: widget.toolbarOptions.textStyle,
      onPressed: (int index) async {
        if (t.getIcons2()[index].icon == Icons.format_indent_increase) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.increaseIndent, null, null) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('indent');
          }
        }
        if (t.getIcons2()[index].icon == Icons.format_indent_decrease) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.decreaseIndent, null, null) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('outdent');
          }
        }
      },
      isSelected: List<bool>.filled(t.getIcons2().length, false),
      children: t.getIcons2(),
    );
  }

  ///
  ToggleButtons _paragraphButtons(ParagraphButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.toolbarOptions.toolbarItemHeight - 2,
        height: widget.toolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.toolbarOptions.buttonColor,
      selectedColor: widget.toolbarOptions.buttonSelectedColor,
      fillColor: widget.toolbarOptions.buttonFillColor,
      focusColor: widget.toolbarOptions.buttonFocusColor,
      highlightColor: widget.toolbarOptions.buttonHighlightColor,
      hoverColor: widget.toolbarOptions.buttonHoverColor,
      splashColor: widget.toolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.toolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.toolbarOptions.buttonBorderColor,
      borderRadius: widget.toolbarOptions.buttonBorderRadius,
      borderWidth: widget.toolbarOptions.buttonBorderWidth,
      renderBorder: widget.toolbarOptions.renderBorder,
      textStyle: widget.toolbarOptions.textStyle,
      onPressed: (int index) async {
        void updateStatus() {
          _alignSelected = List<bool>.filled(t.getIcons1().length, false);
          setState(mounted, this.setState, () {
            _alignSelected[index] = !_alignSelected[index];
          });
        }

        if (t.getIcons1()[index].icon == Icons.format_align_left) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.alignLeft, _alignSelected[index], updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('justifyLeft');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_align_center) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.alignCenter,
                  _alignSelected[index],
                  updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('justifyCenter');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_align_right) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.alignRight, _alignSelected[index], updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('justifyRight');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_align_justify) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.alignJustify,
                  _alignSelected[index],
                  updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('justifyFull');
            updateStatus();
          }
        }
      },
      isSelected: _alignSelected,
      children: t.getIcons1(),
    );
  }
}
