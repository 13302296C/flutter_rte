// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarFontSettingsButtons on ToolbarWidgetState {
  ///
  Widget _fontSizeUnit(FontSettingButtons t) {
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
              value: 'pt',
              child: PointerInterceptor(child: Text('pt')),
            ),
            CustomDropdownMenuItem(
              value: 'px',
              child: PointerInterceptor(child: Text('px')),
            ),
          ],
          value: _fontSizeUnitSelectedItem,
          onChanged: (String? changed) async {
            void updateSelectedItem(dynamic changed) {
              if (changed is String) {
                setState(mounted, this.setState, () {
                  _fontSizeUnitSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var proceed = await widget.htmlToolbarOptions.onDropdownChanged
                      ?.call(DropdownType.fontSizeUnit, changed,
                          updateSelectedItem) ??
                  true;
              if (proceed) {
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }

  ///
  Widget _fontSize(FontSettingButtons t) {
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
        child: CustomDropdownButton<double>(
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
              value: 1,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "11" : "8"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 2,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "13" : "10"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 3,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "16" : "12"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 4,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "19" : "14"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 5,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "24" : "18"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 6,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "32" : "24"} $_fontSizeUnitSelectedItem")),
            ),
            CustomDropdownMenuItem(
              value: 7,
              child: PointerInterceptor(
                  child: Text(
                      "${_fontSizeUnitSelectedItem == "px" ? "48" : "36"} $_fontSizeUnitSelectedItem")),
            ),
          ],
          value: _fontSizeSelectedItem,
          onChanged: (double? changed) async {
            void updateSelectedItem(dynamic changed) {
              if (changed is double) {
                setState(mounted, this.setState, () {
                  _fontSizeSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var intChanged = changed.toInt();
              var proceed = await widget.htmlToolbarOptions.onDropdownChanged
                      ?.call(
                          DropdownType.fontSize, changed, updateSelectedItem) ??
                  true;
              if (proceed) {
                switch (intChanged) {
                  case 1:
                    _actualFontSizeSelectedItem = 11;
                    break;
                  case 2:
                    _actualFontSizeSelectedItem = 13;
                    break;
                  case 3:
                    _actualFontSizeSelectedItem = 16;
                    break;
                  case 4:
                    _actualFontSizeSelectedItem = 19;
                    break;
                  case 5:
                    _actualFontSizeSelectedItem = 24;
                    break;
                  case 6:
                    _actualFontSizeSelectedItem = 32;
                    break;
                  case 7:
                    _actualFontSizeSelectedItem = 48;
                    break;
                }
                await widget.controller
                    .execCommand('fontSize', argument: changed.toString());
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }

  ///
  Widget _fontName(FontSettingButtons t) {
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
              value: 'Courier New',
              child: PointerInterceptor(
                  child: Text('Courier New',
                      style: TextStyle(fontFamily: 'Courier'))),
            ),
            CustomDropdownMenuItem(
              value: 'sans-serif',
              child: PointerInterceptor(
                  child: Text('Sans Serif',
                      style: TextStyle(fontFamily: 'sans-serif'))),
            ),
            CustomDropdownMenuItem(
              value: 'Times New Roman',
              child: PointerInterceptor(
                  child: Text('Times New Roman',
                      style: TextStyle(fontFamily: 'Times'))),
            ),
          ],
          value: _fontNameSelectedItem,
          onChanged: (String? changed) async {
            void updateSelectedItem(dynamic changed) async {
              if (changed is String) {
                setState(mounted, this.setState, () {
                  _fontNameSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var proceed = await widget.htmlToolbarOptions.onDropdownChanged
                      ?.call(
                          DropdownType.fontName, changed, updateSelectedItem) ??
                  true;
              if (proceed) {
                await widget.controller
                    .execCommand('fontName', argument: changed);
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }
}
