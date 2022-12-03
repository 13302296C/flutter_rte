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
This WYCIWYG HTML (not MD) editor is based on [Squire](https://github.com/neilj/Squire) library and offers a great flexibility over the generated HTML.
<br /><br />
Voice-toText feature is powered by [speech_to_text](https://pub.dev/packages/speech_to_text) package and comes enabled by default with this package.
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


### Widget Sizing and Constraints

By default the widget is trying to occupy all available width and sizes its height based on the height of its content, but not less than `minHeight` attribute of [HtmlEditor] widget.
<br /><br />
If explicit heihgt is provided - the widget will size it's height precisely to the height value. If the content height is lagrer than widget height - the content becomes scrollable.

### Toolbar Position

Toolbar could be positionned above or below the editor container, fixed or collapsing on blur. Also, the Toolbar could be located anywhere outside the HtmlEditor widget, and could be attached to different HtmlEditors. For this type of inplementation please refer to the example. All toolbar-related options are contained within [ToolbarOptions] of [HtmlEditorController] class.



## Special Consideration for Web platform

To get the toolbar to scroll on Web, you will need to make sure you override the default scroll behaviour:

1. add the following attribute to the [MaterialApp] widget:

    ```Dart
    return MaterialApp(
        
        // ...

        scrollBehavior: MyCustomScrollBehavior(),
        
        // ...
    );

    ```

2. add that class to to the file where the MaterialApp widget is:
    ```Dart
    class MyCustomScrollBehavior extends MaterialScrollBehavior {
    @override
    Set<PointerDeviceKind> get dragDevices => {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
        };
    }

    ```

