import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tatsam/enum/NetworkState.dart';
import 'package:tatsam/model/country_data.dart';
import 'package:tatsam/model/country_response.dart';
import 'package:tatsam/network/base_api.dart';
import 'package:tatsam/utils/Constants.dart';
import 'package:tatsam/utils/SharedPreferenceUtil.dart';
import 'package:tatsam/utils/util.dart';

class CountryController extends GetxController {
  int offset = 0;
  int limit = 30;
  List<CountryData> countryList = [];
  List<CountryData> favCountryList = [];
  double lastStoredScrollPixel = 0.0;
  int maxElements = 250;
  bool isDataFetched = false;
  String errorMessage;

  Map<String, dynamic> favCountryMap = {};

  Future<STATE> getCountryList() async {
    try {
      if (!isDataFetched) {
        String storedData = await SharedPreferencesUtil().getString(favourites);
        if (storedData != null && storedData.isNotEmpty) {
          favCountryMap = jsonDecode(storedData);
        }
        if (await Utility.isInternetConnected()) {
          CountryResponse response = await fetchListFromServer();
          isDataFetched = true;
          if (response.statusCode == 200 || response.statusCode == 201) {
            countryList = response.data;
            return Future<STATE>.value(STATE.SUCCESS);
          } else {
            errorMessage = response.message;
            return Future<STATE>.value(STATE.FAILURE);
          }
        } else {
          errorMessage = "Internet Not Connected";
          return Future<STATE>.value(STATE.INTERNET_NOT_CONNECTED);
        }
      } else {
        return Future<STATE>.value(STATE.SUCCESS);
      }
    } catch (error) {
      return null;
    }
  }

  Future<CountryResponse> fetchListFromServer() async {
    Map<String, dynamic> queryParams = {'offset': '$offset', 'limit': '$limit'};
    //make the network request
    final dynamic response =
        await BaseApi('', RequestType.GET, queryParams: queryParams)
            .makeRequest();
    //serialize the data

    final CountryResponse countryResponse = CountryResponse.fromJson(response);
    countryResponse.data.forEach((element) {
      if (favCountryMap.isNotEmpty && favCountryMap.containsKey(element.countryCode)) {
        element.isFav = true;
      }
    });
    return countryResponse;
  }

  bool isNeedToFetchNextBatch(ScrollNotification scrollNotification) {
    if (scrollNotification is OverscrollNotification) {
      if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent &&
          lastStoredScrollPixel != scrollNotification.metrics.pixels) {
        lastStoredScrollPixel = scrollNotification.metrics.pixels;
        this.offset += limit;
        fetchNextBatch();
      }
    }
    return false;
  }

  void fetchNextBatch() async {
    CountryResponse response = await fetchListFromServer();
    if (response.data.isNotEmpty && response.data != null) {
      countryList.addAll(response.data);
    }
    update();
  }

  Future<void> addCountryToFavList(CountryData data) async {
    try {
      data.isFav = !data.isFav;
      if (!data.isFav) {
        favCountryMap.remove(data.countryCode);
      } else {
        favCountryMap[data.countryCode] = data.toJson();
      }
      String x = jsonEncode(favCountryMap);
      await SharedPreferencesUtil().setString(favourites, x);
      update();
    } catch (error) {
      return;
    }
  }

  getFavCountryList() {
    favCountryList = countryList.where((element) {
      return element.isFav;
    }).toList();
    return favCountryList;
  }
}
