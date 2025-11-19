part of '../location.cubit.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState.initial() = LocationStateInitial;
  const factory LocationState.loading() = LocationStateLoading;
  const factory LocationState.countriesLoaded(List<CountryModel> countries) = LocationStateCountriesLoaded;
  const factory LocationState.citiesLoaded(List<CityModel> cities) = LocationStateCitiesLoaded;
  const factory LocationState.failed(IFailure failure) = LocationStateFailed;
}