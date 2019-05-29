import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pager_indicator.dart';

class PageDragger extends StatefulWidget {

  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  StreamController<SlideUpdate> slideUpdateStream;


  PageDragger({this.slideUpdateStream, this.canDragLeftToRight, this.canDragRightToLeft});

  @override
  State<StatefulWidget> createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      // 300px以上dragする可能性もあるのでここは0.0 ~ 1.0に範囲を限定する。
      // 右にdragする場合、dxはマイナスになるので、abs()で絶対値を取得してあげる。
      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(
        SlideUpdate(
          UpdateType.dragging,
          slideDirection, 
          slidePercent
        )
      );

      print('Dragging $slideDirection at $slidePercent%');
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(
      SlideUpdate(
        UpdateType.doneDragging,
        SlideDirection.none,
        0.0
      )
    );
    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

enum UpdateType { dragging, doneDragging }

class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(this.updateType, this.direction, this.slidePercent);
}
