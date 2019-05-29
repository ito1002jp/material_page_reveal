import 'dart:math';

import 'package:flutter/material.dart';


class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  const PageReveal({Key key, this.revealPercent, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}


class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    // clipperの位置を計算する。
    final epicenter = Offset(size.width/2, size.height * 0.9);
    // Calculate distance from epicenter to the top left corner to make sure we fill the screen.
    double theta = atan(epicenter.dy / epicenter.dx);
    // コーナーギリギリまでの距離を算出し、それの数字に対してパーセンテージをかけることで次第にclipperが大きくなる。
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

   return new Rect.fromLTWH(epicenter.dx - radius, epicenter.dy - radius, diameter, diameter); 

  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }


}