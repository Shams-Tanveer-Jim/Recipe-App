import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_app/consts/assets.dart';
import 'package:recipe_app/consts/colors.dart';
import 'package:recipe_app/controller/recipe_details_controller.dart';
import 'package:recipe_app/models/search_response.dart';
import 'package:recipe_app/screens/webciew_screen.dart';
import 'package:recipe_app/services/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../consts/sizes.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  RecipeDetailsScreen({required this.recipe, super.key});

  final RecipeDetailsController recipeDetailsController =
      Get.put(RecipeDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: -30,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppAssets.circleVector))),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
              ),
              leading: Image.asset(
                AppAssets.rightMenu,
                scale: 4.5,
              ),
              title: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 2))
                    ],
                    borderRadius: BorderRadius.circular(8.0)),
                child: TextField(
                  onSubmitted: (value) {
                    // homeController.searchRecipe(value);
                    // searchController.clear();
                  },
                  // controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: AppSizes.getResponsiveSize(2),
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    AppAssets.menu,
                    scale: AppSizes.getResponsiveSize(.4),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: AppSizes.getResponsiveSize(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "REFINE SEARCH BY ",
                                  style: TextStyle(
                                    color: const Color(0xff747D88),
                                    fontSize: AppSizes.getResponsiveSize(1.4),
                                  ),
                                ),
                                TextSpan(
                                  text: "Calories, Diet, Ingredients",
                                  style: TextStyle(
                                    color: const Color(0xff747D88),
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.getResponsiveSize(1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          RecipeBasicInfoWidget(recipe: recipe),
                          const SizedBox(
                            height: 8,
                          ),
                          HealthLabelWidget(recipe: recipe),
                          CuisineTypeWidget(recipe: recipe),
                          IngredientWidget(recipe: recipe),
                          PreparationWidget(recipe: recipe),
                          const SizedBox(
                            height: 8,
                          ),
                          NutritionOverallWidget(recipe: recipe),
                          (recipe.dietLabels ?? []).isEmpty
                              ? Container()
                              : TagWidget(recipe: recipe),
                          NutritionDetailsWidget(recipe: recipe)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientWidget extends StatelessWidget {
  const IngredientWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2,
                      color: const Color(0xffFEC915).withOpacity(0.6)))),
          child: Text(
            "Ingredients",
            style: TextStyle(
                color: AppColor.labelColor2,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.getResponsiveSize(2.5)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: AppSizes.getResponsiveSize(14.5),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...(recipe.ingredients ?? []).map(
                (e) => ShowIngredients(e),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CuisineTypeWidget extends StatelessWidget {
  const CuisineTypeWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cuisine Type:",
          style: TextStyle(
              color: AppColor.labelColor,
              fontSize: AppSizes.getResponsiveSize(1.9)),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: AppSizes.getResponsiveSize(2.8),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...(recipe.cuisineType ?? []).map(
                (e) => Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.labelItemContainerColor),
                  child: Text(
                    e,
                    style: TextStyle(fontSize: AppSizes.getResponsiveSize(1.6)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class PreparationWidget extends StatelessWidget {
  const PreparationWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2,
                      color: const Color(0xffFEC915).withOpacity(0.6)))),
          child: Text(
            "Preparation",
            style: TextStyle(
                color: AppColor.labelColor2,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.getResponsiveSize(2.5)),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Instructions on ",
                style: TextStyle(
                    color: Color(0xff747D88),
                    fontSize: AppSizes.getResponsiveSize(1.3))),
            WidgetSpan(
                child: InkWell(
              onTap: () {
                Get.to(() => WebViewScreen(url: recipe.url ?? ""));
              },
              child: Text(recipe.source ?? "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff747D88),
                      decoration: TextDecoration.underline,
                      fontSize: AppSizes.getResponsiveSize(1.3))),
            ))
          ])),
        )
      ],
    );
  }
}

