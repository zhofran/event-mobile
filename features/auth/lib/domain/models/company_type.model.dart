// company_type_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_type.model.freezed.dart';
part 'company_type.model.g.dart';

@freezed
class CompanyTypeModel with _$CompanyTypeModel {
  const factory CompanyTypeModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _CompanyTypeModel;

  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyTypeModelFromJson(json);
}