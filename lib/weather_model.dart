/// 天氣預報資料
class WeatherData {
  /// 標題
  final String datasetDescription;
  /// 地點資訊列表
  final List<Location> locations;

  WeatherData({
    required this.datasetDescription,
    required this.locations,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      datasetDescription: json['datasetDescription'],
      locations: (json['location'] as List)
          .map((locationJson) => Location.fromJson(locationJson))
          .toList(),
    );
  }
}

/// 地點資訊
class Location {
  /// 地點名稱
  final String locationName;
  /// 天氣資訊列表
  final List<WeatherElement> weatherElements;

  Location({
    required this.locationName,
    required this.weatherElements,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationName: json['locationName'],
      weatherElements: (json['weatherElement'] as List)
          .map((elementJson) => WeatherElement.fromJson(elementJson))
          .toList(),
    );
  }
}

/// 天氣資訊
class WeatherElement {
  /// 資訊主題名稱
  final String elementName;
  /// 時段天氣資訊列表
  final List<WeatherTime> times;

  WeatherElement({
    required this.elementName,
    required this.times,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) {
    return WeatherElement(
      elementName: json['elementName'],
      times: (json['time'] as List)
          .map((timeJson) => WeatherTime.fromJson(timeJson))
          .toList(),
    );
  }
}

/// 時段天氣資訊
class WeatherTime {
  /// 開始時間
  final DateTime startTime;
  /// 結束時間
  final DateTime endTime;
  /// 天氣資訊參數
  final WeatherParameter parameter;

  WeatherTime({
    required this.startTime,
    required this.endTime,
    required this.parameter,
  });

  factory WeatherTime.fromJson(Map<String, dynamic> json) {
    return WeatherTime(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      parameter: WeatherParameter.fromJson(json['parameter']),
    );
  }
}

/// 天氣資訊參數
class WeatherParameter {
  /// 參數名稱
  final String parameterName;
  /// 參數值
  final String? parameterValue;
  /// 參數單位
  final String? parameterUnit;

  WeatherParameter({
    required this.parameterName,
    this.parameterValue,
    this.parameterUnit,
  });

  factory WeatherParameter.fromJson(Map<String, dynamic> json) {
    return WeatherParameter(
      parameterName: json['parameterName'],
      parameterValue: json['parameterValue'],
      parameterUnit: json['parameterUnit'],
    );
  }
}
