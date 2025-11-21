part of '../invite_sponsors.cubit.dart';

enum InviteSponsorsStateStatus { initial, loading, failed, succeeded }

@freezed
sealed class InviteSponsorsState with _$InviteSponsorsState {
  const factory InviteSponsorsState({
    required InviteSponsorsStateStatus status,
    required Failure failure,
    required List<Sponsor> allSponsors,
    required List<String> selectedSponsors,
  }) = _InviteSponsorsState;

  factory InviteSponsorsState.initial() => InviteSponsorsState(
        status: InviteSponsorsStateStatus.initial,
        failure: Failure.empty(),
        allSponsors: [],
        selectedSponsors: [],
      );
}
