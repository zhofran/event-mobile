import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/forum_comment.model.dart';
import '../../../domain/models/forum_post.model.dart';
import '../../../domain/models/forum_topic.model.dart';

@RoutePage()
class ForumDetailPage extends StatelessWidget {
  ForumDetailPage({super.key, required this.topic});

  final ForumTopicModel topic;

  final List<ForumPostModel> dummyPosts = [
    ForumPostModel(
      id: 1,
      topicId: 1,
      title: "Share your favorite part of Mining Summit 2025",
      content:
          "Thanks everyone for joining my session! Feel free to ask any questions about AI tools for event management. I'll be checking this thread today!",
      authorId: 123,
      authorName: "Dr. Rina Putri, M.Ed",
      likeCount: 0,
      commentCount: 12,
      createdAt: DateTime(2025, 11, 6),
      updatedAt: DateTime(2025, 11, 6),
    ),
    // Tambahkan lebih banyak post jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(topic.title),
        actions: const [Icon(Icons.more_vert)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          $.navigator.push(
            PostCreateRoute(topic: topic),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => CreatePostScreen(topic: topic),
          //   ),
          // );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyPosts.length,
        itemBuilder: (ctx, i) {
          final post = dummyPosts[i];
          return _PostCard(post: post);
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final ForumPostModel post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Bisa dibuat ke detail post + komentar (Gambar 3)
          // Untuk contoh sederhana kita buat dialog komentar
          _showCommentsBottomSheet(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://ui-avatars.com/api/?name=${post.authorName}&background=FF6B35&color=fff",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(post.content),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thumb_up_off_alt, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text("${post.likeCount}"),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment, size: 20, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text("${post.commentCount}"),
                    ],
                  ),
                  const Icon(Icons.bookmark_border),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final List<ForumCommentModel> comments = [
      ForumCommentModel(
        id: 10,
        postId: post.id,
        content: "I loved your demo, Arya! Which platform would you recommend for automating sponsor matching?",
        authorId: 456,
        authorName: "Dr. Rina Putri, M.Ed",
        likeCount: 0,
        createdAt: DateTime(2025, 11, 6),
        updatedAt: DateTime(2025, 11, 6),
      ),
      ForumCommentModel(
        id: 11,
        postId: post.id,
        content: "The networking lounge was amazing! I met my future collaborator there",
        authorId: 123,
        authorName: "Dr. Rina Putri, M.Ed",
        likeCount: 0,
        createdAt: DateTime(2025, 11, 6),
        updatedAt: DateTime(2025, 11, 6),
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              height: 5,
              width: 40,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text("Reply", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text("${comments.length} Comments"),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: comments.length,
                itemBuilder: (ctx, i) {
                  final c = comments[i];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://ui-avatars.com/api/?name=${c.authorName}&background=FF6B35&color=fff",
                      ),
                    ),
                    title: Text(c.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(c.content),
                    trailing: Text(c.formattedDate, style: const TextStyle(fontSize: 11)),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write a Comment",
                  suffixIcon: Icon(Icons.send, color: Colors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}