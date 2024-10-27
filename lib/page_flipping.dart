import 'dart:math' as math;

import 'package:e_book_workspace/flip_widget/flip_widget.dart';
import 'package:flutter/material.dart';

class PageFlippingWidget extends StatefulWidget {
  final Widget child;
  final Size size;
  final Function onPageFlipped;

  const PageFlippingWidget({super.key, required this.child, required this.size, required this.onPageFlipped});

  @override
  State<PageFlippingWidget> createState() => _PageFlippingState();
}

class _PageFlippingState extends State<PageFlippingWidget> {
  final double minNumber = 0.008;

  double _clampMin(double v) {
    if (v < minNumber && v > -minNumber) {
      if (v >= 0) {
        v = minNumber;
      } else {
        v = -minNumber;
      }
    }
    return v;
  }

  GlobalKey<FlipWidgetState> _flipKey = GlobalKey();
  Offset _oldPosition = Offset.zero;

  double screenWidth = 0.0;
  double swipeDistance = 0.0;
  bool hasReachedOneThird = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('size of page flipping widget ${widget.size}');
    screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: FlipWidget(
        key: _flipKey,
        textureSize: widget.size * 2,
        child: widget.child,
        // leftToRight: true,
      ),
      onHorizontalDragStart: (details) {
        print('onHorizontalDragStart ${details.globalPosition.dx},${details.globalPosition.dy}');
        _oldPosition = details.globalPosition;
        _flipKey.currentState?.startFlip();
      },
      onHorizontalDragUpdate: (details) {
        print('details update ${details.globalPosition.dx},${details.globalPosition.dy}');
        Offset off = details.globalPosition - _oldPosition;
        print('offset $off');
        double tilt = 1 / _clampMin((-off.dy + 20) / 100);
        double percent = math.max(0, -off.dx / widget.size.width * 1.4);
        percent = percent - percent / 2 * (1 - 1 / tilt);
        _flipKey.currentState?.flip(percent, tilt);
        setState(() {
          swipeDistance += details.delta.dx;
          // Check if swipe distance is greater than or equal to 1/3 of the screen width
          if (!hasReachedOneThird && swipeDistance.abs() >= screenWidth / 2) {
            hasReachedOneThird = true;
            widget.onPageFlipped();
            print("Swiped 1/3 of the screen width!");
          }
        });
      },
      onHorizontalDragEnd: (details) {
        _flipKey.currentState?.stopFlip();
        print('details end ${details.globalPosition.dx},${details.globalPosition.dy}');
        print("stopFlipping");
        setState(() {
          swipeDistance = 0.0;
          hasReachedOneThird = false;
        });
      },
      onHorizontalDragCancel: () {
        _flipKey.currentState?.stopFlip();
        print("cancelFlipping");
      },
    );
  }
}
