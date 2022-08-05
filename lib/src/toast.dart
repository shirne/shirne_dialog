library shirne_dialog;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

const _animateDuration = 300;

/// a light weight message tip Widget
class ToastWidget extends StatefulWidget {
  final String message;

  /// dismiss time, in millionseconds
  final int duration;

  /// Icon before text
  final Widget? icon;
  final Alignment alignment;
  final ToastStyle? style;

  const ToastWidget(
    this.message, {
    Key? key,
    this.alignment = Alignment.center,
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
    int id = lists.isEmpty ? 0 : lists.last.id + 1;
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
  static final instances = <Alignment, _ToastGroup>{};

  late final int instanceId;
  int instanceIndex = 0;

  late Alignment alignment;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    final group = instances.putIfAbsent(widget.alignment, () => _ToastGroup());
    instanceId = group.addItem(onCreateInstance);

    if (widget.alignment.y > 0) {
      alignment = Alignment.bottomCenter;
    } else {
      alignment = Alignment.topCenter;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        alignment = widget.alignment;
      });
    });

    Future.delayed(Duration(milliseconds: widget.duration - _animateDuration),
        () {
      if (!mounted) return;
      setState(() {
        opacity = 0;
      });
    });
  }

  @override
  void dispose() {
    instances[widget.alignment]?.removeItem(instanceId);
    super.dispose();
  }

  onCreateInstance(int index) {
    if (!mounted) return;
    //使用异步,防止触发时在initState中执行
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        instanceIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const aDuration = Duration(milliseconds: _animateDuration);

    final text = Text(
      widget.message,
      style: TextStyle(
        color: widget.style?.foregroundColor ?? Colors.white,
      ),
    );

    return IgnorePointer(
      ignoring: true,
      // 入场动画
      child: AnimatedAlign(
        duration: aDuration,
        curve: Curves.easeOutQuart,
        alignment: alignment,
        // 叠加动画
        child: AnimatedSlide(
          duration: aDuration,
          curve: Curves.easeOut,
          offset: Offset(
            0,
            (widget.alignment.y > 0 ? -1.2 : 1.2) * instanceIndex,
          ),
          // 出场动画
          child: AnimatedOpacity(
            opacity: opacity,
            duration: aDuration,
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
        ),
      ),
    );
  }
}
