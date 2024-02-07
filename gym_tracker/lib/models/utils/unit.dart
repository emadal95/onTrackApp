enum UNITS{
  LB,
  KG,
  INCH,
  CM,
}

class Unit {
  static UNITS mapToUnit(String unitStr){
    switch (unitStr.toLowerCase()) {
      case 'lb':
        return UNITS.LB;
      case 'kg':
        return UNITS.KG;
      case 'in':
        return UNITS.INCH;
      case 'cm':
        return UNITS.CM;
    }
  }

  static String mapToStr(UNITS unit){
    switch (unit){
      case UNITS.LB:
        return 'lb';
      case UNITS.KG:
        return 'kg';
      case UNITS.INCH:
        return 'in';
      case UNITS.CM:
        return 'cm';
    }
  }
}