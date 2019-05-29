import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/page.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  const PagerIndicator({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; ++i) {
      var page = viewModel.pages[i];

      var activePercent;
      if (i == viewModel.activeIndex) {
        activePercent = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
        activePercent = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
        activePercent = viewModel.slidePercent;
      } else {
        activePercent = 0.0;
      }

      bool isHallow = i > viewModel.activeIndex 
      || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            page.iconAssetIcon, 
            page.color, 
            isHallow,
            activePercent),
        ),
      );
    }

    final BUBBLE_WIDTH = 55.0;
    final baseTranslation = (viewModel.pages.length * BUBBLE_WIDTH / 2) - (BUBBLE_WIDTH / 2);
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);

    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }
 
    return Column(
      children: <Widget>[
        Expanded(child: Container(),),
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
            ),
        )
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}


class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  const PageBubble({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
            width: lerpDouble(20.0, 45.0, viewModel.activePercent),
            height: lerpDouble(20.0, 45.0, viewModel.activePercent),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: viewModel.isHollow
                    ? const Color(0x88FFFFFF).withAlpha((0x88 * viewModel.activePercent).round())
                    : const Color(0x88FFFFFF),
                border: Border.all(
                  color: viewModel.isHollow
                      ? const Color(0x88FFFFFF).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round())

                      : Colors.transparent,
                  width: 3.0,
                )),
            child: Opacity(
              opacity: viewModel.activePercent,
              child: Image.asset(
                viewModel.iconAssetPath,
                color: viewModel.color,
              ),
            )),
      ),
    );
  }
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.iconAssetPath, this.color, this.isHollow, this.activePercent);
}
