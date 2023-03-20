

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:status_alert/status_alert.dart';
class ErrorPopup{
 late int _duration;
 late String _title;
 late String _subTitle;
    ErrorPopup(
      int _duration,
      String _title,
      String _subTitle,
    ){
      this._duration = _duration;
      this._title = _title;
      this._subTitle = _subTitle;
    }
  void error(BuildContext context){
    StatusAlert.show(context,
    duration:  Duration(seconds: _duration),
    title: _title,
    subtitle: _subTitle,
    configuration: const IconConfiguration(icon: Icons.error_sharp,size: 24,color: Colors.red),
    maxWidth: 50.w,
    );
  }
}