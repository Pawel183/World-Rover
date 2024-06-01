import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SimpleWorldMap(visitedCountries: visitedCountries),
      ],
    );
  }
}