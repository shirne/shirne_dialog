library controller;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shirne_dialog.dart';

/// abstract controller
abstract class DialogController<T> implements ValueListenable {
  ValueNotifier<T>? notifier;

  BuildContext context;
  DialogController.of(this.context, this.notifier);

  void open();
  void update(T value);
  void close();
  void remove();

  @override
  void addListener(VoidCallback listener) {
    notifier?.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    notifier?.removeListener(listener);
  }

  @override
  T? get value => notifier?.value;
}

/// controller of [ProgressWidget]
class ProgressController extends DialogController<double> {
  OverlayEntry? entry;
  ProgressController(BuildContext context, ValueNotifier<double> notifier,
      [this.entry])
      : super.of(context, notifier);

  @override
  open() {
    final overlay =
        Overlay.of(context) ?? MyDialog.navigatorKey.currentState?.overlay;
    assert(overlay != null,
        'ProgressController shuld be create within a Overlay context');
    overlay!.insert(entry!);
  }

  @override
  update(double value) {
    notifier!.value = value;
  }

  @override
  close() {
    notifier!.value = 1;
  }

  @override
  remove() {
    if (entry != null) {
      entry!.remove();
    }
  }
}

/// controller of any popup use [Overlay] exp. [MyDialog.snack]
class EntryController extends DialogController<bool> {
  OverlayEntry? entry;

  bool get isClose => notifier?.value ?? false;

  EntryController(BuildContext context,
      [ValueNotifier<bool>? notifier, this.entry])
      : super.of(context, notifier);

  @override
  open() {
    final overlay =
        Overlay.of(context) ?? MyDialog.navigatorKey.currentState?.overlay;
    assert(overlay != null,
        'EntryController shuld be create with a Scaffold context');
    overlay!.insert(entry!);
  }

  @override
  update(bool value) {
    notifier!.value = value;
  }

  @override
  close() {
    if (notifier != null) {
      notifier!.value = false;
    } else {
      remove();
    }
  }

  @override
  remove() {
    entry!.remove();
  }
}
