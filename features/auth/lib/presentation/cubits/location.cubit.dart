// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/location.service.dart';
import '../../domain/models/city.model.dart';
import '../../domain/models/country.model.dart';

part 'location.cubit.freezed.dart';
part 'states/location.state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._service) : super(const LocationStateInitial());

  final LocationService _service;

  List<CountryModel> _countries = [];
  List<CountryModel> get countries => _countries;

  List<CityModel> _cities = [];
  List<CityModel> get cities => _cities;

  Future getCountries() async {
    try {
      emit(const LocationStateLoading());

      final response = await _service.getCountries();

      log('Countries response: $response', name: 'Location Cubit');

      return response.fold(
        (failure) {
          emit(LocationStateFailed(failure));
          log('Countries failed: ${failure.message}', name: 'Location Cubit');
        },
        (countries) {
          _countries = countries;
          emit(LocationStateCountriesLoaded(countries));
          log('Countries loaded: ${countries.length} items', name: 'Location Cubit');
        },
      );
    } catch (e) {
      log('Countries error: $e', name: 'Location Cubit');
      emit(LocationStateFailed(UnexpectedFailure()));
    }
  }

  Future getCities({
    required String countryIso2,
    String? cityQuery,
  }) async {
    try {
      emit(const LocationStateLoading());

      final response = await _service.getCities(
        countryIso2: countryIso2,
        cityQuery: cityQuery,
      );

      log('Cities response: $response', name: 'Location Cubit');

      return response.fold(
        (failure) {
          emit(LocationStateFailed(failure));
          log('Cities failed: ${failure.message}', name: 'Location Cubit');
        },
        (cities) {
          _cities = cities;
          emit(LocationStateCitiesLoaded(cities));
          log('Cities loaded: ${cities.length} items', name: 'Location Cubit');
        },
      );
    } catch (e) {
      log('Cities error: $e', name: 'Location Cubit');
      emit(LocationStateFailed(UnexpectedFailure()));
    }
  }
}