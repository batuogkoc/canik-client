import 'package:flutter/material.dart';
import 'package:mysample/views/register_page.dart';

import 'confirm_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'TR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image_9.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Image.asset('assets/images/canik_super.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('HOŞ GELDİNİZ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text('Kayıtlı cep telefonunuzu girerek giriş yapabilirsiniz.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Cep Telefon Numaranız',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // InternationalPhoneNumberInput(
            //   onInputChanged: (PhoneNumber number) {
            //     print(number.phoneNumber);
            //   },
            //   onInputValidated: (bool value) {
            //     print(value);
            //   },
            //   selectorConfig: const SelectorConfig(
            //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            //   ),
            //   ignoreBlank: false,
            //   autoValidateMode: AutovalidateMode.disabled,
            //   selectorTextStyle: const TextStyle(color: Colors.white),
            //   initialValue: number,
            //   textFieldController: controller,
            //   formatInput: false,
            //   keyboardType: const TextInputType.numberWithOptions(
            //       signed: true, decimal: true),
            //   inputBorder: const OutlineInputBorder(),
            //   onSaved: (PhoneNumber number) {
            //     print('On Saved: $number');
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Confirm()));
                  },
                  child: const Text('KODU GÖNDER')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabınız yok mu?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
                        },
                        child: const Text('Hemen üye ol',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ))),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text('Üye olmadan devam et',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
