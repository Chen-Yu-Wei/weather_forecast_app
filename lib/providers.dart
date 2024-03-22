import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast_app/weather_model.dart';
import 'weather_repository.dart';

/// 提供 WeatherRepository 實例的 Provider
final weatherRepositoryProvider = Provider((ref) => WeatherRepository());
/// 用於管理使用者輸入地點更新的Provider
final locationProvider = StateProvider<String>((ref) => '');

/// 根據地點提取天氣數據
final weatherDataProvider =
FutureProvider.family<WeatherData?, String>((ref, location) async {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  // 如果地點為空，回傳null
  if (location.isEmpty) {
    return null;
  } else {
    // 呼叫抓取天氣數據API
    final weatherData = await weatherRepository.fetchWeatherData(location);
    return weatherData;
  }
});