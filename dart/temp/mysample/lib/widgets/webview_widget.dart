import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'loading_widget.dart';

class WebviewWidget extends StatefulWidget {
  String? webViewUrl;
  Widget widget;
  WebviewWidget({Key? key, this.webViewUrl, required this.widget}) : super(key: key);
  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  bool isVisibleWebView = true;

  Future<void> getFunc(String args) async {
    setState(() {
      isLoading = false;
    });
    if (args.contains('id_token=')) {
      setState(() {
        isVisibleWebView = false;
      });
      final token = args.substring(args.lastIndexOf('=') + 1);
      Map<String, dynamic> payload = token != null ? Jwt.parseJwt(token) : Jwt.parseJwt('');
      //
      
      //

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('canikId', payload['oid']);
      print(payload['oid']);
      await prefs.setBool('isLogin', true);
      await prefs
          .setString('idToken', token)
          .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.widget)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //     leading: IconButton(
      //         onPressed: () {
      //           Navigator.pop(context, false);
      //         },
      //         icon: const Icon(Icons.arrow_back_ios_sharp)),
      //     backgroundColor: ProjectColors().black3,
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(18.0),
      //         bottomRight: Radius.circular(18.0),
      //       ),
      //     )),
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        BackgroundImage(),
        Loading(isLoading: isLoading),
        Visibility(
          visible: isVisibleWebView,
          child: WebView(
            initialUrl: widget.webViewUrl,
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onPageFinished: getFunc,
            backgroundColor: Colors.transparent,
            gestureNavigationEnabled: true,
            userAgent: Platform.isIOS
                ? 'Mozilla/5.0 AppleWebKit/605.1.15' ' Version/13.0.1 Mobile/15E148 Safari/604.1'
                : 'Mozilla/5.0 AppleWebKit/537.36 Chrome/103.0.5060.71 Mobile Safari/537.36',
            zoomEnabled: true,
          ),
        ),
      ]),
    );
  }

  AppBar _webviewAppBar(BuildContext context) {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        backgroundColor: ProjectColors().black2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
          ),
        ));
  }
}
