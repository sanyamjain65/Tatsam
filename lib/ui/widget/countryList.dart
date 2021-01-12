import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tatsam/controller/CountryController.dart';
import 'package:tatsam/utils/util.dart';

class CountryList extends StatelessWidget {
  int itemCount;
  bool hideFavorites;

  CountryList({this.itemCount, this.hideFavorites = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryController>(
      init: CountryController(),
      builder: (CountryController instance) {
        return ListView.builder(
            key: PageStorageKey<String>('controllerD'),
            itemCount: itemCount != null && itemCount != 0
                ? itemCount
                : instance.maxElements > instance.countryList.length
                    ? instance.countryList.length + 1
                    : instance.countryList.length,
            itemBuilder: (context, index) {
              if (index == instance.countryList.length && !hideFavorites) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Card(
                  elevation: 5.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              color: Utility.colorList[index % 10]),
                          child: Center(
                            child: Text(
                              hideFavorites
                                  ? instance.favCountryList[index].countryCode
                                  : instance.countryList[index].countryCode,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                            flex: 7,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hideFavorites
                                        ? instance.favCountryList[index].country
                                        : instance.countryList[index].country,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(hideFavorites
                                      ? instance.favCountryList[index].region
                                      : instance.countryList[index].region),
                                ],
                              ),
                            )),
                        SizedBox(
                          width: 20.0,
                        ),
                        hideFavorites
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  instance.countryList[index].isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.pink.withOpacity(0.7),
                                ),
                                onPressed: () async {
                                  instance.addCountryToFavList(
                                      instance.countryList[index]);
                                },
                              )
                      ],
                    ),
                  ),
                );
              }
            });
      },
    );
  }
}
