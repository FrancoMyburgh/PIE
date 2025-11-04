import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pie/resources/style_constants.dart';

class NetworkErrorAnimation extends StatefulWidget {
  @override
  _NetworkErrorAnimationState createState() => _NetworkErrorAnimationState();
}

class _NetworkErrorAnimationState extends State<NetworkErrorAnimation> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Dialog(
              insetPadding: const EdgeInsets.all(0.0),
              backgroundColor: Colors.white,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: kPiePink, width: 2.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: kPiePink,
                    ),
                    Text(
                      "Connection Lost",
                      style: kPieHeadingStyle,
                    ),
                  ],
                ),
              ),
            ),
            ),
        ),
      ),
    );
  }
}