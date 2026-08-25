import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _searchedCity = "";
  Future<Map<String, dynamic>>? _weatherFuture;

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('https://wttr.in/${Uri.encodeComponent(city)}?format=j1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("City not found. Please check the spelling.");
    }
  }

  void _search() {
    String city = _cityController.text.trim();
    if (city.isEmpty) return;
    setState(() {
      _searchedCity = city.toUpperCase();
      _weatherFuture = fetchWeather(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade800, Colors.blue.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: "Enter city (e.g. Lahore, Karachi)...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.indigo),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _search,
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: _weatherFuture == null
                  ? const Center(
                      child: Text(
                        "Search any city to check live weather",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : FutureBuilder<Map<String, dynamic>>(
                      future: _weatherFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          final currentCondition = data['current_condition'][0];
                          double temperature = double.parse(currentCondition['temp_C']);
                          String weatherCondition = currentCondition['weatherDesc'][0]['value'];
                          int humidity = int.parse(currentCondition['humidity']);
                          double windSpeed = double.parse(currentCondition['windspeedKmph']);

                          return Center(
                            child: Card(
                              elevation: 10,
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.wb_sunny_rounded, size: 90, color: Colors.orange),
                                    const SizedBox(height: 12),
                                    Text(
                                      _searchedCity,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "$temperature°C",
                                      style: TextStyle(
                                        fontSize: 52,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      weatherCondition,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: Divider(thickness: 1.5),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.water_drop, color: Colors.blue),
                                            const SizedBox(width: 6),
                                            Text("Humidity: $humidity%", style: const TextStyle(fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.air, color: Colors.teal),
                                            const SizedBox(width: 6),
                                            Text("Wind: ${windSpeed}km/h", style: const TextStyle(fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
