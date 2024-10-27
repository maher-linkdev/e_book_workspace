import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class PageFlipCustom extends StatefulWidget {
  @override
  _PageFlipCustomState createState() => _PageFlipCustomState();
}

class _PageFlipCustomState extends State<PageFlipCustom> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final controller = TurnPageController();
    return Scaffold(
      body: TurnPageView.builder(
        controller: controller,
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          color: Colors.red,
          child: Center(
            child: Text("hello World! $index"),
          ),
        ),
        overleafColorBuilder: (index) => Colors.grey,
        animationTransitionPoint: 0.5,
        onSwipe: (isSwipe) {
          print("on swipe $isSwipe");
        },
      ),
    );
  }
}
