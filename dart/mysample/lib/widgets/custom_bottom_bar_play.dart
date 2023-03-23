import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomBottomBarPlay extends StatefulWidget {
  const CustomBottomBarPlay({Key? key}) : super(key: key);

  @override
  State<CustomBottomBarPlay> createState() => _CustomBottomBarPlayState();
}

class _CustomBottomBarPlayState extends State<CustomBottomBarPlay> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text('CANCEL',
                  style:
                      TextStyle(fontFamily: 'Built', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            InkWell(onTap: () {}, child: Image.asset('assets/images/close-circle.png'))
          ],
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                isPressed = !isPressed;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: ProjectColors().blue,
              shape: const CircleBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: isPressed == false
                  ? const Icon(
                      Icons.pause_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.black,
                    ),
            )),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text('FINISH',
                  style:
                      TextStyle(fontFamily: 'Built', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            InkWell(onTap: () {}, child: Image.asset('assets/images/stop-circle.png'))
          ],
        )
      ],
    );
  }
}
