import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/forum_topic.model.dart';

@RoutePage()
class CommunityForumPage extends StatelessWidget {
  CommunityForumPage({super.key});

  final List<ForumTopicModel> dummyTopics = [
    ForumTopicModel(
      id: 1,
      title: 'Smart Mining Innovations',
      description: 'Discuss breakthroughs in AI, automation, and digital transformation.',
      authorId: 123,
      authorName: 'Dr. Rina Putri, M.Ed',
      memberCount: 40,
      postCount: 68,
      eventId: 10,
      eventName: 'Mining Tech Summit 2025',
      createdAt: DateTime(2025, 11, 1),
      updatedAt: DateTime(2025, 11, 20),
    ),
    ForumTopicModel(
      id: 2,
      title: 'Automation & Robotics',
      description: 'Dive deeper into robotics, remote operations, and sensor systems.',
      authorId: 123,
      authorName: 'Dr. Rina Putri, M.Ed',
      memberCount: 10,
      createdAt: DateTime(2025, 11, 5),
      updatedAt: DateTime(2025, 11, 22),
    ),
    ForumTopicModel(
      id: 3,
      title: 'AI in Education: A New Frontier',
      description: 'Mastering Data Analysis for Education Professionals',
      authorId: 123,
      authorName: 'Dr. Rina Putri, M.Ed',
      memberCount: 10,
      createdAt: DateTime(2025, 11, 10),
      updatedAt: DateTime(2025, 11, 22),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Community Forum'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: 'My Forum'),
                Tab(text: 'Discover'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: My Forum
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dummyTopics.length,
                    itemBuilder: (context, index) {
                      final topic = dummyTopics[index];
                      return _TopicCard(topic: topic);
                    },
                  ),
                  // Tab 2: Discover
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dummyTopics.length,
                    itemBuilder: (context, index) {
                      final topic = dummyTopics[index];
                      return _TopicCard(topic: topic);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final ForumTopicModel topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          $.navigator.push(
            ForumDetailRoute(topic: topic),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  topic.authorAvatar ??
                      'https://ui-avatars.com/api/?name=${topic.authorName}&background=FF6B35&color=fff',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.authorName,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (topic.hasEvent)
                      Text(
                        topic.eventSource,
                        style: const TextStyle(fontSize: 11, color: Colors.orange),
                      ),
                  ],
                ),
              ),
              if (topic.memberCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${topic.memberCount}',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
