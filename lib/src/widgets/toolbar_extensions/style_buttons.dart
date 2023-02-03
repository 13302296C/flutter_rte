// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarStyleButtons on ToolbarWidgetState {
  ///
  Widget _styleButtons(StyleButtons t) {
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
                value: 'p', child: PointerInterceptor(child: Text('Normal'))),
            CustomDropdownMenuItem(
                value: 'blockquote',
                child: PointerInterceptor(
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left:
                                  BorderSide(color: Colors.grey, width: 3.0))),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text('Quote',
                          style: TextStyle(
                              fontFamily: 'times', color: Colors.grey))),
                )),
            CustomDropdownMenuItem(
                value: 'pre',
                child: PointerInterceptor(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text('Code',
                          style: TextStyle(
                              fontFamily: 'courier', color: Colors.white))),
                )),
            CustomDropdownMenuItem(
              value: 'h1',
              child: PointerInterceptor(
                  child: Text('Header 1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 32))),
            ),
            CustomDropdownMenuItem(
              value: 'h2',
              child: PointerInterceptor(
                  child: Text('Header 2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24))),
            ),
            CustomDropdownMenuItem(
              value: 'h3',
              child: PointerInterceptor(
                  child: Text('Header 3',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            CustomDropdownMenuItem(
              value: 'h4',
              child: PointerInterceptor(
                  child: Text('Header 4',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
            ),
            CustomDropdownMenuItem(
              value: 'h5',
              child: PointerInterceptor(
                  child: Text('Header 5',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
            ),
            CustomDropdownMenuItem(
              value: 'h6',
              child: PointerInterceptor(
                  child: Text('Header 6',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11))),
            ),
          ],
          value: _fontSelectedItem,
          onChanged: (String? changed) async {
            void updateSelectedItem(dynamic changed) {
              if (changed is String) {
                setState(mounted, this.setState, () {
                  _fontSelectedItem = changed;
                });
              }
            }

            if (changed != null) {
              var proceed = await widget.toolbarOptions.onDropdownChanged
                      ?.call(DropdownType.style, changed, updateSelectedItem) ??
                  true;
              if (proceed) {
                await widget.controller.execCommand('formatBlock',
                    argument: changed.toUpperCase());
                updateSelectedItem(changed);
              }
            }
          },
        ),
      ),
    );
  }
}
