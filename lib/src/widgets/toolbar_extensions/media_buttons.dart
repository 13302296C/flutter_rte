part of '../toolbar_widget.dart';

extension ToolbarMediaButtons on ToolbarWidgetState {
  ToggleButtons _mediaButtons(InsertButtons t) {
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
        // void updateStatus() {
        //   _insertSelected = List<bool>.filled(t.getIcons().length, false);
        //   setState(mounted, this.setState, () {
        //     _alignSelected[index] = !_alignSelected[index];
        //   });
        // }

        if (t.getIcons()[index].icon == Icons.link) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.link, null, null) ??
              true;
          if (proceed) {
            if (_insertSelected[index]) {
              await widget.controller.removeLink();
              return;
            }

            final text = TextEditingController();
            final url = TextEditingController();
            //final textFocus = FocusNode();
            final urlFocus = FocusNode();
            final formKey = GlobalKey<FormState>();
            var openNewTab = false;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert Link'),
                        scrollable: true,
                        content: Form(
                          key: formKey,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Text to display',
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold)),
                                // SizedBox(height: 10),
                                // TextField(
                                //   controller: text,
                                //   focusNode: textFocus,
                                //   textInputAction: TextInputAction.next,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(),
                                //     hintText: 'Text',
                                //   ),
                                //   onSubmitted: (_) {
                                //     urlFocus.requestFocus();
                                //   },
                                // ),
                                // SizedBox(height: 20),
                                Text('URL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: url,
                                  focusNode: urlFocus,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'URL',
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a URL!';
                                    }
                                    return null;
                                  },
                                ),
                                // Row(
                                //   children: <Widget>[
                                //     SizedBox(
                                //       height: 48.0,
                                //       width: 24.0,
                                //       child: Checkbox(
                                //         value: openNewTab,
                                //         activeColor: Color(0xFF827250),
                                //         onChanged: (bool? value) {
                                //           setState(() {
                                //             openNewTab = value!;
                                //           });
                                //         },
                                //       ),
                                //     ),
                                //     ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //           primary: Theme.of(context)
                                //               .dialogBackgroundColor,
                                //           padding: EdgeInsets.only(
                                //               left: 5, right: 5),
                                //           elevation: 0.0),
                                //       onPressed: () {
                                //         setState(() {
                                //           openNewTab = !openNewTab;
                                //         });
                                //       },
                                //       child: Text('Open in new window',
                                //           style: TextStyle(
                                //               color: Theme.of(context)
                                //                   .textTheme
                                //                   .bodyText1
                                //                   ?.color)),
                                //     ),
                                //   ],
                                // ),
                              ]),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var proceed = await widget.htmlToolbarOptions
                                        .linkInsertInterceptor
                                        ?.call(
                                            text.text.isEmpty
                                                ? url.text
                                                : text.text,
                                            url.text,
                                            openNewTab) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertLink(
                                    text.text.isEmpty ? url.text : text.text,
                                    url.text,
                                    openNewTab,
                                  );
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.image_outlined) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.picture, null, null) ??
              true;
          if (proceed) {
            final filename = TextEditingController();
            final url = TextEditingController();
            final urlFocus = FocusNode();
            FilePickerResult? result;
            String? validateFailed;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert Image'),
                        scrollable: true,
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select from files',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: filename,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context)
                                              .dialogBackgroundColor,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          elevation: 0.0),
                                      onPressed: () async {
                                        result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.image,
                                          withData: true,
                                          allowedExtensions: widget
                                              .htmlToolbarOptions
                                              .imageExtensions,
                                        );
                                        if (result?.files.single.name != null) {
                                          setState(() {
                                            filename.text =
                                                result!.files.single.name;
                                          });
                                        }
                                      },
                                      child: Text('Choose image',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color)),
                                    ),
                                    suffixIcon: result != null
                                        ? IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                result = null;
                                                filename.text = '';
                                              });
                                            })
                                        : Container(height: 0, width: 0),
                                    errorText: validateFailed,
                                    errorMaxLines: 2,
                                    border: InputBorder.none,
                                  )),
                              SizedBox(height: 20),
                              Text('URL',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                controller: url,
                                focusNode: urlFocus,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'URL',
                                  errorText: validateFailed,
                                  errorMaxLines: 2,
                                ),
                              ),
                            ]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (filename.text.isEmpty && url.text.isEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please either choose an image or enter an image URL!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  url.text.isNotEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please input either an image or an image URL, not both!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  result?.files.single.bytes != null) {
                                var base64Data =
                                    base64.encode(result!.files.single.bytes!);
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaUploadInterceptor
                                        ?.call(result!.files.single,
                                            InsertFileType.image) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertHtml(
                                      "<img src='data:image/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'/>");
                                }
                                Navigator.of(context).pop();
                              } else {
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaLinkInsertInterceptor
                                        ?.call(
                                            url.text, InsertFileType.image) ??
                                    true;
                                if (proceed) {
                                  widget.controller
                                      .insertNetworkImage(url.text);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.audiotrack_outlined) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.audio, null, null) ??
              true;
          if (proceed) {
            final filename = TextEditingController();
            final url = TextEditingController();
            final urlFocus = FocusNode();
            FilePickerResult? result;
            String? validateFailed;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert Audio'),
                        scrollable: true,
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select from files',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: filename,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context)
                                              .dialogBackgroundColor,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          elevation: 0.0),
                                      onPressed: () async {
                                        result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.audio,
                                          withData: true,
                                          allowedExtensions: widget
                                              .htmlToolbarOptions
                                              .audioExtensions,
                                        );
                                        if (result?.files.single.name != null) {
                                          setState(() {
                                            filename.text =
                                                result!.files.single.name;
                                          });
                                        }
                                      },
                                      child: Text('Choose audio',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color)),
                                    ),
                                    suffixIcon: result != null
                                        ? IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                result = null;
                                                filename.text = '';
                                              });
                                            })
                                        : Container(height: 0, width: 0),
                                    errorText: validateFailed,
                                    errorMaxLines: 2,
                                    border: InputBorder.none,
                                  )),
                              SizedBox(height: 20),
                              Text('URL',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                controller: url,
                                focusNode: urlFocus,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'URL',
                                  errorText: validateFailed,
                                  errorMaxLines: 2,
                                ),
                              ),
                            ]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (filename.text.isEmpty && url.text.isEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please either choose an audio file or enter an audio file URL!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  url.text.isNotEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please input either an audio file or an audio URL, not both!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  result?.files.single.bytes != null) {
                                var base64Data =
                                    base64.encode(result!.files.single.bytes!);
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaUploadInterceptor
                                        ?.call(result!.files.single,
                                            InsertFileType.audio) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertHtml(
                                      "<audio controls src='data:audio/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></audio>");
                                }
                                Navigator.of(context).pop();
                              } else {
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaLinkInsertInterceptor
                                        ?.call(
                                            url.text, InsertFileType.audio) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertHtml(
                                      "<audio controls src='${url.text}'></audio>");
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.videocam_outlined) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.video, null, null) ??
              true;
          if (proceed) {
            final filename = TextEditingController();
            final url = TextEditingController();
            final urlFocus = FocusNode();
            FilePickerResult? result;
            String? validateFailed;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert Video'),
                        scrollable: true,
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select from files',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: filename,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context)
                                              .dialogBackgroundColor,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          elevation: 0.0),
                                      onPressed: () async {
                                        result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.video,
                                          withData: true,
                                          allowedExtensions: widget
                                              .htmlToolbarOptions
                                              .videoExtensions,
                                        );
                                        if (result?.files.single.name != null) {
                                          setState(() {
                                            filename.text =
                                                result!.files.single.name;
                                          });
                                        }
                                      },
                                      child: Text('Choose video',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color)),
                                    ),
                                    suffixIcon: result != null
                                        ? IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                result = null;
                                                filename.text = '';
                                              });
                                            })
                                        : Container(height: 0, width: 0),
                                    errorText: validateFailed,
                                    errorMaxLines: 2,
                                    border: InputBorder.none,
                                  )),
                              SizedBox(height: 20),
                              Text('URL',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                controller: url,
                                focusNode: urlFocus,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'URL',
                                  errorText: validateFailed,
                                  errorMaxLines: 2,
                                ),
                              ),
                            ]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (filename.text.isEmpty && url.text.isEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please either choose a video or enter a video URL!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  url.text.isNotEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please input either a video or a video URL, not both!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  result?.files.single.bytes != null) {
                                var base64Data =
                                    base64.encode(result!.files.single.bytes!);
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaUploadInterceptor
                                        ?.call(result!.files.single,
                                            InsertFileType.video) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertHtml(
                                      "<video controls src='data:video/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></video>");
                                }
                                Navigator.of(context).pop();
                              } else {
                                var proceed = await widget.htmlToolbarOptions
                                        .mediaLinkInsertInterceptor
                                        ?.call(
                                            url.text, InsertFileType.video) ??
                                    true;
                                if (proceed) {
                                  await widget.controller.insertHtml(
                                      "<video controls src='${url.text}'></video>");
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.attach_file) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.otherFile, null, null) ??
              true;
          if (proceed) {
            final filename = TextEditingController();
            final url = TextEditingController();
            final urlFocus = FocusNode();
            FilePickerResult? result;
            String? validateFailed;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert File'),
                        scrollable: true,
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select from files',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: filename,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context)
                                              .dialogBackgroundColor,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          elevation: 0.0),
                                      onPressed: () async {
                                        result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.any,
                                          withData: true,
                                          allowedExtensions: widget
                                              .htmlToolbarOptions
                                              .otherFileExtensions,
                                        );
                                        if (result?.files.single.name != null) {
                                          setState(() {
                                            filename.text =
                                                result!.files.single.name;
                                          });
                                        }
                                      },
                                      child: Text('Choose file',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color)),
                                    ),
                                    suffixIcon: result != null
                                        ? IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                result = null;
                                                filename.text = '';
                                              });
                                            })
                                        : Container(height: 0, width: 0),
                                    errorText: validateFailed,
                                    errorMaxLines: 2,
                                    border: InputBorder.none,
                                  )),
                              SizedBox(height: 20),
                              Text('URL',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                controller: url,
                                focusNode: urlFocus,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'URL',
                                  errorText: validateFailed,
                                  errorMaxLines: 2,
                                ),
                              ),
                            ]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (filename.text.isEmpty && url.text.isEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please either choose a file or enter a file URL!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  url.text.isNotEmpty) {
                                setState(() {
                                  validateFailed =
                                      'Please input either a file or a file URL, not both!';
                                });
                              } else if (filename.text.isNotEmpty &&
                                  result?.files.single.bytes != null) {
                                widget.htmlToolbarOptions.onOtherFileUpload
                                    ?.call(result!.files.single);
                                Navigator.of(context).pop();
                              } else {
                                widget.htmlToolbarOptions.onOtherFileLinkInsert
                                    ?.call(url.text);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.table_chart_outlined) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.table, null, null) ??
              true;
          if (proceed) {
            var currentRows = 1;
            var currentCols = 1;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PointerInterceptor(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Insert Table'),
                        scrollable: true,
                        content: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberPicker(
                                value: currentRows,
                                minValue: 1,
                                maxValue: 10,
                                onChanged: (value) =>
                                    setState(() => currentRows = value),
                              ),
                              Text('x'),
                              NumberPicker(
                                value: currentCols,
                                minValue: 1,
                                maxValue: 10,
                                onChanged: (value) =>
                                    setState(() => currentCols = value),
                              ),
                            ]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (kIsWeb) {
                                widget.controller
                                    .insertTable('${currentRows}x$currentCols');
                              } else {
                                await widget.controller.editorController!
                                    .evaluateJavascript(
                                        source:
                                            "\$('#summernote-2').summernote('insertTable', '${currentRows}x$currentCols');");
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        if (t.getIcons()[index].icon == Icons.horizontal_rule) {
          var proceed = await widget.htmlToolbarOptions.onButtonPressed
                  ?.call(ButtonType.hr, null, null) ??
              true;
          if (proceed) {
            await widget.controller.insertHtml('<hr/>');
          }
        }
      },
      isSelected: _insertSelected,
      children: t.getIcons(),
    );
  }
}
