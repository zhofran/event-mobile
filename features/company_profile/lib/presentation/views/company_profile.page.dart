// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/locator/locator.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:deps/packages/flutter_bloc.dart';

import '../cubits/company_profile.cubit.dart';
import '../../domain/models/company_profile.model.dart';

@RoutePage()
class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({
    super.key,
    @pathParam required this.companyId,
  });

  final int companyId;

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  final _cubit = locator<CompanyProfileCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchCompanyProfile(companyId: widget.companyId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyProfileCubit, PaginatedListState<CompanyProfileModel>>(
      bloc: _cubit,
      builder: (context, state) {
        return switch (state) {
          PaginatedListStateInitial() => _buildLoadingScaffold(),
          PaginatedListStateLoading() => _buildLoadingScaffold(),
          PaginatedListStateRefresh() => _buildLoadingScaffold(),
          PaginatedListStateFailed(:final failure) => _buildErrorScaffold(failure.toString()),
          PaginatedListStateLoaded(:final items) => items.isEmpty
              ? _buildErrorScaffold('Company not found')
              : _buildCompanyProfileScaffold(items.first),
          _ => _buildLoadingScaffold(),
        };
      },
    );
  }

  Widget _buildLoadingScaffold() {
    return FabScaffold(
      appBarSettings: FabAppBarSettings(
        title: const Text('Loading...'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      children: [
        const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorScaffold(String message) {
    return FabScaffold(
      appBarSettings: FabAppBarSettings(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      children: [
        SliverFillRemaining(
          child: Center(child: Text(message)),
        ),
      ],
    );
  }

  Widget _buildCompanyProfileScaffold(CompanyProfileModel company) {
    return FabScaffold(
      tabController: _tabController,
      appBarSettings: FabAppBarSettings(
        title: Text(company.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      children: [
        // Company Banner Section
        SliverToBoxAdapter(
          child: _buildCompanyBanner(company),
        ),
        
        // Company Info Card
        SliverToBoxAdapter(
          child: _buildCompanyInfoCard(company),
        ),
        
        // Tab Bar
        SliverToBoxAdapter(
          child: _buildTabBar(),
        ),
        
        // Tab Content
        SliverToBoxAdapter(
          child: _buildTabContent(company),
        ),
      ],
    );
  }

  Widget _buildCompanyBanner(CompanyProfileModel company) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(company.bannerImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Team photos overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: company.teamImages.take(6).map((imageUrl) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Company logo
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  company.logoImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoCard(CompanyProfileModel company) {
    return Container(
      margin: EdgeInsets.all($.paddings.md),
      padding: EdgeInsets.all($.paddings.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  company.name,
                  style: FabTypography.displayMedium20,
                ),
              ),
              if (company.isVerified)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
          
          PaddingGap.xs(),
          
          Text(
            company.tagline,
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale600,
            ),
          ),
          
          PaddingGap.xs(),
          
          Text(
            '${company.industry} | ${company.location}',
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
          
          Text(
            '${company.employeeRange} • Employee',
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: $.paddings.md),
      child: TabBar(
        controller: _tabController,
        labelColor: FabColors.primary,
        unselectedLabelColor: FabColors.greyscale500,
        indicatorColor: FabColors.primary,
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Posts'),
          Tab(text: 'Jobs'),
        ],
      ),
    );
  }

  Widget _buildTabContent(CompanyProfileModel company) {
    return Container(
      height: 800, // Fixed height for tab content
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAboutTab(company),
          _buildPostsTab(),
          _buildJobsTab(),
        ],
      ),
    );
  }

  Widget _buildAboutTab(CompanyProfileModel company) {
    return SingleChildScrollView(
      padding: EdgeInsets.all($.paddings.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Section
          _buildSectionTitle('Overview'),
          PaddingGap.sm(),
          Text(
            company.description,
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale600,
              height: 1.5,
            ),
          ),
          
          PaddingGap.sm(),
          
          GestureDetector(
            onTap: () {
              // Show more details
            },
            child: Text(
              'Details >',
              style: FabTypography.displayMedium14.copyWith(
                color: FabColors.primary,
              ),
            ),
          ),
          
          PaddingGap.lg(),
          
          // Detail Section
          _buildSectionTitle('Detail'),
          PaddingGap.sm(),
          
          _buildDetailRow('Website', company.website),
          _buildDetailRow('Verified Page', company.verifiedDate),
          _buildDetailRow('Number of employees', company.employeeCount),
          _buildDetailRow('Specialties', company.specialties.join(', ')),
          _buildDetailRow('Industry', company.industry),
          _buildDetailRow('Location', company.location),
          _buildDetailRow('Founded', company.foundedYear.toString()),
          
          PaddingGap.lg(),
          
          // Employee Growth Dashboard
          _buildSectionTitle('Employee Growth Dashboard'),
          PaddingGap.xs(),
          
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              PaddingGap.xs(),
              Text(
                'Number of Visit',
                style: FabTypography.displayRegular12.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            ],
          ),
          
          PaddingGap.sm(),
          
          _buildSectionTitle('Monthly Growth Trend'),
          PaddingGap.xs(),
          
          Text(
            'Number of visitors to the company over the last 3 months',
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
          
          PaddingGap.md(),
          
          // Growth Chart
          _buildGrowthChart(company.growthData),
          
          PaddingGap.sm(),
          
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              PaddingGap.xs(),
              Text(
                'Growth',
                style: FabTypography.displayRegular12.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return const Center(
      child: Text('Posts content will be implemented here'),
    );
  }

  Widget _buildJobsTab() {
    return const Center(
      child: Text('Jobs content will be implemented here'),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: FabTypography.displayMedium16,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: FabTypography.displayMedium14.copyWith(
                color: FabColors.greyscale700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthChart(List<MonthlyGrowthData> data) {
    return Container(
      height: 200,
      padding: EdgeInsets.all($.paddings.md),
      decoration: BoxDecoration(
        color: FabColors.greyscale50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Chart area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.withOpacity(0.3),
                    Colors.orange.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: CustomPaint(
                painter: GrowthChartPainter(data),
              ),
            ),
          ),
          
          PaddingGap.sm(),
          
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: data.map((item) {
              return Text(
                item.month,
                style: FabTypography.displayRegular12.copyWith(
                  color: FabColors.greyscale500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class GrowthChartPainter extends CustomPainter {
  final List<MonthlyGrowthData> data;

  GrowthChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - (data[i].value / maxValue * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
