import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mysample/cubit/canik_store_details_page_cubit.dart';
import 'package:mysample/cubit/product_categories_by_weapons_cubit.dart';
import 'package:mysample/entities/product_category.dart';
import 'package:mysample/models/canik_gun_models.dart';

import 'package:mysample/models/tp9_model.dart';
import 'package:mysample/views/acc_details.dart';
import 'package:mysample/views/canik_home_page.dart';
import 'package:mysample/views/canik_store_subdetails.dart';
import 'package:mysample/views/gun_details.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color_constants.dart';
import '../entities/product_categories_by_weapons.dart';
import '../entities/response/product_categories_weapons_response.dart';
import '../widgets/bottom_app_bar_widget.dart';
import '../widgets/loading_widget.dart';

class StoreDetails extends StatefulWidget {
  Gun? gun;
  String categoryName;
  StoreDetails({Key? key, this.gun, required this.categoryName}) : super(key: key);

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  static const customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );
  int index = 3;
  String language = "";
  ProjectColors projectColors = ProjectColors();
  bool isLoading = false;
  getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language')!.toCapitalized();
    });
    context.read<ProductCategoriesByWeaponsCubit>().getProductCategoriesByWeapons(language).whenComplete(() => isLoading = true);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.categoryName == "TABANCALAR") {
      getLanguage();
    }
    else{
      context
        .read<CanikStoreDetailPageCubit>()
        .getAllProductCategories(widget.categoryName)
        .whenComplete(() => isLoading = true);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(
            text: widget.categoryName,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    widget.categoryName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                widget.categoryName != "TABANCALAR" ?
                Expanded(
                  child: BlocBuilder<CanikStoreDetailPageCubit, List<ProductCategory>>(
                    builder: (context, productCategories) {
                      if (isLoading == false) {
                        return Loading(isLoading: isLoading);
                      }
                      if (productCategories.isNotEmpty) {
                        return GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 210,
                            ),
                            itemCount: productCategories.length,
                            itemBuilder: (_, index) {
                              var productCategory = productCategories[index];

                              return buildCard(productCategory: productCategory,categoryName: widget.categoryName);
                            });
                      } else {
                        return const Center();
                      }
                    },
                  ),
                ):
                Expanded(
                  child: BlocBuilder<ProductCategoriesByWeaponsCubit, ProductCategoriesByWeaponsResponse>(
                    builder: (context, productCategories) {
                      if (isLoading == false) {
                        return Loading(isLoading: isLoading);
                      }
                      if (productCategories.productCategoriesByWeapons.isNotEmpty) {
                        return GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 210,
                            ),
                            itemCount: productCategories.productCategoriesByWeapons.length,
                            itemBuilder: (_, index) {
                              var productCategoryRaw = productCategories.productCategoriesByWeapons[index];
                              List<SubCategory> subcategory = productCategoryRaw.productSubCategory.map((e) => SubCategory(categoryName: e.categoryName,categoryCode: e.categoryCode,productNumber: e.productNumber,imageUrl: e.imageUrl,parentProductCategoryName: e.parentProductCategoryName)).toList();
                              ProductCategory productCategory = ProductCategory(categoryName: productCategoryRaw.categoryName, categoryCode: productCategoryRaw.categoryCode, productSubCategory: subcategory);
                              return buildCard(productCategory: productCategory,categoryName: widget.categoryName, imageUrl:subcategory[0].imageUrl);
                            });
                      } else {
                        return const Center();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard({required ProductCategory productCategory,required String categoryName,String? imageUrl}) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (StoreSubCategoryDetails(
                        productCategory: productCategory,
                      ))));

          // if (widget.gun.productName == 'ACCESSORIES') {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => (AccDetail())));
          // } else {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => (GunDetails())));
          // }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: projectColors.black,
              borderRadius: BorderRadius.circular(16),
              gradient: RadialGradient(
                  center: Alignment(0, -0.4), // near the top right
                  radius: 0.25,
                  colors: [
                    Colors.blueGrey.withOpacity(0.05), // yellow sun
                    projectColors.black.withOpacity(0.85), // blue sky
                  ])),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    categoryName == "TABANCALAR" ? 
                    Expanded(child: Center(child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: imageUrl!,
                      ))) : const SizedBox(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 16, right: 26, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productCategory.categoryName,
                              style: customTextStyle,
                            ),
                          ],
                        ),
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
