import 'package:canik_lib/canik_lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'fusion_test.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder<List<List<dynamic>>>(
              future: csvToProccessedData("../../test_data/DATA_2.csv"),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error!");
                } else if (snapshot.hasData) {
                  List<List<dynamic>> data = snapshot.data!;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("X axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              datum[2] as Quaternion)
                                          .x *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum[1] as Vector3).x *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                          ],
                        ),
                        const Text("Y axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              datum[2] as Quaternion)
                                          .y *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum[1] as Vector3).y *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                          ],
                        ),
                        const Text("Z axis degrees"),
                        SfCartesianChart(
                          series: <ChartSeries>[
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return quaternionToEuler(
                                              datum[2] as Quaternion)
                                          .z *
                                      radians2Degrees;
                                },
                                color: Colors.blue),
                            LineSeries<List<dynamic>, num>(
                                dataSource: data,
                                xValueMapper: (datum, index) {
                                  return datum[0] as num;
                                },
                                yValueMapper: (datum, index) {
                                  return (datum[1] as Vector3).z *
                                      radians2Degrees;
                                },
                                color: Colors.green),
                          ],
                        ),
                        const Text("Gyro deg/s"),
                        vector3ListToChart(data
                            .map((e) => [
                                  e[0],
                                  (e[3] as RawData).rateRad * radians2Degrees
                                ])
                            .toList()),
                        const Text("Accel g"),
                        vector3ListToChart(data
                            .map((e) => [
                                  e[0],
                                  (e[3] as RawData).rawAccelG * radians2Degrees
                                ])
                            .toList()),
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
