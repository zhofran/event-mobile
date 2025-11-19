// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

class CountryModel {
  const CountryModel({
    required this.country,
    required this.iso2,
    required this.iso3,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    country: json['country'] as String,
    iso2: json['iso2'] as String,
    iso3: json['iso3'] as String,
  );

  final String country;
  final String iso2;
  final String iso3;

  Map<String, dynamic> toJson() => {
    'country': country,
    'iso2': iso2,
    'iso3': iso3,
  };

  @override
  String toString() => 'CountryModel(country: $country, iso2: $iso2, iso3: $iso3)';
}