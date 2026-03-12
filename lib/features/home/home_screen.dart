import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> fetchWeather() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.open-meteo.com/v1/forecast?latitude=21.0245&longitude=105.8412&current_weather=true'
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather in Ha Noi')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final data = snapshot.data!['current_weather'];
            final temp = data['temperature'];
            final windspeed = data['windspeed'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wb_sunny, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    '$temp°C',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text('Wind speed: $windspeed km/h')
                ],
              ),
            );
          }

          return const SizedBox();
        }
      ),
    );
  }
}