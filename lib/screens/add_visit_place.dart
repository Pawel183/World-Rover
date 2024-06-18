import 'package:flutter/material.dart';

class AddVisitPlace extends StatefulWidget {
  const AddVisitPlace({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddVisitPlaceState();
  }
}

class _AddVisitPlaceState extends State<AddVisitPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Add Visit Place",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Center(
        child: Text("Add Visit Place"),
      ),
    );
  }
}
