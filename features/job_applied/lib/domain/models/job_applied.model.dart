import 'package:deps/packages/freezed_annotation.dart';

import 'category.model.dart';

part 'job_applied.model.freezed.dart';
part 'job_applied.model.g.dart';

@freezed
sealed class JobAppliedModel with _$JobAppliedModel {
  factory JobAppliedModel({
    required int id,
    required String title,
    required int price,
    required String description,
    required List<String> images,
    required String creationAt,
    required String updatedAt,
    required CategoryModel category,
    @Default(0) int discountRate,
  }) = _JobAppliedModel;

  factory JobAppliedModel.fromJson(Map<String, dynamic> json) =>
      _$JobAppliedModelFromJson(json);

  factory JobAppliedModel.empty() => JobAppliedModel(
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

  JobAppliedModel._();

  bool get isEmpty => this == JobAppliedModel.empty();
  double get discountPrice => price * (1 - discountRate / 100.0);
}
