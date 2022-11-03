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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FutureBuilder<List<List<dynamic>>>(
            future: csvToProccessedData("../../test_data/DATA.csv"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error!");
              } else if (snapshot.hasData) {
                List<List<dynamic>> data = snapshot.data!;
                return SfCartesianChart(
                  series: <ChartSeries>[
                    LineSeries<List<dynamic>, double>(
                        dataSource: data,
                        xValueMapper: (datum, index) {
                          return datum[0] as double;
                        },
                        yValueMapper: (datum, index) {
                          return quaternionToEuler(datum[2] as Quaternion).y *
                              radians2Degrees;
                        },
                        color: Colors.blue),
                    LineSeries<List<dynamic>, double>(
                        dataSource: data,
                        xValueMapper: (datum, index) {
                          return datum[0] as double;
                        },
                        yValueMapper: (datum, index) {
                          return (datum[1] as Vector3).y * radians2Degrees;
                        },
                        color: Colors.green),
                  ],
                );
              } else {
                return const Text("Calculating");
              }
            },
          )
        ]),
      ),
    );
  }
}
