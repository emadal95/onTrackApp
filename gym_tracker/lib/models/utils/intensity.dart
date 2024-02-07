
import 'package:flutter/material.dart';

enum INTENSITY_LEVEL {
  LOW,
  MEDIUM,
  HIGH,
  VERY_INTENSE,
  UNKNOWN
}
class Intensity {

  static INTENSITY_LEVEL mapToIntensityLevel(String intensityStr){
    switch(intensityStr){
      case 'Low':
        return INTENSITY_LEVEL.LOW;
      case 'Medium':
        return INTENSITY_LEVEL.MEDIUM;
      case 'High':
        return INTENSITY_LEVEL.HIGH;
      case 'Very Intense':
        return INTENSITY_LEVEL.VERY_INTENSE;
      default:
        return INTENSITY_LEVEL.UNKNOWN;
    }
  }

  static String mapToString(INTENSITY_LEVEL level){
    switch(level){
      case INTENSITY_LEVEL.LOW:
        return 'Low';
      case INTENSITY_LEVEL.MEDIUM:
        return 'Medium';
      case INTENSITY_LEVEL.HIGH:
        return 'High';
      case INTENSITY_LEVEL.VERY_INTENSE:
        return 'Very Intense';
      default:
        return 'Unknown';
    }
  }

  static Color mapToColor(INTENSITY_LEVEL level){
    switch(level){
      case INTENSITY_LEVEL.LOW:
        return Colors.green;
      case INTENSITY_LEVEL.MEDIUM:
        return Colors.blue;
      case INTENSITY_LEVEL.HIGH:
        return Colors.deepOrange;
      case INTENSITY_LEVEL.VERY_INTENSE:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static double mapToIntensityPercentage(INTENSITY_LEVEL level){
    switch(level){
      case INTENSITY_LEVEL.LOW:
        return 0.25;
      case INTENSITY_LEVEL.MEDIUM:
        return 0.50;
      case INTENSITY_LEVEL.HIGH:
        return 0.75;
      case INTENSITY_LEVEL.VERY_INTENSE:
        return 1.0;
      default:
        return 0.0;
    }
  }
}
