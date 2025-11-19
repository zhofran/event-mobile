// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/city.model.dart';
import '../domain/models/country.model.dart';

@lazySingleton
class LocationService {
  LocationService(this._client);

  final INetworkClient _client;

  /// Get all countries from API
  AsyncEither<List<CountryModel>> getCountries() async {
    final response = await _client.invoke(
      '/api/v1/locations/countries',
      RequestType.get,
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (result) {
        final countries = (result['data'] as List)
            .map((item) => CountryModel.fromJson(item))
            .toList();

        return Right(countries);
      },
    );
  }

  /// Get cities by country from API
  AsyncEither<List<CityModel>> getCities({
    required String countryIso2,
    String? cityQuery,
  }) async {
    final queryParameters = <String, String>{
      'country': countryIso2,
    };

    // Add city search query if provided
    if (cityQuery != null && cityQuery.isNotEmpty) {
      queryParameters['city'] = cityQuery;
    }

    final response = await _client.invoke(
      '/api/v1/locations/search',
      RequestType.get,
      queryParameters: queryParameters,
    );

    return response.fold(
      (failure) {
        return Left(failure);
      },
      (result) {
        final data = result['data'] as Map<String, dynamic>;
        final locations = data['locations'] as List;
        
        final cities = locations
            .map((item) => CityModel.fromJson(item))
            .toList();

        return Right(cities);
      },
    );
  }
}