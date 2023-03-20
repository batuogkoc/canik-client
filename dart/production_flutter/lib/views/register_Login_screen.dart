import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mysample/repository/repo_new.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_home_page.dart';
import 'package:mysample/views/canik_store_home_page.dart';
import 'package:mysample/views/phone_confirm.dart';
import 'package:mysample/views/register_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/webview_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String? idToken;

  var isVisibleWebView = true;
  String _userAgent = '<unknown>';
  String _webUserAgent = '<unknown>';
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initUserAgentState();
    setState(() {});
  }

  bool _isBusy = false;
  AuthorizationTokenResponse? result;
  FlutterAppAuth appAuth = FlutterAppAuth();

  final String _clientId = '98c22eff-99a3-43cb-86b5-7d5b906e0cbe';
  final String _redirectUrl = 'com.canik.mobileapp://oauthredirect/';
  final String _authorizationEndpoint =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/B2C_1_signupsignin/oauth2/v2.0/authorize';
  final String _tokenEndpoint =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/B2C_1_signupsignin/oauth2/v2.0/token';
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final String _loginUrl =
        'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_signupsignin&client_id=98c22eff-99a3-43cb-86b5-7d5b906e0cbe&nonce=defaultNonce&redirect_uri=https%3A%2F%2Foauth.pstmn.io%2Fv1%2Fcallback&scope=openid&response_type=id_token&prompt=login&ui_locales=${locale.languageCode}';

    // Future<void> login() async {
    //   FlutterAppAuth _appauth = FlutterAppAuth();

    //   try {
    //     result = await _appauth.authorizeAndExchangeCode(
    //       AuthorizationTokenRequest(_clientId, _redirectUrl,
    //           serviceConfiguration: AuthorizationServiceConfiguration(
    //             tokenEndpoint: _tokenEndpoint,
    //             authorizationEndpoint: _authorizationEndpoint,
    //             endSessionEndpoint:
    //                 'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/logout?p=B2C_1_signupsignin',
    //           ),

    //           // discoveryUrl:
    //           //     'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_SSO',
    //           scopes: ['openid']),
    //     );
    //     print(result);
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setBool('isLogin', true);
    //     await prefs.setString('idToken', result!.idToken!);
    //     await prefs.setString('token', result!.accessToken!);
    //     Map<String, dynamic> payload = Jwt.parseJwt(result!.idToken!);
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        body: Stack(children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundNew.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset('assets/images/canik_super.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 45.0, right: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Text(AppLocalizations.of(context)!.welcome,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Built',
                                )),
                          ),
                          Text(AppLocalizations.of(context)!.login_description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal)),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(250, 50),
                                primary: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(width: 2, color: Colors.white)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebviewWidget(
                                              webViewUrl: _loginUrl,
                                              widget: TabBarPage(index: 0),
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  AppLocalizations.of(context)!.sign_in,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Built',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 60, child: Divider(height: 40, color: Colors.white, thickness: 1.0)),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  AppLocalizations.of(context)!.or,
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: 'Akhand', fontWeight: FontWeight.normal, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 60, child: Divider(height: 40, color: Colors.white, thickness: 1.0)),
                              ],
                          ),
                          ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(250, 40),
                                    primary: projectColors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side:  BorderSide(width: 1, color: projectColors.blue)),
                                  ),
                                  onPressed: () async{
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setBool('isLogin', false);
                                    await prefs.setString('canikId', '');
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      AppLocalizations.of(context)!.continue_without_login,
                                      style:  TextStyle(
                                          color: projectColors.white ,
                                          fontSize: 16,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
