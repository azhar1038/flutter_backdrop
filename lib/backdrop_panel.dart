library flutter_backdrop;

import 'package:flutter/material.dart';

class BackdropPanel extends StatelessWidget {
  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget frontHeader;
  final Widget child;
  final BorderRadius borderRadius;
  final ShapeBorder shape;
  final double frontHeaderHeight;
  final EdgeInsets padding;

  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.frontHeader,
    this.child,
    this.shape,
    this.borderRadius,
    this.frontHeaderHeight,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: 12.0,
        borderRadius: borderRadius,
        shape: shape,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //---------------------------HEADER-------------------------
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              onTap: onTap,
              child: Container(
                height: frontHeaderHeight,
                child: frontHeader,
              ),
            ),

            //--------------------REST OF THE BODY----------------------
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

