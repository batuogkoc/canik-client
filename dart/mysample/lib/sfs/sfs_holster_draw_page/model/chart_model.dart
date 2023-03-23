class ChartModelForHolsterDraw {
  List<HolsterDrawData> getChartData() {
    final List<HolsterDrawData> stackChartData = [
      HolsterDrawData(holsterNumber: 1, grip: 20, pull: 20, horizontal: 30, aim: 20, shot: 20),
      HolsterDrawData(holsterNumber: 2, grip: 30, pull: 10, horizontal: 10, aim: 10, shot: 40),
      HolsterDrawData(holsterNumber: 3, grip: 30, pull: 50, horizontal: 20, aim: 60, shot: 10),
      HolsterDrawData(holsterNumber: 4, grip: 50, pull: 50, horizontal: 50, aim: 20, shot: 30),
      HolsterDrawData(holsterNumber: 5, grip: 40, pull: 40, horizontal: 10, aim: 30, shot: 60),
      HolsterDrawData(holsterNumber: 6, grip: 15, pull: 40, horizontal: 10, aim: 40, shot: 60),
      HolsterDrawData(holsterNumber: 7, grip: 40, pull: 30, horizontal: 30, aim: 50, shot: 20),
      HolsterDrawData(holsterNumber: 8, grip: 10, pull: 20, horizontal: 10, aim: 20, shot: 20),
      HolsterDrawData(holsterNumber: 9, grip: 10, pull: 10, horizontal: 10, aim: 20, shot: 20),
    ];
    return stackChartData;
  }
}

// BarChartGroupData
class HolsterDrawData {
  final num holsterNumber;
  final num grip;
  final num pull;
  final num horizontal;
  final num aim;
  final num shot;

  HolsterDrawData({
    required this.holsterNumber,
    required this.grip,
    required this.pull,
    required this.horizontal,
    required this.aim,
    required this.shot,
  });
}
