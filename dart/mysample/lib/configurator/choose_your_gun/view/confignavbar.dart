import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../../../views/add_gun_home.dart';
import '../../../views/tabs_bar.dart';

class ConfiguratorNavbar extends StatelessWidget implements PreferredSizeWidget {
  const ConfiguratorNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 10.h,
      leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0)));
                },
                child: Image.asset("assets/images/close_icon.png")),
      title: SizedBox(
        height: 10.h,
        child: Image.asset('assets/images/confignavbar2.png',fit: BoxFit.fill)),
      backgroundColor:Colors.transparent,
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(10.h);
}