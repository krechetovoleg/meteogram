class CiySearch {
  final List<String> cityName;
  final List<double> latitude;
  final List<double> longitude;
  final List<String> country;

  CiySearch({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory CiySearch.fromJson(Map<String, dynamic> json) {
    var citys = CiySearch(
      cityName: [],
      latitude: [],
      longitude: [],
      country: [],
    );

    if (json.length > 1) {
      for (int i = 0; i < json['results'].length; i++) {
        citys.cityName.add(json['results'][i]['name']);
        citys.latitude.add(json['results'][i]['latitude']);
        citys.longitude.add(json['results'][i]['longitude']);
        citys.country.add(json['results'][i]['country']);
      }
    }
    return citys;
  }
}
