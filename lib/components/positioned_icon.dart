import 'package:flutter/material.dart';

class PositionedIcon extends StatelessWidget {
  const PositionedIcon(
      {Key? key,
      this.bottom,
      this.color,
      required this.icon,
      this.onTap,
      this.right,
      this.top})
      : super(key: key);
  final double? top;
  final double? right;
  final double? bottom;
  final void Function()? onTap;
  final IconData icon;
  final MaterialColor? color;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Ink(
            height: 35,
            width: 35,
            decoration: ShapeDecoration(
              color: color ?? Colors.lightBlue,
              shape: const CircleBorder(),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
