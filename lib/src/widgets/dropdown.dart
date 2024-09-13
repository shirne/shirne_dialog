import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../shirne_dialog.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.origRect,
    required this.actions,
    this.actionAlignment,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
    this.position,
    this.elevation = 3.0,
    this.animate,
    this.leaveAnimate,
  });

  final double elevation;
  final Rect origRect;
  final List<Widget> actions;
  final CrossAxisAlignment? actionAlignment;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Set<DropDownLayoutPosition>? position;
  final AnimationConfig? animate;
  final AnimationConfig? leaveAnimate;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late final layoutPositionNotifier = ValueNotifier<DropDownLayoutPosition>(
    DropDownLayoutPosition.bottom,
  );

  final triangle = const IsosTriangle(side: 10, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _DropDownLayout(
        origRect: widget.origRect,
        padding: widget.margin,
        position: widget.position,
        cornerHeight: triangle.height,
        layoutPositionNotifier: layoutPositionNotifier,
      ),
      child: GestureDetector(
        onTap: () {},
        child: ValueListenableBuilder<DropDownLayoutPosition>(
          valueListenable: layoutPositionNotifier,
          builder: (context, value, child) {
            return CombinedAnimation(
              config: widget.animate ??
                  AnimationConfig.enter(align: value.startAlign),
              leaveConfig: widget.leaveAnimate,
              //controller: controller,
              child: child!,
            );
          },
          child: Material(
            color: Colors.transparent,
            borderOnForeground: false,
            elevation: widget.elevation,
            shape: DropdownBorder(
              color: Theme.of(context).colorScheme.surface,
              corner: triangle,
              cornerPosition: layoutPositionNotifier,
            ),
            child: Container(
              padding: widget.padding,
              constraints: BoxConstraints(minWidth: widget.origRect.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    widget.actionAlignment ?? CrossAxisAlignment.center,
                children: widget.actions,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IsosTriangle {
  const IsosTriangle({
    required this.side,
    required this.bottom,
    this.radius = const Radius.circular(4.0),
  });

  final double side;
  final double bottom;
  final Radius radius;

  double get height =>
      math.pow(math.pow(side, 2) + math.pow(bottom / 2, 2), 0.5).toDouble();

  IsosTriangle operator *(double t) {
    return IsosTriangle(
      side: side * t,
      bottom: bottom * t,
      radius: Radius.elliptical(radius.x * t, radius.y * t),
    );
  }
}

class DropdownBorder extends ShapeBorder {
  const DropdownBorder({
    this.color = const Color(0xFFffffff),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.corner = const IsosTriangle(side: 10, bottom: 10),
    required this.cornerPosition,
  });

  final Color color;
  final BorderRadius borderRadius;
  final IsosTriangle corner;
  final ValueNotifier<DropDownLayoutPosition> cornerPosition;

  @override
  EdgeInsetsGeometry get dimensions {
    final p = cornerPosition.value.flipped;
    final height = corner.height;
    switch (p) {
      case DropDownLayoutPosition.top:
        return EdgeInsets.only(top: height);
      case DropDownLayoutPosition.left:
        return EdgeInsets.only(left: height);
      case DropDownLayoutPosition.right:
        return EdgeInsets.only(right: height);
      case DropDownLayoutPosition.bottom:
        return EdgeInsets.only(bottom: height);
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(dimensions.resolve(textDirection).deflateRect(rect));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  Path _getPath(Rect rect) {
    final height = corner.height;
    var triggle = Path()
      ..moveTo(-corner.bottom, 0)
      ..conicTo(
        -corner.bottom / 2,
        0,
        -corner.bottom / 4,
        -height / 2,
        1,
      )
      ..conicTo(0, -height, corner.bottom / 4, -height / 2, 1)
      ..conicTo(
        corner.bottom / 2,
        0,
        corner.bottom,
        0,
        1,
      )
      ..close();
    Matrix4? transform;
    Offset position;
    final p = cornerPosition.value.flipped;
    switch (p) {
      case DropDownLayoutPosition.top:
        position = Offset(rect.width / 2, 0);
        break;
      case DropDownLayoutPosition.left:
        transform = Matrix4.identity()..rotateZ(-math.pi / 2);
        position = Offset(0, rect.height / 2);
        break;
      case DropDownLayoutPosition.right:
        transform = Matrix4.identity()..rotateZ(math.pi / 2);
        position = Offset(rect.width, rect.height / 2);
        break;
      case DropDownLayoutPosition.bottom:
        transform = Matrix4.identity()..rotateZ(math.pi);
        position = Offset(rect.width / 2, rect.height);
        break;
    }
    if (transform != null) {
      triggle = triggle.transform(transform.storage);
    }
    return Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      )
      ..addPath(
        triggle,
        position,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()..color = color;
    final path = _getPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return DropdownBorder(
      color: color,
      corner: corner * t,
      borderRadius: BorderRadius.only(
        topLeft: borderRadius.topLeft * t,
        topRight: borderRadius.topRight * t,
        bottomLeft: borderRadius.bottomLeft * t,
        bottomRight: borderRadius.bottomRight * t,
      ),
      cornerPosition: cornerPosition,
    );
  }
}

enum DropDownLayoutPosition {
  top,
  left,
  right,
  bottom;

  DropDownLayoutPosition get flipped {
    switch (this) {
      case top:
        return bottom;
      case left:
        return right;
      case right:
        return left;
      case bottom:
        return top;
    }
  }

  Alignment get startAlign {
    switch (this) {
      case top:
        return const Alignment(0, 0.3);
      case left:
        return const Alignment(0.3, 0);
      case right:
        return const Alignment(-0.3, 0);
      case bottom:
        return const Alignment(0, -0.3);
    }
  }

  static const auto = {bottom, top, right, left};
  static const vertical = {bottom, top};
  static const horizontal = {bottom, top};
}

typedef _PCEntry = MapEntry<DropDownLayoutPosition, BoxConstraints>;

class _DropDownLayout extends SingleChildLayoutDelegate {
  _DropDownLayout({
    required this.origRect,
    required this.padding,
    Set<DropDownLayoutPosition>? position,
    required this.layoutPositionNotifier,
    this.cornerHeight = 10,
  })  : position = position ?? DropDownLayoutPosition.auto,
        assert(position == null || position.isNotEmpty);

  final Rect origRect;
  final Set<DropDownLayoutPosition> position;
  final EdgeInsets padding;
  final ValueNotifier<DropDownLayoutPosition> layoutPositionNotifier;
  final double cornerHeight;

  @override
  Size getSize(BoxConstraints constraints) => constraints.biggest;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      _resolvedConstraints(constraints).value;

  _PCEntry? _resolved;
  _PCEntry _resolvedConstraints(
    BoxConstraints constraints,
  ) {
    if (_resolved != null) {
      return _resolved!;
    }
    final constraintsSets = <DropDownLayoutPosition, BoxConstraints>{};
    for (final p in position) {
      EdgeInsets resolvedPadding;
      switch (p) {
        case DropDownLayoutPosition.top:
          resolvedPadding = padding.copyWith(
            bottom: constraints.maxHeight - origRect.top,
            top: cornerHeight,
          );
          break;
        case DropDownLayoutPosition.left:
          resolvedPadding = padding.copyWith(
            right: constraints.maxWidth - origRect.left,
            left: cornerHeight,
          );
          break;
        case DropDownLayoutPosition.right:
          resolvedPadding = padding.copyWith(
            left: origRect.right,
            right: cornerHeight,
          );
          break;
        case DropDownLayoutPosition.bottom:
          resolvedPadding = padding.copyWith(
            top: origRect.bottom,
            bottom: cornerHeight,
          );
          break;
      }
      final c = constraints.deflate(resolvedPadding).loosen();
      constraintsSets[p] = c;
      if (c.maxWidth >= constraints.maxWidth / 3 &&
          c.maxHeight >= constraints.maxHeight / 3) {
        break;
      }
    }
    _resolved = constraintsSets.entries.fold<_PCEntry>(
      constraintsSets.entries.first,
      bigger,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      layoutPositionNotifier.value = _resolved!.key;
    });
    return _resolved!;
  }

  static _PCEntry bigger(
    _PCEntry a,
    _PCEntry b,
  ) {
    if (b.value.maxWidth > a.value.maxWidth &&
        b.value.maxHeight > a.value.maxHeight) {
      return b;
    }
    if (b.value.maxWidth <= a.value.maxWidth &&
        b.value.maxHeight <= a.value.maxHeight) {
      return a;
    }
    if (b.value.maxWidth * b.value.maxHeight >
        a.value.maxWidth * a.value.maxHeight) {
      return b;
    }
    return a;
  }

  @override
  bool shouldRelayout(covariant _DropDownLayout oldDelegate) =>
      oldDelegate.origRect != origRect ||
      oldDelegate.position != position ||
      oldDelegate.padding != padding;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final pc = _resolvedConstraints(BoxConstraints.loose(size));
    double top = 0;
    double left = 0;
    switch (pc.key) {
      case DropDownLayoutPosition.top:
        top = origRect.top - childSize.height - cornerHeight;
        left = origRect.left + origRect.width / 2 - childSize.width / 2;
        break;
      case DropDownLayoutPosition.left:
        top = origRect.top + childSize.height / 2 - childSize.height / 2;
        left = origRect.left - childSize.width - cornerHeight;
        break;
      case DropDownLayoutPosition.right:
        top = origRect.top + childSize.height / 2 - childSize.height / 2;
        left = origRect.right + cornerHeight;
        break;
      case DropDownLayoutPosition.bottom:
        top = origRect.bottom + cornerHeight;
        left = origRect.left + origRect.width / 2 - childSize.width / 2;
        break;
    }
    if (top + childSize.height > size.height) {
      top = (size.height - childSize.height).clamp(0, double.infinity);
    }
    if (left + childSize.width > size.width) {
      left = (size.width - childSize.width).clamp(0, double.infinity);
    }

    return Offset(left, top);
  }
}
