part of '../toolbar_widget.dart';

extension ToolbarCustomButtons on ToolbarWidgetState {
  List<Widget> _customButtons(
      List<Widget> toolbarChildren, List<CustomButtonGroup> groups) {
    for (var group in groups) {
      toolbarChildren.insert(
          group.index ?? 0,
          ToggleButtons(
            isSelected: group.buttons.map((e) => e.isSelected).toList(),
            onPressed: (int index) async {
              if (group.buttons[index].action != null) {
                group.buttons[index].action!();
              }
            },
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
            selectedBorderColor:
                widget.toolbarOptions.buttonSelectedBorderColor,
            borderColor: widget.toolbarOptions.buttonBorderColor,
            borderRadius: widget.toolbarOptions.buttonBorderRadius,
            borderWidth: widget.toolbarOptions.buttonBorderWidth,
            renderBorder: widget.toolbarOptions.renderBorder,
            textStyle: widget.toolbarOptions.textStyle,
            children: group.buttons.map((e) => Icon(e.icon)).toList(),
          ));
    }

    return toolbarChildren;
  }
}
