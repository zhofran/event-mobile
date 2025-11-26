// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/failures/auth.failures.dart';
import '../domain/models/availability.model.dart';
import '../domain/models/company_type.model.dart';
import '../domain/models/country.model.dart';
import '../domain/models/honorarium_preference.model.dart';
import '../domain/models/location.model.dart';
import '../domain/models/mobility_scope.model.dart';
import '../domain/models/topic.model.dart';
import '../domain/models/travel_arrangement.model.dart';

@lazySingleton
class AuthService {
  AuthService(this._client);

  final INetworkClient _client;

  AsyncEither<UserModel> login(
    String email,
    String password,
  ) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/auth/login',
      RequestType.post,
      requestBody: {
        'email': email,
        'password': password,
      },
    );

    log('Log response: $response', name: 'Auth Service');

    return response.fold(
      (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        return Left(failure);
      },
      (tokens) async {
        await _client.tokenStorage.setToken(
          OAuth2Token(
            accessToken: tokens['data']['token'],
            refreshToken: '',
            tokenType: 'Bearer',
            expiresIn: 3600,
            scope: '',
          ),
        );

        return _client.invoke<dynamic, UserModel>(
          '/auth/profile',
          RequestType.get,
          fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        );
      },
    );
  }

  AsyncEither<UserModel> otp(String otp, String id) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/otp/verify-email/$id', 
      RequestType.post,
      requestBody: {
        'otp_code': otp,
      },
    );

    log('Log response: $response', name: 'Auth services');

    return response.fold(
      (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        return Left(failure);

      }, 
      (token) async {
        await _client.tokenStorage.setToken(
          OAuth2Token(
            accessToken: token['data']['token'], 
            refreshToken: '', 
            tokenType: 'Bearer', 
            expiresIn: 3600, 
            scope: '',
          ),
        );
        
        return _client.invoke<dynamic, UserModel>(
          '/auth/profile',
          RequestType.get,
          fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        );
      }
    );
  }

  AsyncEither<List<TopicModel>> topic() async {
    final response = await _client.invoke(
      '/enum/topics', 
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Topic');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (topic) {
        final topics = (topic['data'] as List)
        .map((item) => TopicModel.fromJson(item),)
        .toList();

        return Right(topics);
      }
    );
  }
  
  AsyncEither<List<AvailabilityModel>> availability() async {
    final response = await _client.invoke(
      '/enum/availabilities', 
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Topic');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (availability) {
        final avail = (availability['data'] as List)
        .map((item) => AvailabilityModel.fromJson(item),)
        .toList();

        return Right(avail);
      }
    );
  }
  
  AsyncEither<List<MobilityScopeModel>> mobility() async {
    final response = await _client.invoke(
      '/enum/mobility-scopes',
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Topic');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (mobility) {
        final mobile = (mobility['data'] as List)
        .map((item) => MobilityScopeModel.fromJson(item),)
        .toList();

        return Right(mobile);
      }
    );
  }
  
  AsyncEither<List<TravelArrangementModel>> travelArrangement() async {
    final response = await _client.invoke(
      '/enum/travel-arrangements',
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Topic');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (travel) {
        final arangement = (travel['data'] as List)
        .map((item) => TravelArrangementModel.fromJson(item),)
        .toList();

        return Right(arangement);
      }
    );
  }

  AsyncEither<List<HonorariumPreferenceModel>> honor() async {
    final response = await _client.invoke(
      '/enum/honorarium-preferences',
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Topic');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (honorarium) {
        final honor = (honorarium['data'] as List)
        .map((item) => HonorariumPreferenceModel.fromJson(item),)
        .toList();

        return Right(honor);
      }
    );
  }

  AsyncEither<List<CompanyTypeModel>> companyTypes() async {
    final response = await _client.invoke(
      '/enum/company-types', 
      RequestType.get,
    );

    // log('Log result: $response', name: 'Log Auth Service Company Types');

    return response.fold(
      (failure) {
        return Left(failure);
      }, 
      (result) {
        final companyTypes = (result['data'] as List)
            .map((item) => CompanyTypeModel.fromJson(item))
            .toList();

        return Right(companyTypes);
      }
    );
  }

  AsyncEither<List<CountryModel>> countries() async {
    final response = await _client.invoke(
      '/locations/countries', 
      RequestType.get
    );

    return response.fold(
      (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        log('Countries fetch failed: ${failure.message}', name: 'Auth Services Countries');
        
        return Left(failure);
      }, 
      (result) {
        // Response is direct array: [{country: "...", code: "..."}, ...]
        final List<dynamic> countriesData = result is List ? result : (result['data'] ?? []);
        
        final List<CountryModel> countries = countriesData.map((item) {
          if (item is Map<String, dynamic>) {
            return CountryModel.fromJson(item);
          }
          return CountryModel(country: item.toString(), code: '');
        }).toList();
        
        log('Countries loaded: ${countries.length} items', name: 'Auth Services Countries');

        return Right(countries);
      }
    );
  }

  AsyncEither<List<LocationModel>> cities(String countryCode) async {
    final response = await _client.invoke(
      '/locations/country/$countryCode', 
      RequestType.get,
    );

    return response.fold(
    (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        log('Cities fetch failed: ${failure.message}', name: 'Auth Services Cities');
        
        return Left(failure);
      }, 
      (result) {
        // Extract countries list from response
        final cities = (result['data']['locations'] as List)
            .map((item) => LocationModel.fromJson(item))
            .toList();

        log('Cities loaded: ${cities} items', name: 'Auth Services Countries');

        return Right(cities);
      }
    );
  }

  AsyncEither selectRole(int roleId) async {
    final response = await _client.invoke(
      '/auth/select-role', 
      RequestType.post,
      requestBody: {
        'role_id': roleId,
      },
    );

    return response.fold(
      (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        // log('Log result: ${failure.message}', name: 'Auth Services Register Failure');
        
        return Left(failure);
      }, 
      (result) {
        return _client.invoke<dynamic, UserModel>(
          '/auth/profile',
          RequestType.get,
          fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        );
      }
    );
  }
  
  AsyncEither<UserModel> register(
    String email,
    String password,
  ) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/auth/register',
      RequestType.post,
      requestBody: {
        'email': email,
        'password': password,
      },
    );

    // log('Log result: $response', name: 'Auth Services Register');

    return response.fold(
      (failure) {
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        // log('Log result: ${failure.message}', name: 'Auth Services Register Failure');
        
        return Left(failure);
      },
      (tokens) async {
        // log(tokens);
        // await _client.tokenStorage.setToken(
        //   OAuth2Token(
        //     accessToken: tokens['data']['token'],
        //     refreshToken: '',
        //     tokenType: 'Bearer',
        //     expiresIn: 3600,
        //     scope: '',
        //   ),
        // );
        
        // log('Log result: ${tokens['data']['user']}', name: 'Auth Services Register Right');

        final user = UserModel.fromJson(tokens['data']['user']);

        return Right(user);
        // _client.invoke<dynamic, UserModel>(
        //   '/auth/profile',
        //   RequestType.get,
        //   fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        // );
      },
    );
  }

  AsyncEither registerAttendee(
    String firstname,
    String lastname,
    String bio,
    String avatar,
    List<int> topics,
    List<int> locations,
  ) async {
    // final formdata = FormData.fromMap({
    //   'avatar': 'https://res.cloudinary.com/dk0z4ums3/image/upload/v1661753020/attached_image/inilah-cara-merawat-anak-kucing-yang-tepat.jpg',
    //   'first_name': firstname,
    //   'last_name': lastname,
    //   'bio': bio,
    //   'topic_ids': topics,
    //   'city_ids': locations,
    // });

    // log('Log result: ${await MultipartFile.fromFile(avatar)}');
    
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/profile/attendee/complete',
      RequestType.post,
      requestBody: {
        'avatar': 'https://res.cloudinary.com/dk0z4ums3/image/upload/v1661753020/attached_image/inilah-cara-merawat-anak-kucing-yang-tepat.jpg',
        'first_name': firstname,
        'last_name': lastname,
        'bio': bio,
        'topic_ids': topics,
        'city_ids': locations,
      },
    );

    return response.fold(
      (failure) {
        log(failure.toString());
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        return Left(failure);
      },
      (tokens) async {
        log('Result from API: $tokens', name: 'Log from auth service');
        return _client.invoke<dynamic, UserModel>(
          '/auth/profile',
          RequestType.get,
          fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        );
      },
    );
  }

  // Tambahkan method ini di AuthService (auth.service.dart)

  AsyncEither registerEventOrganizer({
    required String companyName,
    required int companyTypeId,
    required String companyDescription,
    required List<int> eventTypeIds,
    required String averageEventSize,
    required String websiteUrl,
    required int cityId,
    required List<String> venueTypes,
    required String repName,
    required String repPosition,
    required String repEmail,
    String? socialMediaUrl,
  }) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/profile/organizer/complete',
      RequestType.post,
      requestBody: {
        'company_name': companyName,
        'company_type_id': companyTypeId,
        'company_description': companyDescription,
        'event_type_ids': eventTypeIds,
        'average_event_size': averageEventSize,
        'website_url': websiteUrl,
        if (socialMediaUrl != null && socialMediaUrl.isNotEmpty) 
          'social_media_url': socialMediaUrl,
        'city_id': cityId,
        'venue_types': venueTypes,
        'rep_name': repName,
        'rep_position': repPosition,
        'rep_email': repEmail,
      },
    );

    return response.fold(
      (failure) {
        log('Register EO failed: ${failure.message}', name: 'Auth Service');
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }
        return Left(failure);
      },
      (result) async {
        log('Register EO success: $result', name: 'Auth Service');
        
        // Fetch updated profile
        return _client.invoke<dynamic, UserModel>(
          '/auth/profile',
          RequestType.get,
          fromJson: (json) => UserModel.fromJson(json['data'] ?? json),
        );
      },
    );
  }

  // AsyncEither<String> uploadProfilePhoto({
  //   required String filePath,
  // }) async {
  //   final formData = FormData.fromMap({
  //     'profile_picture': await MultipartFile.fromFile(filePath),
  //   });

  //   final response = await _client.invoke<void, Map<String, dynamic>>(
  //     '/profile-photo',
  //     RequestType.post,
  //     requestBody: formData,
  //   );

  //   return response.fold(
  //     (failure) => Left(failure),
  //     (data) {
  //       final photoUrl = data['data']['profile_picture_url'] as String;
  //       return Right(photoUrl);
  //     },
  //   );
  // }


}
