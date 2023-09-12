import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final IconData icon;
  final String time;
  final String value;

  const WeatherForecastCard({
    super.key,
    required this.icon,
    required this.time,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 130,
      child: Card(
        elevation: 8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$value ° K',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
