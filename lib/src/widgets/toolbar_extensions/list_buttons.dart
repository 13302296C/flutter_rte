// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarListButtons on ToolbarWidgetState {
  /// [`disc` | `circle` | `square`]
  Widget _listStyles(ListButtons t) {
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
              var proceed = await widget.toolbarOptions.onDropdownChanged?.call(
                      DropdownType.listStyles, changed, updateSelectedItem) ??
                  true;
              if (proceed) {
                if (kIsWeb) {
                  //widget.controller.changeListStyle(changed);
                } else {
                  // await widget.controller.editorController!
                  //     .evaluateJavascript(source: '''
                  //              var \$focusNode = \$(window.getSelection().focusNode);
                  //              var \$parentList = \$focusNode.closest("div.note-editable ol, div.note-editable ul");
                  //              \$parentList.css("list-style-type", "$changed");
                  //           ''');
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
          setState(mounted, this.setState, () {
            _listSelected[index] = !_listSelected[index];
          });
        }

        if (t.getIcons()[index].icon == Icons.format_list_bulleted) {
          var proceed = await widget.toolbarOptions.onButtonPressed
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
          var proceed = await widget.toolbarOptions.onButtonPressed
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
