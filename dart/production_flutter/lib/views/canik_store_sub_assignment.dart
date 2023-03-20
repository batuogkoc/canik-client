import 'package:flutter/material.dart';
import 'package:mysample/cubit/gun_details_cubit.dart';
import 'package:mysample/entities/product_category.dart';
import 'package:mysample/entities/product_category_assignment.dart';
import 'package:mysample/repository/repo_product.dart';
import 'package:mysample/views/gun_details.dart';

import '../constants/color_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_image_widget.dart';

class SubAssignment extends StatefulWidget {
  SubCategory subCategory;
  SubAssignment({Key? key, required this.subCategory}) : super(key: key);

  @override
  State<SubAssignment> createState() => _SubAssignmentState();
}

class _SubAssignmentState extends State<SubAssignment> {
  var productCategoryAssignments;
  static const customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );
  ProjectColors projectColors = ProjectColors();

  @override
  void initState() {
    super.initState();
    productCategoryAssignments = RepositoryProduct().getAllProductCategoryAssignments(widget.subCategory.categoryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(
            text: widget.subCategory.categoryName,
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
                    widget.subCategory.categoryName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<ProductCategoryAssignment>>(
                    future: productCategoryAssignments,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 210,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              var productCategoryAssignment = snapshot.data![index];

                              return buildCard(productCategoryAssignment: productCategoryAssignment);
                            });
                      } else
                        return Center();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard({required ProductCategoryAssignment productCategoryAssignment}) => InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => (GunDetails(
          //               productCategoryAssignment: productCategoryAssignment,
          //             ))));
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
                    Expanded(
                      flex: 6,
                      child: productCategoryAssignment.productImageUrl != null
                          ? Center(child: Image.network(productCategoryAssignment.productImageUrl!))
                          : const Center(),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 16, right: 26, bottom: 15),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productCategoryAssignment.productNumber,
                              style: customTextStyle,
                            ),
                            Text(
                              productCategoryAssignment.productCategoryName,
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
