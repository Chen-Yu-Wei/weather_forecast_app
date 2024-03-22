import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/weather_model.dart';
import 'loading_widget.dart';
import 'providers.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 用於監聽輸入的地點名稱
    final locationController = TextEditingController();
    /// 讀取目前的地點
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('天氣預報查詢'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                /// 城市輸入框
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: '請輸入城市名稱',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                /// 搜尋按鈕
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurpleAccent),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    /// 更新地點狀態
                    ref.read(locationProvider.notifier).state = locationController.text.trim();
                  },
                  child: const Text('搜尋'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            /// 結果顯示區塊
            Consumer(builder: (context, ref, child){
              final weatherData = ref.watch(weatherDataProvider(location));
              return weatherData.when(
                data: (data) {
                  /// 如果數據不為空，則顯示天氣預報
                  if (data != null && data.locations.isNotEmpty) {
                    return Expanded(
                      child: Column(
                        children: [
                          /// 天氣數據標題
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.locations.first.locationName,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                data.datasetDescription,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          /// 天氣數據結果
                          Expanded(
                            child: ListView.builder(
                              itemCount: data!.locations.first.weatherElements
                                  .first.times.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final location = data!.locations.first;
                                return weatherCard(
                                    location.weatherElements, index);
                              },
                            ),
                          )
                        ],
                      ),
                    );
                    /// 若locations為空，則表示沒有此城市的資料
                  } else if(data != null && data.locations.isEmpty){
                    return const Center(
                      child: Text('查無此城市天氣狀態，請重新輸入！'),
                    );
                  } else {
                    return const Center(
                      child: Text('尚未有查詢結果，請輸入城市名稱！'),
                    );
                  }
                },
                loading: () => const LoadingWidget(),
                error: (error, stackTrace) => const Text('查無此城市天氣狀態，請重新輸入！'),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 天氣數據詳細資料Widget
  Widget weatherCard(List<WeatherElement> weatherElementList, int index) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.amberAccent[100],
      shadowColor: Colors.grey,
      elevation: 2,
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 時段title
              Text(
                "${dateTimeFormat(weatherElementList.first.times[index].startTime)} - "
                "${dateTimeFormat(weatherElementList.first.times[index].endTime)}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]
                ),
              ),
              const SizedBox(height: 5),
              /// 時段天氣數據詳細資料
              Expanded(
                child: weatherDataDetail(weatherElementList, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 時段天氣數據詳細資料
  Widget weatherDataDetail(List<WeatherElement> weatherElement, int timeIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            (weatherElement.length / 2).ceil(), (index) {
              final startIndex = (index - 1 ) * 2 + 1;
              final endIndex = startIndex + 1;
              if(index == 0) {
                return weatherDataTitle(weatherElement[index], timeIndex);
              } else if(endIndex < weatherElement.length) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: weatherDataTitle(weatherElement[startIndex], timeIndex),
                    ),
                    Expanded(
                      child: weatherDataTitle(weatherElement[endIndex], timeIndex),
                    ),
                  ],
                );
              } else {
                return weatherDataTitle(weatherElement[startIndex], timeIndex);
              }
          }
    ));
  }

  /// 詳細數據資料title顯示Widget
  Widget weatherDataTitle(WeatherElement weatherElement,  int timeIndex) {
    return Row(
      children: [
        Text(
          '${getWeatherDataTitle(weatherElement.elementName)}：',
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
            weatherElement.times[timeIndex].parameter.parameterName +
                (weatherElement.times[timeIndex].parameter.parameterUnit ?? '')
        ),
      ],
    );
  }

  /// 轉換詳細天氣數據標題
  String getWeatherDataTitle(String title) {
    switch (title) {
      case 'Wx':
        return "天氣現象";
      case 'MaxT':
        return "最高溫度";
      case 'MinT':
        return "最低溫度";
      case 'CI':
        return "舒適度";
      case 'PoP':
        return "降雨機率";
    }
    return '';
  }

  /// 轉換時間格式
  String dateTimeFormat(DateTime dateTime) {
    final df = DateFormat('MM/dd HH:mm');
    return df.format(dateTime);
  }
}
