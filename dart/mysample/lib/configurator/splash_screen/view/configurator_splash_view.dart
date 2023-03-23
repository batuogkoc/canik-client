import 'package:flutter/material.dart';
import 'package:mysample/configurator/choose_your_gun/view/choose_your_gun_view.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';

class ConfiguratorSplashView extends StatefulWidget {
  const ConfiguratorSplashView({Key? key}) : super(key: key);

  @override
  State<ConfiguratorSplashView> createState() => _ConfiguratorSplashViewState();
}

class _ConfiguratorSplashViewState extends State<ConfiguratorSplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(context.durationSlow).then((value) =>
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChooseYourGunView())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors().blue,
      body: const _SplashImage(
        imageName: 'configurator_splash_image',
      ),
    );
  }
}

class _SplashImage extends StatelessWidget {
  const _SplashImage({
    required this.imageName,
    Key? key,
  }) : super(key: key);
  final String imageName;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _nameWithPath,
      fit: BoxFit.fill,
      height: context.height,
      width: context.width,
    );
  }

  String get _nameWithPath => 'assets/images/$imageName.png';
}
