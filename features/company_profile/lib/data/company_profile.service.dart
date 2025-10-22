// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/company_profile.model.dart';

@lazySingleton
class CompanyProfileService {
  CompanyProfileService(this._client);

  final INetworkClient _client;

  AsyncEither<CompanyProfileModel> getCompanyProfile({
    required int companyId,
  }) async {
    return _client.invoke<CompanyProfileModel, CompanyProfileModel>(
      '/companies/$companyId',
      RequestType.get,
      fromJson: CompanyProfileModel.fromJson,
    );
  }

  AsyncEither<List<CompanyProfileModel>> getCompanies({
    required int offset,
    required int limit,
  }) async {
    return _client.invoke<CompanyProfileModel, List<CompanyProfileModel>>(
      '/companies?limit=$limit&offset=$offset',
      RequestType.get,
      fromJson: CompanyProfileModel.fromJson,
    );
  }
}
