import 'package:flutter/material.dart';

/// Ultra Premium Motion Tokens
/// Following Material Design 3 motion system with premium enhancements
abstract class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 400);
  static const Duration extended = Duration(milliseconds: 600);
  static const Duration cinematic = Duration(milliseconds: 800);
  
  // Ultra Premium durations for high-end animations
  static const Duration micro = Duration(milliseconds: 50);
  static const Duration ultraSlow = Duration(milliseconds: 1200);
  static const Duration hero = Duration(milliseconds: 1500);
}

abstract class AppCurves {
  static const Curve easeStandard = Curves.easeInOutCubic;
  static const Curve easeFast = Curves.easeOutCubic;
  static const Curve easeSlow = Curves.easeInCubic;
  static const Curve decelerate = Curves.decelerate;
  static const Curve accelerate = Curves.fastOutSlowIn;
  static const Curve smoothSpring = Curves.fastEaseInToSlowEaseOut;
  static const Curve sharpSpring = Curves.fastOutSlowIn;
  
  // Ultra Premium curves for premium feel
  static const Curve premiumEase = Cubic(0.25, 0.1, 0.25, 1.0);
  static const Curve premiumDecelerate = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve premiumAccelerate = Cubic(0.4, 0.0, 1.0, 1.0);
  static const Curve premiumBounce = Cubic(0.68, -0.55, 0.265, 1.55);
}
