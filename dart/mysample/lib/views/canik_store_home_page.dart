import 'package:flutter/material.dart';
import 'package:mysample/entities/main_category.dart';
import 'package:mysample/models/canik_gun_models.dart';
import 'package:mysample/repository/repo_product.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_store_details_page.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:mysample/widgets/loading_widget.dart';
import 'package:sizer/sizer.dart';
import '../models/gun.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CanikStore extends StatefulWidget {
  const CanikStore({Key? key}) : super(key: key);

  @override
  State<CanikStore> createState() => _CanikStoreState();
}

class _CanikStoreState extends State<CanikStore> {
  String image = 'images/assets/mete_gun.png';
  late Future<List<MainCategory>> mainCategories;
  GetAllProducts? getAllProducts;
  static final  customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
  );
  static final customTextStyleL = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 9.sp,
  );

  static final customTextStyleLIpad = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 8.sp,
  );

  final controller = TextEditingController();
  bool isLoading = false;
  List<CSearchGun> guns = gunListt;
  // List<String> products;
  bool isVisible = true;
  bool isVisibleCard = false;
  CSearchGun gunToDisplay = const CSearchGun(id: 1, title: 'bt', imgPath: 'assets/images/big_equ.png');

  var repository = RepositoryProduct();

  List<GetAllProducts> products = [];

  GetAllProducts selectedProduct = GetAllProducts();

  Future<List<MainCategory>> getAllMainCategories() async {
    var mainCategories = await repository.getAllMainCategories();
    isLoading = true;
    return mainCategories;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      mainCategories = getAllMainCategories();
    });
    
    // context.read<ProductCubit>().getProducts().then((value) => products = value.products);
  }
