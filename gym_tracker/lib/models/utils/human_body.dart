import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/body_icons.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum BODYPARTS { ARMS, SHOULDERS, PECS, BACK, CORE, GLUTES, LEGS, ALL }
class BODYPARTCOLORS { 
  static final charts.Color blue = charts.Color.fromHex(code: '#355B7F'); //core
  static final charts.Color bordeaux = charts.Color.fromHex(code: '#C06A83'); //arms
  static final charts.Color pinkRed = charts.Color.fromHex(code: '#EE717B'); //legs
  static final charts.Color salmon = charts.Color.fromHex(code: '#F8B097'); //glutes
  static final charts.Color lightGreen = charts.Color.fromHex(code: '#72B599'); //pecs
  static final charts.Color lightBlue = charts.Color.fromHex(code: '#0AA3B6'); //shoulders
  static final charts.Color purple = charts.Color.fromHex(code: '#494BA3'); //back
  static final charts.Color yellow = charts.Color.fromHex(code: '#FDCF61'); //all
}

class HumanBody {

  static String mapPartToString(BODYPARTS part) {
    switch(part){
      case BODYPARTS.ARMS:
        return 'Arms';
      case BODYPARTS.SHOULDERS:
        return 'Shoulders';
      case BODYPARTS.PECS:
        return 'Pecs';
      case BODYPARTS.BACK:
        return 'Back';
      case BODYPARTS.CORE:
        return 'Core';
      case BODYPARTS.GLUTES:
        return 'Glutes';
      case BODYPARTS.LEGS:
        return 'Legs';
      case BODYPARTS.ALL:
        return 'All';
    }
  }

  static String mapPartsListToString(List<BODYPARTS> partsList) {
    String partsStr = '';
    int i = 0;
    partsList.forEach((part) {
      if(i != partsList.length-1) 
        partsStr = "$partsStr${mapPartToString(part)},";
      else
        partsStr = "$partsStr${mapPartToString(part)}";
      i++;
    });

    return partsStr;
  }

  static List<BODYPARTS> mapToBodyPartsList(String stringOfParts) {
    List<BODYPARTS> list = [];
    if (stringOfParts.isEmpty) return list;

    stringOfParts.split(',').forEach((part) => list.add(mapToBodyPart(part)));

    return list;
  }

  static BODYPARTS mapToBodyPart(String partStr) {
    switch (partStr) {
      case 'Arms':
        return BODYPARTS.ARMS;
      case 'Shoulders':
        return BODYPARTS.SHOULDERS;
      case 'Pecs':
        return BODYPARTS.PECS;
      case 'Back':
        return BODYPARTS.BACK;
      case 'Core':
        return BODYPARTS.CORE;
      case 'Glutes':
        return BODYPARTS.GLUTES;
      case 'Legs':
        return BODYPARTS.LEGS;
      case 'All':
        return BODYPARTS.ALL;
    }
  }

  static IconData mapToIcon(BODYPARTS part){
    switch(part){
      case BODYPARTS.ARMS:
        return BodyIcons.arm_flex;
      case BODYPARTS.SHOULDERS:
        return BodyIcons.torso;
      case BODYPARTS.PECS:
        return BodyIcons.chest;
      case BODYPARTS.BACK:
        return BodyIcons.back;
      case BODYPARTS.CORE:
        return BodyIcons.abs;
      case BODYPARTS.GLUTES:
        return BodyIcons.butt_side;
      case BODYPARTS.LEGS:
        return BodyIcons.leg;
      case BODYPARTS.ALL:
        return BodyIcons.muscular_silhouette;
      default:
        return BodyIcons.muscular_silhouette;
    }
  }

  static charts.Color mapToChartColor(BODYPARTS part){
    switch(part){
       case BODYPARTS.ARMS:
        return BODYPARTCOLORS.bordeaux;
      case BODYPARTS.SHOULDERS:
        return BODYPARTCOLORS.lightBlue;
      case BODYPARTS.PECS:
        return BODYPARTCOLORS.lightGreen;
      case BODYPARTS.BACK:
        return BODYPARTCOLORS.purple;
      case BODYPARTS.CORE:
        return BODYPARTCOLORS.blue;
      case BODYPARTS.GLUTES:
        return BODYPARTCOLORS.salmon;
      case BODYPARTS.LEGS:
        return BODYPARTCOLORS.pinkRed;
      case BODYPARTS.ALL:
        return BODYPARTCOLORS.yellow;
      default:
        return charts.Color(r: Colors.grey.red, g: Colors.grey.green, b: Colors.grey.blue, a: Colors.grey.alpha);
    }
  }

  static Color mapToColor(BODYPARTS part){
    switch(part){
       case BODYPARTS.ARMS:
        return Color.fromARGB(BODYPARTCOLORS.bordeaux.a, BODYPARTCOLORS.bordeaux.r, BODYPARTCOLORS.bordeaux.g, BODYPARTCOLORS.bordeaux.b);
      case BODYPARTS.SHOULDERS:
        return Color.fromARGB(BODYPARTCOLORS.lightBlue.a, BODYPARTCOLORS.lightBlue.r , BODYPARTCOLORS.lightBlue.g , BODYPARTCOLORS.lightBlue.b);
      case BODYPARTS.PECS:
        return Color.fromARGB(BODYPARTCOLORS.lightGreen.a, BODYPARTCOLORS.lightGreen.r , BODYPARTCOLORS.lightGreen.g , BODYPARTCOLORS.lightGreen.b);
      case BODYPARTS.BACK:
        return Color.fromARGB(BODYPARTCOLORS.purple.a, BODYPARTCOLORS.purple.r, BODYPARTCOLORS.purple.g, BODYPARTCOLORS.purple.b);
      case BODYPARTS.CORE:
        return Color.fromARGB(BODYPARTCOLORS.blue.a, BODYPARTCOLORS.blue.r, BODYPARTCOLORS.blue.g, BODYPARTCOLORS.blue.b);
      case BODYPARTS.GLUTES:
        return Color.fromARGB(BODYPARTCOLORS.salmon.a, BODYPARTCOLORS.salmon.r, BODYPARTCOLORS.salmon.g, BODYPARTCOLORS.salmon.b);
      case BODYPARTS.LEGS:
        return Color.fromARGB(BODYPARTCOLORS.pinkRed.a, BODYPARTCOLORS.pinkRed.r, BODYPARTCOLORS.pinkRed.g, BODYPARTCOLORS.pinkRed.b);
      case BODYPARTS.ALL:
        return Color.fromARGB(BODYPARTCOLORS.yellow.a, BODYPARTCOLORS.yellow.r, BODYPARTCOLORS.yellow.g, BODYPARTCOLORS.yellow.b);
      default:
        return Colors.grey;
    }
  }
}
