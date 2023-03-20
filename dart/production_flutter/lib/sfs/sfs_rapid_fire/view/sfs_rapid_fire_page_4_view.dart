import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/sfs_bottom_circle_buttons.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
class SfsRapidFirePageView4 extends StatefulWidget {
  const SfsRapidFirePageView4({Key? key}) : super(key: key);

  @override
  State<SfsRapidFirePageView4> createState() => _SfsRapidFirePageView4State();
}

class _SfsRapidFirePageView4State extends State<SfsRapidFirePageView4> {
  final List<ChartData> data = [
      ChartData(10,190),
      ChartData(20,20),
      ChartData(30,158),
      ChartData(40,-150),
      ChartData(50,200),
      ChartData(60,300),
      ChartData(50,200),
      ChartData(60,300),
      ChartData(70,-150),
      ChartData(80,200),
      ChartData(90,300),
      ChartData(100,200),
      ChartData(110,300),
    ];
    final List<ChartData2nd> data2nd = [
      ChartData2nd(10,95,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(10,-150,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(20,181,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(20,-130,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(30,230,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(30,-200,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(40,70,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(40,-140,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(50,120,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(50,-155,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(60,130,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(60,-210,Color.fromARGB(255, 255, 215, 207)),
      ChartData2nd(70,40,Color.fromARGB(255, 255, 80, 99)),
      ChartData2nd(70,-240,Color.fromARGB(255, 255, 215, 207)),
    ];
  late ZoomPanBehavior _panBehavior;
  late TooltipBehavior _tooltipbehaviour;
  @override
  void initState() {
    _tooltipbehaviour = TooltipBehavior(enable: true);
    _panBehavior = ZoomPanBehavior(
      enablePinching: true,
      selectionRectBorderColor: projectColors.blue,
      selectionRectBorderWidth: 2,
      selectionRectColor: projectColors.black2,
      enablePanning: true,
      zoomMode: ZoomMode.x
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Image.asset(
          "assets/images/image_9.png",
          height: context.height,
          width: context.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar:const _CustomAppBarRapidFire(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child:  _ArchOfMovement(),
                ),
                Image.asset("assets/images/rapid_fire_arch_image.png",fit: BoxFit.cover,),
                const SizedBox(height: 15,),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(color: ProjectColors().black,borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: AssetImage("assets/images/Chartsbackground.png"),fit: BoxFit.cover)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(AppLocalizations.of(context)!.sfs_page4_title,style: TextStyle(color: projectColors.white,fontSize: 17,fontWeight: FontWeight.w500,letterSpacing: 0.2),)
                          ),
                          const SizedBox(height: 10,),
                          Expanded(
                            flex: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: SfCartesianChart(
                                    tooltipBehavior: _tooltipbehaviour,
                                    enableAxisAnimation: true,
                                    zoomPanBehavior: _panBehavior,
                                    backgroundColor: Colors.transparent,
                                    plotAreaBorderColor: Colors.transparent,
                                    plotAreaBackgroundColor: Colors.transparent,
                                   primaryXAxis: 
                                   NumericAxis(
                                    crossesAt: 0,
                                    isVisible: true,
                                    axisLine:AxisLine(color: projectColors.blue,dashArray: [3,6]),
                                     edgeLabelPlacement: EdgeLabelPlacement.shift,
                                     rangePadding: ChartRangePadding.none,
                                     maximumLabels:0,
                                     // Ekranda X ekseninde max deger verisi ona göre sağa scroll olabiliyor.
                                     visibleMaximum: 60
                                   ),
                                   primaryYAxis: NumericAxis(
                                    crossesAt: 0,
                                    isVisible: false,
                                    maximum: 450,
                                    minimum: -350,
                                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    rangePadding: ChartRangePadding.none, ),
                                series: <ChartSeries>[
                                    SplineSeries<ChartData, int>(
                                      color: projectColors.black3,
                                      enableTooltip: true,
                                        dataSource: data,
                                        markerSettings: MarkerSettings(isVisible: true,height: 7,width: 7,color: projectColors.black2,shape: DataMarkerType.circle),
                                        // Type of spline
                                        
                                        xValueMapper: (ChartData data, _) => data.xval,
                                        yValueMapper: (ChartData data, _) => data.yval,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          alignment: ChartAlignment.center,
                                          labelAlignment: ChartDataLabelAlignment.outer,
                                          textStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: projectColors.white)
                                          
                                          
                                          
                                          )
                                        )
                                    ]
                                )
                                ),
                                const SizedBox(height: 30,),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(color: projectColors.black2,borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      Expanded(
                                        flex:1,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 4,
                                              decoration: BoxDecoration(color: Color.fromARGB(255, 255, 80, 99),borderRadius: BorderRadius.circular(10)),
                                            ),
                                           const SizedBox(width: 5,),
                                           Text(AppLocalizations.of(context)!.sfs_grip,style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 4,
                                                  decoration: BoxDecoration(color: Color.fromARGB(255, 255, 215, 207),borderRadius: BorderRadius.circular(10)),
                                                ),
                                              ],
                                            ),
                                           const SizedBox(width: 5,),
                                           Text(AppLocalizations.of(context)!.sfs_pull,style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),)
                                          ],
                                        ),
                                        
                                      )
                                    ]),
                                  ),
                                ),
                                
                                Expanded(
                                  flex: 7,
                                  child: SfCartesianChart(
                                    tooltipBehavior: _tooltipbehaviour,
                                    enableAxisAnimation: true,
                                    zoomPanBehavior: _panBehavior,
                                    backgroundColor: Colors.transparent,
                                    plotAreaBorderColor: Colors.transparent,
                                    plotAreaBackgroundColor: Colors.transparent,
                                   primaryXAxis: 
                                   NumericAxis(
                                    crossesAt: 0,
                                    isVisible: true,
                                    axisLine:AxisLine(color: projectColors.black3),
                                     edgeLabelPlacement: EdgeLabelPlacement.none,
                                     rangePadding: ChartRangePadding.auto,
                                     maximumLabels:0,
                                     // Ekranda X ekseninde max deger verisi ona göre sağa scroll olabiliyor.
                                     visibleMaximum: 60
                                   ),
                                   primaryYAxis: NumericAxis(
                                     visibleMaximum: 250,
                                     visibleMinimum: -250,
                                    crossesAt: 0,
                                    isVisible: false,
                                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    rangePadding: ChartRangePadding.auto, ),
                                series: <ChartSeries>[
                                    ColumnSeries<ChartData2nd, int>(
                                      pointColorMapper: (datum, index) => datum.color,
                                      color: projectColors.black3,
                                      enableTooltip: true,
                                        dataSource: data2nd,
                                        
                                        
                                        // Type of spline
                                        
                                        xValueMapper: (ChartData2nd data, _) => data.xval,
                                        yValueMapper: (ChartData2nd data, _) => data.yval,
                                        borderRadius:const BorderRadius.all(Radius.circular(5)),
                                        spacing: 0.8
                                        // dataLabelSettings: DataLabelSettings(
                                        //   isVisible: true,
                                        //   alignment: ChartAlignment.far,
                                        //   labelAlignment: ChartDataLabelAlignment.top,
                                        //   textStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: projectColors.white)
                                          
                                        //   )
                                        )
                                    ]
                                )
                                ),
                                
                              //  Expanded(
                              //     flex: 1,
                              //     child: SfSparkLineChart.custom(
                          
                              //       labelStyle: TextStyle(color: Colors.white,fontSize: 10),
                              //       axisLineDashArray: <double>[2,5],
                              //       color: projectColors.black3,
                              //       axisLineColor: projectColors.blue,
                              //       trackball: SparkChartTrackball(
                              //         borderColor: projectColors.blue,
                              //         activationMode: SparkChartActivationMode.tap
                              //       ),
                              //       marker: SparkChartMarker(
                              //         color: projectColors.black3,
                              //         size: 5,
                              //         displayMode: SparkChartMarkerDisplayMode.all
                              //       ),
                              //      labelDisplayMode: 
                              //      SparkChartLabelDisplayMode.all,
                              //      dataCount: data.length,
                              //       xValueMapper: (index) => data[index].xval,
                              //       yValueMapper: (index) => data[index].yval,
                                   
                                          
                                   
                              //     ),
                              //   )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Expanded(
                            flex: 1,
                            child: SfsBottomCircleButtons(index: 4,)
                            ),
                        ],
                      ),
                    ),
                    
                  ),
                )
              ],
            ),
          ),
        bottomNavigationBar:const _CustomBottomBarPauseCancelFinish(),  

        )
      ],
    );
  }
}
class ChartData {
   int xval;
   int yval;
   
