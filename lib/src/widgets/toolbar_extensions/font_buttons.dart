// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarFontButtons on ToolbarWidgetState {
  /// [`strikethrough`|`subscript`|`superscript`]
  ToggleButtons _strikeThrough(FontButtons t) {
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
            _miscFontSelected[index] = !_miscFontSelected[index];
          });
        }

        if (t.getIcons2()[index].icon == Icons.format_strikethrough) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
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
          var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
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
          var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
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
            _fontSelected[index] = !_fontSelected[index];
          });
        }

        if (t.getIcons1()[index].icon == Icons.format_bold) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.bold, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('bold');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_italic) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                  ButtonType.italic, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('italic');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_underline) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                  ButtonType.underline, _fontSelected[index], updateStatus) ??
              true;
          if (proceed) {
            await widget.controller.execCommand('underline');
            updateStatus();
          }
        }
        if (t.getIcons1()[index].icon == Icons.format_clear) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
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
