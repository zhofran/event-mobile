import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/topic.model.dart';

@lazySingleton
class CreateEventService {
  CreateEventService(this._client);

  final INetworkClient _client;

  /// Get all job search event categories from api topic
  AsyncEither<List<Topic>> getEventCategories() async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/enum/topics',
      RequestType.get,
    );

    return response.fold(
      Left.new,
      (data) {
        try {
          final items = (data['data'] as List)
              .map((item) => Topic.fromJson(item))
              .toList();
          return Right(items);
        } catch (e) {
          return Left(
            UnexpectedFailure(exception: e),
          );
        }
      },
    );
  }
}
