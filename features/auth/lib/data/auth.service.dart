// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/dio.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/failures/auth.failures.dart';
import '../domain/models/company_type.model.dart';
import '../domain/models/topic.model.dart';

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

  AsyncEither<UserModel> registerVendor({
    required String companyName,
    required String companyTypeId,
    required String companyDescription,
    required List<int> eventTypeIds,
    required String averageEventSize,
    required String websiteUrl,
    required String socialMediaUrl,
    required String cityId,
    required List<String> venueTypes,
    required String repName,
    required String repPosition,
    required String repEmail,
  }) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/profile/vendor/complete',
      RequestType.post,
      requestBody: {
        'company_name': companyName,
        'company_type_id': companyTypeId,
        'company_description': companyDescription,
        'event_type_ids': eventTypeIds,
        'average_event_size': averageEventSize,
        'website_url': websiteUrl,
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
        log('Register vendor failure: ${failure.toString()}', name: 'Auth Service');
        if (failure is UnauthorizedNetworkFailure) {
          return Left(WrongCredentialsAuthFailure());
        }

        return Left(failure);
      },
      (result) async {
        log('Register vendor success: $result', name: 'Auth Service');
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
