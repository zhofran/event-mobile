import 'package:deps/packages/freezed_annotation.dart';

import 'category.model.dart';

part 'discover.model.freezed.dart';
part 'discover.model.g.dart';

@freezed
sealed class DiscoverModel with _$DiscoverModel {
  factory DiscoverModel({
    required int id,
    required String title,
    required int price,
    required String description,
    required List<String> images,
    required String creationAt,
    required String updatedAt,
    required CategoryModel category,
    @Default(0) int discountRate,
  }) = _DiscoverModel;

  factory DiscoverModel.fromJson(Map<String, dynamic> json) => _$DiscoverModelFromJson(json);

  factory DiscoverModel.empty() => DiscoverModel(
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

  DiscoverModel._();

  bool get isEmpty => this == DiscoverModel.empty();
  double get discountPrice => price * (1 - discountRate / 100.0);
}
