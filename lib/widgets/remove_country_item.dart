import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class RemoveCountryItem extends StatelessWidget {
  const RemoveCountryItem({
    super.key,
    required this.isoCode,
    required this.removeCountry,
  });

  final String isoCode;
  final void Function(String isoCode) removeCountry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5, bottom: 5),
          child: Row(
            children: [
              // Country Flag and name
              Expanded(
                child: Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      isoCode,
                      height: 48,
                      width: 62,
                      borderRadius: 8,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Country.tryParse(isoCode) != null
                                  ? Country.tryParse(isoCode)!.name
                                  : isoCode,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Trash button
              IconButton(
                onPressed: () {
                  removeCountry(isoCode);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 36,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
