import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/speaker.model.dart';

part 'event_page5.cubit.freezed.dart';
part 'states/event_page5.state.dart';

@lazySingleton
class EventPage5Cubit extends Cubit<EventPage5State> {
  EventPage5Cubit() : super(EventPage5State.initial());

  // Dummy data speakers
  final List<Speaker> _allSpeakers = [
    Speaker(
      id: '1',
      speakerUserId: 'user-1',
      speakerName: 'Dr. Rina Putri, M.Ed',
      email: 'rina.putri@example.com',
      phone: '+62812345671',
      organization: 'EdTech Institute',
      bio: 'Education Technology Specialist with 10+ years experience',
      photo: 'https://via.placeholder.com/150',
      speakerFee: 5000000,
      status: 'active',
      name: 'Dr. Rina Putri, M.Ed',
      title: 'Education Technology Specialist',
      location: 'Jakarta, Indonesia',
      specialize: 'AI • Education • Creative Thinking',
      totalEvent: 30,
      fee: 5000000,
    ),
    Speaker(
      id: '2',
      speakerUserId: 'user-2',
      speakerName: 'Dr. Bramasto Putra, Ph.D',
      email: 'bramasto.putra@example.com',
      phone: '+62812345672',
      organization: 'Innovation Consulting Group',
      bio: 'Educational Innovation Consultant and Researcher',
      photo: 'https://via.placeholder.com/150',
      speakerFee: 15000000,
      status: 'active',
      name: 'Dr. Bramasto Putra, Ph.D',
      title: 'Educational Innovation Consultant',
      location: 'Surabaya, Indonesia',
      specialize: 'EdTech • Gamification • Curriculum Design',
      totalEvent: 45,
      fee: 15000000,
    ),
    Speaker(
      id: '3',
      speakerUserId: 'user-3',
      speakerName: 'Naomi Pardede, B.A.',
      email: 'naomi.pardede@example.com',
      phone: '+62812345673',
      organization: 'Youth Research Institute',
      bio: 'Student Researcher focusing on Gen Z behavior',
      photo: 'https://via.placeholder.com/150',
      speakerFee: 3000000,
      status: 'active',
      name: 'Naomi Pardede, B.A.',
      title: 'Student Researcher',
      location: 'Medan, Indonesia',
      specialize: 'Gen Z • Social Media • Youth Empowerment',
      totalEvent: 0,
      fee: 3000000,
    ),
  ];

  List<Speaker> get allSpeakers => _allSpeakers;

  void initialize() {
    emit(
      state.copyWith(
        allSpeakers: _allSpeakers,
        selectedSpeakers: [],
        invitedSpeakers: [],
      ),
    );
  }

  void toggleSpeakerSelection(String speakerId) {
    final selectedIds = List<String>.from(state.selectedSpeakers);

    if (selectedIds.contains(speakerId)) {
      selectedIds.remove(speakerId);
    } else {
      selectedIds.add(speakerId);
    }

    emit(state.copyWith(selectedSpeakers: selectedIds));
  }

  void addInvitedSpeaker(Speaker speaker) {
    final updatedAllSpeakers = List<Speaker>.from(state.allSpeakers)
      ..add(speaker);
    final updatedInvitedSpeakers = List<Speaker>.from(state.invitedSpeakers)
      ..add(speaker);
    
    // Auto-select the invited speaker
    final updatedSelectedSpeakers = List<String>.from(state.selectedSpeakers)
      ..add(speaker.id);

    emit(
      state.copyWith(
        allSpeakers: updatedAllSpeakers,
        invitedSpeakers: updatedInvitedSpeakers,
        selectedSpeakers: updatedSelectedSpeakers,
      ),
    );
  }

  double calculateTotalFee() {
    double total = 0;

    for (String speakerId in state.selectedSpeakers) {
      final speaker = state.allSpeakers.firstWhere(
        (s) => s.id == speakerId,
        orElse: () => Speaker.empty(),
      );

      if (speaker.id.isNotEmpty) {
        total += speaker.fee;
      }
    }

    return total;
  }

  bool isOverBudget(double maxBudget) {
    return calculateTotalFee() > maxBudget;
  }

  Future<void> saveSpeakersLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    // Save selected speaker IDs
    await prefs.writeStringList(
      EventKey.selectedSpeakers.name,
      state.selectedSpeakers,
    );

    // Save invited speakers as objects
    await prefs.writeObjectList<Speaker>(
      EventKey.invitedSpeakers.name,
      state.invitedSpeakers,
    );
  }

  Future<void> loadSpeakersLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    // Load selected speaker IDs
    final selectedIds = prefs.readStringList(
      EventKey.selectedSpeakers.name,
    );

    // Load invited speakers
    final invitedSpeakers = prefs.readObjectList<Speaker>(
      EventKey.invitedSpeakers.name,
      Speaker.fromJson,
    );

    if (selectedIds != null || invitedSpeakers != null) {
      // Merge invited speakers with all speakers
      final updatedAllSpeakers = List<Speaker>.from(_allSpeakers);
      final updatedSelectedIds = List<String>.from(selectedIds ?? []);
      
      if (invitedSpeakers != null) {
        for (final invited in invitedSpeakers) {
          if (!updatedAllSpeakers.any((s) => s.id == invited.id)) {
            updatedAllSpeakers.add(invited);
          }
          // Auto-select invited speakers if not already selected
          if (!updatedSelectedIds.contains(invited.id)) {
            updatedSelectedIds.add(invited.id);
          }
        }
      }

      emit(
        state.copyWith(
          allSpeakers: updatedAllSpeakers,
          selectedSpeakers: updatedSelectedIds,
          invitedSpeakers: invitedSpeakers ?? [],
        ),
      );
    }
  }
}
