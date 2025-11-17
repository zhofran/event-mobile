import 'dart:convert';
import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/create_event.service.dart';

part 'event_page1.cubit.freezed.dart';
part 'states/event_page1.state.dart';

@lazySingleton
class EventPage1Cubit extends Cubit<EventPage1State> {
  EventPage1Cubit() : super(EventPage1State.initial());

  final createEventService = $.get<CreateEventService>();

  void toggleValidityForm({required bool? value}) {
    emit(state.copyWith(isFormValid: value));
  }

  Future<void> getEventCategories({bool refresh = false}) async {
    if (state.eventCategoryOptions.isNotEmpty && !refresh) {
      return;
    }

    emit(state.copyWith(status: EventPage1StateStatus.loading));

    final result = await createEventService.getEventCategories();

    result.fold(
      (failure) {
        log(failure.toString(), name: '_getEventCategories - err');
        emit(
          state.copyWith(status: EventPage1StateStatus.failed),
        );
      },
      (response) {
        log(jsonEncode(response), name: '_getEventCategories - success');

        final options = response
            .map((e) => SelectOption(label: e.name, value: e.name))
            .toList();

        emit(
          state.copyWith(
            eventCategoryOptions: options,
            status: EventPage1StateStatus.succeeded,
          ),
        );
      },
    );
  }

  void createEvent({
    required String eventName,
    required String eventType,
    required List<String> eventCategory,
    required String eventDescription,
    required String eventFormat,
    required String eventBanner,
  }) {
    emit(
      state.copyWith(
        eventName: eventName,
        eventType: eventType,
        eventCategory: eventCategory,
        eventDescription: eventDescription,
        eventFormat: eventFormat,
        eventBanner: eventBanner,
      ),
    );
  }
}
