import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tatsam/controller/country_controller.dart';
import 'package:tatsam/ui/widget/country_list_item.dart';

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
                return CountryListItem(index, hideFavorites);
              }
            });
      },
    );
  }
}
