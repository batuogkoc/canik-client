import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:mysample/cubit/canik_store_details_page_cubit.dart';
import 'package:mysample/entities/product_category.dart';
import 'package:mysample/models/canik_gun_models.dart';

import 'package:mysample/models/tp9_model.dart';
import 'package:mysample/views/acc_details.dart';
import 'package:mysample/views/canik_store_sub_assignment.dart';
import 'package:mysample/views/gun_details.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';

import '../constants/color_constants.dart';
import '../widgets/bottom_app_bar_widget.dart';

class StoreSubCategoryDetails extends StatefulWidget {
  ProductCategory productCategory;

  StoreSubCategoryDetails({
    Key? key,
    required this.productCategory,
  }) : super(key: key);

  @override
  State<StoreSubCategoryDetails> createState() =>
      _StoreSubCategoryDetailsState();
}

class _StoreSubCategoryDetailsState extends State<StoreSubCategoryDetails> {
  static const customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );
  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(
            text: widget.productCategory.categoryName,
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
                    widget.productCategory.categoryName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                widget.productCategory.productSubCategory.length > 0
                    ? Expanded(
                        child: GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 210,
                            ),
                            itemCount: widget
                                .productCategory.productSubCategory.length,
                            itemBuilder: (_, index) {
                              var subCategory = widget
                                  .productCategory.productSubCategory[index];

                              return buildCard(subCategory: subCategory);
                            }),
                      )
                    : Expanded(
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: projectColors.black.withOpacity(0.85),
                                border: Border.all(
                                    color: Colors.white, width: 1.5)),
                            child: const Center(
                              child: Text(
                                'Ürün bulunamadı',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard({required SubCategory subCategory}) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      (SubAssignment(subCategory: subCategory))));
          // if (widget.gun.productName == 'ACCESSORIES') {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => (AccDetail())));
          // } else {

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
                   subCategory.imageUrl != null ? Expanded(child: Center(child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: subCategory.imageUrl!,
                      ))) : const SizedBox(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 16, right: 26, bottom: 15),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              color: projectColors.black3,
                              child: const Text(
                                'YENi',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              subCategory.categoryName,
                              style: customTextStyle,
                            ),
                            // Text(item.title,
                            //     style: TextStyle(
                            //         fontSize: 12,
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w300))
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
