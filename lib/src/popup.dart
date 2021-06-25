library shirne_dialog;

import 'package:flutter/material.dart';

import 'controller.dart';

/// A popup Widget wrapper
class PopupWidget extends StatefulWidget {
  final Widget? child;
  final double? height;
  final double borderRound;
  final EdgeInsetsGeometry padding;
  final DialogController? controller;
  final bool showClose;
  final Widget closeButton;
  final Color backgroundColor;

  const PopupWidget({
    Key? key,
    this.child,
    this.height,
    this.controller,
    this.borderRound = 10,
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor = Colors.white,
    this.showClose = true,
    this.closeButton = const Icon(Icons.cancel),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  double height = 0;

  @override
  void initState() {
    super.initState();
    if (widget.height != null) height = widget.height!;

    if (widget.controller!.notifier != null) {
      widget.controller!.notifier!.addListener(_onController);
    }
  }

  void _onController() {
    if (widget.controller!.notifier!.value == 101) {
      print('will close');
      _close();
    }
  }

  void _close() {
    if (widget.controller!.notifier != null) {
      widget.controller!.notifier!.removeListener(_onController);
    }
    widget.controller!.remove();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(size);
    if (height <= 0) {
      // 按具体高度
      height = size.height * 0.8;
    } else if (height < 1) {
      // 按屏高百分比
      height = size.height * height;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.borderRound),
          topRight: Radius.circular(widget.borderRound),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Padding(
            padding: widget.padding,
            child: widget.child,
          ),
          Align(
            alignment: Alignment.topRight,
            child: widget.showClose
                ? GestureDetector(
                    onTap: () {
                      _close();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: widget.closeButton,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
