import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/search_response.dart';
import 'package:recipe_app/services/api_services.dart';
import 'package:recipe_app/services/helpers.dart';

class HomeController extends GetxController {
  Rx<SearchResponse> searchResponse = SearchResponse().obs;
  RxList<Hits> hits = <Hits>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString nextPageUrl = "".obs;

  searchRecipe(String keyWord) async {
    isLoading.value = true;
    try {
      String url =
          "https://edamam-recipe-search.p.rapidapi.com/api/recipes/v2?type=public&q=$keyWord";
      Map<String, String> headers = {
        'Accept-Language': 'en',
        'X-RapidAPI-Key': '955be791b1mshe23e45e2fedff36p1af7bejsn34eb2500ca8f',
        'X-RapidAPI-Host': 'edamam-recipe-search.p.rapidapi.com'
      };
      var response =
          await ApiService.get(url, headers: headers).catchError((onError) {
        throw onError;
      });
      var jsonString = response.body;
      searchResponse.value = SearchResponse.fromJson(jsonDecode(jsonString));
      hits.value = searchResponse.value.hits ?? [];
      nextPageUrl.value = searchResponse.value.lLinks?.next?.href ?? "";
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }

      showToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addMoreRecipe() async {
    try {
      String url = nextPageUrl.value;

      var response = await ApiService.get(url, headers: {});
      var jsonString = response.body;
      var newSearchResponse = SearchResponse.fromJson(jsonDecode(jsonString));
      hits.addAll(newSearchResponse.hits ?? []);
      nextPageUrl.value = newSearchResponse.lLinks?.next?.href ?? "";
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
  }
}
