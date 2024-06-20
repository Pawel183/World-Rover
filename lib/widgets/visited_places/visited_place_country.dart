import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

class VisitedPlaceCountryPicker extends StatefulWidget {
  const VisitedPlaceCountryPicker({super.key, required this.onPickCountry});

  final void Function(String countryCode, String countryName) onPickCountry;

  @override
  State<VisitedPlaceCountryPicker> createState() => _VisitedPlaceCountryPickerState();
}

class _VisitedPlaceCountryPickerState extends State<VisitedPlaceCountryPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pick a country: ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
        CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Choose country'),
          ),
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            isShowCode: false,
            isDownIcon: true,
            showEnglishName: true,
          ),
          onChanged: (country) {
            widget.onPickCountry(country!.code!, country.name!);
          },
        ),
      ],
    );
  }
}
