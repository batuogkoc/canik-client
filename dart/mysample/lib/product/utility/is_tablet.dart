import 'package:sizer/sizer.dart';

class IsTablet {
  bool isTablet() {
    bool _isTablet = SizerUtil.deviceType == DeviceType.tablet;
    return _isTablet;
  }
}
