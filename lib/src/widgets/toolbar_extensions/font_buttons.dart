// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarFontButtons on ToolbarWidgetState {
  /// [`strikethrough`|`subscript`|`superscript`]
  ToggleButtons _strikeThrough(FontButtons t) {
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
            _miscFontSelected[index] = !_miscFontSelected[index];
          });
        }

        if (t.getIcons2()[index].icon == Icons.format_strikethrough) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.strikethrough,
                  _miscFontSelected[index],
                  updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('strikeThrough');
            updateStatus();
          }
        }
        if (t.getIcons2()[index].icon == Icons.superscript) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.superscript,
                  _miscFontSelected[index],
                  updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('superscript');
            updateStatus();
          }
        }
        if (t.getIcons2()[index].icon == Icons.subscript) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.subscript,
                  _miscFontSelected[index],
                  updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('subscript');
            updateStatus();
          }
        }
      },
      isSelected: _miscFontSelected,
      children: t.getIcons2(),
    );
  }

  /// [ `bold` | `italic` | `underline` | `slear` ]
  ToggleButtons _boldItalic(FontButtons t) {
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
            _fontSelected[index] = !_fontSelected[index];
          });
        }

        if (t.getIcons1()[index].icon == Icons.format_bold) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.bold, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            if (_fontSelected[index]) {
              await widget.controller.execCommand('removeBold');
            } else {
              await widget.controller.execCommand('bold');
            }

            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_italic) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.italic, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            if (_fontSelected[index]) {
              await widget.controller.execCommand('removeItalic');
            } else {
              await widget.controller.execCommand('italic');
            }

            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_underline) {
          var proceed = await widget.toolbarOptions.onButtonPressed?.call(
                  ButtonType.underline, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            if (_fontSelected[index]) {
              await widget.controller.execCommand('removeUnderline');
            } else {
              await widget.controller.execCommand('underline');
            }
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_clear) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.clearFormatting, null, null) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('removeFormat');
          }
        }
      },
      isSelected: _fontSelected,
      children: t.getIcons1(),
    );
  }
}
