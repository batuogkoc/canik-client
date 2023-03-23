import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key}) : super(key: key);

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: Image.asset('assets/images/canik_super.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('DOĞRULAMA KODU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Countdown(
                        seconds: 180,
                        build: (BuildContext context, double time) => Text(
                            '... numaralı telefon numaranıza 6 basamaklı doğrulama kodunu içeren mesaj gönderilmiştir. Kalan süre $time saniye',
                            style: const TextStyle(color: Colors.white))),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Telefonunuza gelen kodu giriniz',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 370,
              child: Divider(
                height: 15,
                color: Colors.white,
                thickness: 1.0,
              ),
            ),
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
                  const Text("Kod gelmedi mi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextButton(
                        onPressed: () {},
                        child: const Text('Tekrar Gönder',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: TextButton(
                  onPressed: () {},
                  child: const Text('Kayıt olmadan devam et',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ))),
            ),
          ])),
    );
  }
}
