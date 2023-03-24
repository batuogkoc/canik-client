import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_svg/svg.dart';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/cubit/get_location_cubit.dart';
import 'package:mysample/cubit/iys_add_cubit.dart';
import 'package:mysample/cubit/iys_questioning_list_cubit.dart';
import 'package:mysample/entities/iys.dart';
import 'package:mysample/entities/only_canik_id.dart';
import 'package:mysample/entities/response/location_permission_response.dart';
import 'package:mysample/product/utility/is_tablet.dart';

import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/register_Login_screen.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:mysample/widgets/ask_us.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/bloc/language_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../constants/constan_text_styles.dart';
import '../cubit/add_location_cubit.dart';
import '../cubit/profile_image_cubit.dart';
import '../entities/location_permission.dart';
import '../entities/profile_image.dart';
import '../entities/response/iys_response.dart';
import '../entities/response/profile_image_response.dart';
import '../product/get_profile_image.dart';
import '../widgets/webview_widget.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:image_picker/image_picker.dart';

class CanikProfile extends StatefulWidget {
  const CanikProfile({Key? key}) : super(key: key);

  @override
  State<CanikProfile> createState() => _CanikProfileState();
}

class _CanikProfileState extends State<CanikProfile> {
  FlutterAppAuth appAuth = FlutterAppAuth();
  final String _authorizationEndpoint =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/B2C_1_signupsignin/oauth2/v2.0/authorize';
  final String _tokenEndpoint =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/B2C_1_signupsignin/oauth2/v2.0/token';

  final String _updateAuth =
      "https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/b2c_1_update/oauth2/v2.0/authorize?p=b2c_1_update";
  final String _updateToken =
      "https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/b2c_1_update/oauth2/v2.0/token?p=b2c_1_update";
  final String _clientId = '98c22eff-99a3-43cb-86b5-7d5b906e0cbe';
  final String _redirectUrl = 'com.canik.mobileapp://oauthredirect/';
  AuthorizationTokenResponse? result;

  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? gender;
  final bool _expanded = false;
  String? selectedValue;
  bool _notification = false;
  String selectCountry = 'Türkiye';
  String? selectCity;
  String? birthDateString;
  String? dropdownValue;
  Color cupertinoColor = Colors.white;
  DateTime date = DateTime.now();
  String adultText = '';
  Uint8List? decodedString;
  String customText = '';
  bool isUploading = false;
  String? name;
  String? familyName;
  String? canikId;
  List<dynamic> emails = [''];
  String? country;
  String? city;

  final ProjectTextStyles _projectTextStyles = ProjectTextStyles();
  double _percentOfProfile = 0;
  final double _addedPercent = 16.6;
  bool isVisibleWebView = false;
  File? imageFile;
  late ProfileImageDeleteModel profileImageDeleteModel;
  String photoId = '';
  IysPermissionResponse x = IysPermissionResponse(
      isError: false,
      iysPermissionResponse: IysPermissionResponseModel(call: false, eMail: false, sms: false),
      message: '');

  final String _logoutUrl =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/logout?p=b2c_1_signupsignin&redirect_uri=com.canik.mobileapp://logout/&id_token_hint=';

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('idToken');
    Map<String, dynamic> payload = token != null ? Jwt.parseJwt(token) : Jwt.parseJwt('');

