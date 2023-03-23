import 'package:flutter/material.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/gun_home_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_bar_widget.dart';
import 'ask_us_chat_page.dart';

class AskUsQuestionsPage extends StatefulWidget {
  @override
  State<AskUsQuestionsPage> createState() => _AskUsQuestionsPageState();
}

class _AskUsQuestionsPageState extends State<AskUsQuestionsPage> {
  String? selectProduct;
  String? selectHeader;
  final List<String> _headers = ['Test1', 'Test2', 'Test3'];
  final List<String> _products = ['Test1', 'Test2', 'Test3'];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Image.asset(
          'assets/images/image_9.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBarWithText(text: 'Bize Sorun'),
          body: Padding(
            padding: EdgeInsets.only(
              left: height / 20,
              right: height / 30,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: height / 8.5),
                SizedBox(
                  height: height / 50,
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  'Kategori Seçiniz',
                  style: TextStyle(
                      color: projectColors.white1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Column(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: selectProduct,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectProduct = newValue!;
                        });
                        print(selectProduct);
                      },
                      isExpanded: true,
                      hint: Text(
                        'Ürünler',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      iconSize: 24,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items: _products.map(buildMenuItem).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  'Başlık',
                  style: TextStyle(
                      color: projectColors.white1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: selectHeader,
                  onChanged: (String? newValue) => setState(() => {
                        selectHeader = newValue!,
                      }),
                  isExpanded: true,
                  hint: Text('BAŞLIK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  iconSize: 24,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  items: _headers.map(buildMenuItem).toList(),
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  'Açıklama',
                  style: TextStyle(
                      color: projectColors.white1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: projectColors.blue),
                    ),
                    hintText: 'Açıklama',
                    hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: height / 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: projectColors.blue,
                        minimumSize: Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AskUsChatPage()));
                      },
                      child: Text(
                        'SORUYU GÖNDER',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Built'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Akhand',
            color: Colors.white),
      ));
}
