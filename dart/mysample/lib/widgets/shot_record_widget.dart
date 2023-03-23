import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/constants/paddings.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constan_text_styles.dart';

class ShotRecordWidget extends StatefulWidget {
  ShotRecordWidget({Key? key}) : super(key: key);

  @override
  State<ShotRecordWidget> createState() => _ShotRecordWidgetState();
}

final ProjectColors _projectColors = ProjectColors();

class _ShotRecordWidgetState extends State<ShotRecordWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: ProjectPadding.paddingLRT30,
            child: Container(
              height: height,
              decoration: _blackCircularDecoration(),
              child: _ShotRecordCard(height: height, onPressed: () {}),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration _blackCircularDecoration() {
    return BoxDecoration(
      color: _projectColors.black,
      borderRadius: BorderRadius.circular(15),
    );
  }
}

class _ShotRecordCard extends StatelessWidget {
  const _ShotRecordCard({
    Key? key,
    required this.height,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPadding.paddingAll15,
      child: SizedBox(
        height: height,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: onPressed,
              child: Padding(
                padding: _ShotRecordPadding().buttonPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    Text(
                      AppLocalizations.of(context)!.add_shot_record,
                      style: ProjectTextStyles.built17Bold,
                    ),
                  ],
                ),
              ),
              style: _addShotRecordButtonStyle(),
            )
          ],
        ),
      ),
    );
  }

  ButtonStyle _addShotRecordButtonStyle() {
    return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), primary: _projectColors.blue);
  }
}

class _ShotRecordPadding {
  final buttonPadding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0);
}
