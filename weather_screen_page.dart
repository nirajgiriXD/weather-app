import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/weather_forecast_card.dart';
import 'package:weather_app/additional_info_card.dart';
import 'package:weather_app/secret_key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const String cityName = 'kathmandu';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherMapAPIKey'),
      );
      if (200 == res.statusCode) {
        return jsonDecode(res.body);
      } else {
        throw 'Something went wrong.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.data != null) {}

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          final String currentWeatherStatus =
              currentWeather['weather'][0]['main'];
          final String currentTemperature =
              currentWeather['main']['temp'].toString();
          final String currentWindSpeed =
              currentWeather['wind']['speed'].toString();
          final String currentHumidity =
              currentWeather['main']['humidity'].toString();
          final String currentPressure =
              currentWeather['main']['pressure'].toString();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Main Content.
                Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 0,
                            sigmaY: 0,
                            // sigmaX: 10,
                            // sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemperature ° K',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                Icon(
                                  currentWeatherStatus == 'Clouds'
                                      ? Icons.cloud
                                      : currentWeatherStatus == 'Rain'
                                          ? Icons.water_drop
                                          : Icons.sunny,
                                  size: 64,
                                ),
                                Text(
                                  currentWeatherStatus,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Spacing.
                const SizedBox(
                  height: 20,
                ),

                // Weather Forecast title.
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Spacing.
                const SizedBox(
                  height: 8,
                ),

                // // Weather forecast.
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < data['list'].length - 1; i++)
                //         WeatherForecastCard(
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                   'Clouds'
                //               ? Icons.cloud
                //               : data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //                   ? Icons.water_drop
                //                   : Icons.sunny,
                //           time: data['list'][i + 1]['dt_txt'],
                //           value: data['list'][i + 1]['main']['temp'].toString(),
                //         )
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data['list'].length - 1,
                    itemBuilder: (context, index) {
                      final compactData = data['list'][index + 1];
                      final time = DateTime.parse(compactData['dt_txt']);
                      return WeatherForecastCard(
                        icon: compactData['weather'][0]['main'] == 'Clouds'
                            ? Icons.cloud
                            : compactData['weather'][0]['main'] == 'Rain'
                                ? Icons.water_drop
                                : Icons.sunny,
                        time: DateFormat.j().format(time),
                        value: compactData['main']['temp'].toString(),
                      );
                    },
                  ),
                ),

                // Spacing.
                const SizedBox(
                  height: 20,
                ),

                // Additional information title.
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),

                // Spacing.
                const SizedBox(
                  height: 16,
                ),

                // Additional information.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCard(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity,
                    ),
                    AdditionalInfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed,
                    ),
                    AdditionalInfoCard(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
