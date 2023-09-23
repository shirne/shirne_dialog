library controller;

import 'dart:math' show min;

import 'package:combined_animation/combined_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef WrapperBuilder = Widget Function(BuildContext, Widget);

/// abstract controller
abstract class DialogController<T> extends ChangeNotifier
    implements ValueListenable<T> {
  T _value;

  bool get isClose;
  bool _isClosed = false;

  AnimationConfig animate;
  AnimationConfig leaveAnimate;

  DialogController(
    this._value, {
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  })  : animate = animate ?? AnimationConfig.fadeAndZoomIn,
        leaveAnimate = leaveAnimate ??
            (animate == null ? null : ~animate) ??
            AnimationConfig.fadeAndZoomOut;

  void open();
  void close();
  void remove();

  set value(v) {
    _value = v;
    if (_isClosed) return;
    _isClosed = isClose;
    notifyListeners();
    if (isClose) {
      close();
    }
  }

  @override
  T get value => _value;
}

/// controller of any popup use [Overlay] exp. [MyDialog.snack]
abstract class OverlayController<T> extends DialogController<T> {
  Widget child;
  OverlayEntry? entry;
  final OverlayState overlay;
  CombinedAnimationController controller = CombinedAnimationController();

  WrapperBuilder? wrapperBuilder;

  bool showOverlay;
  Color? overlayColor;

  OverlayController(
    T value, {
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
    required this.overlay,
    required this.child,
    this.showOverlay = false,
    this.wrapperBuilder,
    this.overlayColor,
  }) : super(
          value,
          animate: animate,
          leaveAnimate: leaveAnimate,
        );

  @override
  void open() {
    entry ??= OverlayEntry(
      builder: (BuildContext context) {
        final animateChild = CombinedAnimation(
          config: animate,
          leaveConfig: leaveAnimate,
          controller: controller,
          onDismiss: remove,
          dismissDuration: Duration.zero,
          child: child,
        );
        return wrapperBuilder?.call(context, animateChild) ??
            Container(
              color: showOverlay ? (overlayColor ?? Colors.black26) : null,
              child: animateChild,
            );
      },
    );

    overlay.insert(entry!);
  }

  @override
  void close() {
    if (!controller.isLeaved) {
      controller.leave();
    }
  }

  @override
  void remove() {
    controller.dispose();
    entry?.remove();
    dispose();
  }
}

/// controller of [ProgressWidget]
class ProgressController extends OverlayController<double> {
  AnimationController? aController;
  ProgressController(
    Widget child, {
    required OverlayState overlay,
    WrapperBuilder? wrapperBuilder,
    bool? showOverlay,
    Color? overlayColor,
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) : super(
          0,
          overlay: overlay,
          showOverlay: showOverlay ?? true,
          overlayColor: overlayColor,
          wrapperBuilder: wrapperBuilder,
          animate: animate,
          leaveAnimate: leaveAnimate,
          child: child,
        );

  void bind(ac) {
    aController = ac;
  }

  void unbind() {
    aController = null;
  }

  @override
  void remove() {
    unbind();
    super.remove();
  }

  void complete() {
    value = 1;
  }

  @override
  set value(double v) {
    if (isClose) return;
    if (aController == null) {
      super.value = v;
    } else {
      if (!aController!.isCompleted) {
        super.value = aController!.value;
        aController!.stop();
      }
      aController!
          .animateTo(
        v,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      )
          .whenComplete(() {
        super.value = v;
      });
    }
  }

  @override
  double get value => min(1, aController?.value ?? _value);

  @override
  bool get isClose => value >= 1;
}

class EntryController extends OverlayController<bool> {
  EntryController(
    Widget child, {
    required OverlayState overlay,
    WrapperBuilder? wrapperBuilder,
    bool? showOverlay,
    Color? overlayColor,
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) : super(
          false,
          overlay: overlay,
          showOverlay: showOverlay ?? false,
          overlayColor: overlayColor,
          wrapperBuilder: wrapperBuilder,
          animate: animate,
          leaveAnimate: leaveAnimate,
          child: child,
        );

  @override
  bool get isClose => value;
}
