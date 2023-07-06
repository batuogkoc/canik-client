import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/sfs/sfs_counter_pages/views/sfs_countdown_page_view.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/widgets/app_bar_sfs.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import '../../../widgets/background_image_sfs_widget.dart';
// import '../../sfs_core/canik_viz.dart';
// import 'package:mysample/sfs/sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_lib/canik_lib.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';

class SfsWaitingPageView extends StatefulWidget {
  final CanikDevice canikDevice;
  final SfsTrainingMode trainingMode;
  final SfsAllSettings allSettings;
  const SfsWaitingPageView(
      {required this.allSettings,
      required this.trainingMode,
      required this.canikDevice,
      Key? key})
      : super(key: key);

  @override
  State<SfsWaitingPageView> createState() => _SfsWaitingPageViewState();
}

class _SfsWaitingPageViewState extends State<SfsWaitingPageView> {
  final String _counterImagePath = 'assets/images/counter_image.png';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
          appBar: const CustomAppBarForSfs(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: _SfsWaitingPaddings.horizontal2h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CustomTimerText(),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h, top: 5.h),
                  child: SizedBox(
                    width: 100.w,
                    child: _CustomButton(
                      function: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SfsCountDownPage(
                                      allSettings: widget.allSettings,
                                      canikDevice: widget.canikDevice,
                                      trainingMode: widget.trainingMode,
                                    )));
                      },
                      buttonColor: ProjectColors().blue,
                      borderSideColor: Colors.transparent,
                      buttonText: AppLocalizations.of(context)!.start,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  child: _CustomButton(
                    function: () {},
                    buttonColor: _SfsWaitingColor.panicColor,
                    borderSideColor: Colors.white,
                    buttonText: AppLocalizations.of(context)!.back,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 10),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.arch_of_movenent,
                        style: _SfsWaitingTextStyles.akhand17,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 12,
                          ))
                    ],
                  ),
                ),
                // Image.asset(
                //   _counterImagePath,
                //   height: 30.h,
                //   width: 100.w,
                // )
                StreamBuilder<List<Vector2>>(
                  stream: widget.canikDevice.processedDataStream.transform(
                      YawPitchVisualiser(400 * 3,
                          dataCaptureFraction: 10 / 400)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("a");
                      return SfCartesianChart(
                        primaryXAxis: NumericAxis(minimum: -180, maximum: 180),
                        primaryYAxis: NumericAxis(minimum: -90, maximum: 90),
                        series: <ChartSeries>[
                          LineSeries<Vector2, double>(
                            dataSource: snapshot.data!,
                            xValueMapper: (datum, index) {
                              return datum.x;
                            },
                            yValueMapper: (datum, index) {
                              return datum.y;
                            },
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Graph Error");
                    } else {
                      return const Text("Waiting graph data");
                    }
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _CustomButton extends StatefulWidget {
  const _CustomButton({
    Key? key,
    required this.buttonColor,
    required this.function,
    required this.borderSideColor,
    required this.buttonText,
  }) : super(key: key);
  final Color buttonColor;
  final Function() function;
  final Color borderSideColor;
  final String buttonText;

  @override
  State<_CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<_CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: widget.buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: context.normalBorderRadius,
                side: BorderSide(color: widget.borderSideColor))),
        onPressed: widget.function,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(widget.buttonText, textAlign: TextAlign.center),
        ));
  }
}

class _CustomTimerText extends StatelessWidget {
  const _CustomTimerText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _SfsWaitingPaddings.onlyTop,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '00:05:00',
            style: _SfsWaitingTextStyles.akhand57,
          ),
        ],
      ),
    );
  }
}

class _SfsWaitingPaddings {
  static EdgeInsets horizontal2h = const EdgeInsets.symmetric(horizontal: 30);
  static const EdgeInsets onlyTop = EdgeInsets.only(top: 90);
}

class _SfsWaitingTextStyles {
  static const TextStyle akhand57 =
      TextStyle(fontSize: 57, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle akhand17 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);
}

class _SfsWaitingColor {
  static const Color panicColor = Color(0xff686F76);
}
