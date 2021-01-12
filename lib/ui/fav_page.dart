import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tatsam/controller/CountryController.dart';
import 'package:tatsam/ui/widget/countryList.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryController>(
        init: CountryController(),
        builder: (CountryController instance) {
          instance.getFavCountryList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Favourite'),
              centerTitle: true,
              backgroundColor: Color(0xFF0F2567),
            ),
            body: instance.favCountryList.isEmpty
                ? Center(
                    child: Container(
                      child: Text('No Favorites yet'),
                    ),
                  )
                : Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    child: CountryList(
                      itemCount: instance.favCountryList.length,
                      hideFavorites: true,
                    ),
                  ),
          );
        });
  }
}
