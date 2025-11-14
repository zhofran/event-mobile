// ignore_for_file: must_be_immutable

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/topic.model.dart';
import '../../../cubits/register.cubit.dart';

@RoutePage()
class AttendeeTopicPage extends StatefulWidget {
  AttendeeTopicPage({required this.dataAttendee, super.key});

  Map<String, dynamic> dataAttendee;

  @override
  State<AttendeeTopicPage> createState() => _AttendeeTopicPageState();
}

class _AttendeeTopicPageState extends State<AttendeeTopicPage> {
  final registerCubit = $.get<RegisterCubit>();

  // Ubah ke Set<int> untuk menyimpan topic IDs
  Set<int> _selectedTopicIds = {};

  @override
  void initState() {
    super.initState();
    registerCubit.getAllTopic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          bloc: registerCubit,
          listener: (context, state) {
            // Handle error
            state.whenOrNull(
              failed: (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: state.whenOrNull(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    topicLoaded: _buildContent,
                    failed: _buildErrorState,
                  ) ?? const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                _buildContinueButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<TopicModel> topics) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        PaddingGap.md(),
        _buildWelcomeSection(),
        PaddingGap.md(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildTopicChips(topics),
        ),
      ],
    );
  }

  Widget _buildErrorState(IFailure failure) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          PaddingGap.md(),
          const Text(
            'Failed to load topics',
            style: FabTypography.displaySemiBold18,
          ),
          PaddingGap.sm(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              failure.message,
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          PaddingGap.md(),
          FabButton.primary(
            onPressed: registerCubit.getAllTopic,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          FabButton.secondary(
            onPressed: () {
              $.navigator.pop();
            },
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
          const Expanded(
            child: FabTextStyled(
              'Register Attendee',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          FabButton.secondary(
            onPressed: () => {},
            isIconOnly: true,
            iconWidget: Assets.images.icons.questionLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'What topics are you interested in?',
            style: FabTypography.displaySemiBold22,
          ),
          PaddingGap.sm(),
          FabTextStyled(
            "Select at least 3 areas that excite you. We'll use them to recommend relevant events and connections.",
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChips(List<TopicModel> topics) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: topics.map((topic) {
        final isSelected = _selectedTopicIds.contains(topic.id);
        
        return ChoiceChip(
          label: Text(topic.name),
          selected: isSelected,
          showCheckmark: false,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTopicIds.add(topic.id);
              } else {
                _selectedTopicIds.remove(topic.id);
              }
            });
          },
          selectedColor: FabColors.primary25,
          backgroundColor: FabColors.background,
          labelStyle: FabTypography.displaySemiBold14.copyWith(
            color: FabColors.textPrimary,
          ),
          side: BorderSide(
            color: isSelected ? FabColors.primary : FabColors.greyscale300,
            width: 1.5,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator berapa yang sudah dipilih
          if (_selectedTopicIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FabTextStyled(
                '${_selectedTopicIds.length} topic${_selectedTopicIds.length > 1 ? 's' : ''} selected',
                style: FabTypography.displayRegular14.copyWith(
                  color: _selectedTopicIds.length >= 3
                      ? FabColors.primary
                      : FabColors.greyscale400,
                ),
              ),
            ),
          
          FabButton.primary(
            onPressed: _selectedTopicIds.length < 3
                ? null
                : () {
                    // Simpan selected topic IDs ke dataAttendee
                    widget.dataAttendee['topic_ids'] = _selectedTopicIds.toList();
                    
                    // Navigate ke halaman berikutnya
                    $.navigator.push(AttendeeLocationRoute(dataAttendee: widget.dataAttendee));
                  },
            size: FabButtonSize.large,
            width: double.infinity,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Jangan close cubit jika shared/singleton
    // registerCubit.close();
    super.dispose();
  }
}