// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {});

  /// HTML for testing DOMPurify library
  String dirtyTestHtml = '''
<img src=x onerror=alert(1)//>
<svg><g/onload=alert(2)//<p>
<p>abc<iframe//src=jAva&Tab;script:alert(3)>def</p>
<math><mi//xlink:href="data:x,<script>alert(4)</script>
<TABLE><tr><td>HELLO</tr></TABL>
<UL><li><A HREF=//google.com>click</UL>
''';

  /// The expected result after sanitization
  String sanitizedTestResult = '''
<img src="x">
<svg><g></g></svg>
<p>abc</p>
<math><mi></mi></math>
<table><tbody><tr><td>HELLO</td></tr></tbody></table>
<ul><li><a href="//google.com">click</a></li></ul>
''';
}
