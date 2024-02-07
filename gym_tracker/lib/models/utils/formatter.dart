import 'package:charts_flutter/flutter.dart' as charts;

class Formatter {
  Formatter();

  static charts.AutoDateTimeTickFormatterSpec get datetimeLineGraphTickFormatter {
    return new charts.AutoDateTimeTickFormatterSpec(
      minute: new charts.TimeFormatterSpec(
        format: 'dd MMM',
        transitionFormat: 'dd MMM',
      ),
      hour: new charts.TimeFormatterSpec(
        format: 'dd MMM',
        transitionFormat: 'dd MMM',
      ),
      day: new charts.TimeFormatterSpec(
        format: 'dd MMM',
        transitionFormat: 'dd MMM',
      ),
      month: new charts.TimeFormatterSpec(
        format: 'dd MMM',
        transitionFormat: 'dd MMM',
      ),
      year: new charts.TimeFormatterSpec(
          format: 'MMM yyyy', transitionFormat: 'MMM yyyy'),
    );
  }
}
