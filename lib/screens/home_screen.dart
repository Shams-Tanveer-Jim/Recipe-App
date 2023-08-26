import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_app/consts/assets.dart';
import 'package:recipe_app/consts/colors.dart';
import 'package:recipe_app/consts/sizes.dart';
import 'package:recipe_app/controller/home_controller.dart';
import 'package:recipe_app/models/search_response.dart';
import 'package:recipe_app/screens/recipe_details_screen.dart';
import 'package:recipe_app/screens/widgets/recipe_shimmer.dart';
import 'package:recipe_app/screens/widgets/shimmer_widget.dart';
import 'package:recipe_app/services/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  final TextEditingController searchController = TextEditingController();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        if (homeController.nextPageUrl.value.isNotEmpty) {
          homeController.addMoreRecipe();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.3),
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.grey.withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppAssets.rightMenu,
                      scale: 4.5,
                    ),
                    Container(
                      height: 38,
                      width: 230,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0)),
                      child: TextField(
                        onSubmitted: (value) {
                          showToast("Please Wait. Searching Recipe");
                          homeController.searchRecipe(value);
                          searchController.clear();
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          isDense: true,
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          suffixIcon: InkWell(
                            onTap: () {
                              searchController.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.7)),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.menu,
                        size: 30,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: AppSizes.getResponsiveSize(4),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    border: Border.all(color: Colors.grey.withOpacity(0.5))),
              ),
              Obx(() {
                if (homeController.isLoading.value) {
                  return SizedBox(
                    height: Get.height / 1.2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text("Please Wait. Searching Recipe"),
                        Expanded(
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (_, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RecipeShimmer(),
                                      RecipeShimmer()
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
                if ((homeController.searchResponse.value.hits ?? []).isEmpty) {
                  return SizedBox(
                    height: Get.height / 1.2,
                    child: const Center(
                      child: Text("No Recipe Available.Search For Recipe"),
                    ),
                  );
                }
                return SizedBox(
                  height: AppSizes.getResponsiveSize(89),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: ListView.builder(
                      itemCount: (homeController.hits.length / 2).ceil() + 1,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (context, index) {
                        if (index < (homeController.hits.length / 2).ceil()) {
                          final int startIndex = index * 2;
                          final int endIndex = (startIndex + 2)
                              .clamp(0, homeController.hits.length);
                          final pageWidgets =
                              homeController.hits.sublist(startIndex, endIndex);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...pageWidgets.map((e) => ShowRecipe(hits: e))
                              ],
                            ),
                          );
                        } else {
                          return homeController.nextPageUrl.value.isNotEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RecipeShimmer(),
                                      RecipeShimmer()
                                    ],
                                  ),
                                )
                              : Container();
                        }
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowRecipe extends StatelessWidget {
  final Hits hits;
  const ShowRecipe({required this.hits, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RecipeDetailsScreen(recipe: hits.recipe ?? Recipe()),
            duration: const Duration(milliseconds: 500),
            transition: Transition.downToUp);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: AppSizes.getResponsiveSize(30),
        width: AppSizes.getResponsiveSize(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          gradient: LinearGradient(
            colors: [Colors.grey.withOpacity(0.05), Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: hits.recipe?.image ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                    errorWidget: (context, url, error) => SizedBox(
                        height: AppSizes.getResponsiveSize(30),
                        width: AppSizes.getResponsiveSize(20.0),
                        child: const Icon(Icons.error)),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: AppSizes.getResponsiveSize(5),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.0),
                            Colors.black.withOpacity(.8),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        hits.recipe?.label ?? "-",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 2),
                      height: AppSizes.getResponsiveSize(4),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.8),
                            Colors.black.withOpacity(.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        hits.recipe?.source ?? "-",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: ((hits.recipe?.calories ?? 0.0) /
                                  (hits.recipe?.yield ?? 1.0))
                              .toStringAsFixed(0),
                          style: const TextStyle(
                            color: AppColor.greenColor,
                          ),
                        ),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: "CAL",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: AppSizes.getResponsiveSize(1.5)))
                      ])),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: AppSizes.getResponsiveSize(1.2)),
                        child: const VerticalDivider(
                          color: Colors.grey,
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: ((hits.recipe?.ingredients ?? []).length)
                              .toStringAsFixed(0),
                          style: const TextStyle(
                            color: AppColor.greenColor,
                          ),
                        ),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: "INGR",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: AppSizes.getResponsiveSize(1.5)))
                      ])),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
