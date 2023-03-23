import 'package:flutter/material.dart';
import 'package:mysample/models/all_acc_model.dart';
import 'package:mysample/views/acc_details.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/app_bar_widget.dart';

class AllAcce extends StatefulWidget {
  const AllAcce({Key? key}) : super(key: key);

  @override
  State<AllAcce> createState() => _AllAcceState();
}

class _AllAcceState extends State<AllAcce> {
  @override
  Widget build(BuildContext context) {
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
          appBar: const CustomAppBarWithText(
            text: 'Yükseltme Ve Görev Paketleri',
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          primary: projectColors.black2,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchAcce()));
                        },
                        icon: const Icon(Icons.search),
                        label: const Text(
                          'AKSESUARLARDA ARA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(50, 50),
                            primary: projectColors.black2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            side: BorderSide(
                                color: projectColors.black3, width: 3.0)),
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchGun()));
                        },
                        child: const Icon(Icons.filter_alt_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 300),
                  itemCount: accessoryList.length,
                  itemBuilder: (_, index) =>
                      buildCard(item: accessoryList[index]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildCard({required Acces item}) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(20),
              child: Ink.image(
                height: 150,
                width: 150,
                image: AssetImage(
                  item.imageUrl,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccDetail()));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: TextStyle(
                        fontSize: 17,
                        color: projectColors.blue,
                      ),
                    ),
                    Text(
                      item.hastag,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
