import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/constants/constan_text_styles.dart';
import 'package:mysample/constants/paddings.dart';
import 'package:mysample/models/acc_card_model.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:kartal/kartal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccAtGunView extends StatefulWidget {
  const AddAccAtGunView({Key? key}) : super(key: key);
  @override
  State<AddAccAtGunView> createState() => _AddAccAtGunViewState();
}

class _AddAccAtGunViewState extends State<AddAccAtGunView> {
  static const String _seriesText = 'METE Serisi';
  final double _cardHeightLength = 10.h;
  final double _cardHeight = 30.h;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          appBar: const CustomAppBarWithText(text: 'Accessory'),
          body: SingleChildScrollView(
            child: Padding(
              padding: ProjectPadding.paddingAll30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(_seriesText, style: ProjectTextStyles.bold20),
                  context.emptySizedHeightBoxLow,
                  SizedBox(
                    height: accCardModelList.length * _cardHeightLength,
                    child: GridView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: _cardHeight,
                      ),
                      itemCount: accCardModelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        AccCardModel _accCardModel = accCardModelList[index];
                        return _AccessoryCard(
                          accCardModel: _accCardModel,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _AccessoryCard extends StatefulWidget {
  const _AccessoryCard({
    Key? key,
    required this.accCardModel,
  }) : super(key: key);
  final AccCardModel accCardModel;

  @override
  State<_AccessoryCard> createState() => _AccessoryCardState();
}

class _AccessoryCardState extends State<_AccessoryCard> {
  final String gunProp = '.380ACP, 9mm, .40S&W';
  final String newText = 'YENİ';
  final double imageHeight = 12.h;
  final double newCardHeight = 2.h;
  final double newCardWidth = 8.w;
  final String imagePathAdded = 'assets/images/ic_added_acc.svg';
  final String imagePathNotAdded = 'assets/images/ic_not_added_acc.svg';
  final double positionedValue = 10;
  final double paddingPopUp = 15;
  final int durationSecond = 3;
  bool isClicked = false;

  void popFunction() {
    Future.delayed(Duration(seconds: durationSecond), () {
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InkWell(
        onTap: () {
          setState(() {
            isClicked = !isClicked;
          });
          if (isClicked == true) {
            _addAlertDialog(AppLocalizations.of(context)!.acc_added);
            popFunction();
          } else {
            _addAlertDialog(AppLocalizations.of(context)!.acc_removed);
            popFunction();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isClicked == false ? Colors.transparent : ProjectColors().blue),
                image: const DecorationImage(image: AssetImage('assets/images/gun_background.png'), fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    widget.accCardModel.imagePath,
                    height: imageHeight,
                  ),
                ),
                Padding(
                  padding: ProjectPadding.paddingLR15T30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: newCardHeight,
                        width: newCardWidth,
                        color: const Color(0xff686F76),
                        child: Center(
                          child: Text(
                            newText,
                            style: ProjectTextStyles.akhandLight10,
                          ),
                        ),
                      ),
                      Text(widget.accCardModel.gunName, style: ProjectTextStyles.akhandSemibold17),
                      Text(
                        gunProp,
                        style: ProjectTextStyles.akhandLight12,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
      isClicked == false
          ? Positioned(right: positionedValue, top: positionedValue, child: SvgPicture.asset(imagePathNotAdded))
          : Positioned(right: positionedValue, top: positionedValue, child: SvgPicture.asset(imagePathAdded))
    ]);
  }

  Future<dynamic> _addAlertDialog(String text) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProjectColors().black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: paddingPopUp),
                child: SvgPicture.asset(imagePathAdded, color: Colors.white),
              ),
              Text(text, style: ProjectTextStyles.akhandSemibold17),
            ],
          ),
        );
      },
    );
  }
}
