class CiySearch {
  List<String> cityName;
  List<double> latitude;
  List<double> longitude;
  List<String> country;
  List<String> timezone;
  List<String> admin1;

  CiySearch({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.timezone,
    required this.admin1,
  });

  factory CiySearch.fromJson(Map<String, dynamic> json) {
    var citys = CiySearch(
      cityName: [],
      latitude: [],
      longitude: [],
      country: [],
      timezone: [],
      admin1: [],
    );

    if (json.length > 1) {
      for (int i = 0; i < json['results'].length; i++) {
        citys.cityName.add(json['results'][i]['name'] ?? '');
        citys.latitude.add(json['results'][i]['latitude'] ?? 0.0);
        citys.longitude.add(json['results'][i]['longitude'] ?? 0.0);
        citys.country.add(json['results'][i]['country'] ?? '');
        citys.timezone.add(json['results'][i]['timezone'] ?? '');
        citys.admin1.add(json['results'][i]['admin1'] ?? '');
      }
    }
    return citys;
  }
}
