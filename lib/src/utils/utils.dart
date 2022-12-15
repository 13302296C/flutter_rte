import 'dart:convert';
import 'dart:math';
import 'package:flutter_rte/flutter_rte.dart';

/// small function to always check if mounted before running setState()
void setState(
    bool mounted, void Function(Function()) setState, void Function() fn) {
  if (mounted) {
    setState.call(fn);
  }
}

/// courtesy of @modulovalue (https://github.com/modulovalue/dart_intersperse/blob/master/lib/src/intersperse.dart)
/// intersperses elements in between list items - used to insert dividers between
/// toolbar buttons when using [ToolbarType.nativeScrollable]
Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}

/// Generates a random string to be used as the [VisibilityDetector] key.
/// Technically this limits the number of editors to a finite number, but
/// nobody will be embedding enough editors to reach the theoretical limit
/// (yes, this is a challenge ;-) )
String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

/// Class to create a script that can be run on Flutter Web.
///
/// [name] provides a unique identifier for the script. Note: It must be unique!
/// Otherwise your script may not be called when using [controller.evaluateJavascriptWeb].
/// [script] provides the script itself. If you'd like to return a value back to
/// Dart, you can do that via a postMessage call (see the README for an example).
class WebScript {
  String name;
  String script;

  WebScript({
    required this.name,
    required this.script,
  }) : assert(name.isNotEmpty && script.isNotEmpty);
}
