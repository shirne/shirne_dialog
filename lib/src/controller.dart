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
  bool get isClosed => _isClosed;

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

  @mustCallSuper
  void close() {
    _isClosed = true;
  }

  void remove();

  set value(T v) {
    _value = v;
    if (_isClosed) return;
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
  OverlayController(
    super.value, {
    super.animate,
    super.leaveAnimate,
    required this.overlay,
    required this.child,
    this.showOverlay = false,
    this.wrapperBuilder,
    this.overlayColor,
  });

  final Widget child;
  final OverlayState overlay;
  final controller = CombinedAnimationController();

  final WrapperBuilder? wrapperBuilder;

  final bool showOverlay;
  final Color? overlayColor;

  OverlayEntry? entry;

  @override
  void open() {
    if (isClosed) return;
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
    if (isClosed) return;
    if (!controller.isEntered) {
      remove();
    } else if (!controller.isLeaved) {
      controller.leave();
    }
    super.close();
  }

  bool _isRemoved = false;
  @override
  void remove() {
    if (_isRemoved) return;
    _isRemoved = true;
    controller.dispose();
    entry?.remove();
    dispose();
  }
}

/// controller of [ProgressWidget]
class ProgressController extends OverlayController<double> {
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

  AnimationController? aController;

  void bind(AnimationController ac) {
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