  ChartData(this.xval, this.yval);
  
}
class ChartData2nd {
   int xval;
   int yval;
   Color color;
  ChartData2nd(this.xval, this.yval, this.color);
  
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _ArchOfMovement extends StatelessWidget {
  const _ArchOfMovement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.arch_of_movenent,
          style: _SfsRapidTextStyles.akhand17,
        ),
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.white,
              size: 12,
            ))
      ],
    );
  }
}
class _SfsRapidTextStyles {
  static const TextStyle akhand57 = TextStyle(fontSize: 57, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle akhand17 = TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle akhand14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand10 = TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle built17 =
      TextStyle(fontFamily: 'Built', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
}
class _CustomAppBarRapidFire extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBarRapidFire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 10.h,
      title: Image.asset('assets/images/rapid_fire_app_bar_image.png'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.h, top: 5.h),
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Image.asset(
                'assets/images/close_icon.png',
              )),
        )
      ],
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(10.h);
}
class _CustomBottomBarPauseCancelFinish extends StatelessWidget {
  const _CustomBottomBarPauseCancelFinish({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('CANCEL', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(onTap: () {}, child: Image.asset('assets/images/close-circle.png'))
            ],
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: ProjectColors().blue,
                shape: const CircleBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.pause_sharp,
                  color: Colors.black,
                ),
              )),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('FINISH', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(onTap: () {}, child: Image.asset('assets/images/stop-circle.png'))
            ],
          )
        ],
      ),
    );
  }
}
