import 'package:flutter/material.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/ask_us_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../constants/constan_text_styles.dart';
import '../product/utility/is_tablet.dart';

class AskUs extends StatelessWidget {
  const AskUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectTextStyles _projectTextStyles = ProjectTextStyles();
    String askUsText = AppLocalizations.of(context)!.frequently_asked_question;
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AskUsPage()));
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            fixedSize: const Size(315, 54),
            primary: projectColors.black3),
        child: Stack(
          children: [
            Center(
              child: Text(
                askUsText,
                style: _projectTextStyles.buttonTextStyle,
              ),
            ),
          ],
        ));
  }
}
