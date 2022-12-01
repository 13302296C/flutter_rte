part of '../toolbar_widget.dart';

extension ToolbarCustomButtons on ToolbarWidgetState {
  List<ToggleButtons> _customButtons(List<CustomButtonGroup> groups) {
    var res = <ToggleButtons>[];

    for (var group in groups) {
      res.add(ToggleButtons(
        isSelected: group.buttons.map((e) => e.isSelected).toList(),
        onPressed: (int index) async {
          if (group.buttons[index].action != null) {
            group.buttons[index].action!();
          }
        },
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
        selectedBorderColor:
            widget.htmlToolbarOptions.buttonSelectedBorderColor,
        borderColor: widget.htmlToolbarOptions.buttonBorderColor,
        borderRadius: widget.htmlToolbarOptions.buttonBorderRadius,
        borderWidth: widget.htmlToolbarOptions.buttonBorderWidth,
        renderBorder: widget.htmlToolbarOptions.renderBorder,
        textStyle: widget.htmlToolbarOptions.textStyle,
        children: group.buttons.map((e) => Icon(e.icon)).toList(),
      ));
    }

    return res;
  }
}