    setState(() {
      name = payload['given_name'];
      familyName = payload['family_name'];
      canikId = payload['oid'];
      emails = payload['emails'];
      country = payload['country'];
      city = payload['city'];
    });
  }

  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('canikId');
  }

  Future<IysAddResponse> addIysModel(String status, String type) async {
    final ipAddress = await Ipify.ipv4();
    IysAddRequestModel iysAddRequestModel = IysAddRequestModel(
        ipAddress: ipAddress, canikId: canikId!, type: type, recipient: emails.first, status: status);
    return context.read<IysAddCubit>().addIys(iysAddRequestModel);
  }

  //TODO: BURAYA TELEFON GELİNCE TELEFON EKLEMESİ YAP!
  Future<void> listIys() async {
    IysPermissionRequestModel iysPermissionRequestModel =
        IysPermissionRequestModel(eMail: emails.first, mobile: '+905555555555');
    context.read<IysQuestioningListCubit>().questioningListIys(iysPermissionRequestModel).then((value) => x = value);
  }

  profilePercentageCalculation() {
    if (name != null) {
      _percentOfProfile += _addedPercent;
    }
    if (familyName != null) {
      _percentOfProfile += _addedPercent;
    }
    if (canikId != null) {
      _percentOfProfile += _addedPercent;
    }
    if (country != null) {
      _percentOfProfile += _addedPercent;
    }
    if (city != null) {
      _percentOfProfile += _addedPercent;
    }
    if (emails.first != null) {
      _percentOfProfile += _addedPercent;
    }
  }

  Future<void> getLocationList() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('deviceId');
    GetLocationPermissionRequestModel getLocationPermissionRequestModel =
        GetLocationPermissionRequestModel(deviceId: deviceId ?? '');
    context.read<GetLocationCubit>().getLocationPermission(getLocationPermissionRequestModel);
  }

  Future<LocationPermissionAddResponse> addLocation(bool status, bool isUpdated, String? recordId) async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('deviceId');
    AddLocationPermissionRequestModel addLocationPermissionRequestModel = AddLocationPermissionRequestModel(
        deviceId: deviceId ?? '',
        recordId: recordId ?? 'cac70bc0-2313-ed11-b83d-000d3aadc6e8',
        status: status,
        isUpdated: isUpdated);
    return context.read<LocationAddCubit>().addLocationIys(addLocationPermissionRequestModel);
  }

  _getFromGallerry() async {
    XFile? xfile =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 480, maxWidth: 640);
    if (xfile != null) {
      setState(() {
        isUploading = false;
      });
      var file = File(xfile.path);
      var imageTobytes = await file.readAsBytes(); // Byte cevirdi
      String base64String = base64.encode(imageTobytes); // Byte to Base64 String
      OnlyCanikId getModel = OnlyCanikId(canikId: canikId!);
      ProfileImageGetModel model = ProfileImageGetModel(canikId: canikId!, image: base64String);
      var result = await context.read<ProfileImageCubit>().addProfileImage(model);
      if (result.isError == false) {
        await context.read<ProfileImageCubit>().getProfileImage(getModel);
        setState(() {
          decodedString = base64.decode(base64String);
          isUploading = true;
        });
      }
    }
  }

  _getFromCamera() async {
    XFile? xfile =
        await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 480, maxWidth: 640);
    if (xfile != null) {
      setState(() {
        isUploading = false;
      });
      var file = File(xfile.path);
      var imageTobytes = await file.readAsBytes(); // Byte cevirdi
      String base64String = base64.encode(imageTobytes); // Byte to Base64 String
      ProfileImageGetModel model = ProfileImageGetModel(canikId: canikId!, image: base64String);
      OnlyCanikId getModel = OnlyCanikId(canikId: canikId!);
      var result = await context.read<ProfileImageCubit>().addProfileImage(model);
      if (result.isError == false) {
        await context.read<ProfileImageCubit>().getProfileImage(getModel);
        setState(() {
          decodedString = base64.decode(base64String);
          isUploading = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo().then((value) {
      GetProfileImage().getProfileImage(context).then((value) {
        setState(() {
          decodedString = value;
          isUploading = true;
        });
      });
      // listIys();
      profilePercentageCalculation();
    });
    getLocationList();
  }

  Future<void> getFunc(String args) async {
    if (args.contains('id_token=')) {
      setState(() {
        isVisibleWebView = false;
      });
      final token = args.substring(args.lastIndexOf('=') + 1);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true);
      await prefs.setString('idToken', token).then(
          (value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final TextEditingController controller = TextEditingController();
    final String _updateUrl =
        'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_update&client_id=98c22eff-99a3-43cb-86b5-7d5b906e0cbe&nonce=defaultNonce&redirect_uri=https%3A%2F%2Foauth.pstmn.io%2Fv1%2Fcallback&scope=openid&response_type=id_token&prompt=login&ui_locales=${locale.languageCode}';
    Future<void> update() async {
      FlutterAppAuth _appauth = FlutterAppAuth();

      try {
        result = await _appauth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(_clientId, _redirectUrl,
              serviceConfiguration: AuthorizationServiceConfiguration(
                tokenEndpoint: _updateToken,
                authorizationEndpoint: _updateAuth,
                endSessionEndpoint:
                    "https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/b2c_1_update/oauth2/v2.0/logout?p=b2c_1_update&ui_locales=${locale.languageCode}",
              ),
              scopes: ['openid']),
        );
        Map<String, dynamic> payload = Jwt.parseJwt(result!.idToken!);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('idToken', result!.idToken!);
        setState(() {
          name = payload['given_name'];
          familyName = payload['family_name'];
          canikId = payload['oid'];
          country = payload['country'];
          city = payload['city'];
        });
      } catch (e) {
        print(e);
      }
    }

    Future<ImageSource?> _getImage(BuildContext context) async {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: Text(
                      AppLocalizations.of(context)!.camera,
                      style: _projectTextStyles.textStyleTitle,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _getFromCamera();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(
                      AppLocalizations.of(context)!.gallery,
                      style: _projectTextStyles.textStyleTitle,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _getFromGallerry();
                    },
                  ),
                  !decodedString.isNullOrEmpty
                      ? ListTile(
                          leading: const Icon(Icons.delete),
                          title: Text(
                            AppLocalizations.of(context)!.delete,
                            style: _projectTextStyles.textStyleTitle,
                          ),
                          onTap: () async {
                            setState(() {
                              isUploading = false;
                            });
                            OnlyCanikId profileImageGetModel = OnlyCanikId(canikId: canikId ?? '');
                            profileImageDeleteModel = ProfileImageDeleteModel(id: photoId);

                            var result =
                                await context.read<ProfileImageCubit>().deleteProfileImage(profileImageDeleteModel);
                            if (result.result == true) {
                              await context.read<ProfileImageCubit>().getProfileImage(profileImageGetModel);
                              setState(() {
                                decodedString = base64.decode("");
                                isUploading = true;
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        )
                      : const SizedBox(),
                ],
              ));
    }

    final AuthorizationServiceConfiguration _serviceConfiguration = AuthorizationServiceConfiguration(
        authorizationEndpoint: _authorizationEndpoint,
        tokenEndpoint: _tokenEndpoint,
        endSessionEndpoint:
            "https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/b2c_1_signupsignin/oauth2/v2.0/logout?p=b2c_1_signupsignin");

    Future<void> logout(String idToken) async {
      try {
        var x = await appAuth.endSession(
          EndSessionRequest(
            idTokenHint: idToken,
            postLogoutRedirectUrl: 'com.canik.mobileapp://logout',
            serviceConfiguration: _serviceConfiguration,
          ),
        );

        print(x);
      } catch (e) {
        print(e);
      }
    }

    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    bool isAdult2(DateTime birthDate) {
      String datePattern = "dd-MM-yyyy";

      // Current time - at this moment
      DateTime today = DateTime.now();

      // Parsed date to check
      // DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
      // print('birthday: ' + birthDate.toString());

      // Date to check but moved 18 years ahead
      DateTime adultDate = DateTime(
        birthDate.year + 18,
        birthDate.month,
        birthDate.day,
      );

      return adultDate.isBefore(today);
    }

    String? selectValue = locale.languageCode == 'tr' ? 'Türkçe' : 'English';

    List<String> _languages = ['English', 'Türkçe'];
    final height = MediaQuery.of(context).size.height;

    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final emailController = TextEditingController();

    nameController.text = name ?? '';
    surnameController.text = familyName ?? '';
    emailController.text = emails.first;
    final double profileIconHeight = 15.h;
    final double profileIconHeight2 = 15.h;
    print(profileIconHeight);
    return Stack(
      children: [
        const BackgroundImage(),
        DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp)),
                centerTitle: true,
                backgroundColor: projectColors.black2,
                title: Text(
                  'CANiK ID',
                  style: _projectTextStyles.textStyle,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(45),
                  centerTitle: true,
                  title: Padding(
                    padding: IsTablet().isTablet() ? EdgeInsets.only(top: 1.h) : EdgeInsets.only(top: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isUploading
                            ? InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  _getImage(context);
                                },
                                child: Stack(
                                  children: [
                                    BlocBuilder<ProfileImageCubit, ProfileImageGetResponse>(
                                      builder: (context, state) {
                                        var imageString = state.imageModel.image;
                                        photoId = state.imageModel.id;
                                        Uint8List _decodedString = base64.decode(imageString);
                                        if (state.imageModel.image.isEmpty) {
                                          return SizedBox(
                                            height: profileIconHeight,
                                            width: 15.w,
                                            child: FittedBox(
                                              child: SvgPicture.asset(
                                                'assets/images/ic_profile.svg',
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            height: profileIconHeight,
                                            width: 15.w,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: MemoryImage(_decodedString), fit: BoxFit.contain)),
                                          );
                                        }
                                      },
                                    ),
                                    Positioned(
                                        right: IsTablet().isTablet() ? 0.25.w : 0.5.w,
                                        bottom: IsTablet().isTablet() ? 2.h : 1.h,
                                        child: Container(
                                            decoration:
                                                BoxDecoration(shape: BoxShape.circle, color: ProjectColors().black),
                                            child: IsTablet().isTablet()
                                                ? Icon(Icons.add, color: Colors.white, size: 13.sp)
                                                : Icon(Icons.add, color: Colors.white, size: 13.sp)))
                                  ],
                                ),
                              )
                            : const CircularProgressIndicator(),
                        SizedBox(
                          height: profileIconHeight > 305 ? profileIconHeight2 : profileIconHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 1.w),
                                      child: Text(AppLocalizations.of(context)!.profile_fill_rate,
                                          style: _projectTextStyles.textStyle),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 1.w),
                                      child: Text(
                                        '%' + _percentOfProfile.roundToDouble().toStringAsFixed(0),
                                        style: _projectTextStyles.textStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              LinearPercentIndicator(
                                width: 50.w,
                                lineHeight: 14.0,
                                percent: _percentOfProfile.roundToDouble() / 100,
                                backgroundColor: Colors.white,
                                progressColor: ProjectColors().blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: IsTablet().isTablet() ? Size.fromHeight(height / 6) : Size.fromHeight(height / 7),
                  child: TabBar(tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.personal,
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500),
                      ),
                    ),

                    ///TODO: PERMISSION KISMI DUZELINCE AÇ
                    // Tab(
                    //   child: Text(
                    //     AppLocalizations.of(context)!.permissions,
                    //     style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.settings,
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500),
                      ),
                    )
                  ]),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18.0),
                    bottomRight: Radius.circular(18.0),
                  ),
                )),
            body: TabBarView(children: [
              _TabBarViewOne(
                  buttonTextStyle: _projectTextStyles.buttonTextStyle,
                  height: height,
                  textStyleTitleText: _projectTextStyles.textStyleTitleText,
                  canikId: canikId,
                  textStyleMid: _projectTextStyles.textStyleMid,
                  name: name,
                  familyName: familyName,
                  country: country,
                  city: city,
                  emails: emails,
                  updateUrl: _updateUrl),
              //  Padding(
              //   padding: EdgeInsets.only(left: 30, right: 30, top: height / 16),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       // customRow(
              //       //   textStyleTitleText,
              //       //   textStyleTitleY,
              //       //   customText = AppLocalizations.of(context)!.sms_permission,
              //       // ),
              //       // SizedBox(
              //       //   height: height / 17,
              //       // ),

              //       BlocBuilder<IysQuestioningListCubit, IysPermissionResponse>(
              //         builder: (context, response) {
              //           IysPermissionResponseModel permission = x.iysPermissionResponse;
              //           if (x.isError == false) {
              //             return Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   AppLocalizations.of(context)!.e_mail_permission,
              //                   style: _projectTextStyles.textStyleTitleText,
              //                 ),
              //                 ElevatedButton(
              //                     style: ElevatedButton.styleFrom(
              //                       primary: const Color(0xff9cabc2).withOpacity(0.60),
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(30),
              //                       ),
              //                     ),
              //                     onPressed: () {
              //                       // Aktif edildiğinde kapat!
              //                       if (true == true) {
              //                         return;
              //                       }

              //                       if (permission.eMail == false) {
              //                         addIysModel('ONAY', 'EPOSTA').then((value) {
              //                           setState(() {
              //                             x.iysPermissionResponse.eMail = !permission.eMail;

              //                             // if (value.result == 'false') {
              //                             //   x.iysPermissionResponse.eMail = !x.iysPermissionResponse.eMail;
              //                             //   //TODO: ERROR UYARI MESAJI YAZ
              //                             // }
              //                           });
              //                         });
              //                       } else {
              //                         addIysModel('RET', 'EPOSTA').then((value) {
              //                           setState(() {
              //                             x.iysPermissionResponse.eMail = !permission.eMail;

              //                             if (value.result == 'false') {
              //                               x.iysPermissionResponse.eMail = !x.iysPermissionResponse.eMail;
              //                               //TODO: ERROR UYARI MESAJI YAZ
              //                             }
              //                           });
              //                         });
              //                       }
              //                     },
              //                     child: permission.eMail == false
              //                         ? Text(
              //                             AppLocalizations.of(context)!.allow,
              //                             style: _projectTextStyles.buttonTextStyle,
              //                           )
              //                         : Text(AppLocalizations.of(context)!.cancel,
              //                             style: _projectTextStyles.buttonTextStyle))
              //               ],
              //             );
              //           } else {
              //             return Container();
              //           }
              //           //   return Row(
              //           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           //     children: [
              //           //       Text(
              //           //         AppLocalizations.of(context)!.e_mail_permission,
              //           //         style: textStyleTitleText,
              //           //       ),
              //           //       Row(
              //           //         children: [
              //           //           ElevatedButton(
              //           //               onPressed: () {
              //           //                 addIysModel('ONAY', 'EPOSTA');
              //           //                 listIys();
              //           //               },
              //           //               style: ElevatedButton.styleFrom(
              //           //                 primary: const Color(0xff9cabc2).withOpacity(0.60),
              //           //                 shape: RoundedRectangleBorder(
              //           //                   borderRadius: BorderRadius.circular(30),
              //           //                 ),
              //           //               ),
              //           //               child: Text(
              //           //                 AppLocalizations.of(context)!.available,
              //           //                 style: textStyleTitleY,
              //           //               )),
              //           //         ],
              //           //       ),
              //           //     ],
              //           //   );
              //           // } else {
              //           //   return Row(
              //           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           //     children: [
              //           //       Text(
              //           //         AppLocalizations.of(context)!.e_mail_permission,
              //           //         style: textStyleTitleText,
              //           //       ),
              //           //       Row(
              //           //         children: [
              //           //           ElevatedButton(
              //           //               onPressed: () {
              //           //                 addIysModel('RET', 'EPOSTA');
              //           //                 listIys();
              //           //               },
              //           //               style: ElevatedButton.styleFrom(
              //           //                 primary: const Color(0xff9cabc2).withOpacity(0.60),
              //           //                 shape: RoundedRectangleBorder(
              //           //                   borderRadius: BorderRadius.circular(30),
              //           //                 ),
              //           //               ),
              //           //               child: Text(AppLocalizations.of(context)!.cancel)),
              //           //         ],
              //           //       ),
              //           //     ],
              //           //   );
              //           // }
              //         },
              //       ),
              //       SizedBox(
              //         height: height / 17,
              //       ),
              //       // Location İzin
              //       BlocBuilder<GetLocationCubit, GetLocationPermissionResponse>(
              //         builder: (context, response) {
              //           if (response.getLocationPermissionResponseModel.isNotNullOrEmpty) {
              //             if (response.getLocationPermissionResponseModel.last.status == true) {
              //               return Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(AppLocalizations.of(context)!.location_permission,
              //                       style: _projectTextStyles.textStyleTitleText),
              //                   ElevatedButton(
              //                       onPressed: () async {
              //                         recordId = response.getLocationPermissionResponseModel.last.recordId;
              //                         var res = await addLocation(false, true, recordId);
              //                         EasyLoading.show(dismissOnTap: false);
              //                         if (res.result == 'true') {
              //                           getLocationList();
              //                           EasyLoading.dismiss();
              //                         }
              //                       },
              //                       style: ElevatedButton.styleFrom(
              //                         primary: const Color(0xff9cabc2).withOpacity(0.60),
              //                         shape: RoundedRectangleBorder(
              //                           borderRadius: BorderRadius.circular(30),
              //                         ),
              //                       ),
              //                       child: Text(AppLocalizations.of(context)!.cancel,
              //                           style: _projectTextStyles.buttonTextStyle)),
              //                 ],
              //               );
              //             } else {
              //               return Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(AppLocalizations.of(context)!.location_permission,
              //                       style: _projectTextStyles.textStyleTitleText),
              //                   ElevatedButton(
              //                       onPressed: () async {
              //                         recordId = response.getLocationPermissionResponseModel.last.recordId;
              //                         EasyLoading.show(dismissOnTap: false);
              //                         var res = await addLocation(true, true, recordId);
              //                         if (res.result == 'true') {
              //                           getLocationList();
              //                           EasyLoading.dismiss();
              //                         }
              //                       },
              //                       style: ElevatedButton.styleFrom(
              //                         primary: const Color(0xff9cabc2).withOpacity(0.60),
              //                         shape: RoundedRectangleBorder(
              //                           borderRadius: BorderRadius.circular(30),
              //                         ),
              //                       ),
              //                       child: Text(
              //                         AppLocalizations.of(context)!.allow,
              //                         style: _projectTextStyles.buttonTextStyle,
              //                       )),
              //                 ],
              //               );
              //             }
              //           } else {
              //             return Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(AppLocalizations.of(context)!.location_permission,
              //                     style: _projectTextStyles.textStyleTitleText),
              //                 ElevatedButton(
              //                     onPressed: () async {
              //                       if (true == true) {
              //                         return;
              //                       }
              //                       if (response.getLocationPermissionResponseModel.isNotNullOrEmpty) {
              //                         recordId = response.getLocationPermissionResponseModel.last.recordId;
              //                         EasyLoading.show(dismissOnTap: false);
              //                         var res = await addLocation(true, true, recordId);
              //                         if (res.result == 'true') {
              //                           getLocationList();
              //                           EasyLoading.dismiss();
              //                         }
              //                       }
              //                     },
              //                     style: ElevatedButton.styleFrom(
              //                       primary: const Color(0xff9cabc2).withOpacity(0.60),
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(30),
              //                       ),
              //                     ),
              //                     child: Text(
              //                       AppLocalizations.of(context)!.allow,
              //                       style: _projectTextStyles.buttonTextStyle,
              //                     )),
              //               ],
              //             );
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: height / 20, right: height / 20, top: height / 16),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            ImageIcon(
                              const AssetImage('assets/images/globe-americas.png'),
                              color: projectColors.blue,
                            ),
                            Text(
                              AppLocalizations.of(context)!.language,
                              style: _projectTextStyles.textStyleTitleText,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            value: selectValue,
                            underline: const SizedBox(),
                            onChanged: (String? newValue) => setState(
                              () async {
                                selectValue = newValue!;
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('language', selectValue == 'Türkçe' ? 'tr' : 'en');

                                context.read<LanguageFormBloc>().add(LanguageFormEvent.selectLanguage(
                                    selectValue == 'Türkçe' ? const Locale('tr') : const Locale('en')));
                              },
                            ),
                            isExpanded: true,
                            hint: Text(AppLocalizations.of(context)!.choose_language_dropdown,
                                style: _projectTextStyles.textStyleTitleText),
                            iconSize: 24,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: _languages.map(buildMenuItem).toList(),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ImageIcon(
                                  const AssetImage('assets/images/bell.png'),
                                  color: projectColors.blue,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.notification,
                                  style: _projectTextStyles.textStyleTitleText,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: height / 5),
                              child: CupertinoSwitch(
                                activeColor: projectColors.blue,
                                trackColor: projectColors.black3,
                                value: _notification,
                                onChanged: (bool value) {
                                  setState(() {
                                    _notification = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height / 60.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();

                            await prefs.setString('idToken', '');

                            await prefs.setBool('isLogin', false);
                            await prefs.setString('canikId', '');
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const LoginRegister()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              fixedSize: const Size(315, 54),
                              primary: Colors.white.withOpacity(0.20)),
                          child: Text(
                            AppLocalizations.of(context)!.sign_out,
                            style: _projectTextStyles.buttonTextStyle,
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Row customRow(TextStyle textStyleTitleText, TextStyle textStyleTitleY, String customText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          customText,
          style: textStyleTitleText,
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.available,
                  style: textStyleTitleY,
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff9cabc2).withOpacity(0.60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.cancel)),
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp, color: Colors.white),
      ));
}

class _TabBarViewOne extends StatelessWidget {
  final TextStyle buttonTextStyle;
  final double height;
  final TextStyle textStyleTitleText;
  final String? canikId;
  final TextStyle textStyleMid;
  final String? name;
  final String? familyName;
  final String? country;
  final String? city;
  final List emails;
  const _TabBarViewOne({
    Key? key,
    required this.buttonTextStyle,
    required this.height,
    required this.textStyleTitleText,
    required this.canikId,
    required this.textStyleMid,
    required this.name,
    required this.familyName,
    required this.country,
    required this.city,
    required this.emails,
    required String updateUrl,
  })  : _updateUrl = updateUrl,
        super(key: key);

  final String _updateUrl;
  static final _textStylePdf = TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static final _textStyleTitleTextU = TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: ProjectColors().blue,
      color: Colors.white,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Future<String> _getLanguage() async {
      final prefs = await SharedPreferences.getInstance();
      String language = prefs.getString('language')!;
      return language;
    }

//Read to pdf
    Future<List<int>> _readDocumentData(String name) async {
      final ByteData data = await rootBundle.load('assets/textfiles/$name');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    }

    Future<void> _extractAllText() async {
      String _pdfName = await _getLanguage().then(
          (value) => value == 'tr' ? 'CanikApp_enlightenment_text_tr.pdf' : 'CanikApp_enlightenment_text_eng.pdf');
      List<int> readData = await _readDocumentData(_pdfName);
      final PdfDocument document = PdfDocument(inputBytes: readData);
      PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText(startPageIndex: 0, endPageIndex: 4, layoutText: true);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: const EdgeInsets.all(1),
          title: Center(child: Text(AppLocalizations.of(context)!.lighting_text, style: textStyleMid)),
          backgroundColor: ProjectColors().black,
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Text(
                text,
                style: _textStylePdf,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.close,
                  style: textStyleMid,
                ))
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: height / 20,
        right: height / 30,
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: height / 16),
          Text(
            'CANiK ID',
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(
            canikId ?? '',
            style: textStyleMid,
          ),
          SizedBox(
            height: height / 50,
          ),
          Text(
            AppLocalizations.of(context)!.name,
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(name == null ? '' : name!, style: textStyleMid),
          SizedBox(
            height: height / 40,
          ),
          Text(
            AppLocalizations.of(context)!.surname,
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(familyName == null ? '' : familyName!, style: textStyleMid),
          SizedBox(
            height: height / 40,
          ),
          Text(
            AppLocalizations.of(context)!.country,
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(country == null ? '' : country!, style: textStyleMid),
          SizedBox(
            height: height / 40,
          ),
          Text(
            AppLocalizations.of(context)!.province,
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(city == null ? '' : city!, style: textStyleMid),
          SizedBox(
            height: height / 40,
          ),
          Text(
            AppLocalizations.of(context)!.e_mail,
            style: textStyleTitleText,
          ),
          SizedBox(
            height: height / 160,
          ),
          Text(emails.first ?? '', style: textStyleMid),
          context.emptySizedHeightBoxNormal,
          TextButton(
              onPressed: () async => await _extractAllText(),
              child: Text(
                AppLocalizations.of(context)!.canik_kvkk,
                style: _textStyleTitleTextU,
              )),
          Padding(
            padding: EdgeInsets.only(top: height / 20),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebviewWidget(
                                webViewUrl: _updateUrl,
                                widget: const CanikProfile(),
                              )));
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    fixedSize: const Size(315, 54),
                    primary: projectColors.blue),
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: buttonTextStyle,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height / 60.0),
            child: const AskUs(),
          )
        ],
      ),
    );
  }
}

