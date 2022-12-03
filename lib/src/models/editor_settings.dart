import 'package:flutter/material.dart';

/// Class that helps pass editor settings to the [onSettingsChange] callback
class EditorSettings {
  String parentElement;
  String fontName;
  double fontSize;
  bool isBold;
  bool isItalic;
  bool isUnderline;
  bool isStrikethrough;
  bool isSuperscript;
  bool isSubscript;
  Color foregroundColor;
  Color backgroundColor;
  bool isUl;
  bool isOl;
  bool isLink;
  bool isAlignLeft;
  bool isAlignCenter;
  bool isAlignRight;
  bool isAlignJustify;
  double lineHeight;
  TextDirection textDirection;

  EditorSettings({
    required this.parentElement,
    required this.fontName,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isStrikethrough,
    required this.isSuperscript,
    required this.isSubscript,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.isUl,
    required this.isOl,
    required this.isLink,
    required this.isAlignLeft,
    required this.isAlignCenter,
    required this.isAlignRight,
    required this.isAlignJustify,
    required this.lineHeight,
    required this.textDirection,
  });
}
