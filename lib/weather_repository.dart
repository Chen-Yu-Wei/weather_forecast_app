import 'package:dio/dio.dart';
import 'package:weather_forecast_app/authInterceptor.dart';
import 'package:weather_forecast_app/weather_model.dart';

/// 天氣預報倉庫
class WeatherRepository {
  late Dio _dio;

  /// constructor
  WeatherRepository() {
    /// 配置Dio實例
    var options = BaseOptions(
      baseUrl: 'https://opendata.cwa.gov.tw/api/v1/rest/datastore',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    _dio = Dio(options);
    /// 添加驗證攔截器
    _dio.interceptors.add(AuthInterceptor());
  }

  /// 取天氣預報
  /// [location] 地點
  Future<WeatherData> fetchWeatherData(String location) async {
    try {
      final response = await _dio.get(
        '/F-C0032-001',
        queryParameters: {'locationName': location},
      );
      final recordsJson = response.data['records'] as Map<String, dynamic>;
      final datasetDescription = recordsJson['datasetDescription'] as String;

      final locationsJson = recordsJson['location'] as List<dynamic>;
      final locations = locationsJson.map((json) => Location.fromJson(json)).toList();

      return WeatherData(datasetDescription: datasetDescription, locations: locations);

    } catch (e) {
      print('Failed to fetch weather data');
      return WeatherData(datasetDescription: '', locations: []);
    }
  }
}