//ExpansionPanelList(
//   children: [
//     ExpansionPanel(
//       backgroundColor: Color(0xff232931),
//       headerBuilder: ((context, isExpanded) {
//         return Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Image.asset(
//                 'assets/images/expIcon.png',
//                 color: Colors.white,
//               ),
//             ),
//             const Expanded(
//                 flex: 5,
//                 child: Text(
//                   'DİĞER ÜYELİK BİLGİLERİM',
//                   style: textStyleTitleText,
//                 )),
//           ],
//         );
//       }),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text('İlçe', style: textStyleSmall),
//           Text(
//             'Uyruk',
//             style: textStyleSmall,
//           ),
//           Text(
//             'TC No',
//             style: textStyleSmall,
//           ),
//           Text(
//             'Doğum Tarihi',
//             style: textStyleSmall,
//           ),
//           Text(
//             'Cinsiyet',
//             style: textStyleSmall,
//           ),
//           Text(
//             'Teslim Adresi',
//             style: textStyleSmall,
//           ),
//           Text(
//             'Fatura Adresi',
//             style: textStyleSmall,
//           )
//         ],
//       ),
//       isExpanded: _expanded,
//       canTapOnHeader: true,
//     )
//   ],
//   expansionCallback: (panelIndex, isExpanded) {
//     _expanded = !_expanded;
//     setState(() {});
//   },
// ),

/// TODO: SONRAKİ FAZ İÇİN KULLANILACAK OLAN PROFİL DOLULUK ORANI İÇİN BAR.
// SizedBox(
//   height: height / 20,
//   width: height / 3,
//   child: Column(
//     children: [
//       Row(
//         //mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             AppLocalizations.of(context)!
//                 .profile_fill_rate,
//             style: textStyleTitle,
//           ),
//           SizedBox(
//             width: height / 12,
//           ),
//           const Text(
//             '%90',
//             style: textStyleTitleY,
//           ),
//         ],
//       ),
//       LinearPercentIndicator(
//         width: height / 3.5,
//         lineHeight: 10.0,
//         percent: 0.9,
//         progressColor: const projectColors.blue,
//       )
//     ],
//   ),
// )

class _CanikIdProfileTextStyle {
  static final akhand17 = TextStyle(fontSize: 10.sp, color: const Color(0xff657981), fontWeight: FontWeight.w500);
  static final akhand17B = TextStyle(fontSize: 10.sp, color: const Color(0xff49C7EF), fontWeight: FontWeight.w500);
}
