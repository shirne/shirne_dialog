import 'dart:ui' as ui;

import 'package:combined_animation/combined_animation.dart';
import 'package:flutter/material.dart';

import 'dialog_icons.dart';
import 'my_dialog.dart';

/// Provide unified parameter settings for various dialogs
class ShirneDialogTheme extends ThemeExtension<ShirneDialogTheme> {
  /// detault top position for [MyDialog.toast]
  final Alignment alignTop;

  /// default bottom position for [MyDialog.toast]
  final Alignment alignBottom;

  /// success icon for [MyDialog.toast]
  final Widget iconSuccess;

  /// error icon for [MyDialog.toast]
  final Widget iconError;

  /// warning icon for [MyDialog.toast]
  final Widget iconWarning;

  /// info icon for [MyDialog.toast]
  final Widget iconInfo;

  /// help icon for [MyDialog.toast]
  final Widget iconHelp;

  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? cancelButtonStyle;

  final ModalStyle? modalStyle;
  final ToastStyle? toastStyle;
  final SnackStyle? snackStyle;

  const ShirneDialogTheme({
    this.alignTop = const Alignment(0.0, -0.7),
    this.alignBottom = const Alignment(0.0, 0.7),
    this.iconSuccess = const Icon(
      DialogIcons.checkmarkFill,
      color: Colors.green,
    ),
    this.iconError = const Icon(
      DialogIcons.closeFill,
      color: Colors.red,
    ),
    this.iconWarning = const Icon(
      DialogIcons.warningFill,
      color: Colors.deepOrangeAccent,
    ),
    this.iconInfo = const Icon(
      DialogIcons.informationFill,
      color: Colors.blue,
    ),
    this.iconHelp = const Icon(
      DialogIcons.helpFill,
      color: Colors.blue,
    ),
    this.primaryButtonStyle,
    this.cancelButtonStyle,
    this.modalStyle = const ModalStyle(),
    this.toastStyle = const ToastStyle(),
    this.snackStyle = const SnackStyle(),
  });

  /// Creates a copy of this theme
  /// but with the given fields replaced with the new values.
  @override
  ThemeExtension<ShirneDialogTheme> copyWith({
    Alignment? alignTop,
    Alignment? alignBottom,
    Icon? iconSuccess,
    Icon? iconError,
    Icon? iconWarning,
    Icon? iconInfo,
    Icon? iconHelp,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? cancelButtonStyle,
    ModalStyle? modalStyle,
  }) {
    return ShirneDialogTheme(
      alignTop: alignTop ?? this.alignTop,
      alignBottom: alignBottom ?? this.alignBottom,
      iconSuccess: iconSuccess ?? this.iconSuccess,
      iconError: iconError ?? this.iconError,
      iconWarning: iconWarning ?? this.iconWarning,
      iconInfo: iconInfo ?? this.iconInfo,
      iconHelp: iconHelp ?? this.iconHelp,
      primaryButtonStyle: primaryButtonStyle ?? this.primaryButtonStyle,
      cancelButtonStyle: cancelButtonStyle ?? this.cancelButtonStyle,
      modalStyle: modalStyle ?? this.modalStyle,
    );
  }

  /// TODO
  @override
  ThemeExtension<ShirneDialogTheme> lerp(
      ThemeExtension<ShirneDialogTheme>? other, double t) {
    final o = other as ShirneDialogTheme?;
    return ShirneDialogTheme(
      alignTop: Alignment.lerp(alignTop, o?.alignTop, t) ?? alignTop,
      alignBottom:
          Alignment.lerp(alignBottom, o?.alignBottom, t) ?? alignBottom,
      iconSuccess: t < 0.5 ? iconSuccess : o?.iconSuccess ?? iconSuccess,
      iconError: t < 0.5 ? iconError : o?.iconError ?? iconError,
      iconWarning: t < 0.5 ? iconWarning : o?.iconWarning ?? iconWarning,
      iconInfo: t < 0.5 ? iconInfo : o?.iconInfo ?? iconInfo,
      iconHelp: t < 0.5 ? iconHelp : o?.iconHelp ?? iconHelp,
      primaryButtonStyle:
          ButtonStyle.lerp(primaryButtonStyle, o?.primaryButtonStyle, t) ??
              primaryButtonStyle,
      cancelButtonStyle:
          ButtonStyle.lerp(cancelButtonStyle, o?.cancelButtonStyle, t) ??
              cancelButtonStyle,
      modalStyle: ModalStyle.lerp(modalStyle, o?.modalStyle, t),
      toastStyle: ToastStyle.lerp(toastStyle, o?.toastStyle, t),
      snackStyle: SnackStyle.lerp(snackStyle, o?.snackStyle, t),
    );
  }
}

/// Style for modal
class ModalStyle {
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