class NutritionOverallWidget extends StatelessWidget {
  const NutritionOverallWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2,
                      color: const Color(0xffFEC915).withOpacity(0.6)))),
          child: Text(
            "Nutrition",
            style: TextStyle(
                color: AppColor.labelColor2,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.getResponsiveSize(2.5)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: const BoxDecoration(
            color: AppColor.greenColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: AppSizes.getResponsiveSize(5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffD9D9D9),
                    ),
                    child: Text(
                      ((recipe.calories ?? 0.0) / (recipe.yield ?? 1.0))
                          .toStringAsFixed(0),
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("CAL / SERV",
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)))
                ],
              ),
              Container(
                width: 1,
                height: AppSizes.getResponsiveSize(5.5),
                color: const Color(0xff3C444C),
              ),
              Column(
                children: [
                  Container(
                    width: AppSizes.getResponsiveSize(5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffD9D9D9),
                    ),
                    child: Text(
                      "${((recipe.totalDaily?.eNERCKCAL?.quantity ?? 0.0) / (recipe.yield ?? 1.0)).toStringAsFixed(0)}%",
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("DAILY VALUE",
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)))
                ],
              ),
              Container(
                width: 1,
                height: AppSizes.getResponsiveSize(5.5),
                color: const Color(0xff3C444C),
              ),
              Column(
                children: [
                  Container(
                    width: AppSizes.getResponsiveSize(5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffD9D9D9),
                    ),
                    child: Text(
                      ((recipe.yield ?? 1.0)).toStringAsFixed(0),
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("SERVINGS",
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.7)))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HealthLabelWidget extends StatelessWidget {
  const HealthLabelWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Health Labels:",
          style: TextStyle(
              color: AppColor.labelColor,
              fontSize: AppSizes.getResponsiveSize(1.9)),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: AppSizes.getResponsiveSize(2.8),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...(recipe.healthLabels ?? []).map((e) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.labelItemContainerColor),
                    child: Text(
                      e,
                      style:
                          TextStyle(fontSize: AppSizes.getResponsiveSize(1.6)),
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class RecipeBasicInfoWidget extends StatelessWidget {
  const RecipeBasicInfoWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (recipe.label ?? "-"),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: AppSizes.getResponsiveSize(2.2),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "See full recipe on:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: AppSizes.getResponsiveSize(1.7),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => WebViewScreen(url: recipe.url ?? ""));
                  },
                  child: Text(
                    recipe.source ?? "-",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: AppSizes.getResponsiveSize(1.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: AppSizes.getResponsiveSize(3.5),
                      width: AppSizes.getResponsiveSize(3.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: AppColor.greenColor),
                      child: Image.asset(
                        AppAssets.plus,
                        scale: 2.8,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: AppSizes.getResponsiveSize(3.5),
                      width: AppSizes.getResponsiveSize(3.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: AppColor.greenColor),
                      child: Image.asset(
                        AppAssets.share,
                        scale: 4,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            height: AppSizes.getResponsiveSize(23),
            child: CachedNetworkImage(
              imageUrl: recipe.image ?? "",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill)),
              ),
              progressIndicatorBuilder: (context, url, progress) =>
                  const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black)),
                  child: const Icon(Icons.error)),
            ),
          ),
        )
      ],
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2,
                      color: const Color(0xffFEC915).withOpacity(0.6)))),
          child: Text(
            "Tags",
            style: TextStyle(
                color: AppColor.labelColor2,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.getResponsiveSize(2.5)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            ...(recipe.dietLabels ?? []).map(
              (e) => InkWell(
                onTap: () {},
                child: Text(
                  e + (((recipe.dietLabels ?? []).last == e) ? "" : ", "),
                  style: TextStyle(
                      color: const Color(0xff747D88),
                      decoration: TextDecoration.underline,
                      fontSize: AppSizes.getResponsiveSize(1.9)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NutritionDetailsWidget extends StatelessWidget {
  NutritionDetailsWidget({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;
  final RecipeDetailsController recipeDetailsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2,
                      color: const Color(0xffFEC915).withOpacity(0.6)))),
          child: Text(
            "Nutrition",
            style: TextStyle(
                color: AppColor.labelColor2,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.getResponsiveSize(2.5)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: AppSizes.getResponsiveSize(7.65),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.greenColor),
          child: Stack(
            children: [
              Container(
                height: AppSizes.getResponsiveSize(7.5),
                width: AppSizes.getResponsiveSize(40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 1,
                          offset: Offset(-2, 2)),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Container(
                  margin: EdgeInsets.only(
                      top: AppSizes.getResponsiveSize(1.2),
                      bottom: AppSizes.getResponsiveSize(0.8),
                      right: 10,
                      left: AppSizes.getResponsiveSize(1.5)),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...(recipe.digest ?? []).map((e) => Obx(() {
                            var index = (recipe.digest ?? []).indexOf(e);

                            return GestureDetector(
                              onTap: () {
                                recipeDetailsController.currentNutrition.value =
                                    index;
                              },
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: recipeDetailsController
                                                      .currentNutrition.value ==
                                                  index
                                              ? 1.2
                                              : 1,
                                          color: recipeDetailsController
                                                      .currentNutrition.value ==
                                                  index
                                              ? Colors.black
                                              : Colors.grey)),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: recipeDetailsController
                                                  .currentNutrition.value ==
                                              index
                                          ? [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  blurRadius: 1,
                                                  offset: Offset(0, 2)),
                                            ]
                                          : null,
                                      color: recipeDetailsController
                                                  .currentNutrition.value ==
                                              index
                                          ? AppColor.greenColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.getResponsiveSize(2),
                                      vertical: AppSizes.getResponsiveSize(1)),
                                  margin: const EdgeInsets.only(right: 4),
                                  child: Center(
                                      child: Text(
                                    e.label ?? "-",
                                    style: TextStyle(
                                        color: recipeDetailsController
                                                    .currentNutrition.value ==
                                                index
                                            ? const Color(0xff3C444C)
                                            : const Color(0xff8B8B8B),
                                        fontSize: recipeDetailsController
                                                    .currentNutrition.value ==
                                                index
                                            ? AppSizes.getResponsiveSize(1.7)
                                            : AppSizes.getResponsiveSize(1.4)),
                                  )),
                                ),
                              ),
                            );
                          }))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(() {
          Digest digest = (recipe.digest ??
              [])[recipeDetailsController.currentNutrition.value];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: const BoxDecoration(
              color: AppColor.greenColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Text(
                          digest.label ?? "-",
                          style: TextStyle(
                              fontSize: AppSizes.getResponsiveSize(2.2),
                              color: const Color(0xff3A3A3A),
                              fontWeight: FontWeight.w700),
                        ),
                        (digest.sub ?? []).isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  recipeDetailsController
                                          .showDetailsNutrition.value =
                                      !recipeDetailsController
                                          .showDetailsNutrition.value;
                                },
                                child: Icon(recipeDetailsController
                                        .showDetailsNutrition.value
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up))
                            : Container()
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ((digest.total ?? 0.0) / (recipe.yield ?? 0.0))
                                    .toStringAsFixed(0) +
                                (digest.unit ?? ""),
                            style: TextStyle(
                                fontSize: AppSizes.getResponsiveSize(1.5),
                                color: const Color(0xff3A3A3A),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "${((digest.daily ?? 0.0) / (recipe.yield ?? 0.0)).toStringAsFixed(0)}%",
                            style: TextStyle(
                                fontSize: AppSizes.getResponsiveSize(1.5),
                                color: const Color(0xff3A3A3A),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: recipeDetailsController.showDetailsNutrition.value,
                  child: Column(
                    children: [
                      ...(digest.sub ?? []).map((e) => Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          e.label ?? "-",
                                          style: TextStyle(
                                              fontSize:
                                                  AppSizes.getResponsiveSize(
                                                      1.5),
                                              color: const Color(0xff3A3A3A),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ((e.total ?? 0.0) / (recipe.yield ?? 0.0))
                                              .toStringAsFixed(0) +
                                          (e.unit ?? ""),
                                      style: TextStyle(
                                          fontSize:
                                              AppSizes.getResponsiveSize(1.5),
                                          color: const Color(0xff3A3A3A),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "${((e.daily!) / (recipe.yield ?? 0.0)).toStringAsFixed(0)}%",
                                      style: TextStyle(
                                          fontSize:
                                              AppSizes.getResponsiveSize(1.5),
                                          color: const Color(0xff3A3A3A),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ))
            ]),
          );
        }),
      ],
    );
  }
}

class ShowIngredients extends StatelessWidget {
  final Ingredients ingredients;
  const ShowIngredients(this.ingredients, {super.key});

  @override
  Widget build(BuildContext context) {
    var ingredientList = getIngredients(ingredients.text ?? '');
    return Container(
      height: AppSizes.getResponsiveSize(14.5),
      width: AppSizes.getResponsiveSize(13.5),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: AppColor.greenColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.5),
                child: Center(
                    child: Text(
                  (ingredientList[0] ?? "-").toString(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: const Color(0xff3C444C),
                      fontSize: AppSizes.getResponsiveSize(2.1),
                      fontWeight: FontWeight.bold),
                )),
              )),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white.withOpacity(.58),
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
              child: Center(
                child: Text(
                  toCapitalize(ingredientList[1]! ?? "") ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: const Color(0xff3C444C),
                      fontSize: AppSizes.getResponsiveSize(1.7)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? toCapitalize(String? input) {
  if (input == null || input.isEmpty) return input;
  return '${input[0].toUpperCase()}${input.substring(1).toLowerCase()}';
}
