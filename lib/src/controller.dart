import 'dart:async';

import 'package:flutter/material.dart';

abstract class DialogController<T>{
  ValueNotifier<T>? notifier;
  Future<dynamic>? result;

  BuildContext context;
  DialogController.of(this.context, this.notifier);

  void open();
  void update(T _value);
  void close();
  void remove();
}

class ProgressController extends DialogController<int> {
  OverlayEntry? entry;
  ProgressController(BuildContext context, ValueNotifier<int> notifier, [this.entry]) : super.of(context, notifier);

  open() {
    Overlay.of(context)!.insert(entry!);
  }

  update(int value) {
    notifier!.value = value;
  }

  close() {
    notifier!.value = 101;
  }

  remove() {
    if(entry != null) {
      entry!.remove();
    }
  }
}

class ModalController extends DialogController<int> {

  ModalController(BuildContext context, [ValueNotifier<int>? notifier]) : super.of(context, notifier);

  open() {

  }

  update(int value) {}

  close() {
    remove();
  }

  remove() {
    Navigator.pop(context);
  }
}

class EntryController extends DialogController<int> {
  OverlayEntry? entry;

  EntryController(BuildContext context, [ValueNotifier<int>? notifier, this.entry])
      : super.of(context, notifier);

  open() {
    Overlay.of(context)!.insert(entry!);
  }

  update(int value) {}

  close() {
    if(notifier != null)notifier!.value = 101;
    else{
      remove();
    }
  }

  remove() {
    entry!.remove();
  }
}
