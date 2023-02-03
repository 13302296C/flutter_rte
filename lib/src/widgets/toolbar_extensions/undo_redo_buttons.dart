// ignore_for_file: invalid_use_of_protected_member

part of '../toolbar_widget.dart';

extension ToolbarUndoRedoButtons on ToolbarWidgetState {
  /// [ `fullscreen` || `codeview` || `undo` || `redo` || `help` ]
  ToggleButtons _undoRedoButtons(OtherButtons t) {
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
        // void updateStatus() {
        //   setState(mounted, this.setState, () {
        //     //_miscSelected[index] = !_miscSelected[index];
        //   });
        // }

        // if (t.getIcons1()[index].icon == Icons.fullscreen) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed?.call(
        //           ButtonType.fullscreen, _miscSelected[index], updateStatus) ??
        //       true;
        //   if (proceed) {
        //     //widget.controller.setFullScreen();
        //     updateStatus();
        //   }
        // }
        // if (t.getIcons1()[index].icon == Icons.code) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed?.call(
        //           ButtonType.codeview, _miscSelected[index], updateStatus) ??
        //       true;
        //   if (proceed) {
        //     widget.controller.toggleCodeView();
        //     updateStatus();
        //   }
        // }
        if (t.getIcons1()[index].icon == Icons.undo) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.undo, null, null) ??
              true;
          if (proceed) {
            widget.controller.undo();
          }
        }
        if (t.getIcons1()[index].icon == Icons.redo) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.redo, null, null) ??
              true;
          if (proceed) {
            widget.controller.redo();
          }
        }
        if (t.getIcons1()[index].icon == Icons.help_outline) {
          var proceed = await widget.toolbarOptions.onButtonPressed
                  ?.call(ButtonType.help, null, null) ??
              true;
          if (proceed) {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: const Text('Help'),
                        scrollable: true,
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: SingleChildScrollView(
                            child: _table(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
      },
      isSelected: List.filled(t.getIcons1().length, false),
      children: t.getIcons1(),
    );
  }

  DataTable _table() => DataTable(
        columnSpacing: 5,
        dataRowHeight: 75,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Key Combination',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Action',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[DataCell(Text('ESC')), DataCell(Text('Escape'))],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('ENTER')),
              DataCell(Text('Insert Paragraph'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+Z')),
              DataCell(Text('Undo the last command'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+Z')),
              DataCell(Text('Undo the last command'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+Y')),
              DataCell(Text('Redo the last command'))
            ],
          ),
          DataRow(
            cells: <DataCell>[DataCell(Text('TAB')), DataCell(Text('Tab'))],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('SHIFT+TAB')),
              DataCell(Text('Untab'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+B')),
              DataCell(Text('Set a bold style'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+I')),
              DataCell(Text('Set an italic style'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+U')),
              DataCell(Text('Set an underline style'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+S')),
              DataCell(Text('Set a strikethrough style'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+BACKSLASH')),
              DataCell(Text('Clean a style'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+L')),
              DataCell(Text('Set left align'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+E')),
              DataCell(Text('Set center align'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+R')),
              DataCell(Text('Set right align'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+J')),
              DataCell(Text('Set full align'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+NUM7')),
              DataCell(Text('Toggle unordered list'))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+SHIFT+NUM8')),
              DataCell(Text('Toggle ordered list')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+LEFTBRACKET')),
              DataCell(Text('Outdent on current paragraph')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+RIGHTBRACKET')),
              DataCell(Text('Indent on current paragraph')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM0')),
              DataCell(Text(
                  'Change current block\'s format as a paragraph (<p> tag)')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM1')),
              DataCell(Text('Change current block\'s format as H1')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM2')),
              DataCell(Text('Change current block\'s format as H2')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM3')),
              DataCell(Text('Change current block\'s format as H3')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM4')),
              DataCell(Text('Change current block\'s format as H4')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM5')),
              DataCell(Text('Change current block\'s format as H5')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+NUM6')),
              DataCell(Text('Change current block\'s format as H6')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+ENTER')),
              DataCell(Text('Insert horizontal rule')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('CTRL+K')),
              DataCell(Text('Show link dialog'))
            ],
          ),
        ],
      );
}
