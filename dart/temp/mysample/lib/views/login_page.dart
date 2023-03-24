import 'package:flutter/material.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_store_home_page.dart';
import 'package:mysample/views/register_page.dart';
import 'package:mysample/views/tabs_bar.dart';

class LoginC extends StatefulWidget {
  LoginC({Key? key}) : super(key: key);

  @override
  State<LoginC> createState() => _LoginCState();
}

class _LoginCState extends State<LoginC> {
  @override
  Widget build(BuildContext context) {
    ThemeData(fontFamily: 'Akhand');
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/images/canik_super.png'),
            ),
            const Text('Canik ID ve Parolanız ile giriş yapabilirsiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: projectColors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText: 'Canik ID',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: projectColors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: 'Parola',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 11.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: projectColors.blue,
                            fixedSize: const Size(152, 54),
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
                            'Giriş Yap',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Built'),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                //titlePadding: EdgeInsets.only(left: 150),
                                title: const Center(
                                    child: Text('Şifremi unuttum')),
                                content: Column(
                                  children: const [
                                    Text(
                                      'Şifrenizi yenilenmemiz için e-mail adresinizi veya telefon numaranıza ihtiyacımız var',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        hintText:
                                            'Telefon numarası ya da e-mail adresi ',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Tamam'))
                                ],
                              ),
                            );
                          },
                          child: Text(
                            'PAROLAMI UNUTTUM',
                            style: TextStyle(
                              color: projectColors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Hesabınız yok mu?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text('Hemen üye ol',
                                    style: TextStyle(
                                      color: projectColors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextButton(
                              onPressed: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TabBarPage(
                                                  index: 0,
                                                )))
                                  },
                              child: Text('Üye olmadan devam et',
                                  style: TextStyle(
                                    color: projectColors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
