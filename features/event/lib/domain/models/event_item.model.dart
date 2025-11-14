import 'package:deps/features/features.dart';
import 'package:deps/packages/freezed_annotation.dart';

part 'event_item.model.freezed.dart';

@freezed
sealed class EventItemModel with _$EventItemModel {
  factory EventItemModel({
    required int id,
    required DiscoverModel product,
    required int quantity,
  }) = _EventItemModel;

  factory EventItemModel.empty() => EventItemModel(
        id: 0,
        product: DiscoverModel.empty(),
        quantity: 0,
      );

/*   CartItemModel._();

  bool get isEmpty => this == CartItemModel.empty(); */
}
