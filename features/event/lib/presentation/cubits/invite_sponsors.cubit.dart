import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/sponsor.model.dart';

part 'invite_sponsors.cubit.freezed.dart';
part 'states/invite_sponsors.state.dart';

@lazySingleton
class InviteSponsorsCubit extends Cubit<InviteSponsorsState> {
  InviteSponsorsCubit() : super(InviteSponsorsState.initial());

  // Dummy data sponsors
  final List<Sponsor> _allSponsors = [
    Sponsor(
      id: '1',
      name: 'Tokopakedi',
      industry: 'E-Commerce',
      location: 'Jakarta, Indonesia',
      type: 'Monetary',
      description:
          'We support events that empower small creators and digital entrepreneurs. Our sponsorship includes co-branding, booth activations, and Tokopakedi vouchers for attendees.',
      logo: null,
    ),
    Sponsor(
      id: '2',
      name: 'Bank Center Afrika',
      industry: 'Banking & Finance',
      location: 'Surabaya, Indonesia',
      type: 'Monetary • Media',
      description:
          'We aim to fund and collaborate with events that educate people about finance and entrepreneurship. Our support includes workshops, talks, and media exposure through our platforms.',
      logo: null,
    ),
    Sponsor(
      id: '3',
      name: 'Mustibisha Motors Med...',
      industry: 'Automotive',
      location: 'Medan, Indonesia',
      type: 'Product',
      description:
          'We bring vehicle displays, test-drive zones, and brand activations to lifestyle and tech events that share our vision of innovation and sustainability.',
      logo: null,
    ),
  ];

  List<Sponsor> get allSponsors => _allSponsors;

  void initialize() {
    emit(
      state.copyWith(
        allSponsors: _allSponsors,
        selectedSponsors: [],
      ),
    );
  }

  void toggleSponsorSelection(String sponsorId) {
    final selectedIds = List<String>.from(state.selectedSponsors);

    if (selectedIds.contains(sponsorId)) {
      selectedIds.remove(sponsorId);
    } else {
      selectedIds.add(sponsorId);
    }

    emit(state.copyWith(selectedSponsors: selectedIds));
  }

  Future<void> saveSponsorsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeStringList(
      EventKey.selectedSponsors.name,
      state.selectedSponsors,
    );
  }

  Future<void> loadSponsorsLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final selectedIds = prefs.readStringList(
      EventKey.selectedSponsors.name,
    );

    if (selectedIds != null) {
      emit(
        state.copyWith(
          selectedSponsors: selectedIds,
        ),
      );
    }
  }
}
