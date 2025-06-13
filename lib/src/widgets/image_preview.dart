library shirne_dialog;

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../shirne_dialog.dart';

final _placementImage = MemoryImage(
  Uint8List.fromList([
    71, 73, 70, 56, 55, 97, 1, 0, 1, 0, 240, 0, 0, 0, 0, 0, 201, 69, 38, //
    33, 249, 4, 1, 0, 0, 1, 0, 44, 0, 0, 0, 00, 1, 0, 1, 0, 0, 2, 2, 76, 1,
    0,
    59,
  ]),
);

class ImageAutoPreview extends StatefulWidget {
  const ImageAutoPreview({
    required this.src,
    super.key,
    this.group,
    this.placeholder,
  });

  final String src;

  final String? group;

  final ImageProvider<Object>? placeholder;

  @override
  State<ImageAutoPreview> createState() => _ImageAutoPreviewState();
}

class _ImageAutoPreviewState extends State<ImageAutoPreview> {
  static final previewImages = <ImageAutoPreview>[];

  @override
  void initState() {
    super.initState();
    previewImages.add(widget);
  }

  @override
  void dispose() {
    previewImages.remove(widget);
    super.dispose();
  }

  ImageProvider<Object> getImage(String src) {
    if (src.startsWith('assets/')) {
      return AssetImage(src);
    }
    return NetworkImage(src);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapUp: (details) {
          final images = previewImages
              .where((e) => e.group == widget.group)
              .map<String>((e) => e.src)
              .toList();
          final ele = context as Element;
          MyDialog.imagePreview(
            images,
            currentImage: widget.src,
            startRect: Rect.fromLTWH(
              details.globalPosition.dx - details.localPosition.dx,
              details.globalPosition.dy - details.localPosition.dy,
              ele.size!.width,
              ele.size!.height,
            ),
          );
        },
        child: FadeInImage(
          placeholder: widget.placeholder ?? _placementImage,
          image: getImage(widget.src),
        ),
      );
}

class ImagePreviewWidget extends StatefulWidget {
  const ImagePreviewWidget({
    super.key,
    required this.imageUrls,
    this.currentImage,
    this.placement,
    this.backgroundColor,
    this.startRect,
  });
  final List<String> imageUrls;
  final String? currentImage;
  final ImageProvider<Object>? placement;
  final Color? backgroundColor;
  final Rect? startRect;
  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  int _currentImage = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.currentImage != null && widget.currentImage!.isNotEmpty) {
      _currentImage = widget.imageUrls.indexOf(widget.currentImage!);
      if (_currentImage < 0) {
        _currentImage = 0;
      }
    }

    _controller = PageController(initialPage: _currentImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: widget.backgroundColor ?? Colors.black54,
      floatingActionButton: Text(
        "${_currentImage + 1}/${widget.imageUrls.length}",
        style: const TextStyle(color: Colors.white),
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentImage = index;
          });
        },
        children: widget.imageUrls
            .map<Widget>(
              (src) => _ImageItem(
                src,
                widget.placement,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  const _ImageItem(this.src, this.placement);
  final String src;
  final ImageProvider<Object>? placement;

  @override
  Widget build(BuildContext context) {
    final image = FadeInImage(
      placeholder: placement ?? _placementImage,
      image: NetworkImage(src),
    );
    return Center(
      child: image,
    );
  }
}
