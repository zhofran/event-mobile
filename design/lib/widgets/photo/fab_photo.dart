import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/packages/image_picker.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FabPhoto extends StatefulWidget {
  const FabPhoto({
    required this.formControl,
    this.labelText,
    this.helperText,
    this.width = 120.0,
    this.height = 120.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.shape = BoxShape.circle,
    this.enabled = true,
    this.onImagePicked,
    this.validationMessages,
    this.showErrors = true,
    super.key,
  });

  /// Form control untuk reactive forms
  final FormControl formControl;

  /// Label untuk field
  final String? labelText;

  /// Helper text
  final String? helperText;

  final double width;
  final double height;

  final BoxShape shape;
  final Color backgroundColor;
  final Color iconColor;
  final bool enabled;
  final ValueChanged<File?>? onImagePicked;

  /// Message Validation / Error
  final Map<String, String Function(Object messages)>? validationMessages;

  final bool showErrors;

  @override
  State<FabPhoto> createState() => _FabPhotoState();
}

class _FabPhotoState extends State<FabPhoto> {
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _updateImageFromControl();
    widget.formControl.valueChanges.listen((_) {
      _updateImageFromControl();
    });
  }

  void _updateImageFromControl() {
    final currentValue = widget.formControl.value;
    if (currentValue != null &&
        currentValue is String &&
        currentValue.isNotEmpty) {
      setState(() {
        _pickedImage = XFile(currentValue);
      });
    } else {
      setState(() {
        _pickedImage = null;
      });
    }
  }

  Future<void> _pickImage() async {
    if (!widget.enabled) {
      return;
    }

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
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1005,
      );
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
        // Update form control with file path
        widget.formControl.value = image.path;
        widget.formControl.markAsTouched();

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
    return ReactiveValueListenableBuilder(
      formControl: widget.formControl,
      builder: (context, control, child) {
        final hasError =
            control.hasErrors && control.touched && widget.showErrors;
        final errorMessage = hasError
            ? FabValidationMessages.getErrorMessage(
                formControl: widget.formControl,
                fieldLabel: widget.labelText,
                customMessages: widget.validationMessages,
              )
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: FabTypography.bodySmallMedium,
              ),
              const SizedBox(height: 8),
            ],

            // Photo Container
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  shape: widget.shape,
                  borderRadius: widget.shape == BoxShape.rectangle
                      ? BorderRadius.circular(12)
                      : null,
                  border: Border.all(
                    color: hasError
                        ? FabColors.error
                        : (widget.shape == BoxShape.rectangle
                            ? FabColors.greyscale200
                            : Colors.transparent),
                    width: hasError ? 2 : 1,
                  ),
                  color: widget.backgroundColor,
                ),
                child: _pickedImage != null
                    ? Container(
                        width: widget.width,
                        height: widget.height,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: widget.shape,
                          borderRadius: widget.shape == BoxShape.rectangle
                              ? BorderRadius.circular(12)
                              : null,
                        ),
                        child: Image.file(
                          File(_pickedImage!.path),
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(
                        width: 86,
                        height: 86,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            size: 33,
                            color: widget.iconColor,
                          ),
                        ),
                      ),
              ),
            ),

            // Helper/Error Text
            if (hasError || widget.helperText != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  if (hasError) ...[
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: FabColors.error,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      hasError ? (errorMessage ?? 'Error') : widget.helperText!,
                      style: hasError
                          ? FabTypography.bodySmallRegular.copyWith(
                              color: FabColors.error,
                            )
                          : FabTypography.bodySmallLight.copyWith(
                              color: FabColors.greyscale400,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
