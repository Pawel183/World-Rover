import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:world_rover/widgets/simple_world_map.dart';

class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  var visitedCountries = ["US", "CN", "PL"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 10),
      child: Column(
        children: [
          SimpleWorldMap(visitedCountries: visitedCountries),
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Statistic",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 15,
                        percent: 0.22,
                        progressColor: Theme.of(context).colorScheme.primary,
                        center: Text(
                          "22%",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "13",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            "Countries",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text("Add country"),
                icon: const Icon(Icons.add),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text("Remove country"),
                icon: const Icon(Icons.remove),
              )
            ],
          )
        ],
      ),
    );
  }
}
