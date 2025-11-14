// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.model.freezed.dart';
part 'user.model.g.dart';

// Custom converter for DateTime from ISO string
DateTime _dateFromJson(String timestamp) => DateTime.parse(timestamp);
String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    String? name,
    required String email,
    String? avatar,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson) 
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson) 
    required DateTime updatedAt,
    List<RoleModel>? roles,
    @JsonKey(name: 'email_verified') required bool emailVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.empty() => UserModel(
        id: 0,
        email: '',
        roles: [],
        emailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  const UserModel._();

  bool get isEmpty => id == 0 && email.isEmpty;
}

@freezed
sealed class RoleModel with _$RoleModel {
  const factory RoleModel({
    required int id,
    required String name,
    required String description,
    required List<PermissionModel> permissions,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}

@freezed
sealed class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    required int id,
    required String name,
    required String description,
    required String resource,
    required String action,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}