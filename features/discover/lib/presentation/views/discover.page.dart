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

import '../cubits/discover_list.cubit.dart';
import 'widgets/discover_appbar_actions.dart';
import 'widgets/discover_listing_card.dart';

@RoutePage()
class DiscoverPage extends StatefulWidget {
  DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 1, vsync: this);
  final _cubit = locator<DiscoverListCubit>();

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
        height: 64, // Increased height for better spacing
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
                    uri: $.get<UserCubit>().state.avatar,
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

              // Action buttons
              const DiscoverAppBarActions(),
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
      ),
      onRefreshes: [_cubit.refresh],
      children: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 8),
          sliver: PaginatedGridList<DiscoverModel, DiscoverListCubit>(
            index: 0,
            bloc: _cubit,
            crossAxisCount: 1,
            localFilter: (product) =>
                product.images.isEmpty || product.images.first.startsWith('['),
            itemHeight: $.context.height * 0.5,
            skeletonBuilder: (_) {
              return DiscoverListingCard(product: DiscoverModel.empty());
            },
            itemBuilder: (_, product, __) {
              return DiscoverListingCard(product: product);
            },
          ),
        )
      ],
    );
  }
}
