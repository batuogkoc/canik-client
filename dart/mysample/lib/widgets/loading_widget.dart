import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoading;
  const Loading({Key? key, required this.isLoading}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: SpinKitFadingCircle(size: 80, color: Colors.white)),
    );
  }
}
