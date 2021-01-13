import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tatsam/controller/country_controller.dart';
import 'package:tatsam/enum/NetworkState.dart';
import 'package:tatsam/ui/fav_page.dart';
import 'package:tatsam/ui/widget/countryList.dart';

class CountryDetails extends StatelessWidget {
  List<Color> colorList = [
    Colors.red,
    Colors.pink,
    Colors.blue,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.pink,
    Colors.green,
    Colors.indigo,
    // Colors.lightGreenAccent,
    Colors.lightBlue,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryController>(
      init: CountryController(),
      builder: (instance) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Tatsam'),
            backgroundColor: Color(0xFF0F2567),
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.pink.withOpacity(0.7),
                    ),
                    onPressed: () {
                      Get.to(FavouritePage());
                    }),
              )
            ],
          ),
          body: FutureBuilder<STATE>(
            future: instance.getCountryList(),
            builder: (BuildContext context, AsyncSnapshot<STATE> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == STATE.INTERNET_NOT_CONNECTED ||
                    snapshot.data == STATE.FAILURE) {
                  return Center(child: Text(instance.errorMessage));
                } else {
                  return NotificationListener<ScrollNotification>(
                      onNotification: (notification) =>
                          instance.isNeedToFetchNextBatch(notification),
                      child: Container(
                          padding:
                              EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                          child: CountryList()));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
