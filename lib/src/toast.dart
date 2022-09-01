library shirne_dialog;

import 'dart:async';

import 'package:flutter/material.dart';

import 'my_dialog.dart';
import 'theme.dart';

const _defaultDuration = Duration(milliseconds: 300);

/// a light weight message tip Widget
class ToastWidget extends StatefulWidget {
  final String message;

  /// dismiss time, in millionseconds
  final int duration;

  /// Icon before text
  final Widget? icon;
  final ToastStyle? style;

  const ToastWidget(
    this.message, {
    Key? key,
    this.duration = 3000,
    this.icon,
    this.style,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToastWidgetState();
}

class _InstanceData {
  final int id;
  final Function(int index) onCountChange;
  _InstanceData(this.id, this.onCountChange);
}

class _ToastGroup {
  final lists = <_InstanceData>[];

  int addItem(Function(int index) onCountChange) {
    final id = lists.isEmpty ? 0 : lists.last.id + 1;
    lists.add(_InstanceData(id, onCountChange));
    onChange();
    return id;
  }

  void onChange() {
    int index = lists.length - 1;
    for (final a in lists) {
      a.onCountChange(index--);
    }
  }

  void removeItem(int id) {
    lists.removeWhere((a) => a.id == id);
    onChange();
  }
}

class _ToastWidgetState extends State<ToastWidget> {
  static final instances = <AlignmentGeometry, _ToastGroup>{};

  late final int instanceId;
  int instanceIndex = 0;

  late ToastStyle style;
  bool willHide = false;

  @override
  void initState() {
    super.initState();
    style = (widget.style ?? MyDialog.theme.toastStyle ?? const ToastStyle())
        .bottomIfNoAlign();
    final group =
        instances.putIfAbsent(style.enterAnimation!.endAlign!, _ToastGroup.new);
    instanceId = group.addItem(onCreateInstance);

    Future.delayed(
        Duration(
          milliseconds: widget.duration - _defaultDuration.inMilliseconds,
        ), () {
      if (!mounted) return;
      setState(() {
        willHide = true;
        if (style.leaveAnimation?.startAlign !=
            style.leaveAnimation?.startAlign) {
          instanceIndex = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    instances[style.enterAnimation!.endAlign!]?.removeItem(instanceId);
    super.dispose();
  }

  /// translate position of this when new toast at the same position
  void onCreateInstance(int index) {
    if (!mounted || willHide) return;

    //使用异步,防止触发时在initState中执行
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        instanceIndex = index;
      });
    });
  }

  /// Whether the alignment is up
  static bool isTop(AlignmentGeometry? alignment) {
    if (alignment != null) {
      if (alignment is Alignment) {
        return alignment.y > 0;
      }
      if (alignment is AlignmentDirectional) {
        return alignment.y > 0;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.message,
      style: TextStyle(
        color: widget.style?.foregroundColor ?? Colors.white,
      ),
    );

    return IgnorePointer(
      ignoring: true,

      // 出入场动画
      child: AnimatedSlide(
        duration: style.enterAnimation?.duration ?? _defaultDuration,
        curve: Curves.easeOut,
        offset: Offset(
          0,
          (isTop(style.enterAnimation?.endAlign) ? -1.2 : 1.2) * instanceIndex,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.style?.backgroundColor ??
                const Color.fromRGBO(0, 0, 0, 0.5),
            shape: BoxShape.rectangle,
            borderRadius:
                widget.style?.borderRadius ?? BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Material(
            color: Colors.transparent,
            child: widget.icon == null
                ? text
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.icon!,
                      const SizedBox(width: 15),
                      text,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
