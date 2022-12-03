<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Flutter Rich Text Editor

Rich text editor for Flutter with built-in Voice-to-Text. 

## Under the Hood
This WYCIWYG HTML (not MD) editor is based on [Squire](https://github.com/neilj/Squire) library and offers great flexibility and control over the generated HTML.
<br /><br />
Voice-to-text feature is powered by [speech_to_text](https://pub.dev/packages/speech_to_text) package and comes enabled by default with this package.
To disable voice-to-text feature - set the corresponding top-level attribute within [HtmlEditor] constructor.

## Basic Implementation

```Dart

// 1. Define a var to store changes within parent class or a provider etc...
String result = '';

// ...

// 2. Add HtmlEditor to your build method
HtmlEditor(
    initalValue: 'Hello world!'
    onChanged:(s){
        result = s ?? '';
    }
);
```

## Advanced Implementation

To take advantage of the entire API you'll need to create and configure an instance of [HtmlEditorController]. That instance provides access to the following groups of features:

 * Editor options group (all things editor)
 * Toolbar options group (all things toolbar)
 * Other options group (decoration and explicit height)


### Sizing and Constraints

By default widget is trying to occupy all available width and sizes its height based on the height of its content, but not less than the value of `minHeight` attribute of [HtmlEditor] widget.
<br /><br />
If explicit `height` is provided - the widget will size it's height precisely to the value of `height`. In this case, if content height is lagrer than the widget height - the content becomes scrollable.

### Toolbar Position

All toolbar-related options are contained within [ToolbarOptions] of [HtmlEditorController] class. Toolbar could be positionned:

 * _above_ or _below_ the editor container, by setting the `toolbarPosition` attribute;
 * _locked_ or _collapsing_ on blur by setting the TODO. 
 * _scrollable_, _grid_ or _expandeble_ by setting the `toolbarType` attribute
 * Completely detached from the editor and located anywhere outside the [HtmlEditor]widget. This allows [ToolbarWidget] to be attached to several HtmlEditors. For this type of inplementation please refer to the example. 

### Toolbar Contents and Custom Button Groups

Toolbar button groups could be enabled/disabled via `defaultToolbarButtons` attribute of [HtmlToolbarOptions] class within the controller. You can customize the toolbar by overriding the default value of this attribute.
<br /><br />
Adding your own button groups to the toolbar is very simple - just provide a list of [CustomButtonGroup] objects to the `customButtonGroups` attribute. Each button group will consist of a list of [CustomToolbarButton] objects, each with its own icon, tap callback and an `isSelected` flag to let the toolbar know if the icon button should be highlighted.

## Special Considerations for the Web Platform

To get the toolbar to scroll on Web, you will need to make sure you override the default scroll behaviour:

1. Add the following override class to your app:
    ```Dart
    class MyCustomScrollBehavior extends MaterialScrollBehavior {
    @override
    Set<PointerDeviceKind> get dragDevices => {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
        };
    }

    ```

2. Add the following attribute to the [MaterialApp] widget:

    ```Dart
    return MaterialApp(
        // ...
        scrollBehavior: MyCustomScrollBehavior(),
        // ...
    );

    ```