//TODO: BLOCBUİLDER YAPISINI GERİ KUR UNUTMA.

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            const BackgroundImage(),
            FutureBuilder(
                future: getAllMainCategories(),
                builder: (context, snapshot) {
                  if (isLoading == false) {
                    return Loading(isLoading: isLoading);
                  }
                  return const Center();
                })
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            physics:const BouncingScrollPhysics(),
            children: [
              Padding(
                padding:const EdgeInsets.only(left: 30.0, right: 30.0, top: 30,bottom: 15),
                child:100.h < 1220 ? SizedBox(
                  child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: projectColors.black2,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: projectColors.blue, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white, width: 1),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        prefixIconColor: Colors.white,
                        hintText: AppLocalizations.of(context)!.search_text,
                        hintStyle:  customTextStyle,
                      ),
                      onChanged: (query) {
                       
                      })
                ):
                SizedBox(
                  child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: projectColors.black2,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: projectColors.blue, width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white, width: 3),
                        ),
                        prefixIcon:const Padding(
                          padding:  EdgeInsets.only(left: 25),
                          child:  Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        prefixIconColor: Colors.white,
                        hintText: AppLocalizations.of(context)!.search_text,
                        hintStyle:  customTextStyleLIpad,
                      ),
                      onChanged: (query) {
                        
                      })
                )
                ,
              ),
              Visibility(
                visible: !isVisible,
                child: const Padding(
                  padding: EdgeInsets.only(left: 32.0, top: 22, bottom: 9),
                  child: Text('Search Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
              Visibility(visible: isVisibleCard, child: SearchResultCard(selectedProduct)),
              Visibility(
                visible: isVisibleCard,
                child: const Padding(
                  padding: EdgeInsets.only(left: 32.0, top: 22, bottom: 9),
                  child: Text('Related Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
              Visibility(
                visible: !isVisible,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedProduct = product;
                                    isVisibleCard = true;
                                    controller.text = selectedProduct.productCategoryName!;
                                    controller.selection =
                                        TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 9),
                                    Text((product.productCategoryName ?? ''),
                                        style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 0.25,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0,right: 30),
                  child: SizedBox(
                    height: 100.h < 1220 ? 4.h : 5.h,
                    child: FutureBuilder<List<MainCategory>>(
                        future: mainCategories,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              //shrinkWrap: true,

                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) => 100.h < 1220 ? buildCard(
                                mainCategory: snapshot.data![index],
                              ) : buildCardForIPadpro(mainCategory: snapshot.data![index],),
                              separatorBuilder: (_, index) => const SizedBox(width: 10),
                            );
                          } else {
                            return const Center();
                          }
                        }),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, top: 20, right: 50, bottom: 45),
                  child: SizedBox(
                    height:100.h < 1220 ? 100.h : 120.h,
                    child: FutureBuilder<List<MainCategory>>(
                      future: mainCategories,
                      builder: (context, snapshot) {
                        //List<MainCategory> x = snapshot.data!;
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              //shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,

                                //mainAxisExtent: 300,
                                //childAspectRatio: (itemWidth / itemHeight),
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) =>
                                  buildImageCard(mainCategory: snapshot.data![index], item2: gunList[index]),
                            ),
                          );
                        } else {
                          return const Center();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<GetAllProducts> searchItem(String query, List<GetAllProducts> nameOfProducts) {
    var filtredProducts = nameOfProducts
        .where((element) => element.productCategoryName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print(filtredProducts.length);
    products = filtredProducts;
    return filtredProducts;
  }

  Widget buildImageCard({required MainCategory mainCategory, required Gun item2}) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreDetails(
                        gun: item2,
                        categoryName: mainCategory.parentProductCategoryName,
                      )));
        },
        child: 100.h < 1220 ?   Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/gun_background.png'), fit: BoxFit.cover)),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ 
              Expanded(flex: 8, child: Image.asset(item2.imageUrl)),
              Expanded(
                flex: 2,
                child: Text(
                  mainCategory.parentProductCategoryName,
                  style: customTextStyle,
                ),
              ),
            ],
          )
        ):
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/gun_background.png'), fit: BoxFit.cover)),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Container(height: 180,  child: Image.asset(item2.imageUrl,fit: BoxFit.fill,)),
              const SizedBox(height: 100,),
              Text(
                mainCategory.parentProductCategoryName,
                style: customTextStyleLIpad,
              ),
            ],
          )
        )
        ,
      );

  Widget buildCard({required MainCategory mainCategory, Gun? gun}) => Center(
    child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoreDetails(
                            gun: gun,
                            categoryName: mainCategory.parentProductCategoryName,
                          )));
            },
            child: Container(
              color: projectColors.black2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: Text(
                    mainCategory.parentProductCategoryName,
                    style: customTextStyleL,
                  ),
                ),
              ),
            ),
          ),
        ),
  );
       Widget buildCardForIPadpro({required MainCategory mainCategory, Gun? gun}) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoreDetails(
                          gun: gun,
                          categoryName: mainCategory.parentProductCategoryName,
                        )));
          },
          child: Container(
            color: projectColors.black2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Center(
                child: Text(
                  mainCategory.parentProductCategoryName,
                  style: customTextStyleLIpad,
                ),
              ),
            ),
          ),
        ),
      );

  Widget SearchResultCard(GetAllProducts product) => Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 28),
        child: SizedBox(
          width: 315,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xff4C535E).withOpacity(0.60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15.0),
                  child: Text(
                    (product.productCategoryName ?? ''),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15.0),
                  child: Text(
                    (product.productNumber ?? ''),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  // Column(
  //   mainAxisAlignment: MainAxisAlignment.start,
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     // Padding(
  //     //   padding: const EdgeInsets.only(bottom: 12.0),
  //     //   child: ElevatedButton.icon(
  //     //     style: ElevatedButton.styleFrom(
  //     //       alignment: Alignment.centerLeft,
  //     //       primary: Color(0xff393E46),
  //     //       fixedSize: const Size(500, 60),
  //     //       shape: RoundedRectangleBorder(
  //     //           borderRadius: BorderRadius.circular(15)),
  //     //     ),
  //     //     onPressed: () {
  //     //       Navigator.push(
  //     //           context,
  //     //           MaterialPageRoute(
  //     //               builder: (context) => SearchGun()));
  //     //     },
  //     //     icon: const Icon(Icons.search),
  //     //     label: const Text(
  //     //       'SİLAHLARDA ARA',
  //     //       style: TextStyle(
  //     //           color: Colors.white,
  //     //           fontSize: 17,
  //     //           fontFamily: 'Akhand',
  //     //           fontWeight: FontWeight.w600),
  //     //     ),
  //     //   ),
  //     // ),
  //     SizedBox(
  //       height: 360,
  //       child: ListView.separated(
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         itemCount: gunList.length,
  //         itemBuilder: (_, index) =>
  //             buildCard(item: gunList[index]),
  //         separatorBuilder: (_, index) => const SizedBox(
  //             width: 12,
  //             child: SizedBox(
  //               height: 15,
  //             )),
  //       ),
  //     ),
  //   ],
  // ),
  // Column(
  //   mainAxisAlignment: MainAxisAlignment.start,
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.only(bottom: 12.0),
  //       child: ElevatedButton.icon(
  //         style: ElevatedButton.styleFrom(
  //           alignment: Alignment.centerLeft,
  //           primary: Color(0xff393E46),
  //           fixedSize: const Size(500, 60),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15)),
  //         ),
  //         onPressed: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => SearchAcce()));
  //         },
  //         icon: const Icon(Icons.search),
  //         label: const Text(
  //           'AKSESUARLARDA ARA',
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 17,
  //               fontFamily: 'Akhand',
  //               fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //     ),
  //     // SizedBox(
  //     //   height: 120,
  //     //   child: ListView.separated(
  //     //     shrinkWrap: true,
  //     //     scrollDirection: Axis.vertical,
  //     //     itemCount: accessoryList.length,
  //     //     itemBuilder: (_, index) =>
  //     //         buildCardAc(item: accessoryList[index]),
  //     //     separatorBuilder: (_, index) => const SizedBox(
  //     //         width: 12,
  //     //         child: SizedBox(
  //     //           height: 15,
  //     //         )),
  //     //   ),
  //     // ),
  //   ],
  // ),
  // Widget buildCard({required Gun item}) => Container(
  //       width: 315,
  //       height: 120,
  //       child: AspectRatio(
  //         aspectRatio: 12 / 3,
  //         child: Stack(
  //           children: [
  //             ClipRect(
  //               child: Material(
  //                 color: Colors.blueGrey.shade300,
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: Ink.image(
  //                   alignment: Alignment.topRight,
  //                   image: AssetImage(
  //                     item.imageUrl,
  //                   ),
  //                   child: InkWell(
  //                     onTap: () {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) => StoreDetails()),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 10.0, horizontal: 25.0),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         item.productName,
  //                         style: cardTextStyle,
  //                       ),
  //                       Text(
  //                         'SERİSİ',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontFamily: 'Built',
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w400),
  //                       ),
  //                       Text(
  //                         item.productOfNumber,
  //                         textAlign: TextAlign.start,
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  // Widget buildCardAc({required Accessory item}) => Container(
  //       width: 315,
  //       height: 120,
  //       child: AspectRatio(
  //         aspectRatio: 12 / 3,
  //         child: Stack(
  //           children: [
  //             ClipRect(
  //               child: Material(
  //                 color: Colors.blueGrey.shade300,
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: Ink.image(
  //                   alignment: Alignment.topRight,
  //                   image: AssetImage(
  //                     item.imageUrl,
  //                   ),
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => Accessoryy()));
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     item.productName,
  //                     style: cardTextStyle,
  //                   ),
  //                   Text(
  //                     item.productOfNumber,
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
}
