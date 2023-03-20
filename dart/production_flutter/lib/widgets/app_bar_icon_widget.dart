import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_id_profile.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/profile_image_cubit.dart';
import '../entities/response/profile_image_response.dart';
import '../product/get_profile_image.dart';
import '../views/canik_id_profile_login_page.dart';

class CustomAppBarWithImage extends StatefulWidget implements PreferredSizeWidget {
  final String imagePath;
  final index;
  const CustomAppBarWithImage({Key? key, required this.imagePath, required this.index}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<CustomAppBarWithImage> createState() => _CustomAppBarWithImageState();
}

class _CustomAppBarWithImageState extends State<CustomAppBarWithImage> {
  Uint8List? decodedString;
  @override
  void initState() {
    super.initState();
    GetProfileImage().getProfileImage(context).then((value) {
      setState(() {
        decodedString = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: widget.index != 2 ? false : true,
        leading: widget.index == 1
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarPage(index: 1)));
                },
                child: Image.asset('assets/images/gun_icon.png'))
            : widget.index == 7
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0)));
                    },
                    child: const Icon(Icons.home))
                : null,
        centerTitle: true,
        title: Image.asset(widget.imagePath, height: 30),
        backgroundColor: projectColors.black2,
        actions: [
          BlocBuilder<ProfileImageCubit, ProfileImageGetResponse>(
            builder: (context, state) {
              var imageString = state.imageModel.image;

              Uint8List _decodedString = base64.decode(imageString);
              if (state.imageModel.image.isEmpty) {
                return IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      var isLogin = prefs.getBool('isLogin');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  isLogin == true ? const CanikProfile() : const CanikIdProfileLogin()));
                    },
                    icon: Image.asset('assets/images/profil_icon.png'));
              } else {
                return IconButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    var isLogin = prefs.getBool('isLogin');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                isLogin == true ? const CanikProfile() : const CanikIdProfileLogin()));
                  },
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, image: DecorationImage(image: MemoryImage(_decodedString))),
                  ),
                );
              }
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
          ),
        ));
  }
}
