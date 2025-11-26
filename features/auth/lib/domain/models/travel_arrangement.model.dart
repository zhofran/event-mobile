// travel_arrangement.model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'travel_arrangement.model.freezed.dart';
part 'travel_arrangement.model.g.dart';

// Helper DateTime (bisa kamu pindahkan ke file utils jika ingin dipakai global)
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) return DateTime(1970);
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
class TravelArrangementModel with _$TravelArrangementModel {
  const factory TravelArrangementModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _TravelArrangementModel;

  factory TravelArrangementModel.fromJson(Map<String, dynamic> json) =>
      _$TravelArrangementModelFromJson(json);

  // Empty state (sama seperti model-model sebelumnya)
  factory TravelArrangementModel.empty() => TravelArrangementModel(
        id: 0,
        name: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const TravelArrangementModel._();

  bool get isEmpty => id == 0 && name.isEmpty;
}