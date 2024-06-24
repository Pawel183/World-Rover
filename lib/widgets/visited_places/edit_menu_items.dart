import 'package:flutter/material.dart';

class EditMenuItems extends StatefulWidget {
  const EditMenuItems({super.key});

  @override
  State<EditMenuItems> createState() => _EditMenuItemsState();
}

class _EditMenuItemsState extends State<EditMenuItems> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.edit),
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'Country',
          child: Text('Country'),
        ),
        const PopupMenuItem<String>(
          value: 'Place_name',
          child: Text('Place name'),
        ),
        const PopupMenuItem<String>(
          value: 'Map_location',
          child: Text('Map location'),
        ),
        const PopupMenuItem<String>(
          value: 'Photo',
          child: Text('Photo'),
        ),
      ],
    );
  }
}