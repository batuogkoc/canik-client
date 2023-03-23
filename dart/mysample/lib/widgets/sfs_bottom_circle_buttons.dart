import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mysample/sfs/sfs_rapid_fire/view/sfs_rapid_fire_page_3_view.dart';

import '../sfs/sfs_rapid_fire/view/sfs_rapid_fire_page_4_view.dart';
import '../views/add_gun_home.dart';

class SfsBottomCircleButtons extends StatefulWidget {
  int index;
   SfsBottomCircleButtons({required this.index,Key? key}) : super(key: key);

  @override
  State<SfsBottomCircleButtons> createState() => _SfsBottomCircleButtonsState();
}

class _SfsBottomCircleButtonsState extends State<SfsBottomCircleButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color:widget.index == 1 ? projectColors.white : projectColors.black3,
                                      shape: BoxShape.circle
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: widget.index == 2 ? projectColors.white : projectColors.black3,
                                      shape: BoxShape.circle
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SfsRapidFirePageView3(),));
                                    },
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: widget.index == 3 ? projectColors.white : projectColors.black3,
                                        shape: BoxShape.circle
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SfsRapidFirePageView4(),));
                                    },
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: widget.index == 4 ? projectColors.white : projectColors.black3,
                                        shape: BoxShape.circle
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                        
  }
}