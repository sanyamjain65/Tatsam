class CountryData {
    String country;
    String region;
    String countryCode;

    CountryData({this.country, this.region});

    CountryData.fromJson(Map<String, dynamic> json, String countryCode) {
        country = json['country'];
        region = json['region'];
        this.countryCode = countryCode;
    }
}