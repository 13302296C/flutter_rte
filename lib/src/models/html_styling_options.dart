import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Allows to set a pre-defined style for main componennts of the editor
class HtmlStylingOptions {
  /// body text color of the editor when Theme.brightness = `light`
  Color textColorLight;

  /// body text color of the editor when Theme.brightness = `dark`
  Color textColorDark;

  /// getter for body text color based on context (brightness)
  Color textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? textColorLight
          : textColorDark;

  /// get CSS color of body text for injection into HTML style
  String textColorCssString(BuildContext context) =>
      '#${(textColor(context).value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  /// Add contents of your **style.css** file to this variable
  /// to inject global style to the head of the document.
  /// (do NOT add `<style>` tags)
  String? globalStyleSheet;

  /// This defines which tag to use for paragraphs.
  ///
  /// The default value is `p`, however the `div` is also acceptable.
  ///
  /// Other values like `foo`, `bar` and `bonkers` in theory should work
  /// but weren't tested.
  String blockTag;

  /// defines `style` and `class` attributes of a block tag
  HtmlTagAttributes? blockTagAttributes;

  /// internal storage of attribute settings
  final Map<String, HtmlTagAttributes?> _tagSettings = {
    'blockquote': null,
    'code': null,
    'pre': null,
    'ul': null,
    'ol': null,
    'li': null,
    'a': null,
  };

  /// defines `style` and `class` attributes of `<blockquote>` tag
  HtmlTagAttributes? get blockquote => _tagSettings['blockquote'];
  set blockquote(HtmlTagAttributes? attr) => _tagSettings['blockquote'] = attr;

  /// defines `style` and `class` attributes of `<code>` tag
  HtmlTagAttributes? get code => _tagSettings['code'];
  set code(HtmlTagAttributes? attr) => _tagSettings['code'] = attr;

  /// defines `style` and `class` attributes of `<pre>` tag
  HtmlTagAttributes? get pre => _tagSettings['pre'];
  set pre(HtmlTagAttributes? attr) => _tagSettings['pre'] = attr;

  /// defines `style` and `class` attributes of `<ul>` tag
  HtmlTagAttributes? get ul => _tagSettings['ul'];
  set ul(HtmlTagAttributes? attr) => _tagSettings['ul'] = attr;

  /// defines `style` and `class` attributes of `<ol>` tag
  HtmlTagAttributes? get ol => _tagSettings['ol'];
  set ol(HtmlTagAttributes? attr) => _tagSettings['ol'] = attr;

  /// defines `style` and `class` attributes of `<li>` tag
  HtmlTagAttributes? get li => _tagSettings['li'];
  set li(HtmlTagAttributes? attr) => _tagSettings['li'] = attr;

  /// defines `style` and `class` attributes of `<a>` tag
  HtmlTagAttributes? get a => _tagSettings['a'];
  set a(HtmlTagAttributes? attr) => _tagSettings['a'] = attr;

  /// The editor will strip all tags down to plain text if `true`.
  /// Otherwise will paste "as is" at your own risk.
  bool sanitizeOnPaste;

  ///
  HtmlStylingOptions({
    this.globalStyleSheet,
    this.blockTag = 'p',
    this.blockTagAttributes,
    HtmlTagAttributes? blockquote,
    HtmlTagAttributes? code,
    HtmlTagAttributes? pre,
    HtmlTagAttributes? ul,
    HtmlTagAttributes? ol,
    HtmlTagAttributes? li,
    HtmlTagAttributes? a,
    this.sanitizeOnPaste = true,
    this.textColorLight = const Color.fromRGBO(0, 0, 0, 1),
    this.textColorDark = const Color.fromRGBO(0xea, 0xea, 0xea, 1),
  }) {
    _tagSettings['blockquote'] = blockquote;
    _tagSettings['code'] = code;
    _tagSettings['pre'] = pre;
    _tagSettings['ul'] = ul;
    _tagSettings['ol'] = ol;
    _tagSettings['li'] = li;
    _tagSettings['a'] = a;
  }

  /// gets contents of `globalStyleSheet` field prepared for injection
  String get getRootStyleText {
    return globalStyleSheet?.replaceAll('\n', '') ?? '';
  }

  /// Gets Squire config object text ready for injection
  String get options {
    var r = "blockTag: '$blockTag',\n";
    if (blockTagAttributes != null) {
      r += 'blockAttributes: ${blockTagAttributes!.getString},\n';
    }
    r += 'tagAttributes: {\n';
    _tagSettings.forEach((key, value) {
      if (value != null) {
        r += '$key: ${value.getString},\n';
      }
    });
    r += '},\n';
    r += 'isSetHTMLSanitized: $sanitizeOnPaste,\n';
    return r;
  }

  // Imports text (css) from any asset file to place into root `<style>` tag.
  Future<String> importCssFromFile(String asset) async {
    return await rootBundle
        .loadString(asset, cache: false)
        .then((value) => globalStyleSheet = value);
  }
}

/// Defines attribute values for a specific HTML tag.
///
/// if the values are null - the attributes are not injected.
///
///I.e. the Dart definition of
/// ```dart
/// var pAttributes = HtmlTagAttributes(
///     cssClass: 'my-custom-class',
///     inlineStyle: 'text-indent:3.5em; text-align:justify;',
/// );
///
/// ```
///
/// will translate into the following HTML:
///
/// ```html
/// <p class="my-custom-class" style="text-indent:3.5em; text-align:justify;"></p>
/// ```
class HtmlTagAttributes {
  /// sets the `class` attribute value of a tag
  String? cssClass;

  /// sets the inline `style` attribute value of a tag.
  String? inlineStyle;

  ///
  String get getString {
    var a = '';
    if (cssClass != null) {
      a += '\'class\':\'$cssClass\'';
    }
    if (inlineStyle != null) {
      if (a.isNotEmpty) a = '$a, ';
      a += '\'style\':\'$inlineStyle\'';
    }
    return '{ $a }';
  }

  ///
  HtmlTagAttributes({this.cssClass, this.inlineStyle});
}
