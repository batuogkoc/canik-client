import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/bloc/language_form_bloc.dart';
import 'package:mysample/constants/paddings.dart';
import 'package:mysample/views/welcoming_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geocoding/geocoding.dart' as geo;

import 'package:location/location.dart';

import '../constants/color_constants.dart';
import '../constants/constan_text_styles.dart';
import '../cubit/add_location_cubit.dart';
import '../entities/location_permission.dart';

class Choice extends StatefulWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  bool submittedLocation = false;
  bool submittedLanguage = false;
  String? _deviceId;

  showErrorMessage() {
    setState(() {});
  }

  choicePageStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('choicePageStatus', true);
  }

  LocationData? _locationData;
  String? _country = '';
  Future<void> _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    Location location = Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var placemarks = await geo.placemarkFromCoordinates(_locationData!.latitude!, _locationData!.longitude!);
    setState(() {
      _country = placemarks[0].country;
    });
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  void addLocation() {
    AddLocationPermissionRequestModel addLocationPermissionRequestModel = AddLocationPermissionRequestModel(
        deviceId: _deviceId ?? '', recordId: '3fa85f64-5717-4562-b3fc-2c963f66afa6', status: true, isUpdated: false);
    context.read<LocationAddCubit>().addLocationIys(addLocationPermissionRequestModel);
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    String? selectValue = locale.languageCode == 'tr' ? 'Türkçe' : 'English';
    List<String> _languages = ['English', 'Türkçe'];

    ProjectColors projectColors = ProjectColors();

    return BlocBuilder<LanguageFormBloc, LanguageFormState>(
      builder: (context, state) {
        const textStyle = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500);
        return Scaffold(
          backgroundColor: projectColors.black,
          body: Stack(children: [
            Padding(
              padding: ProjectPadding.paddingLR30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.location_info,
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Built', fontWeight: FontWeight.w600, fontSize: 24)),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          AppLocalizations.of(context)!.choose_country,
                          style: textStyle,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              _getUserLocation();
                              submittedLocation = false;
                            },
                            child: Container(
                              height: 40,
                              color: Colors.transparent,
                              padding: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_country!, style: ProjectTextStyles.popUpTextStyle2),
                                        const Spacer(flex: 5),
                                        const Padding(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            Icons.arrow_drop_down_outlined,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(color: Colors.white, height: 1)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: submittedLocation,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(AppLocalizations.of(context)!.location_error_message,
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(AppLocalizations.of(context)!.choose_language,
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Built', fontWeight: FontWeight.w600, fontSize: 23)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          AppLocalizations.of(context)!.choose_language_dropdown,
                          style: textStyle,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            dropdownColor: Colors.black,
                            value: selectValue,
                            onChanged: (String? newValue) => setState(
                              () async {
                                selectValue = newValue!;
                                submittedLanguage = false;
                                context.read<LanguageFormBloc>().add(LanguageFormEvent.selectLanguage(
                                    selectValue == 'Türkçe' ? const Locale('tr') : const Locale('en')));

                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('language', selectValue == 'Türkçe' ? 'tr' : 'en');
                              },
                            ),
                            isExpanded: true,
                            hint: Text(AppLocalizations.of(context)!.choose_language_dropdown,
                                style: const TextStyle(
                                    fontFamily: 'Akhand',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17)),
                            iconSize: 24,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: _languages.map(buildMenuItem).toList(),
                          ),
                          Visibility(
                            visible: submittedLanguage,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(AppLocalizations.of(context)!.language_error_message,
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: projectColors.blue,
                          fixedSize: const Size(154, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () async {
                          if (selectValue != null) {
                            choicePageStatus();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('language', locale.languageCode);
                            await prefs.setBool('isLogin', false);
                            addLocation();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcoming()));
                          } else {
                            setState(() {
                              if (selectValue != null) {
                              } else if (selectValue == null) {
                                submittedLanguage = true;
                              } else {
                                submittedLanguage = true;
                              }
                            });
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.continue_button,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Built'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Akhand', color: Colors.white),
      ));
}
