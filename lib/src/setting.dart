import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Provide unified parameter settings for various dialogs
class Setting {
  /// detault top position for [MyDialog.toast]
  final Alignment alignTop;

  /// detault bottom position for [MyDialog.toast]
  final Alignment alignBottom;

  /// success icon for [MyDialog.toast]
  final Widget iconSuccess;

  /// error icon for [MyDialog.toast]
  final Widget iconError;

  /// warning icon for [MyDialog.toast]
  final Widget iconWarning;

  /// info icon for [MyDialog.toast]
  final Widget iconInfo;

  /// detault button text for [MyDialog.confirm]
  final String buttonTextOK;

  /// detault button text for [MyDialog.confirm]
  final String buttonTextCancel;

  const Setting({
    this.alignTop = const Alignment(0.0, -0.7),
    this.alignBottom = const Alignment(0.0, 0.7),
    this.iconSuccess = const Icon(
      CupertinoIcons.checkmark_circle_fill,
      color: Colors.green,
    ),
    this.iconError = const Icon(
      CupertinoIcons.multiply_circle_fill,
      color: Colors.red,
    ),
    this.iconWarning = const Icon(
      CupertinoIcons.exclamationmark_triangle_fill,
      color: Colors.deepOrangeAccent,
    ),
    this.iconInfo = const Icon(
      CupertinoIcons.exclamationmark_circle_fill,
      color: Colors.blue,
    ),
    this.buttonTextOK = 'OK',
    this.buttonTextCancel = 'Cancel',
  });
}
