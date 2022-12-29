import 'package:canik_lib/canik_lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'fusion_test.dart';
import 'fusion_test.dart' as fusion_test;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Select data format")),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  const String path = "../../data/fusion_datasets/DATA.csv";
                  return FusionTestWidget(
                      path, csvReadOld(path, Vector3.zero()));
                }));
              },
              child: const Text("Old format")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  const String path = "../../data/new_dataset/DataSet.csv";
                  return FusionTestWidget(path, csvRead(path, Vector3.zero()));
                }));
              },
              child: const Text("New format")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  const String path =
                      "../../data/fusion_github_dataset/Justa_dataset.csv";
                  // const String path =
                  //     "../../data/fusion_github_dataset/Synthetic3.csv";
                  return FusionTestWidget(
                      path, csvReadGithub(path, outPath: ""));
                }));
              },
              child: const Text("Github")),
          ElevatedButton(
              onPressed: () {
                fusion_test.main([]);
              },
              child: const Text("Main")),
        ],
      )),
    );
    // return const FusionTestOldCsv("../../data/fusion_datasets/DATA.csv");
  }
}

class FusionTestWidget extends StatefulWidget {
  final String path;
  final Future<List<Map<String, dynamic>>> dataFuture;
  const FusionTestWidget(this.path, this.dataFuture, {super.key});

  @override
  State<FusionTestWidget> createState() => _FusionTestWidgetState();
}

class _FusionTestWidgetState extends State<FusionTestWidget> {
  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
        enableSelectionZooming: false,
        enablePanning: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart: ${widget.path}"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.dataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error!");
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Deviation deg"),
                        SfCartesianChart(series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, num>(
                            dataSource: data,
                            xValueMapper: (datum, index) {
                              return datum[xAxisKey] as num;
                            },
                            yValueMapper: (datum, index) {
                              if (datum.containsKey("quatVal")) {
                                Quaternion quatVal =
                                    datum["quatVal"] as Quaternion;
                                Quaternion quatEst =
                                    (datum["madgwick"] as ProcessedData)
                                        .orientation;
                                Quaternion diff =
                                    (quatVal * quatEst.inverted()).normalized();
                                double ret = diff.radians * radians2Degrees;
                                ret = ret > 180 ? 360 - ret : ret;
                                return ret;
                              } else {
                                return 0;
                              }
                            },
                            color: Colors.red,
                          ),
                          LineSeries<Map<String, dynamic>, num>(
                            dataSource: data,
                            xValueMapper: (datum, index) {
                              return datum[xAxisKey] as num;
                            },
                            yValueMapper: (datum, index) {
                              if (datum.containsKey("quatVal")) {
                                Quaternion quatVal =
                                    datum["quatVal"] as Quaternion;
                                Quaternion quatEst =
                                    (datum["scf"] as ProcessedData).orientation;
                                Quaternion diff =
                                    (quatVal * quatEst.inverted()).normalized();
                                double ret = diff.radians * radians2Degrees;
                                ret = ret > 180 ? 360 - ret : ret;
                                return ret;
                              } else {
                                return 0;
                              }
                            },
                            color: Colors.green,
                          )
                        ], zoomPanBehavior: _zoomPanBehavior),
                        const Text("X axis degrees"),
                        SfCartesianChart(series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, num>(
                              dataSource: data,
                              xValueMapper: (datum, index) {
                                return datum[xAxisKey] as num;
                              },
                              yValueMapper: (datum, index) {
                                return quaternionToEuler(
                                            (datum["madgwick"] as ProcessedData)
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
                        ], zoomPanBehavior: _zoomPanBehavior),
                        const Text("Y axis degrees"),
                        SfCartesianChart(series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, num>(
                              dataSource: data,
                              xValueMapper: (datum, index) {
                                return datum[xAxisKey] as num;
                              },
                              yValueMapper: (datum, index) {
                                return quaternionToEuler(
                                            (datum["madgwick"] as ProcessedData)
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
                        ], zoomPanBehavior: _zoomPanBehavior),
                        const Text("Z axis degrees"),
                        SfCartesianChart(series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, num>(
                              dataSource: data,
                              xValueMapper: (datum, index) {
                                return datum[xAxisKey] as num;
                              },
                              yValueMapper: (datum, index) {
                                return quaternionToEuler(
                                            (datum["madgwick"] as ProcessedData)
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
                        ], zoomPanBehavior: _zoomPanBehavior),
                        const Text("Gyro deg/s"),
                        vector3ListToChart(
                            data
                                .map((e) => [
                                      e[xAxisKey],
                                      (e["raw"] as RawData).rateRad *
                                          radians2Degrees
                                    ])
                                .toList(),
                            zoomPanBehavior: _zoomPanBehavior),
                        const Text("Accel g"),
                        vector3ListToChart(
                            data
                                .map((e) => [
                                      e[xAxisKey],
                                      (e["raw"] as RawData).rawAccelG
                                    ])
                                .toList(),
                            zoomPanBehavior: _zoomPanBehavior),
                        const Text("Device Accel Norm g"),
                        SfCartesianChart(series: <ChartSeries>[
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
                          LineSeries<Map<String, dynamic>, num>(
                              dataSource: data,
                              xValueMapper: (datum, index) {
                                return datum[xAxisKey] as num;
                              },
                              yValueMapper: (datum, index) {
                                if (datum.containsKey("deviceAccelVal")) {
                                  return (datum["deviceAccelVal"] as Vector3)
                                      .length;
                                } else {
                                  return 0;
                                }
                              },
                              color: Colors.blue),
                        ], zoomPanBehavior: _zoomPanBehavior),
                        const Text("dT"),
                        SfCartesianChart(series: <ChartSeries>[
                          LineSeries<Map<String, dynamic>, num>(
                              dataSource: data,
                              xValueMapper: (datum, index) {
                                return datum["time"] as num;
                              },
                              yValueMapper: (datum, index) {
                                return datum["dt"] as num;
                              },
                              color: Colors.blue),
                        ], zoomPanBehavior: _zoomPanBehavior),
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

SfCartesianChart vector3ListToChart(List<List<dynamic>> list,
    {ZoomPanBehavior? zoomPanBehavior}) {
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
    zoomPanBehavior: zoomPanBehavior,
  );
}
