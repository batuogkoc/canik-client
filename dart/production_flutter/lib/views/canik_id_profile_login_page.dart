// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/cubit/special_page_cubit.dart';
import 'package:mysample/entities/new.dart';
import 'package:mysample/models/slide.dart';
import 'package:mysample/models/special_detail_listview.dart';
import 'package:mysample/models/special_model.dart';
import 'package:mysample/repository/repo_new.dart';
import 'package:mysample/repository/repo_weapon.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/register_Login_screen.dart';
import 'package:mysample/views/register_page.dart';
import 'package:mysample/views/special_details_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:mysample/widgets/app_bar_icon_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/language_form_bloc.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/webview_widget.dart';

class CanikIdProfileLogin extends StatefulWidget {
  const CanikIdProfileLogin({Key? key}) : super(key: key);

  @override
  State<CanikIdProfileLogin> createState() => _CanikIdProfileLoginState();
}

class _CanikIdProfileLoginState extends State<CanikIdProfileLogin> {
  String selectCountry = 'Türkiye';
  String? selectCity;
  bool _notification = false;
 @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final String _loginUrl =
      'https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_signupsignin&client_id=98c22eff-99a3-43cb-86b5-7d5b906e0cbe&nonce=defaultNonce&redirect_uri=https%3A%2F%2Foauth.pstmn.io%2Fv1%2Fcallback&scope=openid&response_type=id_token&prompt=login&ui_locales=${locale.languageCode}';
    const textStyleTitleText = TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
    const textStyle = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500);
    final height = MediaQuery.of(context).size.height;
    String? selectValue = locale.languageCode == 'tr' ? 'Türkçe' : 'English';
    List<String> _citys = [
      "Adana",
      "Adıyaman",
      "Afyonkarahisar",
      "Ağrı",
      "Aksaray",
      "Amasya",
      "Ankara",
      "Antalya",
      "Ardahan",
      "Artvin",
      "Aydın",
      "Balıkesir",
      "Bartın",
      "Batman",
      "Bayburt",
      "Bilecik",
      "Bingöl",
      "Bitlis",
      "Bolu",
      "Burdur",
      "Bursa",
      "Çanakkale",
      "Çankırı",
      "Çorum",
      "Denizli",
      "Diyarbakır",
      "Düzce",
      "Edirne",
      "Elazığ",
      "Erzincan",
      "Erzurum",
      "Eskişehir",
      "Gaziantep",
      "Giresun",
      "Gümüşhane",
      "Hakkâri",
      "Hatay",
      "Iğdır",
      "Isparta",
      "İstanbul",
      "İzmir",
      "Kahramanmaraş",
      "Karabük",
      "Karaman",
      "Kars",
      "Kastamonu",
      "Kayseri",
      "Kilis",
      "Kırıkkale",
      "Kırklareli",
      "Kırşehir",
      "Kocaeli",
      "Konya",
      "Kütahya",
      "Malatya",
      "Manisa",
      "Mardin",
      "Mersin",
      "Muğla",
      "Muş",
      "Nevşehir",
      "Niğde",
      "Ordu",
      "Osmaniye",
      "Rize",
      "Sakarya",
      "Samsun",
      "Şanlıurfa",
      "Siirt",
      "Sinop",
      "Sivas",
      "Şırnak",
      "Tekirdağ",
      "Tokat",
      "Trabzon",
      "Tunceli",
      "Uşak",
      "Van",
      "Yalova",
      "Yozgat",
      "Zonguldak"
    ];
    List<String> _countries = [
      'Türkiye',
      'ABD Virgin Adaları',
      'Afganistan',
      'Aland Adaları',
      'Almanya',
      'Amerika Birleşik Devletleri',
      'Amerika Birleşik Devletleri Küçük Dış Adaları',
      'Amerikan Samoası',
      'Andora',
      'Angola',
      'Anguilla',
      'Antarktika',
      'Antigua ve Barbuda',
      'Arjantin',
      'Arnavutluk',
      'Aruba',
      'Avrupa Birliği',
      'Avustralya',
      'Avusturya',
      'Azerbayca ',
      'Bahamalar',
      'Bahreyn',
      'Bangladeş',
      'Barbados',
      'Batı Sahara',
      'Belize',
      'Belçika',
      'Benin',
      'Bermuda',
      'Beyaz Rusya',
      'Bhutan',
      'Bilinmeyen veya Geçersiz Bölge',
      'Birleşik Arap Emirlikleri',
      'Birleşik Krallık',
      'Bolivya',
      'Bosna Hersek',
      'Botsvana',
      'Bouvet Adası',
      'Brezilya',
      'Brunei',
      'Bulgaristan',
      'Burkina Faso',
      'Burundi',
      'Cape Verde',
      'Cebelitarık',
      'Cezayir',
      'Christmas Adası',
      'Cibuti',
      'Cocos Adaları',
      'Cook Adaları',
      'Çad',
      'Çek Cumhuriyeti',
      'Çin',
      'Danimarka',
      'Dominik',
      'Dominik Cumhuriyeti',
      'Doğu Timor',
      'Ekvator',
      'Ekvator Ginesi',
      'El Salvador',
      'Endonezya',
      'Eritre',
      'Ermenistan',
      'Estonya',
      'Etiyopya',
      'Falkland Adaları (Malvinalar)',
      'Faroe Adaları',
      'Fas',
      'Fiji',
      'Fildişi Sahilleri',
      'Filipinler',
      'Filistin Bölgesi',
      'Finlandiya',
      'Fransa',
      'Fransız Guyanası',
      'Fransız Güney Bölgeleri',
      'Fransız Polinezyası',
      'Gabon',
      'Gambia',
      'Gana',
      'Gine',
      'Gine-Bissau',
      'Granada',
      'Grönland',
      'Guadeloupe',
      'Guam',
      'Guatemala',
      'Guernsey',
      'Guyana',
      'Güney Afrika',
      'Güney Georgia ve Güney Sandwich Adaları',
      'Güney Kore',
      'Güney Kıbrıs Rum Kesimi',
      'Gürcistan',
      'Haiti',
      'Heard Adası ve McDonald Adaları',
      'Hindistan',
      'Hint Okyanusu İngiliz Bölgesi',
      'Hollanda',
      'Hollanda Antilleri',
      'Honduras',
      'Hong Kong SAR - Çin',
      'Hırvatistan',
      'Irak',
      'İngiliz Virgin Adaları',
      'İran',
      'İrlanda',
      'İspanya',
      'İsrail',
      'İsveç',
      'İsviçre',
      'İtalya',
      'İzlanda',
      'Jamaika',
      'Japonya',
      'Jersey',
      'Kamboçya',
      'Kamerun',
      'Kanada',
      'Karadağ',
      'Katar',
      'Kayman Adaları',
      'Kazakistan',
      'Kenya',
      'Kiribati',
      'Kolombiya',
      'Komorlar',
      'Kongo',
      'Kongo Demokratik Cumhuriyeti',
      'Kosta Rika',
      'Kuveyt',
      'Kuzey Kore',
      'Kuzey Mariana Adaları',
      'Küba',
      'Kırgızistan',
      'Laos',
      'Lesotho',
      'Letonya',
      'Liberya',
      'Libya',
      'Liechtenstein',
      'Litvanya',
      'Lübnan',
      'Lüksemburg',
      'Macaristan',
      'Madagaskar',
      'Makao S.A.R. Çin',
      'Makedonya',
      'Malavi',
      'Maldivler',
      'Malezya',
      'Mali',
      'Malta',
      'Man Adası',
      'Marshall Adaları',
      'Martinik',
      'Mauritius',
      'Mayotte',
      'Meksika',
      'Mikronezya Federal Eyaletleri',
      'Moldovya Cumhuriyeti',
      'Monako',
      'Montserrat',
      'Moritanya',
      'Mozambik',
      'Moğolistan',
      'Myanmar',
      'Mısır',
      'Namibya',
      'Nauru',
      'Nepal',
      'Nijer',
      'Nijerya',
      'Nikaragua',
      'Niue',
      'Norfolk Adası',
      'Norveç',
      'Orta Afrika Cumhuriyeti',
      'Özbekistan',
      'Pakistan',
      'Palau',
      'Panama',
      'Papua Yeni Gine',
      'Paraguay',
      'Peru',
      'Pitcairn',
      'Polonya',
      'Portekiz',
      'Porto Riko',
      'Reunion',
      'Romanya',
      'Ruanda',
      'Rusya Federasyonu',
      'Saint Helena',
      'Saint Kitts ve Nevis',
      'Saint Lucia',
      'Saint Pierre ve Miquelon',
      'Saint Vincent ve Grenadinler',
      'Samoa',
      'San Marino',
      'Sao Tome ve Principe',
      'Senegal',
      'Seyşeller',
      'Sierra Leone',
      'Singapur',
      'Slovakya',
      'Slovenya',
      'Solomon Adaları',
      'Somali',
      'Sri Lanka',
      'Sudan',
      'Surinam',
      'Suriye',
      'Suudi Arabistan',
      'Svalbard ve Jan Mayen',
      'Svaziland',
      'Sırbistan',
      'Sırbistan-Karadağ',
      'Şili',
      'Tacikistan',
      'Tanzanya',
      'Tayland',
      'Tayvan',
      'Togo',
      'Tokelau',
      'Tonga',
      'Trinidad ve Tobago',
      'Tunus',
      'Turks ve Caicos Adaları',
      'Tuvalu',
      'Türkmenistan',
      'Uganda',
      'Ukrayna',
      'Umman',
      'Uruguay',
      'Uzak Okyanusya',
      'Ürdün',
      'Vanuatu',
      'Vatikan',
      'Venezuela',
      'Vietnam',
      'Wallis ve Futuna',
      'Yemen',
      'Yeni Kaledonya',
      'Yeni Zelanda',
      'Yunanistan',
      'Zambiya',
      'Zimbabve'
    ];
    List<String> _languages = ['English', 'Türkçe'];
    return Stack(
      children: [
        Image.asset(
          'assets/images/backgroundNew.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: CustomAppBarWithText(
              text: AppLocalizations.of(context)!.settings,
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: height / 20, right: height / 20, top: height / 15),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/globe-americas.png'),
                                color: projectColors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.language,
                                style: textStyleTitleText,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 5.0),
                            child: Text(
                              AppLocalizations.of(context)!.choose_language_dropdown,
                              style: textStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              value: selectValue,
                              underline: SizedBox(),
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
                                  style: textStyleTitleText),
                              iconSize: 24,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items: _languages.map(buildMenuItem).toList(),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ImageIcon(
                                    AssetImage('assets/images/bell.png'),
                                    color: projectColors.blue,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.notification,
                                    style: textStyleTitleText,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CupertinoSwitch(
                                    activeColor: projectColors.blue,
                                    trackColor: projectColors.black3,
                                    value: _notification,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _notification = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    fixedSize: const Size(152, 54),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
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
                                  child: Text(
                                    AppLocalizations.of(context)!.sign_in,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontFamily: 'Built',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: projectColors.blue,
                                    fixedSize: const Size(152, 54),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side:  BorderSide(width: 1, color: projectColors.blue)),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0)));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.continue_without_login,
                                    style: TextStyle(
                                        color: projectColors.white ,
                                        fontSize: 16,
                                        fontFamily: 'Built',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.white),
      ));
}
