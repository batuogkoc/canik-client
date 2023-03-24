import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_store_home_page.dart';
import 'package:mysample/views/login_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:mysample/widgets/date_picker_widget.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isChecked = false;
  bool isCheckedK = false;
  bool isCheckedKi = false;
  bool isCheckedP = false;
  bool isCheckedGps = false;
  String? _selectedCountry;
  @override
  Widget build(BuildContext context) {
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

    final Text hintext;
    final TextEditingController controller = TextEditingController();
    String initialCountry = 'TR';
    Future<List<int>> _readDocumentData(String name) async {
      final ByteData data = await rootBundle.load('assets/textfiles/$name');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    }

    Future<void> _extractAllText() async {
      //Load the existing PDF document.
      PdfDocument document = PdfDocument(inputBytes: await _readDocumentData('CanikApp_enlightenment_text_tr.pdf'));

      //Create the new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      //Display the text.
      //_showResult(text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('CanikApp KVKK Aydınlatma Metni'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(text),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
        ),
      );
    }

    Future<void> _extractAllTextK() async {
      //Load the existing PDF document.
      PdfDocument document = PdfDocument(inputBytes: await _readDocumentData('CanikApp_user_agreement_tr.pdf'));

      //Create the new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      //Display the text.
      //_showResult(text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('CanikApp kullanıcı sözleşmesi:'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(text),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image_9.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: [
              SizedBox(
                child: Image.asset('assets/images/canik_super.png'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Text('YENİ ÜYE',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Built',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text('Haydi başlayalım',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Canik ID',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Adınız Soyadınız',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const TextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Parola',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'E-mail adresi',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DatePickerWidget(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: _selectedCountry,
                      onChanged: (String? newValue) => setState(
                        () => _selectedCountry = newValue!,
                      ),
                      isExpanded: true,
                      hint: const Text('Ülkenizi seçiniz',
                          style: TextStyle(
                              fontFamily: 'Akhand', color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16)),
                      iconSize: 24,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items: _countries.map(buildMenuItem).toList(),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: InternationalPhoneNumberInput(
                  //     onInputChanged: (PhoneNumber number) {
                  //       print(number.phoneNumber);
                  //     },
                  //     onInputValidated: (bool value) {
                  //       print(value);
                  //     },
                  //     selectorConfig: const SelectorConfig(
                  //       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  //     ),
                  //     ignoreBlank: false,
                  //     inputDecoration: const InputDecoration(
                  //         enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white),
                  //         ),
                  //         focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.blue),
                  //         ),
                  //         hintStyle: TextStyle(color: Colors.white),
                  //         hintText: 'Telefon Numarası'),
                  //     textStyle: TextStyle(color: Colors.white),
                  //     autoValidateMode: AutovalidateMode.disabled,
                  //     selectorTextStyle: const TextStyle(color: Colors.white),
                  //     cursorColor: Colors.white,
                  //     initialValue: number,
                  //     textFieldController: controller,
                  //     formatInput: false,
                  //     keyboardType: const TextInputType.numberWithOptions(
                  //         signed: true, decimal: true),
                  //     inputBorder: const OutlineInputBorder(),
                  //     onSaved: (PhoneNumber number) {
                  //       print('On Saved: $number');
                  //     },
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.0, color: Colors.white),
                          ),
                          value: isCheckedK,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedK = value!;
                            });
                          }),
                      SizedBox(
                        child: TextButton(
                            onPressed: _extractAllTextK,
                            child: const Text(
                              'CanikApp kullanıcı sözleşmesini kabul ediyorum.',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.0, color: Colors.white),
                          ),
                          value: isCheckedKi,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedKi = value!;
                            });
                          }),
                      SizedBox(
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Kişiselleştirilmiş pazarlamaya rıza veriyorum.'),
                                  content: const Text(
                                      'CanikApp Aydınlatma Metni uyarınca ürün pazarlama süreçlerinin yürütülmesi kapsamında geçmişe dönük alışveriş alışkanlıklarım ve eğilimlerim ile mobil uygulama sayfa ziyaret ve gezinme bilgilerimin analiz edilerek pazarlama faaliyetlerinin planlanması, segmentasyon ve profilleme analizlerinin yapılması için elde edilmesini, işlenmesini ve saklanmasını bu kutucuğu işaretleyerek kabul ediyorum. \n Yukarıda yer alanlara ilişkin rızamı vermek zorunda olmadığımı ve Canik ile iletişime geçerek herhangi bir zamanda geri alabileceğimin farkındayım. İlgili rızanın geri alınması, geri alınmadan önce söz konusu rızaya dayalı herhangi bir işlemenin yasallığını etkilememektedir.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'Kişiselleştirilmiş pazarlamaya rıza veriyorum.',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.0, color: Colors.white),
                          ),
                          value: isCheckedP,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedP = value!;
                            });
                          }),
                      SizedBox(
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Pazarlamaya ilişkin ticari iletileri almaya rıza veriyorum'),
                                  content: const SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                        'CanikApp Aydınlatma Metni uyarınca elektronik posta adresim, cep telefonu numaram, bulunduğum ülke ve saat dilimi ile uygulamada seçtiğim dil bilgisi dahil olmak üzere kişisel verilerimin reklam, kampanya, promosyon, genel hediye kodları, müşteriye özel tek kullanımlık kodlar ve özelleştirilmiş reklamların iletilmesi; ürün pazarlama ve tanıtım süreçleri ile iletişim faaliyetlerinin yürütülmesi; Canik’e yönelttiğim soruların cevaplanması amaçlarıyla elde edilmesini, işlenmesini ve saklanmasını ve tarafıma bu doğrultuda ticari elektronik ileti (örneğin, SMS, push notification ve e-posta) gönderilmesini bu kutucuğu işaretleyerek kabul ediyorum.  \n Yukarıda yer alanlara ilişkin rızamı vermek zorunda olmadığımı ve Canik ile iletişime geçerek herhangi bir zamanda geri alabileceğimin farkındayım. İlgili rızanın geri alınması, geri alınmadan önce söz konusu rızaya dayalı herhangi bir işlemenin yasallığını etkilememektedir.'),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'Pazarlamaya ilişkin ticari iletileri almaya rıza veriyorum.',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.0, color: Colors.white),
                          ),
                          value: isCheckedGps,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedGps = value!;
                            });
                          }),
                      SizedBox(
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('GPS konumumun işlenmesine rıza veriyorum.'),
                                  content: const Text(
                                      'CanikApp Aydınlatma Metni uyarınca, GPS konumumun, bulunduğum konuma yakın Canik etkinlikleri, ürünleri ve hizmetleri hakkında bilgilendirmeleri alabilmem amacıyla elde edilmesini, işlenmesini ve saklanmasını bu kutucuğu işaretleyerek kabul ediyorum. \n Yukarıda yer alanlara ilişkin rızamı vermek zorunda olmadığımı ve Canik ile iletişime geçerek herhangi bir zamanda geri alabileceğimin farkındayım. İlgili rızanın geri alınması, geri alınmadan önce söz konusu rızaya dayalı herhangi bir işlemenin yasallığını etkilememektedir.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'GPS konumumun işlenmesine rıza veriyorum.',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: _extractAllText,
                      child: const Text(
                        'CanikApp KVKK Aydınlatma Metnini okumak için buraya tıklayabilirsiniz.',
                        style: TextStyle(color: Colors.white),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: projectColors.blue,
                          fixedSize: const Size(315, 53),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabBarPage(
                                        index: 0,
                                      )));
                        },
                        child: const Text(
                          'Üye Ol',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Built'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Zaten üye misin?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginC()));
                            },
                            child: const Text('Giriş yap',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                ))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Akhand', color: Colors.white),
      ));
}

                    // CountryListPick(
                    //   appBar: AppBar(
                    //     backgroundColor: Colors.black,
                    //     title: Text('Pick your country'),
                    //   ),
                    //   theme: CountryTheme(
                    //     isShowFlag: true,
                    //     isShowTitle: true,
                    //     isShowCode: true,
                    //     isDownIcon: true,
                    //     showEnglishName: false,
                    //     labelColor: Colors.white,
                    //   ),
                    //   initialSelection: '+90',
                    //   onChanged: (CountryCode? code) {
                    //     print(code?.name);
                    //     print(code?.code);
                    //     print(code?.dialCode);
                    //     print(code?.flagUri);
                    //   },
                    // ),