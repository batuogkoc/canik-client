import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../views/add_gun_home.dart';
import 'color_constants.dart';

final ProjectColors _projectColors = ProjectColors();

class ProjectTextStyles {
  static const built17Bold =
      TextStyle(fontSize: 16, fontFamily: 'Built', fontWeight: FontWeight.bold, color: Colors.white);
  static const popUpTitleTextStyle =
      TextStyle(fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
  static const popUpTextStyle2 = TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);

  final black17bold = TextStyle(fontSize: 17, color: _projectColors.black3, fontWeight: FontWeight.bold);
  final blue17 = TextStyle(color: _projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500);
  static const bold20 = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  static const akhandSemibold17 = TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
  static const akhandLight12 = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300);
  static const akhandLight10 = TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w300);

  // Profil Page

    final textStyle = TextStyle(color: projectColors.black3, fontSize: 10.5.sp, fontWeight: FontWeight.bold);
    final textStyleTitle = TextStyle(color: projectColors.black3, fontSize: 10.sp, fontWeight: FontWeight.w500);
    final textStyleTitleY = TextStyle(color: projectColors.blue, fontSize: 10.sp, fontWeight: FontWeight.w500);
    final textStyleTitleText = TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w500);

    final textStyleSmall = TextStyle(color: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.w500);
    final textStyleMid = TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w500);
    final buttonTextStyle = TextStyle(color: Colors.white, fontSize: 11.sp,fontFamily: 'Built' ,fontWeight: FontWeight.w500);
  // Compare Page
    final gunNameTextStyle = TextStyle(color: projectColors.white, fontSize: 14.sp, fontWeight: FontWeight.w500);
    final gunNameTabletTextStyle = TextStyle(color: projectColors.white, fontSize: 13.sp, fontWeight: FontWeight.w500);


    final gunProperyNameTitleTextStyle = TextStyle(color: projectColors.white, fontSize: 14.sp, fontWeight:FontWeight.w500);
    final gunProperyNameTitleTabletTextStyle = TextStyle(color: projectColors.white, fontSize: 12.sp, fontWeight:FontWeight.w500);

    final gunProperyNameTextStyle = TextStyle(color: projectColors.black, fontSize: 14.sp, fontWeight:FontWeight.w500);
    final gunProperyNameTabletTextStyle = TextStyle(color: projectColors.black, fontSize: 12.sp, fontWeight:FontWeight.w500);
}
