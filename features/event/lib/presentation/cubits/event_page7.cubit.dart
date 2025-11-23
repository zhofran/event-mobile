import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/sponsorship.model.dart';

part 'event_page7.cubit.freezed.dart';
part 'states/event_page7.state.dart';

@lazySingleton
class EventPage7Cubit extends Cubit<EventPage7State> {
  EventPage7Cubit() : super(EventPage7State.initial());

  /// Initialize cubit with sponsorship goal
  void initialize({required double sponsorshipGoal}) {
    emit(
      state.copyWith(
        sponsorshipGoal: sponsorshipGoal,
      ),
    );
  }

  /// Add a new sponsorship
  void addSponsorship({
    required String title,
    required String type,
    required String requestedProduct,
    required String productAmount,
    required String description,
  }) {
    final newSponsorship = Sponsorship(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      type: type,
      requestedProduct: requestedProduct,
      productAmount: productAmount,
      description: description,
    );

    final updatedSponsorships = List<Sponsorship>.from(state.sponsorships)
      ..add(newSponsorship);

    emit(
      state.copyWith(
        sponsorships: updatedSponsorships,
        status: EventPage7StateStatus.succeeded,
      ),
    );
  }

  /// Update an existing sponsorship
  void updateSponsorship({
    required String id,
    required String title,
    required String type,
    required String requestedProduct,
    required String productAmount,
    required String description,
  }) {
    final updatedSponsorship = Sponsorship(
      id: id,
      title: title,
      type: type,
      requestedProduct: requestedProduct,
      productAmount: productAmount,
      description: description,
    );

    final updatedSponsorships = state.sponsorships.map((s) {
      return s.id == id ? updatedSponsorship : s;
    }).toList();

    emit(
      state.copyWith(
        sponsorships: updatedSponsorships,
        status: EventPage7StateStatus.succeeded,
      ),
    );
  }

  /// Remove a sponsorship
  void removeSponsorship(String id) {
    final updatedSponsorships =
        state.sponsorships.where((s) => s.id != id).toList();

    emit(
      state.copyWith(
        sponsorships: updatedSponsorships,
        status: EventPage7StateStatus.succeeded,
      ),
    );
  }

  /// Save sponsorships to local storage
  Future<void> saveSponsorshipsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeObjectList<Sponsorship>(
      EventKey.sponsorships.name,
      state.sponsorships,
    );
  }

  /// Load sponsorships from local storage
  Future<List<Sponsorship>?> loadSponsorshipsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final sponsorships = prefs.readObjectList<Sponsorship>(
      EventKey.sponsorships.name,
      Sponsorship.fromJson,
    );

    if (sponsorships != null) {
      emit(
        state.copyWith(
          sponsorships: sponsorships,
        ),
      );
    }

    return sponsorships;
  }

  /// Clear all sponsorships
  void clearAllSponsorships() {
    emit(
      state.copyWith(
        sponsorships: [],
        status: EventPage7StateStatus.initial,
      ),
    );
  }

  /// Reset state
  void reset() {
    emit(EventPage7State.initial());
  }
}
