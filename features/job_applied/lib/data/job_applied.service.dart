// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/job_applied.model.dart';

@lazySingleton
class JobAppliedService {
  JobAppliedService(this._client);

  final INetworkClient _client;

  AsyncEither<List<JobAppliedModel>> getJobAppliedItems({
    required int offset,
    required int limit,
  }) async {
    return _client.invoke<JobAppliedModel, List<JobAppliedModel>>(
      '/products?limit=$limit&offset=$offset',
      RequestType.get,
      fromJson: JobAppliedModel.fromJson,
    );
  }
}
