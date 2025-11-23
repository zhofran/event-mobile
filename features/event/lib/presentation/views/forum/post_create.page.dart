import 'package:deps/design/design.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/forum_topic.model.dart';

@RoutePage()
class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key, required this.topic});

  final ForumTopicModel topic;

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text("Add Post"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create New Post", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Share your ideas, questions, or insights with the community."),
            const SizedBox(height: 32),
            const Text("Post Title *", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Write a clear, descriptive title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Content/Questions *", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Start your discussion here... You can share your experience, ask a question, or attach supporting files.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Add Attachment"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.camera_alt, size: 48, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can attach up to 3 files (PDF, JPG, PNG, or DOC).",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FabButton.primary(
                // onPressed: byPass,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const _SuccessDialog(),
                  ).then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  'Continue',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/robot_success.png', // kamu bisa ganti dengan asset robot oranye
            height: 120,
            package: 'your_package', // atau gunakan NetworkImage jika tidak pakai asset
          ),
          const SizedBox(height: 24),
          const Text(
            "Post Published!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Your post is now live in Smart Mining Innovations.\nCommunity members can start replying to your topic.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("View Post", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("Continue", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}