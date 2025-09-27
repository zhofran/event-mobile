import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../design.dart';

/// Contoh penggunaan FabSelectBottomSheet
class SelectExample extends StatefulWidget {
  const SelectExample({super.key});

  @override
  State<SelectExample> createState() => _SelectExampleState();
}

class _SelectExampleState extends State<SelectExample> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'country': FormControl<String>(),
      'city': FormControl<String>(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Example'),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Country selector
              FabSelectBottomSheet<String>(
                formControl: form.control('country') as FormControl<String>,
                labelText: 'Country',
                hintText: 'Select your country',
                searchHintText: 'Search Country',
                prefixIcon: Icon(
                  UIcons.boldRounded.globe,
                  color: FabColors.primary300,
                ),
                options: [
                  SelectOption(
                    value: 'ID',
                    label: 'Indonesia',
                    icon: const Text('🇮🇩'),
                  ),
                  SelectOption(
                    value: 'US',
                    label: 'United States',
                    icon: const Text('🇺🇸'),
                  ),
                  SelectOption(
                    value: 'SG',
                    label: 'Singapore',
                    icon: const Text('🇸🇬'),
                  ),
                  SelectOption(
                    value: 'MY',
                    label: 'Malaysia',
                    icon: const Text('🇲🇾'),
                  ),
                  SelectOption(
                    value: 'TH',
                    label: 'Thailand',
                    icon: const Text('🇹🇭'),
                  ),
                  SelectOption(
                    value: 'VN',
                    label: 'Vietnam',
                    icon: const Text('🇻🇳'),
                  ),
                  SelectOption(
                    value: 'PH',
                    label: 'Philippines',
                    icon: const Text('🇵🇭'),
                  ),
                  SelectOption(
                    value: 'AU',
                    label: 'Australia',
                    icon: const Text('🇦🇺'),
                  ),
                  SelectOption(
                    value: 'JP',
                    label: 'Japan',
                    icon: const Text('🇯🇵'),
                  ),
                  SelectOption(
                    value: 'KR',
                    label: 'South Korea',
                    icon: const Text('🇰🇷'),
                  ),
                ],
                onChanged: (option) {
                  print('Selected country: ${option?.label}');
                },
              ),
              
              const SizedBox(height: 16),
              
              // City selector
              FabSelectBottomSheet<String>(
                formControl: form.control('city') as FormControl<String>,
                labelText: 'City',
                hintText: 'Select your city',
                searchHintText: 'Search City',
                showSearch: false, // Disable search for this example
                prefixIcon: Icon(
                  UIcons.boldRounded.marker,
                  color: FabColors.primary300,
                ),
                options: [
                  SelectOption(
                    value: 'jakarta',
                    label: 'Jakarta',
                    icon: Icon(
                      UIcons.boldRounded.building,
                      size: 20,
                      color: FabColors.greyscale600,
                    ),
                  ),
                  SelectOption(
                    value: 'surabaya',
                    label: 'Surabaya',
                    icon: Icon(
                      UIcons.boldRounded.building,
                      size: 20,
                      color: FabColors.greyscale600,
                    ),
                  ),
                  SelectOption(
                    value: 'bandung',
                    label: 'Bandung',
                    icon: Icon(
                      UIcons.boldRounded.building,
                      size: 20,
                      color: FabColors.greyscale600,
                    ),
                  ),
                  SelectOption(
                    value: 'medan',
                    label: 'Medan',
                    icon: Icon(
                      UIcons.boldRounded.building,
                      size: 20,
                      color: FabColors.greyscale600,
                    ),
                  ),
                  SelectOption(
                    value: 'semarang',
                    label: 'Semarang',
                    icon: Icon(
                      UIcons.boldRounded.building,
                      size: 20,
                      color: FabColors.greyscale600,
                    ),
                  ),
                ],
                onChanged: (option) {
                  print('Selected city: ${option?.label}');
                },
              ),
              
              const SizedBox(height: 32),
              
              // Submit button
              FabButton.primary(
                child: const Text('Submit'),
                onPressed: () {
                  final country = form.control('country').value;
                  final city = form.control('city').value;
                  
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Form Values'),
                      content: Text('Country: $country\nCity: $city'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}