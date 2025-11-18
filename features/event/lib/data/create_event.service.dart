import 'dart:developer';

import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/fpdart.dart';
import 'package:deps/packages/injectable.dart';

import '../domain/models/topic.model.dart';

@lazySingleton
class CreateEventService {
  CreateEventService(this._client);

  final INetworkClient _client;

  // Create Budget Planner
  AsyncEither<bool> createBudgetPlan({
    required int venueBudget,
    required int speakerFee,
    required int vendorBudget,
    required int ticketSales,
    required int sponsorshipIncome,
  }) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/events/budget-plan',
      RequestType.post,
      requestBody: {
        'venue_budget': venueBudget,
        'speaker_fee': speakerFee,
        'vendor_budget': vendorBudget,
        'ticket_sales': ticketSales,
        'sponsorship_income': sponsorshipIncome,
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        log(data.toString(), name: 'Create Budget Plan - success');
        final success = data['message'] == 'Budget Plan created successfully';
        return Right(success);
      },
    );
  }

  // Create Event Details
  AsyncEither<bool> createEventDetails({
    required String organizerId,
    required String eventName,
    required String eventType,
    required List<int> eventCategory,
    required String description,
    required String eventFormat,
    required String eventBanner,
  }) async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/events/details',
      RequestType.post,
      requestBody: {
        'organizer_id': '44',
        'budget_plan_id': '1d16745c-07a0-457a-8859-c16ea624d010',
        'event_name': eventName,
        'event_type': eventType,
        'event_category': eventCategory,
        'description': description,
        'event_format': eventFormat,
        'event_banner': eventBanner,
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        log(data.toString(), name: 'Create Event Details - success');
        final success = data['success'] as bool? ?? false;
        return Right(success);
      },
    );
  }

  /// Get all job search event categories from api topic
  AsyncEither<List<Topic>> getEventCategories() async {
    final response = await _client.invoke<void, Map<String, dynamic>>(
      '/enum/topics',
      RequestType.get,
    );

    return response.fold(
      Left.new,
      (data) {
        try {
          final items = (data['data'] as List)
              .map((item) => Topic.fromJson(item))
              .toList();
          return Right(items);
        } catch (e) {
          return Left(
            UnexpectedFailure(exception: e),
          );
        }
      },
    );
  }
}
