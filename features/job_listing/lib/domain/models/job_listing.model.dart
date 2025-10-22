import 'package:deps/packages/freezed_annotation.dart';

import 'category.model.dart';

part 'job_listing.model.freezed.dart';
part 'job_listing.model.g.dart';

@freezed
sealed class JobListingModel with _$JobListingModel {
  factory JobListingModel({
    required int id,
    required String title,
    required int price,
    required String description,
    required List<String> images,
    required String creationAt,
    required String updatedAt,
    required CategoryModel category,
    @Default(0) int discountRate,
  }) = _JobListingModel;

  factory JobListingModel.fromJson(Map<String, dynamic> json) =>
      _$JobListingModelFromJson(json);

  factory JobListingModel.empty() => JobListingModel(
        id: 0,
        title: 'Lorem ipsum dolor',
        price: 100,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac ullamcorper ligula. Quisque leo est, pellentesque vel hendrerit sit amet, varius vitae tortor.',
        images: [],
        creationAt: '',
        updatedAt: '',
        category: CategoryModel.empty(),
      );

  JobListingModel._();

  bool get isEmpty => this == JobListingModel.empty();
  double get discountPrice => price * (1 - discountRate / 100.0);
}
