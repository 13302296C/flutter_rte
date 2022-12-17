// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarCopyPasteButtons on ToolbarWidgetState {
  /// [ `copy` | `paste` ]
  ToggleButtons _copyPaste(OtherButtons t) {
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
        if (t.getIcons2()[index].icon == Icons.copy) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.copy, null, null) ??
              true;
          if (proceed) {
            var data = await widget.controller.getSelectedText();
            await Clipboard.setData(ClipboardData(text: data)).onError(
                (error, stackTrace) => throw Exception(
                    'There was an error copying to clipboard: ${error.toString()}'));
          }
        }
        if (t.getIcons2()[index].icon == Icons.paste) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.paste, null, null) ??
              true;
          if (proceed) {
            var data = await Clipboard.getData(Clipboard.kTextPlain).onError(
                (error, stackTrace) => throw Exception(
                    'There was an error pasting from clipboard: ${error.toString()}'));
            if (data != null) {
              var text = data.text!;
              await widget.controller.insertHtml(text);
            }
          }
        }
      },
      isSelected: List<bool>.filled(t.getIcons2().length, false),
      children: t.getIcons2(),
    );
  }
}
