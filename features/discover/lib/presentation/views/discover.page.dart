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

import '../../domain/models/discover_event.model.dart';
import '../cubits/discover_list.cubit.dart';
import 'widgets/event_card.dart';

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
  String selectedTab = 'For You';
  String? selectedLocation;
  String? selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  // Dummy data - siap untuk diganti dengan API response
  final List<DiscoverEventModel> events = [
    DiscoverEventModel(
      id: 1,
      title: 'MiningTech Summit 2025',
      imageUrl: 'https://via.placeholder.com/400x200/1e3a8a/ffffff?text=MiningTech+Summit+2025',
      location: 'Jakarta Convention Center',
      startDate: DateTime(2025, 11, 15, 7, 0),
      endDate: DateTime(2025, 11, 18, 7, 0),
      priceStart: 150000,
      badge: 'Sales End Soon',
      category: 'Conference',
    ),
    DiscoverEventModel(
      id: 2,
      title: 'EdTech Asia Conference',
      imageUrl: 'https://via.placeholder.com/400x200/0c4a6e/ffffff?text=EdTech+Asia+Summit+2024',
      location: 'Marina Bay Sands Expo',
      startDate: DateTime(2026, 3, 22, 9, 0),
      endDate: DateTime(2026, 3, 25, 9, 0),
      priceStart: 500000,
      category: 'Conference',
    ),
    DiscoverEventModel(
      id: 3,
      title: 'Gardening for Toddlers',
      imageUrl: 'https://via.placeholder.com/400x200/fbbf24/ffffff?text=Gardening+for+Toddlers',
      location: 'Surabaya Grand City',
      startDate: DateTime(2025, 12, 20, 11, 0),
      endDate: DateTime(2025, 12, 22, 11, 0),
      priceStart: 100000,
      category: 'Seminars',
    ),
  ];

  List<DiscoverEventModel> get filteredEvents {
    List<DiscoverEventModel> filtered = events;
    
    if (selectedCategory != null) {
      filtered = filtered.where((e) => e.category == selectedCategory).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Discover Events Near You',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTab('For You'),
                const SizedBox(width: 16),
                _buildTab('Nearby'),
                const SizedBox(width: 16),
                _buildTab('Trending'),
                const SizedBox(width: 16),
                _buildTab('Category'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Implement filter
                  },
                ),
              ],
            ),
          ),

          // Location/Category Header
          if (selectedTab == 'Nearby' || selectedTab == 'Category')
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTab == 'Nearby' 
                        ? 'Event in Central Jakarta'
                        : selectedCategory ?? 'Conference',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedTab == 'Nearby') {
                        _showLocationPicker();
                      } else {
                        _showCategoryPicker();
                      }
                    },
                    child: const Text(
                      'Change',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),

          // Event List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return FabEventCard(
                  event: filteredEvents[index],
                  onTap: () {
                    $.navigator.push(DiscoverEventDetailRoute(event: filteredEvents[index]));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
          if (title == 'Category') {
            selectedCategory = 'Conference';
          } else {
            selectedCategory = null;
          }
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              height: 2,
              width: 20,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Central Jakarta'),
                onTap: () {
                  setState(() => selectedLocation = 'Central Jakarta');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('South Jakarta'),
                onTap: () {
                  setState(() => selectedLocation = 'South Jakarta');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Conference'),
                onTap: () {
                  setState(() => selectedCategory = 'Conference');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Seminars'),
                onTap: () {
                  setState(() => selectedCategory = 'Seminars');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
