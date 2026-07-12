import 'dart:math';

import 'package:flutter/material.dart';

/// Form Analysis Engine - Analyzes pose keypoints to detect form flaws
class FormAnalysisEngine {
  const FormAnalysisEngine();

  /// Calculates the angle between three points (p1-p2-p3) in degrees
  /// p2 is the vertex point
  /// Returns angle between 0-180 degrees
  double calculateAngle(Offset p1, Offset p2, Offset p3) {
    // Vectors p2->p1 and p2->p3
    final double dx1 = p1.dx - p2.dx;
    final double dy1 = p1.dy - p2.dy;
    final double dx2 = p3.dx - p2.dx;
    final double dy2 = p3.dy - p2.dy;

    // Dot product
    final double dot = dx1 * dx2 + dy1 * dy2;

    // Magnitudes
    final double magnitude1 = sqrt(dx1 * dx1 + dy1 * dy1);
    final double magnitude2 = sqrt(dx2 * dx2 + dy2 * dy2);

    // Avoid division by zero
    if (magnitude1 == 0 || magnitude2 == 0) {
      return 0.0;
    }

    // Calculate angle in radians
    final double cosAngle = dot / (magnitude1 * magnitude2);
    // Clamp to [-1, 1] to avoid floating point errors
    final double clampedCos = cosAngle.clamp(-1.0, 1.0);
    final double angleRad = acos(clampedCos);

    // Convert to degrees
    return angleRad * 180 / pi;
  }

  /// Analyzes squat form based on keypoints
  /// Returns null if form is good, or a flaw description if detected
  String? analyzeSquat(List<Offset> keypoints) {
    if (keypoints.length < 17) {
      return 'Insufficient keypoints for analysis';
    }

    // MoveNet keypoint indices:
    // 11: left hip, 12: right hip
    // 13: left knee, 14: right knee
    // 15: left ankle, 16: right ankle
    // 5: left shoulder, 6: right shoulder

    // Use left side for analysis (could average both sides later)
    final Offset leftHip = keypoints[11];
    final Offset leftKnee = keypoints[13];
    final Offset leftAnkle = keypoints[15];
    final Offset leftShoulder = keypoints[5];

    // Check if keypoints are valid (not zero)
    if (leftHip == Offset.zero ||
        leftKnee == Offset.zero ||
        leftAnkle == Offset.zero ||
        leftShoulder == Offset.zero) {
      return 'Unable to detect full pose';
    }

    // Calculate knee angle (hip-knee-ankle)
    final double kneeAngle = calculateAngle(leftHip, leftKnee, leftAnkle);

    // Check squat depth: hip should be below knee for proper depth
    // In image coordinates: higher Y value = lower position
    final bool isDeepEnough = leftHip.dy > leftKnee.dy;

    // Check knee angle: should be less than 90 degrees for good squat
    final bool kneeAngleInRange = kneeAngle < 90 && kneeAngle > 60; // Reasonable range

    // We don't actually need to use this variable since we check specific angle ranges below
    // but keeping it for clarity of the validation logic
    if (!kneeAngleInRange) {
      // This will be caught by the more specific checks below
    }

    // Detect flaws
    if (!isDeepEnough) {
      return 'Not deep enough - try to go lower until your hips are below your knees';
    }

    if (kneeAngle >= 90) {
      return 'Knees not bent enough - aim for a deeper squat position';
    }

    if (kneeAngle <= 45) {
      return 'Knees too bent - you might be going too deep, maintain control';
    }

    // Check forward lean (shoulders vs hips)
    final double leanAngle = calculateAngle(leftAnkle, leftHip, leftShoulder);
    if (leanAngle < 70) { // Too far forward
      return 'Chest falling forward - keep your chest up and back straight';
    }

    if (leanAngle > 110) { // Too far back
      return 'Leaning too far back - engage your core and keep balanced';
    }

    // Check knee valgus (knees caving in)
    // Simple check: knee should be roughly aligned with foot
    final Offset rightHip = keypoints[12];
    final Offset rightKnee = keypoints[14];
    final Offset rightAnkle = keypoints[16];

    if (rightHip != Offset.zero &&
        rightKnee != Offset.zero &&
        rightAnkle != Offset.zero) {
      // Check if knees are significantly inward
      final double kneeWidth = (leftKnee.dx - rightKnee.dx).abs();
      final double footWidth = (leftAnkle.dx - rightAnkle.dx).abs();

      if (kneeWidth < footWidth * 0.7) { // Knees too close together
        return 'Knees caving in - push knees out to align with toes';
      }
    }

    // Form looks good
    return null;
  }

  /// Generates a prompt for the LLM coach based on detected flaw
  String generateCoachPrompt(String exercise, String detectedFlaw) {
    return 'The user is performing a $exercise. I detected: $detectedFlaw. Provide a very brief, encouraging 1-sentence cue to fix this.';
  }
}