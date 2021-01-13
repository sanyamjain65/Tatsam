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

  /// Get the list of the countries to be displayed in the listview.
  /// Also fetches the favourites list from the persistence storage.
  ///
  /// Returns [STATE] which describes the state of the network response.
  Future<STATE> getCountryList() async {
    try {
      //this is to avoid the multiple request everytime the widget rebuilds.
      if (!isDataFetched) {
        //get the favourites list from the persistence storage
        String storedData = await SharedPreferencesUtil().getString(favourites);
        //check if the data is present in the storage
        if (storedData != null && storedData.isNotEmpty) {
          favCountryMap = jsonDecode(storedData);
        }
        //check for internet connectivity
        if (await Utility.isInternetConnected()) {
          //make network request
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
          errorMessage = "Please check your network connectivity";
          return Future<STATE>.value(STATE.INTERNET_NOT_CONNECTED);
        }
      } else {
        return Future<STATE>.value(STATE.SUCCESS);
      }
    } catch (error) {
      return null;
    }
  }

  /// Make network request to fetch the list of the countries.
  ///
  /// Returns [CountryResponse]
  Future<CountryResponse> fetchListFromServer() async {
    Map<String, dynamic> queryParams = {'offset': '$offset', 'limit': '$limit'};
    //make the network request
    final dynamic response =
        await BaseApi('', RequestType.GET, queryParams: queryParams)
            .makeRequest();
    //serialize the data
    final CountryResponse countryResponse = CountryResponse.fromJson(response);
    //mark the favourites in the data returned from the network request.
    countryResponse.data.forEach((country) {
      if (favCountryMap.isNotEmpty && favCountryMap.containsKey(country.countryCode)) {
        country.isFav = true;
      }
    });
    return countryResponse;
  }

  /// Checks whether the user has scrolled to the bottom of the listview.
  /// if yes, fetches the next batch of countries
  bool isNeedToFetchNextBatch(ScrollNotification scrollNotification) {
    //validate the type of notification
    if (scrollNotification is OverscrollNotification) {
      //check if the user has scrolled to the bottom.
      if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent &&
          lastStoredScrollPixel != scrollNotification.metrics.pixels) {
        lastStoredScrollPixel = scrollNotification.metrics.pixels;
        this.offset += limit;
        //fetches the next batch.
        fetchNextBatch();
      }
    }
    return false;
  }

  /// Fetches the next batch of the data to be shown to the user.
  /// rebuilds the fetching the data
  void fetchNextBatch() async {
    CountryResponse response = await fetchListFromServer();
    if (response.data.isNotEmpty && response.data != null) {
      countryList.addAll(response.data);
    }
    update();
  }

  ///Mark/unmark the country as favourite
  ///[countryData] country data object to be mark/unmark as favourite
  Future<void> addCountryToFavList(CountryData countryData) async {
    try {
      //toggle the favourite flag.
      countryData.isFav = !countryData.isFav;
      //remove the country from the storage if the it is to be unmark from favourites.
      //this optimizes storage by removing unwanted data from the storage.
      if (!countryData.isFav) {
        favCountryMap.remove(countryData.countryCode);
      } else {
        //add the country to the storage if it is marked as favourite
        favCountryMap[countryData.countryCode] = countryData.toJson();
      }
      //encode and save the data in storage
      String x = jsonEncode(favCountryMap);
      await SharedPreferencesUtil().setString(favourites, x);
      update();
    } catch (error) {
      return;
    }
  }

  ///Get The list of favourite countries.
  getFavCountryList() {
    favCountryMap.forEach((key, value) {
      favCountryList.add(CountryData.fromJson(value, key));
    });
    return favCountryList;
  }
}
