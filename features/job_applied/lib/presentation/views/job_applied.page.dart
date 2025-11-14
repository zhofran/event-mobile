// ignore_for_file: max_lines_for_function, max_lines_for_file
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/locator/locator.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/models/job_applied.model.dart';
import '../cubits/job_applied_list.cubit.dart';
import 'widgets/job_applied_card.dart';

@RoutePage()
class JobAppliedPage extends StatefulWidget {
  JobAppliedPage({super.key});

  @override
  State<JobAppliedPage> createState() => _JobAppliedPageState();
}

class _JobAppliedPageState extends State<JobAppliedPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  final List<Tab> _tabs = [
    const Tab(text: 'Application'),
    const Tab(text: 'Saved'),
  ];
  final _cubit = locator<JobAppliedListCubit>();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          child: FabTabBar(
            tabs: _tabs,
            controller: _tabController,
          ),
        ),
      ),
      onRefreshes: [_cubit.refresh, null],
      children: [
        SliverPadding(
          padding: EdgeInsets.all($.paddings.md),
          sliver: PaginatedGridList<JobAppliedModel, JobAppliedListCubit>(
            index: 0,
            bloc: _cubit,
            crossAxisCount: 1,
            localFilter: (product) =>
                product.images.isEmpty || product.images.first.startsWith('['),
            itemHeight: $.context.height * 0.23,
            skeletonBuilder: (_) {
              return JobAppliedCard(product: JobAppliedModel.empty());
            },
            itemBuilder: (_, product, __) {
              return JobAppliedCard(product: product);
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all($.paddings.md),
          sliver: PaginatedGridList<JobAppliedModel, JobAppliedListCubit>(
            index: 0,
            bloc: _cubit,
            crossAxisCount: 1,
            localFilter: (product) =>
                product.images.isEmpty || product.images.first.startsWith('['),
            itemHeight: $.context.height * 0.25,
            skeletonBuilder: (_) {
              return JobAppliedCard(product: JobAppliedModel.empty());
            },
            itemBuilder: (_, product, __) {
              return JobAppliedCard(product: product);
            },
          ),
        ),
      ],
    );
  }
}
