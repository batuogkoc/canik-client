import 'package:scidart/numdart.dart';
import 'package:circular_buffer/circular_buffer.dart';
import 'package:canik_lib/canik_lib.dart';
import '../dataset.dart';

class ShotDetector {
  int shotCounter = 0;

  final int windowSize;
  final int algorithmPeriod;

  int _dataCounter = 0;

  final ShotDataset _shotDataset;

  final ShotConditions _shotConditions;

  bool _lastWindowShotCandidate = false;

  final CircularBuffer<double> _accelNormBuffer;

  ShotDetector(this._shotConditions, this._shotDataset,
      {this.windowSize = 90, this.algorithmPeriod = 40})
      : _accelNormBuffer = CircularBuffer(windowSize);

  void onDataReceive(double data) {
    _accelNormBuffer.add(data);
    _dataCounter++;
    if (_dataCounter >= algorithmPeriod) {
      _dataCounter = 0;
      _calculator();
    }
  }

  bool processFilteredShotSignal(Array rawSignalWithinWindow,
      ShotDataset dataset, ShotConditions conditions) {
    // var maxCorrelationArray =
    //     dataset.maxCorrelationList(normalizeCopy(rawSignalWithinWindow));
    var maxCorrelationArray = dataset.maxCorrelationList(rawSignalWithinWindow);
    return conditions.checkConditions(
        maxCorrelationArray, rawSignalWithinWindow);
  }

  void _shotDetected() {
    shotCounter++;
    print("Shot detected");
  }

  void _calculator() {
    var windowSignal = _accelNormBuffer.toList(growable: false);
    // print(windowSignals.length);
    // var filteredWindowSignal = Array(_movingAverage(windowSignals));
    // var filteredWindowSignal = Array(windowSignals);
    // var filter = SavitzkyGolayFilter(13, 3);
    // var filteredWindowSignal = filter.filter(Array(windowSignal));
    // print(windowSignals);
    // print(filteredWindowSignal);
    bool shotCandidateDetected = processFilteredShotSignal(
        Array(windowSignal), _shotDataset, _shotConditions);

    if (_lastWindowShotCandidate == false && shotCandidateDetected == true) {
      _shotDetected();
    }
    _lastWindowShotCandidate = shotCandidateDetected;
  }
}
