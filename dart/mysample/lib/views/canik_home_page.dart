import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mysample/cubit/main_page_product_cubit.dart';
import 'package:mysample/cubit/weapon_update_cubit.dart';
import 'package:mysample/entities/main_category.dart';
import 'package:mysample/entities/product_category_assignment.dart';
import 'package:mysample/entities/response/mainproduct_response.dart';
import 'package:mysample/sfs/sfs_connect_page/sfs_connect_page.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/all_shot_record_page.dart';
import 'package:mysample/views/register_Login_screen.dart';
import 'package:mysample/views/special_details_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../cubit/campaign_cubit.dart';
import '../cubit/product_categories_by_weapons_cubit.dart';
import '../cubit/weapon_list_cubit.dart';
import '../cubit/weapon_to_user_get_cubit.dart';
import '../entities/campaign.dart';
import '../entities/product_categories_by_weapons.dart';
import '../entities/product_category.dart';
import '../entities/response/weapon_to_user_response.dart';
import '../entities/weapon.dart';
import '../models/canik_gun_models.dart';
import '../models/canik_home_page_slide_models.dart';
import '../product/utility/is_tablet.dart';
import '../repository/repo_product.dart';
import '../widgets/loading_widget.dart';
import 'add_gun_with_barcode.dart';
import 'canik_store_details_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'compare_guns_page.dart';

class CanikHomePage extends StatefulWidget {
  AuthorizationTokenResponse? result;
 

  CanikHomePage({Key? key, this.result}) : super(key: key);

  @override
  State<CanikHomePage> createState() => _CanikHomePageState();
}

class _CanikHomePageState extends State<CanikHomePage> {
  late Future<List<MainCategory>> mainCategories;
  late Future<List<ProductCategoriesByWeapons>> productCategoriesFilteredByGuns;
  bool isLoading = false;
  bool? isLogin;
  var guns = gunList;
  ProjectColors projectColors = ProjectColors();

