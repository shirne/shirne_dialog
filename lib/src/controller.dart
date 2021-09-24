library shirne_dialog.controller;

import 'dart:async';

import 'package:flutter/material.dart';

/// abstract controller
abstract class DialogController<T> {
  ValueNotifier<T>? notifier;
  Future<dynamic>? result;

  BuildContext context;
  DialogController.of(this.context, this.notifier);

  void open();
  void update(T value);
  void close();
  void remove();
}

/// controller of [ProgressWidget]
class ProgressController extends DialogController<int> {
  OverlayEntry? entry;
  ProgressController(BuildContext context, ValueNotifier<int> notifier,
      [this.entry])
      : super.of(context, notifier);

  @override
  open() {
    Overlay.of(context)!.insert(entry!);
  }

  @override
  update(int value) {
    notifier!.value = value;
  }

  @override
  close() {
    notifier!.value = 101;
  }

  @override
  remove() {
    if (entry != null) {
      entry!.remove();
    }
  }
}

/// controller of any popup use [Overlay] exp. [MyDialog.snack]
class EntryController extends DialogController<int> {
  OverlayEntry? entry;

  EntryController(BuildContext context,
      [ValueNotifier<int>? notifier, this.entry])
      : super.of(context, notifier);

  @override
  open() {
    Overlay.of(context)!.insert(entry!);
  }

  @override
  update(int value) {}

  @override
  close() {
    if (notifier != null) {
      notifier!.value = 101;
    } else {
      remove();
    }
  }

  @override
  remove() {
    entry!.remove();
  }
}
