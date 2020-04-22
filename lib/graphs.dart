import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'global.dart' as global;
import 'generated/l10n.dart';

class Data {
  final String text;
  final int counter;
  final int shitcounter;
  Data(this.text, this.counter, this.shitcounter);
  }

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  DonutPieChart(this.seriesList, {this.animate});
  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData() {
    return new DonutPieChart(
      _createSampleData(),
      animate: true,
    );
  }
  factory DonutPieChart.withSampleData2() {
    return new DonutPieChart(
      _createSampleData2(),
      animate: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
    );

  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales2, int>> _createSampleData() {
    final data = [
      new LinearSales2(0, 4,),                                                      //hier wird Wisch und Papiermenge festgelegt für Deutschland
      new LinearSales2(1, 7,),

    ];
    return [
      new charts.Series<LinearSales2, int>(
        id: 'Sales',
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        colorFn: (LinearSales2 sales, _) {
          final bucket = sales.year * 2;       //bucket um Farbe festzulegen
          if (bucket >= 2) {
            return charts.ColorUtil.fromDartColor(Colors.amber[800]);
          } else {
            return charts.ColorUtil.fromDartColor(Colors.lightBlue);
          }
        },
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales2, int>> _createSampleData2() {
    final data = [
      new LinearSales2(0, global.avgshitcounter,),                                                      //hier persönliche Wischmenge
      new LinearSales2(1, global.wipecounter,),

    ];
    return [
      new charts.Series<LinearSales2, int>(
        id: 'Sales',
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        colorFn: (LinearSales2 sales, _) {
          final bucket = sales.year * 2;       //bucket um Farbe festzulegen
          if (bucket >= 2) {
            return charts.ColorUtil.fromDartColor(Colors.amber[800]);
          } else {
            return charts.ColorUtil.fromDartColor(Colors.lightBlue);
          }
        },
        data: data,
      )
    ];
  }
}

class SimpleScatterPlotChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  SimpleScatterPlotChart(this.seriesList, {this.animate});
  /// Creates a [ScatterPlotChart] with sample data and no transition.
  factory SimpleScatterPlotChart.withSampleData() {
    return new SimpleScatterPlotChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new charts.ScatterPlotChart(seriesList, animate: animate);
  }
  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5, 8.0),
      new LinearSales(10, 25, 8.0),
      new LinearSales(12, 75, 8.0),
      new LinearSales(13, 150, 15.0),
      new LinearSales(16, 50, 8.0),
      new LinearSales(24, 75, 9.0),
      new LinearSales(20, 121, 8.0),
      new LinearSales(50, 110, 15.0),
      new LinearSales(37, 10, 15.5),
    ];

    final maxMeasure = 180;

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        // Providing a color function is optional.
        colorFn: (LinearSales sales, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = sales.sales / maxMeasure;

          if (bucket < 1 / 3) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return charts.ColorUtil.fromDartColor(Colors.amber[800]);
          } else {
            return charts.ColorUtil.fromDartColor(Colors.purple[500]);
          }
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        // Providing a radius function is optional.
        radiusPxFn: (LinearSales sales, _) => sales.radius,
        data: data,
      )
    ];
  }
}

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  StackedBarChart(this.seriesList, {this.animate});
  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData() {
    return new StackedBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
    ];
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  final double radius;
 LinearSales(this.year, this.sales, this.radius);}
/// Sample linear data type. 2D
class LinearSales2 {
  final int year;
  final int sales;

  LinearSales2(this.year, this.sales);
  }

Widget Testbutton(BuildContext context) {
  //int testvariable = 55;
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.amber,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: (Icon(Icons.sync)),
            color: Colors.white,
            onPressed: () {},
            tooltip: '${global.testvariable}',
          ),
        ),
      ),
    );
  } // zum Testen nur

//simple chart
class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class oli{
  final int yAchse;
  final String xAchse;
  final charts.Color color;

  oli(this.yAchse, this.xAchse, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
