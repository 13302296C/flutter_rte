part of '../toolbar_widget.dart';

extension ToolbarMediaButtons on ToolbarWidgetState {
  ToggleButtons _mediaButtons(InsertButtons t) {
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
        //   _insertSelected = List<bool>.filled(t.getIcons().length, false);
        //   setState(mounted, this.setState, () {
        //     _alignSelected[index] = !_alignSelected[index];
        //   });
        // }

        if (t.getIcons()[index].icon == Icons.link) {
          var proceed = await widget.toolbarOptions.onButtonPressed
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
                        title: const Text('Insert Link'),
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
                                const Text('URL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: url,
                                  focusNode: urlFocus,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
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
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var proceed = await widget
                                        .toolbarOptions.linkInsertInterceptor
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
                            child: const Text('OK'),
                          )
                        ],
                      );
                    }),
                  );
                });
          }
        }
        // if (t.getIcons()[index].icon == Icons.image_outlined) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed
        //           ?.call(ButtonType.picture, null, null) ??
        //       true;
        //   if (proceed) {
        //     final filename = TextEditingController();
        //     final url = TextEditingController();
        //     final urlFocus = FocusNode();
        //     FilePickerResult? result;
        //     String? validateFailed;
        //     await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return PointerInterceptor(
        //             child: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //               return AlertDialog(
        //                 title: Text('Insert Image'),
        //                 scrollable: true,
        //                 content: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text('Select from files',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextFormField(
        //                           controller: filename,
        //                           readOnly: true,
        //                           decoration: InputDecoration(
        //                             prefixIcon: ElevatedButton(
        //                               style: ElevatedButton.styleFrom(
        //                                   primary: Theme.of(context)
        //                                       .dialogBackgroundColor,
        //                                   padding: EdgeInsets.only(
        //                                       left: 5, right: 5),
        //                                   elevation: 0.0),
        //                               onPressed: () async {
        //                                 result =
        //                                     await FilePicker.platform.pickFiles(
        //                                   type: FileType.image,
        //                                   withData: true,
        //                                   allowedExtensions: widget
        //                                       .toolbarOptions
        //                                       .imageExtensions,
        //                                 );
        //                                 if (result?.files.single.name != null) {
        //                                   setState(() {
        //                                     filename.text =
        //                                         result!.files.single.name;
        //                                   });
        //                                 }
        //                               },
        //                               child: Text('Choose image',
        //                                   style: TextStyle(
        //                                       color: Theme.of(context)
        //                                           .textTheme
        //                                           .bodyText1
        //                                           ?.color)),
        //                             ),
        //                             suffixIcon: result != null
        //                                 ? IconButton(
        //                                     icon: Icon(Icons.close),
        //                                     onPressed: () {
        //                                       setState(() {
        //                                         result = null;
        //                                         filename.text = '';
        //                                       });
        //                                     })
        //                                 : Container(height: 0, width: 0),
        //                             errorText: validateFailed,
        //                             errorMaxLines: 2,
        //                             border: InputBorder.none,
        //                           )),
        //                       SizedBox(height: 20),
        //                       Text('URL',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextField(
        //                         controller: url,
        //                         focusNode: urlFocus,
        //                         textInputAction: TextInputAction.done,
        //                         decoration: InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           hintText: 'URL',
        //                           errorText: validateFailed,
        //                           errorMaxLines: 2,
        //                         ),
        //                       ),
        //                     ]),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () async {
        //                       if (filename.text.isEmpty && url.text.isEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please either choose an image or enter an image URL!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           url.text.isNotEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please input either an image or an image URL, not both!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           result?.files.single.bytes != null) {
        //                         var base64Data =
        //                             base64.encode(result!.files.single.bytes!);
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaUploadInterceptor
        //                                 ?.call(result!.files.single,
        //                                     InsertFileType.image) ??
        //                             true;
        //                         if (proceed) {
        //                           await widget.controller.insertHtml(
        //                               "<img src='data:image/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'/>");
        //                         }
        //                         Navigator.of(context).pop();
        //                       } else {
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaLinkInsertInterceptor
        //                                 ?.call(
        //                                     url.text, InsertFileType.image) ??
        //                             true;
        //                         if (proceed) {
        //                           widget.controller
        //                               .insertNetworkImage(url.text);
        //                         }
        //                         Navigator.of(context).pop();
        //                       }
        //                     },
        //                     child: Text('OK'),
        //                   )
        //                 ],
        //               );
        //             }),
        //           );
        //         });
        //   }
        // }
        // if (t.getIcons()[index].icon == Icons.audiotrack_outlined) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed
        //           ?.call(ButtonType.audio, null, null) ??
        //       true;
        //   if (proceed) {
        //     final filename = TextEditingController();
        //     final url = TextEditingController();
        //     final urlFocus = FocusNode();
        //     FilePickerResult? result;
        //     String? validateFailed;
        //     await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return PointerInterceptor(
        //             child: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //               return AlertDialog(
        //                 title: Text('Insert Audio'),
        //                 scrollable: true,
        //                 content: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text('Select from files',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextFormField(
        //                           controller: filename,
        //                           readOnly: true,
        //                           decoration: InputDecoration(
        //                             prefixIcon: ElevatedButton(
        //                               style: ElevatedButton.styleFrom(
        //                                   primary: Theme.of(context)
        //                                       .dialogBackgroundColor,
        //                                   padding: EdgeInsets.only(
        //                                       left: 5, right: 5),
        //                                   elevation: 0.0),
        //                               onPressed: () async {
        //                                 result =
        //                                     await FilePicker.platform.pickFiles(
        //                                   type: FileType.audio,
        //                                   withData: true,
        //                                   allowedExtensions: widget
        //                                       .toolbarOptions
        //                                       .audioExtensions,
        //                                 );
        //                                 if (result?.files.single.name != null) {
        //                                   setState(() {
        //                                     filename.text =
        //                                         result!.files.single.name;
        //                                   });
        //                                 }
        //                               },
        //                               child: Text('Choose audio',
        //                                   style: TextStyle(
        //                                       color: Theme.of(context)
        //                                           .textTheme
        //                                           .bodyText1
        //                                           ?.color)),
        //                             ),
        //                             suffixIcon: result != null
        //                                 ? IconButton(
        //                                     icon: Icon(Icons.close),
        //                                     onPressed: () {
        //                                       setState(() {
        //                                         result = null;
        //                                         filename.text = '';
        //                                       });
        //                                     })
        //                                 : Container(height: 0, width: 0),
        //                             errorText: validateFailed,
        //                             errorMaxLines: 2,
        //                             border: InputBorder.none,
        //                           )),
        //                       SizedBox(height: 20),
        //                       Text('URL',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextField(
        //                         controller: url,
        //                         focusNode: urlFocus,
        //                         textInputAction: TextInputAction.done,
        //                         decoration: InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           hintText: 'URL',
        //                           errorText: validateFailed,
        //                           errorMaxLines: 2,
        //                         ),
        //                       ),
        //                     ]),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () async {
        //                       if (filename.text.isEmpty && url.text.isEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please either choose an audio file or enter an audio file URL!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           url.text.isNotEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please input either an audio file or an audio URL, not both!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           result?.files.single.bytes != null) {
        //                         var base64Data =
        //                             base64.encode(result!.files.single.bytes!);
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaUploadInterceptor
        //                                 ?.call(result!.files.single,
        //                                     InsertFileType.audio) ??
        //                             true;
        //                         if (proceed) {
        //                           await widget.controller.insertHtml(
        //                               "<audio controls src='data:audio/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></audio>");
        //                         }
        //                         Navigator.of(context).pop();
        //                       } else {
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaLinkInsertInterceptor
        //                                 ?.call(
        //                                     url.text, InsertFileType.audio) ??
        //                             true;
        //                         if (proceed) {
        //                           await widget.controller.insertHtml(
        //                               "<audio controls src='${url.text}'></audio>");
        //                         }
        //                         Navigator.of(context).pop();
        //                       }
        //                     },
        //                     child: Text('OK'),
        //                   )
        //                 ],
        //               );
        //             }),
        //           );
        //         });
        //   }
        // }
        // if (t.getIcons()[index].icon == Icons.videocam_outlined) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed
        //           ?.call(ButtonType.video, null, null) ??
        //       true;
        //   if (proceed) {
        //     final filename = TextEditingController();
        //     final url = TextEditingController();
        //     final urlFocus = FocusNode();
        //     FilePickerResult? result;
        //     String? validateFailed;
        //     await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return PointerInterceptor(
        //             child: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //               return AlertDialog(
        //                 title: Text('Insert Video'),
        //                 scrollable: true,
        //                 content: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text('Select from files',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextFormField(
        //                           controller: filename,
        //                           readOnly: true,
        //                           decoration: InputDecoration(
        //                             prefixIcon: ElevatedButton(
        //                               style: ElevatedButton.styleFrom(
        //                                   primary: Theme.of(context)
        //                                       .dialogBackgroundColor,
        //                                   padding: EdgeInsets.only(
        //                                       left: 5, right: 5),
        //                                   elevation: 0.0),
        //                               onPressed: () async {
        //                                 result =
        //                                     await FilePicker.platform.pickFiles(
        //                                   type: FileType.video,
        //                                   withData: true,
        //                                   allowedExtensions: widget
        //                                       .toolbarOptions
        //                                       .videoExtensions,
        //                                 );
        //                                 if (result?.files.single.name != null) {
        //                                   setState(() {
        //                                     filename.text =
        //                                         result!.files.single.name;
        //                                   });
        //                                 }
        //                               },
        //                               child: Text('Choose video',
        //                                   style: TextStyle(
        //                                       color: Theme.of(context)
        //                                           .textTheme
        //                                           .bodyText1
        //                                           ?.color)),
        //                             ),
        //                             suffixIcon: result != null
        //                                 ? IconButton(
        //                                     icon: Icon(Icons.close),
        //                                     onPressed: () {
        //                                       setState(() {
        //                                         result = null;
        //                                         filename.text = '';
        //                                       });
        //                                     })
        //                                 : Container(height: 0, width: 0),
        //                             errorText: validateFailed,
        //                             errorMaxLines: 2,
        //                             border: InputBorder.none,
        //                           )),
        //                       SizedBox(height: 20),
        //                       Text('URL',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextField(
        //                         controller: url,
        //                         focusNode: urlFocus,
        //                         textInputAction: TextInputAction.done,
        //                         decoration: InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           hintText: 'URL',
        //                           errorText: validateFailed,
        //                           errorMaxLines: 2,
        //                         ),
        //                       ),
        //                     ]),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () async {
        //                       if (filename.text.isEmpty && url.text.isEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please either choose a video or enter a video URL!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           url.text.isNotEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please input either a video or a video URL, not both!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           result?.files.single.bytes != null) {
        //                         var base64Data =
        //                             base64.encode(result!.files.single.bytes!);
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaUploadInterceptor
        //                                 ?.call(result!.files.single,
        //                                     InsertFileType.video) ??
        //                             true;
        //                         if (proceed) {
        //                           await widget.controller.insertHtml(
        //                               "<video controls src='data:video/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></video>");
        //                         }
        //                         Navigator.of(context).pop();
        //                       } else {
        //                         var proceed = await widget.toolbarOptions
        //                                 .mediaLinkInsertInterceptor
        //                                 ?.call(
        //                                     url.text, InsertFileType.video) ??
        //                             true;
        //                         if (proceed) {
        //                           await widget.controller.insertHtml(
        //                               "<video controls src='${url.text}'></video>");
        //                         }
        //                         Navigator.of(context).pop();
        //                       }
        //                     },
        //                     child: Text('OK'),
        //                   )
        //                 ],
        //               );
        //             }),
        //           );
        //         });
        //   }
        // }
        // if (t.getIcons()[index].icon == Icons.attach_file) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed
        //           ?.call(ButtonType.otherFile, null, null) ??
        //       true;
        //   if (proceed) {
        //     final filename = TextEditingController();
        //     final url = TextEditingController();
        //     final urlFocus = FocusNode();
        //     FilePickerResult? result;
        //     String? validateFailed;
        //     await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return PointerInterceptor(
        //             child: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //               return AlertDialog(
        //                 title: Text('Insert File'),
        //                 scrollable: true,
        //                 content: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text('Select from files',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextFormField(
        //                           controller: filename,
        //                           readOnly: true,
        //                           decoration: InputDecoration(
        //                             prefixIcon: ElevatedButton(
        //                               style: ElevatedButton.styleFrom(
        //                                   primary: Theme.of(context)
        //                                       .dialogBackgroundColor,
        //                                   padding: EdgeInsets.only(
        //                                       left: 5, right: 5),
        //                                   elevation: 0.0),
        //                               onPressed: () async {
        //                                 result =
        //                                     await FilePicker.platform.pickFiles(
        //                                   type: FileType.any,
        //                                   withData: true,
        //                                   allowedExtensions: widget
        //                                       .toolbarOptions
        //                                       .otherFileExtensions,
        //                                 );
        //                                 if (result?.files.single.name != null) {
        //                                   setState(() {
        //                                     filename.text =
        //                                         result!.files.single.name;
        //                                   });
        //                                 }
        //                               },
        //                               child: Text('Choose file',
        //                                   style: TextStyle(
        //                                       color: Theme.of(context)
        //                                           .textTheme
        //                                           .bodyText1
        //                                           ?.color)),
        //                             ),
        //                             suffixIcon: result != null
        //                                 ? IconButton(
        //                                     icon: Icon(Icons.close),
        //                                     onPressed: () {
        //                                       setState(() {
        //                                         result = null;
        //                                         filename.text = '';
        //                                       });
        //                                     })
        //                                 : Container(height: 0, width: 0),
        //                             errorText: validateFailed,
        //                             errorMaxLines: 2,
        //                             border: InputBorder.none,
        //                           )),
        //                       SizedBox(height: 20),
        //                       Text('URL',
        //                           style:
        //                               TextStyle(fontWeight: FontWeight.bold)),
        //                       SizedBox(height: 10),
        //                       TextField(
        //                         controller: url,
        //                         focusNode: urlFocus,
        //                         textInputAction: TextInputAction.done,
        //                         decoration: InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           hintText: 'URL',
        //                           errorText: validateFailed,
        //                           errorMaxLines: 2,
        //                         ),
        //                       ),
        //                     ]),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () {
        //                       if (filename.text.isEmpty && url.text.isEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please either choose a file or enter a file URL!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           url.text.isNotEmpty) {
        //                         setState(() {
        //                           validateFailed =
        //                               'Please input either a file or a file URL, not both!';
        //                         });
        //                       } else if (filename.text.isNotEmpty &&
        //                           result?.files.single.bytes != null) {
        //                         widget.toolbarOptions.onOtherFileUpload
        //                             ?.call(result!.files.single);
        //                         Navigator.of(context).pop();
        //                       } else {
        //                         widget.toolbarOptions.onOtherFileLinkInsert
        //                             ?.call(url.text);
        //                         Navigator.of(context).pop();
        //                       }
        //                     },
        //                     child: Text('OK'),
        //                   )
        //                 ],
        //               );
        //             }),
        //           );
        //         });
        //   }
        // }
        // if (t.getIcons()[index].icon == Icons.table_chart_outlined) {
        //   var proceed = await widget.toolbarOptions.onButtonPressed
        //           ?.call(ButtonType.table, null, null) ??
        //       true;
        //   if (proceed) {
        //     var currentRows = 1;
        //     var currentCols = 1;
        //     await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return PointerInterceptor(
        //             child: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //               return AlertDialog(
        //                 title: Text('Insert Table'),
        //                 scrollable: true,
        //                 content: Row(
        //                     mainAxisSize: MainAxisSize.min,
        //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                     children: [
        //                       NumberPicker(
        //                         value: currentRows,
        //                         minValue: 1,
        //                         maxValue: 10,
        //                         onChanged: (value) =>
        //                             setState(() => currentRows = value),
        //                       ),
        //                       Text('x'),
        //                       NumberPicker(
        //                         value: currentCols,
        //                         minValue: 1,
        //                         maxValue: 10,
        //                         onChanged: (value) =>
        //                             setState(() => currentCols = value),
        //                       ),
        //                     ]),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () async {
        //                       if (kIsWeb) {
        //                         widget.controller
        //                             .insertTable('${currentRows}x$currentCols');
        //                       } else {
        //                         await widget.controller.editorController!
        //                             .evaluateJavascript(
        //                                 source:
        //                                     "\$('#summernote-2').summernote('insertTable', '${currentRows}x$currentCols');");
        //                       }
        //                       Navigator.of(context).pop();
        //                     },
        //                     child: Text('OK'),
        //                   )
        //                 ],
        //               );
        //             }),
        //           );
        //         });
        //   }
        // }
        if (t.getIcons()[index].icon == Icons.horizontal_rule) {
          var proceed = await widget.toolbarOptions.onButtonPressed
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
