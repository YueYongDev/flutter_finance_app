import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int length;
  final int activeIndex;
  final Color activeColor;

  const PageIndicator({
    required this.length,
    required this.activeIndex,
    required this.activeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == activeIndex ? activeColor : Colors.grey,
          ),
        );
      }),
    );
  }
}
