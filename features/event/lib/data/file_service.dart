import 'dart:developer';

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/dio.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

@lazySingleton
class FileService {
  FileService(this._client);

  final INetworkClient _client;

  // Upload File
  AsyncEither<String> uploadFile(String photoPath) async {
    // Create FormData for file upload
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(photoPath),
    });

    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/files/upload',
      RequestType.post,
      requestBody: formData,
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        log(data.toString(), name: 'Upload File - success');
        final urlFile = data['data']['file_path'] as String? ?? '';
        return Right(urlFile);
      },
    );
  }
}