  const ModalStyle({
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

  /// Creates a copy of this style
  /// but with the given fields replaced with the new values.
  ModalStyle copyWith({
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    EdgeInsets? contentPadding,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    Color? backgroundColor,
    double? elevation,
    String? semanticLabel,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    ShapeBorder? shape,
    bool? scrollable,
  }) =>
      ModalStyle(
        titlePadding: titlePadding ?? this.titlePadding,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        contentPadding: contentPadding ?? this.contentPadding,
        contentTextStyle: contentTextStyle ?? this.contentTextStyle,
        actionsPadding: actionsPadding ?? this.actionsPadding,
        actionsAlignment: actionsAlignment ?? this.actionsAlignment,
        actionsOverflowDirection:
            actionsOverflowDirection ?? this.actionsOverflowDirection,
        actionsOverflowButtonSpacing:
            actionsOverflowButtonSpacing ?? this.actionsOverflowButtonSpacing,
        buttonPadding: buttonPadding ?? this.buttonPadding,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        elevation: elevation ?? this.elevation,
        semanticLabel: semanticLabel ?? this.semanticLabel,
        insetPadding: insetPadding ?? this.insetPadding,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        shape: shape ?? this.shape,
        scrollable: scrollable ?? this.scrollable,
      );

  static ModalStyle lerp(ModalStyle? a, ModalStyle? b, double t) {
    return ModalStyle(
      titlePadding:
          EdgeInsetsGeometry.lerp(a?.titlePadding, b?.titlePadding, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      contentPadding:
          EdgeInsets.lerp(a?.contentPadding, b?.contentPadding, t) ??
              EdgeInsets.zero,
      contentTextStyle:
          TextStyle.lerp(a?.contentTextStyle, b?.contentTextStyle, t),
      actionsPadding:
          EdgeInsetsGeometry.lerp(a?.actionsPadding, b?.actionsPadding, t) ??
              EdgeInsets.zero,
      actionsAlignment: t < 0.5 ? a?.actionsAlignment : b?.actionsAlignment,
      actionsOverflowDirection:
          t < 0.5 ? a?.actionsOverflowDirection : b?.actionsOverflowDirection,
      actionsOverflowButtonSpacing: ui.lerpDouble(
          a?.actionsOverflowButtonSpacing ?? 0,
          b?.actionsOverflowButtonSpacing ?? 0,
          t),
      buttonPadding:
          EdgeInsetsGeometry.lerp(a?.buttonPadding, b?.buttonPadding, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: ui.lerpDouble(a?.elevation, b?.elevation, t),
      semanticLabel: t < 0.5 ? a?.semanticLabel : b?.semanticLabel,
      insetPadding: EdgeInsets.lerp(a?.insetPadding, b?.insetPadding, t) ??
          EdgeInsets.zero,
      clipBehavior: (t < 0.5 ? a?.clipBehavior : b?.clipBehavior) ?? Clip.none,
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      scrollable: (t < 0.5 ? a?.scrollable : b?.scrollable) ?? false,
    );
  }
}

/// Style for [ToastWidget]
class ToastStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final AnimationConfig? animationIn;
  final AnimationConfig? animationOut;

  const ToastStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.animationIn,
    this.animationOut,
  });
  ToastStyle topIfNoAlign() {
    if (animationIn?.alignEnd != null) return this;
    return _reAlign(MyDialog.theme.alignTop, const Alignment(0, -1.2));
  }

  ToastStyle top() {
    return _reAlign(MyDialog.theme.alignTop, const Alignment(0, -1.2));
  }

  ToastStyle bottomIfNoAlign() {
    if (animationIn?.alignEnd != null) return this;
    return _reAlign(MyDialog.theme.alignBottom, const Alignment(0, 1.2));
  }

  ToastStyle bottom() {
    return _reAlign(MyDialog.theme.alignBottom, const Alignment(0, 1.2));
  }

  ToastStyle _reAlign(Alignment align, Alignment out) {
    return copyWith(
      animationIn: (animationIn ?? AnimationConfig.fadeAndZoomIn).copyWith(
        alignStart:
            (animationIn?.alignStart == animationIn?.alignEnd) ? align : out,
        alignEnd: align,
      ),
      animationOut: (animationOut ?? AnimationConfig.fadeAndZoomOut).copyWith(
        alignStart:
            (animationOut?.alignStart == animationOut?.alignEnd) ? align : out,
        alignEnd: align,
      ),
    );
  }

  /// Creates a copy of this style
  /// but with the given fields replaced with the new values.
  ToastStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    AnimationConfig? animationIn,
    AnimationConfig? animationOut,
  }) =>
      ToastStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        animationIn: animationIn ?? this.animationIn,
        animationOut: animationOut ?? this.animationOut,
      );

  static ToastStyle lerp(ToastStyle? a, ToastStyle? b, double t) {
    return ToastStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      animationIn: t < 0.5 ? a?.animationIn : b?.animationIn,
      animationOut: t < 0.5 ? a?.animationOut : b?.animationOut,
    );
  }
}

/// Style for [SnackWidget]
class SnackStyle {
  final Gradient? gradient;
  final BoxDecoration? decoration;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  const SnackStyle({
    this.height,
    this.gradient,
    this.decoration,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  /// Creates a copy of this style
  /// but with the given fields replaced with the new values.
  SnackStyle copyWith({
    Gradient? gradient,
    BoxDecoration? decoration,
    double? height,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
  }) =>
      SnackStyle(
        gradient: gradient ?? this.gradient,
        decoration: decoration ?? this.decoration,
        height: height ?? this.height,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  static SnackStyle lerp(SnackStyle? a, SnackStyle? b, double t) {
    return SnackStyle(
      gradient: Gradient.lerp(a?.gradient, b?.gradient, t),
      decoration: BoxDecoration.lerp(a?.decoration, b?.decoration, t),
      height: ui.lerpDouble(a?.height, b?.height, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
    );
  }
}
