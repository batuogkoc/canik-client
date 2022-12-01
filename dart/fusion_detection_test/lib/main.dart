import 'package:canik_lib/canik_lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'fusion_test.dart';

String xAxisKey = "time";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FusionTestOldCsv("../../data/fusion_datasets/DATA.csv");
  }
}

class FusionTestOldCsv extends StatelessWidget {
  final String path;
  const FusionTestOldCsv(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: csvReadOld(path),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error!");
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("X axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler((datum["madgwick"]
                                                  as ProcessedData)
                                              .orientation)
                                          .x *
                                      radians2Degrees;
                                },
                                color: Colors.red),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              (datum["scf"] as ProcessedData)
                                                  .orientation)
                                          .x *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum["eulerVal"] as Vector3).x *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                          ],
                        ),
                        const Text("Y axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler((datum["madgwick"]
                                                  as ProcessedData)
                                              .orientation)
                                          .y *
                                      radians2Degrees;
                                },
                                color: Colors.red),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              (datum["scf"] as ProcessedData)
                                                  .orientation)
                                          .y *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum["eulerVal"] as Vector3).y *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                          ],
                        ),
                        const Text("Z axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler((datum["madgwick"]
                                                  as ProcessedData)
                                              .orientation)
                                          .z *
                                      radians2Degrees;
                                },
                                color: Colors.red),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              (datum["scf"] as ProcessedData)
                                                  .orientation)
                                          .z *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum["eulerVal"] as Vector3).z *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                          ],
                        ),
                        const Text("Gyro deg/s"),
                        vector3ListToChart(data
                            .map((e) => [
                                  e[xAxisKey],
                                  (e["raw"] as RawData).rateRad *
                                      radians2Degrees
                                ])
                            .toList()),
                        const Text("Accel g"),
                        vector3ListToChart(data
                            .map((e) =>
                                [e[xAxisKey], (e["raw"] as RawData).rawAccelG])
                            .toList()),
                        // const Text("Device Accel g scf"),
                        // vector3ListToChart(data
                        //     .map((e) => [
                        //           e[xAxisKey],
                        //           (e["scf"] as ProcessedData).deviceAccelG
                        //         ])
                        //     .toList()),
                        const Text("Device Accel Norm g"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum["madgwick"] as ProcessedData)
                                      .deviceAccelG
                                      .length;
                                },
                                color: Colors.red),
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[xAxisKey] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum["scf"] as ProcessedData)
                                      .deviceAccelG
                                      .length;
                                },
                                color: Colors.green),
                          ],
                        ),
                        const Text("dT"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<Map<String, dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum["time"] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return datum["dt"] as num;
                                },
                                color: Colors.blue),
                          ],
                        ),
                      ]);
                } else {
                  return const Text("Calculating");
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}

SfCartesianChart vector3ListToChart(List<List<dynamic>> list) {
  return SfCartesianChart(
    series: <ChartSeries>[
      LineSeries<List<dynamic>, num>(
          dataSource: list,
          xValueMapper: (datum, index) {
            return datum[0] as num;
          },
          yValueMapper: (datum, index) {
            return (datum[1] as Vector3).x;
          },
          color: Colors.red),
      LineSeries<List<dynamic>, num>(
          dataSource: list,
          xValueMapper: (datum, index) {
            return datum[0] as num;
          },
          yValueMapper: (datum, index) {
            return (datum[1] as Vector3).y;
          },
          color: Colors.green),
      LineSeries<List<dynamic>, num>(
          dataSource: list,
          xValueMapper: (datum, index) {
            return datum[0] as num;
          },
          yValueMapper: (datum, index) {
            return (datum[1] as Vector3).z;
          },
          color: Colors.blue),
    ],
  );
}
