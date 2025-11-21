import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/vendor_rfq.model.dart';

part 'event_page6.cubit.freezed.dart';
part 'states/event_page6.state.dart';

@lazySingleton
class EventPage6Cubit extends Cubit<EventPage6State> {
  EventPage6Cubit() : super(EventPage6State.initial());

  /// Initialize cubit with maximum budget
  void initialize({required double maximumBudget}) {
    emit(
      state.copyWith(
        maximumBudget: maximumBudget,
      ),
    );
  }

  /// Add a new vendor
  void addVendor({
    required String categories,
    required String vendor,
    required double budget,
    required String description,
  }) {
    final newVendor = VendorRFQ(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categories: categories,
      vendor: vendor,
      budget: budget,
      description: description,
    );

    final updatedVendors = List<VendorRFQ>.from(state.vendors)..add(newVendor);

    emit(
      state.copyWith(
        vendors: updatedVendors,
        status: EventPage6StateStatus.succeeded,
      ),
    );
  }

  /// Update an existing vendor
  void updateVendor({
    required String id,
    required String categories,
    required String vendor,
    required double budget,
    required String description,
  }) {
    final updatedVendor = VendorRFQ(
      id: id,
      categories: categories,
      vendor: vendor,
      budget: budget,
      description: description,
    );

    final updatedVendors = state.vendors.map((v) {
      return v.id == id ? updatedVendor : v;
    }).toList();

    emit(
      state.copyWith(
        vendors: updatedVendors,
        status: EventPage6StateStatus.succeeded,
      ),
    );
  }

  /// Remove a vendor
  void removeVendor(String id) {
    final updatedVendors = state.vendors.where((v) => v.id != id).toList();

    emit(
      state.copyWith(
        vendors: updatedVendors,
        status: EventPage6StateStatus.succeeded,
      ),
    );
  }

  /// Save vendors to local storage
  Future<void> saveVendorsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeObjectList<VendorRFQ>(
      EventKey.vendors.name,
      state.vendors,
    );
  }

  /// Load vendors from local storage
  Future<List<VendorRFQ>?> loadVendorsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final vendors = prefs.readObjectList<VendorRFQ>(
      EventKey.vendors.name,
      VendorRFQ.fromJson,
    );

    if (vendors != null) {
      emit(
        state.copyWith(
          vendors: vendors,
        ),
      );
    }

    return vendors;
  }

  /// Clear all vendors
  void clearAllVendors() {
    emit(
      state.copyWith(
        vendors: [],
        status: EventPage6StateStatus.initial,
      ),
    );
  }

  /// Reset state
  void reset() {
    emit(EventPage6State.initial());
  }
}
