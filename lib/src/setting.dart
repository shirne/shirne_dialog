import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Provide unified parameter settings for various dialogs
class MyDialogSetting {
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

  final ModalSetting? modalSetting;

  const MyDialogSetting({
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
    this.modalSetting,
  });
}

class ModalSetting {
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final EdgeInsets contentPadding;
  final TextStyle? contentTextStyle;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final bool scrollable;

  const ModalSetting({
    this.titlePadding,
    this.titleTextStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
    this.clipBehavior = Clip.none,
    this.shape,
    this.scrollable = false,
  });
}
