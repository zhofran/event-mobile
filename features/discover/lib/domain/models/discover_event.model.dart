import 'package:deps/packages/freezed_annotation.dart';


part 'discover_event.model.freezed.dart';
part 'discover_event.model.g.dart';

@freezed
sealed class DiscoverEventModel with _$DiscoverEventModel {
  factory DiscoverEventModel({
    required int id,
    required String title,
    required String imageUrl,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required int priceStart,
    String? badge,
    required String category,
  }) = _DiscoverEventModel;

  factory DiscoverEventModel.fromJson(Map<String, dynamic> json) => _$DiscoverEventModelFromJson(json);

  factory DiscoverEventModel.empty() => DiscoverEventModel(
        id: 0,
        title: 'Lorem ipsum dolor',
        imageUrl: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ac ullamcorper ligula. Quisque leo est, pellentesque vel hendrerit sit amet, varius vitae tortor.',
        location: 'Jakrta Convention Center',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        priceStart: 100,
        badge: '',
        category: 'Conference',
      );

  const DiscoverEventModel._();

  bool get isEmpty => this == DiscoverEventModel.empty();

  String getFormattedDate() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final startMonth = months[startDate.month - 1];
    final endMonth = months[endDate.month - 1];
    final timezone = startDate.hour < 12 ? 'WIB' : 'SGT';
    
    return '${startDate.day} $startMonth ${startDate.year.toString().substring(2)} - ${endDate.day} $endMonth ${endDate.year.toString().substring(2)} • ${startDate.hour.toString().padLeft(2, '0')}.${startDate.minute.toString().padLeft(2, '0')} $timezone';
  }

  String getFormattedPrice() {
    return priceStart.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
