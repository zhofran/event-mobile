// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/discover.model.dart';

@lazySingleton
class DiscoverService {
  DiscoverService(this._client);

  final INetworkClient _client;

  AsyncEither<List<DiscoverModel>> getDiscoverItems({
    required int offset,
    required int limit,
  }) async {
    return _client.invoke<DiscoverModel, List<DiscoverModel>>(
      '/products?limit=$limit&offset=$offset',
      RequestType.get,
      fromJson: DiscoverModel.fromJson,
    );
  }
}
