// ignore_for_file: max_lines_for_function, max_lines_for_file
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/locator/locator.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../cubits/job_listing_list.cubit.dart';
import 'widgets/job_listing_card.dart';

@RoutePage()
class JobListingPage extends StatefulWidget {
  JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 1, vsync: this);
  final List<Tab> _tabs = [
    const Tab(text: 'For you'),
    const Tab(text: 'Mining'),
    const Tab(text: 'Location'),
    const Tab(text: 'Experience'),
  ];
  final _cubit = locator<JobListingListCubit>();
  
  // Selection state management
  final Set<String> _selectedCardIds = <String>{};
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Selection helper methods
  void _onCardLongPress(JobListingModel product) {
    setState(() {
      _isSelectionMode = true;
      _selectedCardIds.add(product.id.toString());
    });
  }

  void _onCardTap(JobListingModel product) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedCardIds.contains(product.id.toString())) {
          _selectedCardIds.remove(product.id.toString());
          if (_selectedCardIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedCardIds.add(product.id.toString());
        }
      });
    } else {
      // Normal navigation
      $.navigator.push(
        JobListingDetailsRoute(
          product: product,
          onSelectedItemChanged: (index) {},
        ),
      );
    }
  }

  bool _isCardSelected(JobListingModel product) {
    return _selectedCardIds.contains(product.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FabScaffold(
      tabController: _tabController,
      appBarSettings: FabAppBarSettings(
        height: 64,
        title: Container(
          height: 59, // Explicit height for the title container
          padding: EdgeInsets.symmetric(
            horizontal: $.paddings.sm,
            vertical: $.paddings.xs, // Added vertical padding
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child: FabImage(
                    width: 40,
                    height: 40,
                    uri: $.get<UserCubit>().state.avatar ?? '',
                    onPressed: $.get<UserCubit>().logout,
                  ),
                ),
              ),

              PaddingGap.sm(),

              // Greeting text with proper typography
              Expanded(
                child: Text(
                  'Hi Anto Wiranto ✋',
                  style: FabTypography.displaySemiBold18.copyWith(
                    color: FabColors.greyscale900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        searchBar: FabAppBarSearchBarSettings(
            enabled: true,
            height: 48,
            placeholderText: 'Search...',
            padding: EdgeInsets.symmetric(horizontal: $.paddings.md),
            toolbar: FabAppBarToolbarSettings(),
            searchResult: Container(
              color: Colors.white,
            )),
        toolbar: FabAppBarToolbarSettings(
          enabled: true,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FabTabBar(
                tabs: _tabs,
                controller: _tabController,
                mainAxisAlignment: MainAxisAlignment.start,
                indicatorColor: FabColors.greyscale0,
                labelStyle: FabTypography.bodySmallSemiBold.copyWith(
                  color: FabColors.greyscale900,
                ),
                unselectedLabelStyle: FabTypography.bodySmallRegular.copyWith(
                  color: FabColors.greyscale400,
                ),
                padding: EdgeInsets.symmetric(horizontal: $.paddings.xs),
              ),
              IconButton(
                onPressed: () {},
                icon: Assets.images.icons.system.filterLine.svg(
                  width: 20,
                  height: 20,
                  color: FabColors.greyscale400,
                  package: 'design',
                ),
                padding: EdgeInsets.all($.paddings.xs),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
      onRefreshes: [
        _cubit.refresh,
      ],
      children: [
        SliverPadding(
          padding: EdgeInsets.all($.paddings.md),
          sliver: PaginatedGridList<JobListingModel, JobListingListCubit>(
            index: 0,
            bloc: _cubit,
            crossAxisCount: 1,
            localFilter: (product) =>
                product.images.isEmpty || product.images.first.startsWith('['),
            itemHeight: $.context.height * 0.22,
            skeletonBuilder: (_) {
              return JobListingCard(product: JobListingModel.empty());
            },
            itemBuilder: (_, product, __) {
              return JobListingCard(
                product: product,
                isSelected: _isCardSelected(product),
                onTap: () => _onCardTap(product),
                onLongPress: () => _onCardLongPress(product),
              );
            },
          ),
        )
      ],
    );
  }
}
