import 'dart:math';

import 'package:deps/features/features.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/job_listing.service.dart';
import '../../domain/models/category.model.dart';
import '../../domain/models/job_listing.model.dart';

@injectable
class JobListingListCubit extends Cubit<PaginatedListState<JobListingModel>>
    implements PaginatedListCubit<JobListingModel> {
  JobListingListCubit(this._service)
      : super(const PaginatedListState.initial());

  final JobListingService _service;

  @override
  Future<void> fetch({
    int offset = 0,
    int limit = 20,
  }) async {
    emit(const PaginatedListState.loading());

    final response =
        await _service.getJobListingItems(offset: offset, limit: limit);

    response.fold(
      (failure) => emit(PaginatedListState.failed(failure)),
      (_) {
        final newProducts = <JobListingModel>[];

        for (var i = 0; i < 30; i++) {
          newProducts.add(
            JobListingModel(
              id: i,
              title: '$i Job Listing',
              price: i + 10 * 10,
              discountRate: Random().nextInt(31) + 20,
              description: '$i Job Description',
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
