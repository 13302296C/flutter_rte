// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarColorButtons on ToolbarWidgetState {
  ToggleButtons _colorButtons(ColorButtons t) {
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
        void updateStatus(Color? color) {
          setState(mounted, this.setState, () {
            _colorSelected[index] = !_colorSelected[index];
            if (color != null &&
                t.getIcons()[index].icon == Icons.format_color_text) {
              _foreColorSelected = color;
            }
            if (color != null &&
                t.getIcons()[index].icon == Icons.format_color_fill) {
              _backColorSelected = color;
            }
          });
        }

        if (_colorSelected[index]) {
          if (t.getIcons()[index].icon == Icons.format_color_text) {
            var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                    ButtonType.foregroundColor,
                    _colorSelected[index],
                    updateStatus) ??
                true;
            if (proceed) {
              await widget.controller.execCommand('textColor',
                  argument: (Colors.black.value & 0xFFFFFF)
                      .toRadixString(16)
                      .padLeft(6, '0')
                      .toUpperCase());
              updateStatus(null);
            }
          }
          if (t.getIcons()[index].icon == Icons.format_color_fill) {
            var proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                    ButtonType.highlightColor,
                    _colorSelected[index],
                    updateStatus) ??
                true;
            if (proceed) {
              await widget.controller.execCommand('highlightColor',
                  argument: (Colors.yellow.value & 0xFFFFFF)
                      .toRadixString(16)
                      .padLeft(6, '0')
                      .toUpperCase());
              updateStatus(null);
            }
          }
        } else {
          var proceed = true;
          if (t.getIcons()[index].icon == Icons.format_color_text) {
            proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                    ButtonType.foregroundColor,
                    _colorSelected[index],
                    updateStatus) ??
                true;
          } else if (t.getIcons()[index].icon == Icons.format_color_fill) {
            proceed = await widget.htmlToolbarOptions.onButtonPressed?.call(
                    ButtonType.highlightColor,
                    _colorSelected[index],
                    updateStatus) ??
                true;
          }
          if (proceed) {
            late Color newColor;
            if (t.getIcons()[index].icon == Icons.format_color_text) {
              newColor = _foreColorSelected;
            } else {
              newColor = _backColorSelected;
            }
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: AlertDialog(
                      scrollable: true,
                      content: ColorPicker(
                        color: newColor,
                        onColorChanged: (color) {
                          newColor = color;
                        },
                        title: Text('Choose a Color',
                            style: Theme.of(context).textTheme.headline6),
                        width: 40,
                        height: 40,
                        spacing: 0,
                        runSpacing: 0,
                        borderRadius: 0,
                        wheelDiameter: 165,
                        enableOpacity: false,
                        showColorCode: true,
                        colorCodeHasColor: true,
                        pickersEnabled: <ColorPickerType, bool>{
                          ColorPickerType.wheel: true,
                        },
                        copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                          parseShortHexCode: true,
                        ),
                        actionButtons: const ColorPickerActionButtons(
                          dialogActionButtons: true,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                            onPressed: () {
                              if (t.getIcons()[index].icon ==
                                  Icons.format_color_text) {
                                setState(mounted, this.setState, () {
                                  _foreColorSelected = Colors.black;
                                });
                                widget.controller.execCommand('removeFormat',
                                    argument: 'textColor');
                                widget.controller.execCommand('textColor',
                                    argument: 'initial');
                              }
                              if (t.getIcons()[index].icon ==
                                  Icons.format_color_fill) {
                                setState(mounted, this.setState, () {
                                  _backColorSelected = Colors.yellow;
                                });
                                widget.controller.execCommand('removeFormat',
                                    argument: 'highlightColor');
                                widget.controller.execCommand('highlightColor',
                                    argument: 'initial');
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('Reset to default color')),
                        TextButton(
                          onPressed: () {
                            if (t.getIcons()[index].icon ==
                                Icons.format_color_text) {
                              widget.controller.execCommand('textColor',
                                  argument: (newColor.value & 0xFFFFFF)
                                      .toRadixString(16)
                                      .padLeft(6, '0')
                                      .toUpperCase());
                              setState(mounted, this.setState, () {
                                _foreColorSelected = newColor;
                              });
                            }
                            if (t.getIcons()[index].icon ==
                                Icons.format_color_fill) {
                              widget.controller.execCommand('highlightColor',
                                  argument: (newColor.value & 0xFFFFFF)
                                      .toRadixString(16)
                                      .padLeft(6, '0')
                                      .toUpperCase());
                              setState(mounted, this.setState, () {
                                _backColorSelected = newColor;
                              });
                            }
                            setState(mounted, this.setState, () {
                              _colorSelected[index] = !_colorSelected[index];
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Set color'),
                        )
                      ],
                    ),
                  );
                });
          }
        }
      },
      isSelected: _colorSelected,
      children: t.getIcons(),
    );
  }
}