  static final customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 11.sp,
  );
  static final customTextStyleIpad = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 7.sp,
  );
  Gun item =
      Gun(imageUrl: 'assets/images/canik_store_1.png', productName: 'TP');
  int _current = 0;
  final controller = CarouselController();
  var repository = RepositoryProduct();

  String? canikId;
  String? name;
  String language = "";
  late Future<List<ProductCategoryAssignment>> productCategoryAssignments;

  String? imageUrl;
  Future<List<MainCategory>> getAllMainCategories() async {
    var mainCategories = await repository.getAllMainCategories();
    isLoading = true;
    return mainCategories;
  }

  Future<List<ProductCategoriesByWeapons>> getProductCategories() async {
    // var productCategory = await repository.getProductCategories("TABANCALAR");
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language')!.toCapitalized();
    });
    var productCategoryRaw = await context.read<ProductCategoriesByWeaponsCubit>().getProductCategoriesByWeapons(language);
    
    return productCategoryRaw.productCategoriesByWeapons;
  }
      // 

  // Future<List<ProductCategoryAssignment>> getAllProductCategoryAssignments(
  //     String productCategoryCode) async {
  //   var productCategoryAssignments =
  //       await repository.getAllProductCategoryAssignments(productCategoryCode);

  //   return productCategoryAssignments;
  // }

  Future<bool?> _isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool('isLogin');
    });
    return null;
  }

  setCanikid(String? canikId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('canikId', canikId!);
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('idToken');
    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      setState(() {
        name = payload['name'];
        canikId = payload['oid'];
        setCanikid(canikId);
      });
    }
  }

  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('canikId');
  }
  Future<void> getMainPageProducts() async {
  await context.read<MainPageProductCubit>().getMainPageProducts();
  }
  Future<void> getCampaigns() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language')!.toUpperCase();
    });

   await context.read<CampaignCubit>().getCampaigns(language);
  }

  static final customTextStyleLIpad = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 9.sp,
  );
  @override
  void initState() {
    super.initState();
    _isLogin();
    mainCategories = getAllMainCategories();
    productCategoriesFilteredByGuns = getProductCategories();

    // context.read<UserInfoCubit>().getUserInfoByBearerToken();
    getUserInfo().then((value) => context
        .read<WeaponListCubit>()
        .getAllWeaponToUsers(
            WeaponToUserListRequestModel(canikId: canikId ?? '')));

    getCampaigns();
    getMainPageProducts();
  }

  @override
  Widget build(BuildContext context) {
    final homePageSlideListTwo = [
      HomePageSlide(
          iconUrl: 'assets/images/task-planning.png',
          title: AppLocalizations.of(context)!.my_shots,
          subtitle: AppLocalizations.of(context)!.my_shots_subtitle),
    ];

    final List<Widget> imageSliders = homePageSlideListTwo
        .map(
          (item) => Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Container(
              height: 110,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.white, width: 1))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  100.h < 850
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: Image.asset(item.iconUrl)),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                        fontFamily: 'Built',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      color: projectColors.black3,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  var isLogin = prefs.getBool('isLogin');
                                  var x =
                                      AppLocalizations.of(context)!.my_shots;
                                  if (item.title.toLowerCase().contains(
                                      AppLocalizations.of(context)!
                                          .my_shots
                                          .toLowerCase())) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => isLogin == true
                                            ? const AllShotRecords()
                                            : const LoginRegister(),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                    Icons.keyboard_arrow_right_sharp),
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      : 100.h < 1220
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 2, child: Image.asset(item.iconUrl)),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                            fontFamily: 'Built',
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          color: projectColors.black3,
                                          fontSize: 9.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      var isLogin = prefs.getBool('isLogin');
                                      var x = AppLocalizations.of(context)!
                                          .my_shots;
                                      if (item.title.toLowerCase().contains(
                                          AppLocalizations.of(context)!
                                              .my_shots
                                              .toLowerCase())) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                isLogin == true
                                                    ? const AllShotRecords()
                                                    : const LoginRegister(),
                                          ),
                                        );
                                      }

                                      /// TODO: SERTİFİKALAR GELİNCE GELECEK FAZDA AÇ.
                                      // else if (item.title.toLowerCase().contains(
                                      //     AppLocalizations.of(context)!.certificates)) {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => isLogin == true
                                      //               ? CertificatesPage()
                                      //               : LoginRegister()));
                                      // }
                                    },
                                    icon: const Icon(
                                        Icons.keyboard_arrow_right_sharp),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          : 100.h < 1750
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 60,
                                        child: Image.asset(
                                          item.iconUrl,
                                          fit: BoxFit.contain,
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                              fontFamily: 'Built',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            color: projectColors.black3,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox.fromSize(
                                      size: const Size.fromRadius(50),
                                      child: FittedBox(
                                        child: IconButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var isLogin =
                                                prefs.getBool('isLogin');
                                            var x =
                                                AppLocalizations.of(context)!
                                                    .my_shots;
                                            if (item.title
                                                .toLowerCase()
                                                .contains(AppLocalizations.of(
                                                        context)!
                                                    .my_shots
                                                    .toLowerCase())) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => isLogin ==
                                                          true
                                                      ? const AllShotRecords()
                                                      : const LoginRegister(),
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_right_sharp),
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 80,
                                        child: Image.asset(
                                          item.iconUrl,
                                          fit: BoxFit.contain,
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                              fontFamily: 'Built',
                                              fontSize: 42,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            color: projectColors.black3,
                                            fontSize: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox.fromSize(
                                      size: const Size.fromRadius(60),
                                      child: FittedBox(
                                        child: IconButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var isLogin =
                                                prefs.getBool('isLogin');
                                            var x =
                                                AppLocalizations.of(context)!
                                                    .my_shots;
                                            if (item.title
                                                .toLowerCase()
                                                .contains(AppLocalizations.of(
                                                        context)!
                                                    .my_shots
                                                    .toLowerCase())) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => isLogin ==
                                                          true
                                                      ? const AllShotRecords()
                                                      : const LoginRegister(),
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_right_sharp),
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: homePageSlideList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => controller.animateToPage(entry.key),
                        child: Container(
                          width: _current == entry.key ? 16.0 : 4.0,
                          height: 4.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              borderRadius: _current == entry.key
                                  ? BorderRadius.circular(20)
                                  : BorderRadius.circular(50),
                              color: (projectColors.black3)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  name != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 29.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              100.h < 1220
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .hi_again,
                                              style:
                                                  customTextStyleWithWelcome(),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const SfsConnectPage()));
                                              },
                                              child: Text(
                                                name ?? '',
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontFamily: 'Built',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .thanks_canik,
                                          style: customTextStyleWithWelcome(),
                                        ),
                                      ],
                                    )
                                  : 100.h < 1750
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .hi_again,
                                                  style:
                                                      customTextStyleWithWelcomeIpad(),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  name ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 38,
                                                      fontFamily: 'Built',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .thanks_canik,
                                              style:
                                                  customTextStyleWithWelcomeIpad(),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .hi_again,
                                                  style:
                                                      customTextStyleWithWelcomeIpad(),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  name ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 38,
                                                      fontFamily: 'Built',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .thanks_canik,
                                              style:
                                                  customTextStyleWithWelcomeIpad(),
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        )
                      : Container(),
                  BlocBuilder<MainPageProductCubit, MainPageProductResponse>(
                      builder: (context, state) {
                    if (state.isError == true) {
                      return const Center();
                    }
                    return Container(
                      height: 100.h < 1220 ? 50.h : 45.h,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.mainPageProducts.length,
                          itemBuilder: (context, index) {
                            return 100.h < 1220
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                projectColors.black2,
                                                projectColors.black,
                                              ],
                                            )),
                                        height: 50.h,
                                        width: 85.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Center(
                                                child:
                                                    state.mainPageProducts[index]
                                                                .imageUrl ==
                                                            ""
                                                        ? Image.asset(
                                                            'assets/images/shadowgun2.png',
                                                            fit: BoxFit.contain,
                                                            height: 35.h,
                                                          )
                                                        :  CachedNetworkImage(key:UniqueKey(),imageUrl: state
                                                                .mainPageProducts[
                                                                    index]
                                                                .imageUrl,height: 35.h,fit: BoxFit.contain,)
                                                        ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 6.0),
                                                    child: Container(
                                                      height: 20,
                                                      color: projectColors.black3,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .newKeyword,
                                                        style: TextStyle(
                                                            fontSize: 9.sp,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2.0),
                                                    child: Text(
                                                      state
                                                          .mainPageProducts[index]
                                                          .productName,
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : 100.h < 1750
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 40.0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    projectColors.black2,
                                                    projectColors.black,
                                                  ],
                                                )),
                                            height: 40.h,
                                            width: 90.w,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:  EdgeInsets.only(top: 5.h),
                                                  child: Center(
                                                      child: state
                                                                  .mainPageProducts[
                                                                      index]
                                                                  .imageUrl ==
                                                              ""
                                                          ? Image.asset(
                                                              'assets/images/shadowgun2.png',
                                                              fit: BoxFit.contain,
                                                              height: 340,
                                                            )
                                                          :  CachedNetworkImage(
                                                            key:UniqueKey(),
                                                            imageUrl: state
                                                                .mainPageProducts[
                                                                    index]
                                                                .imageUrl,height: 340,fit: BoxFit.contain,),
                                                )),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15.0, bottom: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        color:
                                                            projectColors.black3,
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .newKeyword,
                                                          style: const TextStyle(
                                                              fontSize: 35,
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        state
                                                            .mainPageProducts[
                                                                index]
                                                            .productName,
                                                        style: const TextStyle(
                                                            fontSize: 38,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 40.0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    projectColors.black2,
                                                    projectColors.black,
                                                  ],
                                                )),
                                            height: 40.h,
                                            width: 95.w,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:  EdgeInsets.only(top: 5.h),
                                                  child: Center(
                                                      child: state
                                                                  .mainPageProducts[
                                                                      index]
                                                                  .imageUrl ==
                                                              ""
                                                          ? Image.asset(
                                                              'assets/images/shadowgun2.png',
                                                              fit: BoxFit.contain,
                                                              height: 340,
                                                            )
                                                          : CachedNetworkImage(
                                                            key: UniqueKey(),
                                                            imageUrl: state
                                                                  .mainPageProducts[
                                                                      index]
                                                                  .imageUrl,
                                                              fit: BoxFit.contain,
                                                              height: 340,)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15.0, bottom: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        color:
                                                            projectColors.black3,
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .newKeyword,
                                                          style:  TextStyle(
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        state
                                                            .mainPageProducts[
                                                                index]
                                                            .productName,
                                                        style:  TextStyle(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                          }),
                    );
                  }),
                  CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: imageSliders,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompareGunsPage()));
                      },
                      child: Container(
                        height: 100.h > 1200 ? 20.h : 15.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: projectColors.black,
                            border: Border.all(color: projectColors.black3)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Frame259.png'),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Image.asset(
                                      'assets/images/yellowgun.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: 100.h < 1220
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .compare_guns_button_1,
                                              style: TextStyle(
                                                  color: projectColors.white,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .compare_guns_button_2,
                                              style: TextStyle(
                                                  color: projectColors.white,
                                                  fontSize: 20),
                                            ),
                                            Icon(
                                              Icons.compare_arrows,
                                              color: projectColors.blue,
                                              size: 30,
                                            )
                                          ],
                                        )
                                      : 100.h < 1750
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .compare_guns_button_1,
                                                  style: TextStyle(
                                                      color:
                                                          projectColors.white,
                                                      fontSize: 40),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .compare_guns_button_2,
                                                  style: TextStyle(
                                                      color:
                                                          projectColors.white,
                                                      fontSize: 40),
                                                ),
                                                Icon(
                                                  Icons.compare_arrows,
                                                  color: projectColors.blue,
                                                  size: 50,
                                                )
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .compare_guns_button_1,
                                                  style: TextStyle(
                                                      color:
                                                          projectColors.white,
                                                      fontSize: 40),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .compare_guns_button_2,
                                                  style: TextStyle(
                                                      color:
                                                          projectColors.white,
                                                      fontSize: 40),
                                                ),
                                                Icon(
                                                  Icons.compare_arrows,
                                                  color: projectColors.blue,
                                                  size: 50,
                                                )
                                              ],
                                            ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),

                  100.h < 1220
                      ? CustomViewAllWidget(
                          customText: AppLocalizations.of(context)!.categories,
                          paddingBottom: 16,
                          paddingTop: 30,
                        )
                      : CustomViewAllWidgetIpad(
                          customText: AppLocalizations.of(context)!.categories,
                          paddingBottom: 16,
                          paddingTop: 30,
                        ),

                  FutureBuilder<List<MainCategory>>(
                    future: mainCategories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                          ),
                          itemBuilder: (context, index) {
                            var gun = gunList[index];
                            var mainCategory = snapshot.data![index];
                            return buildImageCard(
                              mainCategory: mainCategory,
                              item: gun,
                            );
                          },
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  100.h < 1220
                      ? CustomViewAllWidget(
                          customText:
                              AppLocalizations.of(context)!.featured_product,
                          paddingBottom: 15,
                          paddingTop: 41,
                        )
                      : CustomViewAllWidgetIpad(
                          customText:
                              AppLocalizations.of(context)!.featured_product,
                          paddingBottom: 15,
                          paddingTop: 41,
                        ),

                  100.h < 1220
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 210,
                            child: FutureBuilder<List<ProductCategoriesByWeapons>>(
                              future: productCategoriesFilteredByGuns,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  
                                  ProductCategoriesByWeapons productCategory = 
                                  language == "TR" ?
                                      snapshot.data!.firstWhere(((element) =>
                                          element.categoryName == 'TP SERİSİ')) : snapshot.data!.firstWhere(((element) =>
                                          element.categoryName == 'TP SERIES')) ;

                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productCategory
                                        .productSubCategory.length,
                                    itemBuilder: (context, index) {
                                      SubCategory subCategory = SubCategory(
                                      categoryName: 
                                      productCategory.productSubCategory[index].categoryName, 
                                      categoryCode: productCategory.productSubCategory[index].categoryCode,
                                      imageUrl: productCategory.productSubCategory[index].imageUrl,
                                      parentProductCategoryName: productCategory.productSubCategory[index].parentProductCategoryName,
                                      productNumber: productCategory.productSubCategory[index].productNumber
                                      );
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: buildListview(
                                            subCategory: subCategory,
                                            isTablet: false),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 360,
                            child: FutureBuilder<List<ProductCategoriesByWeapons>>(
                              future: productCategoriesFilteredByGuns,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  ProductCategoriesByWeapons productCategory =
                                      language == "TR" ?
                                      snapshot.data!.firstWhere(((element) =>
                                          element.categoryName == 'TP SERİSİ')) : snapshot.data!.firstWhere(((element) =>
                                          element.categoryName == 'TP SERIES')) ;

                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productCategory
                                        .productSubCategory.length,
                                    itemBuilder: (context, index) {
                                      SubCategory subCategory = SubCategory(
                                      categoryName: 
                                      productCategory.productSubCategory[index].categoryName, 
                                      categoryCode: productCategory.productSubCategory[index].categoryCode,
                                      imageUrl: productCategory.productSubCategory[index].imageUrl,
                                      parentProductCategoryName: productCategory.productSubCategory[index].parentProductCategoryName,
                                      productNumber: productCategory.productSubCategory[index].productNumber
                                      );
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: buildListview(
                                            subCategory: subCategory,
                                            isTablet: true),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                          ),
                        ),

                  //------------------------------------------------------------------------------------------------------------------
                  //GELECEK FAZDA GÖSTERİLECEK OLAN CANİK AKADEMİ İÇİN KODLAR
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 45.0),
                  //   child: Text(
                  //     'CANIK ACADEMY',
                  //     style: customTextStyleWithTitle(),
                  //   ),
                  // ),
                  // const Text(
                  //   'Take a look at some of the latest and greatest from CANIK Academy.',
                  //   style: TextStyle(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.bold,
                  //       color: projectColors.black3),
                  // ),

                  // Stack(
                  //   alignment: Alignment.bottomLeft,
                  //   children: [
                  //     Container(
                  //       height: 330,
                  //       width: 350,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20)),
                  //       child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(20),
                  //         child: Image.asset(
                  //           'assets/images/canik_academy.png',
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.all(19.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             height: 14,
                  //             color: const projectColors.black3,
                  //             child: const Text(
                  //               'LIMITED EDITION',
                  //               style: TextStyle(
                  //                   fontSize: 10,
                  //                   fontWeight: FontWeight.w300,
                  //                   color: Colors.white),
                  //             ),
                  //           ),
                  //           const Text(
                  //             'Pistol Courses',
                  //             style: TextStyle(
                  //                 fontSize: 17,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.white),
                  //           ),
                  //           const Text(
                  //             'Our progressive pistol development courses offer a logical shooting evolution designed to build a complete shooter, from beginner to expert.',
                  //             style: TextStyle(fontSize: 12, color: Colors.white),
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  100.h < 1220
                      ? CustomViewAllWidget(
                          customText: AppLocalizations.of(context)!.my_arms,
                          paddingBottom: 15,
                          paddingTop: 41,
                        )
                      : CustomViewAllWidgetIpad(
                          customText: AppLocalizations.of(context)!.my_arms,
                          paddingBottom: 15,
                          paddingTop: 41,
                        ),

                  BlocBuilder<WeaponListCubit, WeaponToUserListResponse>(
                    builder: (context, response) {
                      if (response.weaponToUsers.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: SizedBox(
                            height: 340,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: projectColors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Image.asset(
                                          'assets/images/dont_add_gun.png')),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .not_have_registered_gun,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, right: 10, left: 10),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .not_have_registered_gun_text,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        var isLogin = prefs.getBool('isLogin');
                                        if (isLogin == true) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddGunB()));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginRegister()));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(285, 54),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          primary: projectColors.blue),
                                      child: Text(
                                        AppLocalizations.of(context)!.add_gun,
                                        style: const TextStyle(
                                            fontFamily: 'Built',
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 60.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: response.weaponToUsers.length,
                            itemBuilder: (context, index) {
                              WeaponToUserListResponseModel weaponToUser =
                                  response.weaponToUsers[index];

                              return GunCard(
                                language: language,
                                weaponToUser: weaponToUser,
                                canikId: canikId,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  isLogin == true
                      ? 100.h < 1220
                          ? CustomViewAllWidget(
                              paddingTop: 41,
                              paddingBottom: 15,
                              customText: AppLocalizations.of(context)!.for_you)
                          : CustomViewAllWidgetIpad(
                              paddingTop: 41,
                              paddingBottom: 15,
                              customText: AppLocalizations.of(context)!.for_you)
                      : const Center(),
                  isLogin == true
                      ? Padding(
                          padding: _CanikHomePadding().specialCardPadding,
                          child: 100.h < 1220
                              ? _specialForYouCard(language, 0)
                              : 100.h < 1750
                                  ? _specialForYouCard(language, 1)
                                  : _specialForYouCard(language, 2),
                        )
                      : const Center(),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder(
            future: getAllMainCategories(),
            builder: (context, snapshot) {
              if (isLoading == false) {
                return Loading(isLoading: isLoading);
              }
              return const Center();
            }),
      ],
    );
  }

  Center _specialForYouCard(String language, int isTablet) {
    return isTablet == 0
        ? Center(
            child: SizedBox(
              height: 35.h,
              child: BlocBuilder<CampaignCubit, List<Campaign>>(
                builder: (context, campaigns) {
                  if (campaigns.isNotEmpty) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: campaigns.length,
                      itemBuilder: (_, index) => newCard(
                          campaign: campaigns[index],
                          index: index,
                          language: language,
                          isTablet: 0),
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
          )
        : isTablet == 1
            ? Center(
                child: SizedBox(
                  height: 33.h,
                  child: BlocBuilder<CampaignCubit, List<Campaign>>(
                    builder: (context, campaigns) {
                      if (campaigns.isNotEmpty) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: campaigns.length,
                          itemBuilder: (_, index) => newCard(
                              campaign: campaigns[index],
                              index: index,
                              language: language,
                              isTablet: 1),
                          separatorBuilder: (_, index) =>
                              const SizedBox(width: 10),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                  height: 32.h,
                  child: BlocBuilder<CampaignCubit, List<Campaign>>(
                    builder: (context, campaigns) {
                      if (campaigns.isNotEmpty) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: campaigns.length,
                          itemBuilder: (_, index) => newCard(
                              campaign: campaigns[index],
                              index: index,
                              language: language,
                              isTablet: 2),
                          separatorBuilder: (_, index) =>
                              const SizedBox(width: 10),
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                ),
              );
  }

  Widget buildImageCard(
      {required Gun item, required MainCategory mainCategory}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreDetails(
                      gun: item,
                      categoryName: mainCategory.parentProductCategoryName,
                    )));
      },
      child: 100.h < 1220
          ? Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/gun_background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 8, child: Image.asset(item.imageUrl)),
                  Expanded(
                    flex: 2,
                    child: Text(
                      mainCategory.parentProductCategoryName,
                      style: customTextStyle,
                    ),
                  ),
                ],
              ))
          : Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/gun_background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 180,
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.fill,
                      )),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    mainCategory.parentProductCategoryName,
                    style: customTextStyleLIpad,
                  ),
                ],
              )),
    );
  }

  // Widget buildCard({required Campaign campaign, required index}) => ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => SpecialDetails(campaign: campaign)),
  //           );
  //         },
  //         child: Container(
  //           width: 300,
  //           decoration: BoxDecoration(
  //             color: projectColors.black,
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(
  //                 color: index == 0 ? projectColors.blue : Colors.transparent, style: BorderStyle.solid, width: 3.0),
  //           ),
  //           child: Container(
  //             decoration: campaign.imageUrl != null
  //                 ? BoxDecoration(image: DecorationImage(image: NetworkImage(campaign.imageUrl!), fit: BoxFit.fitWidth))
  //                 : const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/special_img.png'))),
  //             child: Padding(
  //               padding: const EdgeInsets.only(left: 15.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Text(campaign.title,
  //                       style: const TextStyle(
  //                           overflow: TextOverflow.ellipsis,
  //                           color: Colors.white,
  //                           fontSize: 17,
  //                           fontWeight: FontWeight.w600)),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );

  Widget newCard(
      {required Campaign campaign,
      required index,
      required String language,
      required int isTablet}) {
    double _imageHeight = 25.h;
    double _cardWidth = 46.5.w;
    return isTablet == 0
        ? SizedBox(
            width: 86.w,
            child: Card(
              color: projectColors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: projectColors.blue, width: 3)),
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecialDetails(
                                      campaign: campaign,
                                      language: language,
                                    )),
                          );
                        },
                        child: campaign.imageUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: SizedBox(
                                  width: 100.w,
                                  height: _imageHeight,
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: campaign.imageUrl!,
                                    fit: BoxFit.fill,),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: SizedBox(
                                  width: 100.w,
                                  height: _imageHeight,
                                  child: Image.asset(
                                    "assets/images/special_img.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                      ),
                      campaign.startDate != null && campaign.endDate != null
                          ? Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: projectColors.blue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: EdgeInsets.all(2.sp),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month,
                                          color: Colors.white, size: 12.sp),
                                      SizedBox(
                                        width: 2.sp,
                                      ),
                                      Text(
                                        language == "EN"
                                            ? DateFormat("yyyy-MM-dd").format(
                                                DateTime.parse(
                                                    campaign.startDate!))
                                            : DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse(
                                                    campaign.startDate!)),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Positioned(
                        bottom: 5,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                              color: projectColors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department_sharp,
                                    color: Colors.white, size: 12.sp),
                                SizedBox(
                                  width: 2.sp,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.for_you,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.h),
                    child: Center(
                      child: Text(
                        campaign.title.length > 40
                            ? campaign.title.substring(0, 40) + '...'
                            : campaign.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: projectColors.white,
                            fontWeight: FontWeight.bold),
                            textAlign:TextAlign.center
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : isTablet == 1
            ? SizedBox(
                width: _cardWidth,
                child: Card(
                  color: projectColors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: projectColors.blue, width: 3)),
                  elevation: 4,
                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpecialDetails(
                                          campaign: campaign,
                                          language: language,
                                        )),
                              );
                            },
                            child: campaign.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: SizedBox(
                                      height: _imageHeight,
                                      width: _cardWidth,
                                      child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: campaign.imageUrl!,
                                    fit: BoxFit.fill,),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: SizedBox(
                                      height: _imageHeight,
                                      width: _cardWidth,
                                      child: Image.asset(
                                        "assets/images/special_img.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: projectColors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(2.sp),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 12.sp,
                                    ),
                                    SizedBox(
                                      width: 2.sp,
                                    ),
                                    Text(
                                      language == "EN"
                                          ? DateFormat("yyyy-MM-dd").format(
                                              DateTime.parse(
                                                  campaign.startDate!))
                                          : DateFormat("dd-MM-yyyy").format(
                                              DateTime.parse(
                                                  campaign.startDate!)),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: projectColors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(2.sp),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_sharp,
                                      color: Colors.white,
                                      size: 12.sp,
                                    ),
                                    SizedBox(
                                      width: 2.sp,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.for_you,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.sp),
                        child: Center(
                          child: Text(
                            campaign.title.length > 40
                                ? campaign.title.substring(0, 40) + '...'
                                : campaign.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: projectColors.white,
                                fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: _cardWidth,
                child: Card(
                  color: projectColors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: projectColors.blue, width: 3)),
                  elevation: 4,
                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpecialDetails(
                                          campaign: campaign,
                                          language: language,
                                        )),
                              );
                            },
                            child: campaign.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: SizedBox(
                                      height: _imageHeight,
                                      width: _cardWidth,
                                      child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: campaign.imageUrl!,
                                    fit: BoxFit.fill,),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: SizedBox(
                                      height: _imageHeight,
                                      width: _cardWidth,
                                      child: Image.asset(
                                        "assets/images/special_img.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: projectColors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(2.sp),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 12.sp,
                                    ),
                                    SizedBox(
                                      width: 2.sp,
                                    ),
                                    Text(
                                      language == "EN"
                                          ? DateFormat("yyyy-MM-dd").format(
                                              DateTime.parse(
                                                  campaign.startDate!))
                                          : DateFormat("dd-MM-yyyy").format(
                                              DateTime.parse(
                                                  campaign.startDate!)),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: projectColors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(2.sp),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_sharp,
                                      color: Colors.white,
                                      size: 12.sp,
                                    ),
                                    SizedBox(
                                      width: 2.sp,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.for_you,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Center(
                          child: Text(
                            campaign.title.length > 40
                                ? campaign.title.substring(0, 40) + '...'
                                : campaign.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: projectColors.white,
                                fontWeight: FontWeight.bold),
                                textAlign:TextAlign.center
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Widget buildListview({
    required bool isTablet,
    required SubCategory subCategory,
  }) {
    return !isTablet
        ? InkWell(
            onTap: () {},
            child: Container(
              width: 150,
              height: 210,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/gun_background.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(
                  //     flex: 5,
                  //     child: Center(child: Image.asset(item.imageUrl))),
                  Flexible(
                      flex: 5,
                      child: Center(child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: subCategory.imageUrl!,
                      ))),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.sp),
                        child: Text(subCategory.categoryName,
                            style: customTextStyle),
                      )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp, top: 2.sp),
                      child: Text(
                        ".380ACP, 9mm, .40S&W",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {},
            child: Container(
              width: 280,
              height: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/gun_background.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 5,
                    child: Center(
                        // child: SizedBox(
                        //     height: 180,
                        //     child: Image.asset(
                        //       item.imageUrl,
                        //       fit: BoxFit.contain,
                        //     ))),
                      child: SizedBox(
                            height: 180,
                            child: Image.network(
                              subCategory.imageUrl!,
                              fit: BoxFit.contain,
                            )))
                  ),
                  const SizedBox(height: 40),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp),
                      child: Text(
                        subCategory.categoryName,
                        style: customTextStyleIpad,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp, top: 2.sp),
                      child: Text(
                        ".380ACP, 9mm, .40S&W",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 7.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TextStyle customTextStyleWithWelcome() {
    return TextStyle(
        fontSize: 22,
        fontFamily: 'Built',
        fontWeight: FontWeight.w600,
        color: projectColors.black2);
  }

  TextStyle customTextStyleWithWelcomeIpad() {
    return TextStyle(
        fontSize: 38,
        fontFamily: 'Built',
        fontWeight: FontWeight.w600,
        color: projectColors.black2);
  }

  TextStyle customTextStyleWithTitle() {
    return const TextStyle(
        fontSize: 22,
        fontFamily: 'Built',
        fontWeight: FontWeight.w600,
        color: Colors.white);
  }
}

class GunCard extends StatefulWidget {
  final language;
  final WeaponToUserListResponseModel weaponToUser;
  final String? canikId;
  const GunCard({
    Key? key,
    required this.weaponToUser,
    this.canikId,
    required this.language,
  }) : super(key: key);

  @override
  State<GunCard> createState() => _GunCardState();
}

class _GunCardState extends State<GunCard> {
  final GlobalKey _key = GlobalKey();

  // Coordinates
  double _x = 0.0, _y = 0.0;
  _onLoading() {
    Navigator.pop(context);
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabBarPage(
                  index: 0,
                )));
  }

  // This function is called when the user presses the floating button
  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);

    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double _imageHeight = 30.h;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        //color: const Color(0xff4C535E).withOpacity(0.20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              //stops: Alignment.center,

              end: Alignment.bottomCenter,
              colors: [
                projectColors.black2,
                projectColors.black,
              ],
            )),
        width: 85.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tarih Datası geldiği zaman güncellenecek.
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    //12082022
                    widget.language == "EN"
                        ? widget.weaponToUser.date
                                .replaceAll(".", "")
                                .substring(4) +
                            "-" +
                            widget.weaponToUser.date
                                .replaceAll(".", "")
                                .substring(2, 4) +
                            "-" +
                            widget.weaponToUser.date
                                .replaceAll(".", "")
                                .substring(0, 2)
                        : widget.weaponToUser.date.replaceAll(".", "-"),
                    style: TextStyle(
                        color: projectColors.blue,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    key: _key,
                    onPressed: () {
                      _getOffset(_key);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                Positioned(
                                  bottom: screenHeight - _y - 155,
                                  left: _x - 80,
                                  child: Container(
                                    width: 15.h,
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: projectColors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              EasyLoading.show();
                                              var res = await context
                                                  .read<WeaponToUserGetCubit>()
                                                  .getWeaponToUserByRecordId(
                                                      WeaponToUserGetRequestModel(
                                                          recordId: widget
                                                              .weaponToUser
                                                              .recordId));

                                              if (res.isError == false) {
                                                EasyLoading.dismiss();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return AddGunHome(
                                                    weaponToUserGetResponseModel:
                                                        res.weaponToUser.first,
                                                  );
                                                }));
                                              } else {
                                                EasyLoading.dismiss();
                                                _onLoading();
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .edit,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Image.asset(
                                                    'assets/images/edit.png'),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 1.h, bottom: 1.h),
                                            child: const Divider(
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              EasyLoading.show(
                                                  dismissOnTap: false);
                                              WeaponToUserListResponseModel
                                                  gunToDelete =
                                                  widget.weaponToUser;
                                              var res = await context
                                                  .read<WeaponUpdateCubit>()
                                                  .updateWeaponToUser(
                                                    WeaponToUserUpdateRequestModel(
                                                      serialNumber: gunToDelete
                                                          .serialNumber,
                                                      name: gunToDelete.name,
                                                      recordID:
                                                          gunToDelete.recordId,
                                                      isDeleted: true,
                                                    ),
                                                  );
                                              if (res.isError == false) {
                                                var res2 = await context
                                                    .read<WeaponListCubit>()
                                                    .getAllWeaponToUsers(
                                                        WeaponToUserListRequestModel(
                                                            canikId: widget
                                                                .canikId!));
                                                if (res2.isError == false) {
                                                  EasyLoading.dismiss();
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .delete,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Image.asset(
                                                    'assets/images/trash.png'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 2.h,
                    ))
              ],
            ),
            widget.weaponToUser.imageUrl == ""
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: SizedBox(
                        height: 35.h,
                        child: Image.asset(
                          'assets/images/shadowgun.png',
                          fit: BoxFit.contain,
                        )),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: SizedBox(
                      height: 35.h,
                      child: Image.network(
                        widget.weaponToUser.imageUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.weaponToUser.name,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    widget.weaponToUser.serialNumber,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomViewAllWidget extends StatelessWidget {
  final double paddingTop;
  final double paddingBottom;
  final String customText;

  const CustomViewAllWidget(
      {Key? key,
      required this.paddingTop,
      required this.paddingBottom,
      required this.customText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(customText,
              style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Built',
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var isLogin = prefs.getBool('isLogin');
                if (customText == AppLocalizations.of(context)!.categories ||
                    customText ==
                        AppLocalizations.of(context)!.featured_product) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (TabBarPage(
                                index: 3,
                              ))));
                } else if (customText ==
                    AppLocalizations.of(context)!.my_arms) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isLogin == true
                              ? TabBarPage(
                                  index: 1,
                                )
                              : const LoginRegister()));
                } else if (customText ==
                    AppLocalizations.of(context)!.for_you) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isLogin == true
                              ? TabBarPage(
                                  index: 2,
                                )
                              : const LoginRegister()));
                }
              },
              child: Text(
                AppLocalizations.of(context)!.view_all,
                style: TextStyle(
                  fontSize: 14,
                  color: projectColors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ))
        ],
      ),
    );
  }
}

class _CanikHomePadding {
  EdgeInsets specialCardPadding = const EdgeInsets.only(bottom: 160);
}

class CustomViewAllWidgetIpad extends StatelessWidget {
  final double paddingTop;
  final double paddingBottom;
  final String customText;

  const CustomViewAllWidgetIpad(
      {Key? key,
      required this.paddingTop,
      required this.paddingBottom,
      required this.customText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(customText,
              style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Built',
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var isLogin = prefs.getBool('isLogin');
                if (customText == AppLocalizations.of(context)!.categories ||
                    customText ==
                        AppLocalizations.of(context)!.featured_product) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (TabBarPage(
                                index: 3,
                              ))));
                } else if (customText ==
                    AppLocalizations.of(context)!.my_arms) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isLogin == true
                              ? TabBarPage(
                                  index: 1,
                                )
                              : const LoginRegister()));
                } else if (customText ==
                    AppLocalizations.of(context)!.for_you) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isLogin == true
                              ? TabBarPage(
                                  index: 2,
                                )
                              : const LoginRegister()));
                }
              },
              child: Text(
                AppLocalizations.of(context)!.view_all,
                style: TextStyle(
                  fontSize: 30,
                  color: projectColors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ))
        ],
      ),
    );
  }
}
 extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}