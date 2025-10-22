import 'dart:math';

import 'package:deps/features/features.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/discover.service.dart';
import '../../domain/models/category.model.dart';

@injectable
class DiscoverListCubit extends Cubit<PaginatedListState<DiscoverModel>> implements PaginatedListCubit<DiscoverModel> {
  DiscoverListCubit(this._service) : super(const PaginatedListState.initial());

  final DiscoverService _service;

  @override
  Future<void> fetch({
    int offset = 0,
    int limit = 20,
  }) async {
    emit(const PaginatedListState.loading());

    final response = await _service.getDiscoverItems(offset: offset, limit: limit);

    response.fold(
      (failure) => emit(PaginatedListState.failed(failure)),
      (_) {
        final newProducts = <DiscoverModel>[];

        for (var i = 0; i < 30; i++) {
          newProducts.add(
            DiscoverModel(
              id: i,
              title: '$i Product jaa ya',
              price: i + 10 * 10,
              discountRate: Random().nextInt(31) + 20,
              description: '$i Product Description',
              images: ['https://picsum.photos/500/500'],
              creationAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
              category: CategoryModel(
                id: i,
                name: '$i Category',
                image: '',
                creationAt: DateTime.now().toString(),
                updatedAt: DateTime.now().toString(),
              ),
            ),
          );
        }

        emit(PaginatedListState.loaded(newProducts));

        //emit(PaginatedListState.loaded(products));
      },
    );
  }

  void refresh() => emit(const PaginatedListState.refresh());
}
