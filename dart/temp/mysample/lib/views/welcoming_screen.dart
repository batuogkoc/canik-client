import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysample/models/slide.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/slide_item_widget.dart';
import 'package:mysample/views/register_Login_screen.dart';
import 'package:mysample/widgets/slide_dots.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Welcoming extends StatefulWidget {
  Welcoming({Key? key}) : super(key: key);

  @override
  State<Welcoming> createState() => _WelcomingState();
}

class _WelcomingState extends State<Welcoming> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (ctx, i) => SlideItem(index: _currentPage),
            itemCount: slideList.length,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: _onPageChanged,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _currentPage == 4 ? false : true,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: projectColors.blue,
                            fixedSize: const Size(147, 54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                        onPressed: () {
                          _currentPage += 1;
                          _pageController.animateToPage(_currentPage,
                              duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.next_button,
                          style: const TextStyle(fontFamily: 'Built', fontWeight: FontWeight.w700, fontSize: 17),
                        )),
                  ),
                  Visibility(
                    visible: _currentPage == 4 ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: projectColors.blue,
                              fixedSize: const Size(147, 54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const LoginRegister()));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.continue_button,
                            style: TextStyle(fontFamily: 'Built', fontWeight: FontWeight.w700, fontSize: 17),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: _currentPage == 4 ? false : true,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const LoginRegister()));
                      },
                      child: Text(AppLocalizations.of(context)!.skip_button,
                          style: TextStyle(fontFamily: 'Akhand', fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(primary: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int i = 0; i < slideList.length; i++)
                        if (i == _currentPage) SlideDots(true,_onPageChanged,i) else SlideDots(false,_onPageChanged,i)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
