// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

class CityModel {
  const CityModel({
    required this.id,
    required this.city,
    required this.cityAscii,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.iso2,
    required this.iso3,
    required this.adminName,
    required this.capital,
    required this.population,
    required this.locationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json['id'] as int,
    city: json['city'] as String,
    cityAscii: json['city_ascii'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    country: json['country'] as String,
    iso2: json['iso2'] as String,
    iso3: json['iso3'] as String,
    adminName: json['admin_name'] as String,
    capital: json['capital'] as String,
    population: json['population'] as int,
    locationId: json['location_id'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );

  final int id;
  final String city;
  final String cityAscii;
  final double latitude;
  final double longitude;
  final String country;
  final String iso2;
  final String iso3;
  final String adminName;
  final String capital;
  final int population;
  final String locationId;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'city': city,
    'city_ascii': cityAscii,
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
    'iso2': iso2,
    'iso3': iso3,
    'admin_name': adminName,
    'capital': capital,
    'population': population,
    'location_id': locationId,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  @override
  String toString() => 'CityModel(id: $id, city: $city, country: $country)';
}