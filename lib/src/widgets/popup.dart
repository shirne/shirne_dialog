library shirne_dialog;

import 'package:flutter/material.dart';

import '../theme.dart';

/// A popup Widget wrapper
class PopupWidget extends StatefulWidget {
  /// 弹出内容
  final Widget? child;

  /// 弹出层高度，不设置随内容而定，受最大高度限制
  final double? height;

  /// 弹出层最大高度，默认减去 toolBarHeight及statusBarheight
  final double? maxHeight;

  /// 自定义的弹窗背景样式
  final PopupStyle? style;

  /// 关闭按钮的语义化
  final String? closeSemanticsLabel;

  /// 指定的关闭按钮组件
  final Widget? closeButton;

  const PopupWidget({
    Key? key,
    this.child,
    this.height,
    this.maxHeight,
    this.style,
    this.closeButton,
    this.closeSemanticsLabel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  double? height;

  @override
  void initState() {
    super.initState();
    if (widget.height != null) height = widget.height!;
  }

  @override
  Widget build(BuildContext context) {
    final mediaData = MediaQuery.of(context);
    if (height != null) {
      if (height! <= 0) {
        // 按具体高度
        height = mediaData.size.height * 0.8;
      } else if (height! < 1) {
        // 按屏高百分比
        height = mediaData.size.height * height!;
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height ?? 0,
        maxHeight: widget.maxHeight ??
            mediaData.size.height - kToolbarHeight - mediaData.padding.top,
      ),
      child: Container(
        height: height,
        margin: widget.style?.margin,
        decoration: widget.style?.decoration ??
            BoxDecoration(
              color: widget.style?.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.style?.borderRadius ?? 16.0),
                topRight: Radius.circular(widget.style?.borderRadius ?? 16.0),
              ),
            ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Center(
                child: widget.style?.dragHandlerBuilder?.call(context) ??
                    Container(
                      width: 128,
                      height: 6.0,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: widget.style?.padding ??
                  const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 32.0,
                    bottom: 16.0,
                  ),
              child: widget.child,
            ),
            if (widget.style?.showClose ?? true)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: widget.style?.closeButtonBuilder?.call(context) ??
                      Semantics(
                        button: true,
                        label: widget.closeSemanticsLabel ?? 'close',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.closeButton ??
                              const Icon(
                                Icons.cancel,
                                color: Colors.black38,
                              ),
                        ),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
