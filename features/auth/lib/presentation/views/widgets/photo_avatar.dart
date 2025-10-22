import 'dart:io';
import 'package:deps/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAvatar extends StatefulWidget {
  final double size;
  final BoxShape shape;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<File?>? onImagePicked;

  const PhotoAvatar({
    super.key,
    this.size = 120.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.onImagePicked,
    this.shape = BoxShape.circle,
  });

  @override
  State<PhotoAvatar> createState() => _PhotoAvatarState();
}

class _PhotoAvatarState extends State<PhotoAvatar> {
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _selectImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _selectImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source, maxWidth: 500, maxHeight: 500);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
        if (widget.onImagePicked != null) {
          widget.onImagePicked!(File(image.path));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: widget.shape,
          color: widget.backgroundColor,
        ),
        child: _pickedImage != null
        ? Container(
          width: widget.size,
          height: widget.size,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: FabColors.textPrimary
          ),
          child: Image.file(
            File(_pickedImage!.path),
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        )
        // CircleAvatar(
        //   radius: widget.size,
        //   backgroundImage: FileImage(
        //     File(_pickedImage!.path),
        //     scale: 0.5
        //   ),
        // )
        : Center(
          child: Icon(
            CupertinoIcons.camera_fill,
            size: widget.size * 0.33,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}