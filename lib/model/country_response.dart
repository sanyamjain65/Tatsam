import 'package:flutter/material.dart';
import 'package:tatsam/model/country_data.dart';

class CountryResponse {
    String status;
    int statusCode;
    String version;
    int total;
    int limit;
    int offset;
    String access;
    List<CountryData> data = [];

    CountryResponse(
        {this.status,
            this.statusCode,
            this.version,
            this.total,
            this.limit,
            this.offset,
            this.access,
            this.data});

    CountryResponse.fromJson(Map<String, dynamic> json) {
        status = json['status'];
        statusCode = json['status-code'];
        version = json['version'];
        total = json['total'];
        limit = json['limit'];
        offset = json['offset'];
        access = json['access'];
        if(json['data'] != null) {
            Map<String, dynamic> dataMap = json['data'];
            dataMap.forEach((String key, dynamic value) {
                data.add(new CountryData.fromJson(value, key));
            });
        } else {
            data = null;
        }
    }
}