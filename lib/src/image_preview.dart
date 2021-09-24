library shirne_dialog;

import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String? currentImage;
  final ImageProvider<Object>? placement;

  const ImagePreviewWidget({
    Key? key,
    required this.imageUrls,
    this.currentImage,
    this.placement,
  }) : super(key: key);
  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  int _currentImage = 0;
  late PageController _controller;
  late ImageProvider _placementImage;

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
    _placementImage = MemoryImage(Uint8List.fromList([
      71, 73, 70, 56, 55, 97, 1, 0, 1, 0, 240, 0, 0, 0, 0, 0, 201, 69, 38, //
      33, 249, 4, 1, 0, 0, 1, 0, 44, 0, 0, 0, 00, 1, 0, 1, 0, 0, 2, 2, 76, 1, 0,
      59,
    ]));
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
      backgroundColor: Colors.transparent,
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
              (src) => Center(
                child: FadeInImage(
                  placeholder: widget.placement ?? _placementImage,
                  image: NetworkImage(src),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
