import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tatsam/enum/NetworkState.dart';
import 'package:tatsam/model/country_data.dart';
import 'package:tatsam/model/country_response.dart';
import 'package:tatsam/network/base_api.dart';
import 'package:tatsam/utils/util.dart';

class CountryController extends GetxController {
  int offset = 0;
  int limit = 30;
  List<CountryData> countryList = [];
  double lastStoredScrollPixel = 0.0;
  int maxElements = 250;
  bool isDataFetched = false;
  String errorMessage;

  Future<STATE> getCountryList() async {
    try {
      if (!isDataFetched) {
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
}
