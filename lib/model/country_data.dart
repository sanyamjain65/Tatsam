class CountryData {
    String country;
    String region;
    String countryCode;
    bool isFav;

    CountryData({this.country, this.region});

    CountryData.fromJson(Map<String, dynamic> json, String countryCode, {bool isFav}) {
        country = json['country'];
        region = json['region'];
        this.countryCode = countryCode;
        this.isFav = isFav ?? false;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['country'] = this.country;
        data['region'] = this.region;
        data['countryCode'] = this.countryCode;
        data['isFav'] = this.isFav;
        return data;
    }
}