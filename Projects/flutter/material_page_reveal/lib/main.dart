import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/page.dart';
import 'package:material_page_reveal/page_dragger.dart';
import 'package:material_page_reveal/page_reveal.dart';
import 'package:material_page_reveal/pager_indicator.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<SlideUpdate> _slideUpdateStream;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    _slideUpdateStream = StreamController<SlideUpdate>();

    _slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

          nextPageIndex.clamp(0.0, pages.length - 1);
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5){
            activeIndex = slideDirection == SlideDirection.leftToRight ?
              activeIndex - 1 :
              activeIndex + 1;
          }
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(viewModel: pages[activeIndex], percentVisible: 1.0),
          PageReveal(
              revealPercent: slidePercent,
              child: Page(viewModel: pages[nextPageIndex], percentVisible: slidePercent)),
          PagerIndicator(
            viewModel: PagerIndicatorViewModel(
                pages, activeIndex, slideDirection, slidePercent),
          ),
          PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length -1,
            slideUpdateStream: _slideUpdateStream,
            )
        ],
      ),
    );
  }
}
