part of '../toolbar_widget.dart';

extension ToolbarListButtons on ToolbarWidgetState {
  /// [`disc` | `circle` | `square`]
  Widget _listStyles(ListButtons t) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      height: widget.htmlToolbarOptions.toolbarItemHeight,
      decoration: !widget.htmlToolbarOptions.renderBorder
          ? null
          : widget.htmlToolbarOptions.dropdownBoxDecoration ??
              BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.12))),
      child: CustomDropdownButtonHideUnderline(
        child: CustomDropdownButton<String>(
          elevation: widget.htmlToolbarOptions.dropdownElevation,
          icon: widget.htmlToolbarOptions.dropdownIcon,
          iconEnabledColor: widget.htmlToolbarOptions.dropdownIconColor,
          iconSize: widget.htmlToolbarOptions.dropdownIconSize,
          itemHeight: widget.htmlToolbarOptions.dropdownItemHeight,
          focusColor: widget.htmlToolbarOptions.dropdownFocusColor,
          dropdownColor: widget.htmlToolbarOptions.dropdownBackgroundColor,
          menuDirection: widget.htmlToolbarOptions.dropdownMenuDirection ??
              (widget.htmlToolbarOptions.toolbarPosition ==
                      ToolbarPosition.belowEditor
                  ? DropdownMenuDirection.up
                  : DropdownMenuDirection.down),
          menuMaxHeight: widget.htmlToolbarOptions.dropdownMenuMaxHeight ??
              MediaQuery.of(context).size.height / 3,
          style: widget.htmlToolbarOptions.textStyle,
          items: [
            CustomDropdownMenuItem(
              value: 'decimal',
              child: PointerInterceptor(child: Text('1. Numbered')),
            ),
            CustomDropdownMenuItem(
              value: 'lower-alpha',
              child: PointerInterceptor(child: Text('a. Lower Alpha')),
            ),
            CustomDropdownMenuItem(
              value: 'upper-alpha',
              child: PointerInterceptor(child: Text('A. Upper Alpha')),
            ),
            CustomDropdownMenuItem(
              value: 'lower-roman',
              child: PointerInterceptor(child: Text('i. Lower Roman')),
            ),
            CustomDropdownMenuItem(
              value: 'upper-roman',
              child: PointerInterceptor(child: Text('I. Upper Roman')),
            ),
            CustomDropdownMenuItem(
              value: 'disc',
              child: PointerInterceptor(child: Text('• Disc')),
            ),
            CustomDropdownMenuItem(
              value: 'circle',
              child: PointerInterceptor(child: Text('○ Circle')),
            ),
            CustomDropdownMenuItem(
              value: 'square',
              child: PointerInterceptor(child: Text('■ Square')),
            ),
          ],
          hint: Text('Select list style'),
          value: _listStyleSelectedItem,
          onChanged: (String? changed) async {
            void updateSelectedItem(dynamic changed) {
              if (changed is String) {
                setState(mounted, this.setState, () {
                  _listStyleSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var proceed = await widget.htmlToolbarOptions.onDropdownChanged
                      ?.call(DropdownType.listStyles, changed,
                          updateSelectedItem) ??
                  true;
              if (proceed) {
                if (kIsWeb) {
                  widget.controller.changeListStyle(changed);
                } else {
                  await widget.controller.editorController!
                      .evaluateJavascript(source: '''
                               var \$focusNode = \$(window.getSelection().focusNode);
                               var \$parentList = \$focusNode.closest("div.note-editable ol, div.note-editable ul");
                               \$parentList.css("list-style-type", "$changed");
                            ''');
                }
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }

  /// [`UL` | `OL`]
  ToggleButtons _ulOl(ListButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.htmlToolbarOptions.toolbarItemHeight - 2,
        height: widget.htmlToolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.htmlToolbarOptions.buttonColor,
      selectedColor: widget.htmlToolbarOptions.buttonSelectedColor,
      fillColor: widget.htmlToolbarOptions.buttonFillColor,
      focusColor: widget.htmlToolbarOptions.buttonFocusColor,
      highlightColor: widget.htmlToolbarOptions.buttonHighlightColor,
      hoverColor: widget.htmlToolbarOptions.buttonHoverColor,
      splashColor: widget.htmlToolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.htmlToolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.htmlToolbarOptions.buttonBorderColor,
      borderRadius: widget.htmlToolbarOptions.buttonBorderRadius,
      borderWidth: widget.htmlToolbarOptions.buttonBorderWidth,
      renderBorder: widget.htmlToolbarOptions.renderBorder,
      textStyle: widget.htmlToolbarOptions.textStyle,
      onPressed: (int index) async {
        void updateStatus() {
          setState(mounted, this.setState, () {
            _listSelected[index] = !_listSelected[index];
          });
        }

        if (t.getIcons()[index].icon == Icons.format_list_bulleted) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.ul, _listSelected[index], updateStatus) ??
              true;
          if (proceed) {
            if (!_listSelected[index]) {
              await widget.controller.execCommand('insertUnorderedList');
            } else {
              await widget.controller.execCommand('removeList');
            }
            updateStatus();
          }
        }
        if (t.getIcons()[index].icon == Icons.format_list_numbered) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.ol, _listSelected[index], updateStatus) ??
              true;
          if (proceed) {
            if (!_listSelected[index]) {
              await widget.controller.execCommand('insertOrderedList');
            } else {
              await widget.controller.execCommand('removeList');
            }
            updateStatus();
          }
        }
      },
      isSelected: _listSelected,
      children: t.getIcons(),
    );
  }
}
