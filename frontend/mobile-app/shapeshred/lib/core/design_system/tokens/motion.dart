import 'package:flutter/material.dart';

abstract class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 400);
  static const Duration extended = Duration(milliseconds: 600);
  static const Duration cinematic = Duration(milliseconds: 800);
}

abstract class AppCurves {
  static const Curve easeStandard = Curves.easeInOutCubic;
  static const Curve easeFast = Curves.easeOutCubic;
  static const Curve easeSlow = Curves.easeInCubic;
  static const Curve decelerate = Curves.decelerate;
  static const Curve accelerate =
      Curves.fastOutSlowIn; // Replaced missing 'accelerate'
  static const Curve smoothSpring = Curves.fastEaseInToSlowEaseOut;
  static const Curve sharpSpring = Curves.fastOutSlowIn;
}
