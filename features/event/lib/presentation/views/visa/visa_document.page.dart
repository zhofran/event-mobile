// import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/file_picker.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VisaDocumentPage extends StatefulWidget {
  const VisaDocumentPage({super.key});

  @override
  State<VisaDocumentPage> createState() => _VisaDocumentPageState();
}

class _VisaDocumentPageState extends State<VisaDocumentPage> {
  String? invitationLetterFileName;
  String? proofOfAccommodationFileName;
  String? returnFlightTicketFileName;
  String? additionalDocumentFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(),

                  PaddingGap.lg(),
                  
                  _buildStepTitle(),
                  
                  PaddingGap.lg(),
                  
                  _buildDocumentUpload(
                    'Invitation Letter',
                    invitationLetterFileName,
                    isRequired: true,
                    onUpload: () => _pickFile((fileName) {
                      setState(() {
                        invitationLetterFileName = fileName;
                      });
                    }),
                  ),
                  
                  PaddingGap.md(),
                  
                  _buildDocumentUpload(
                    'Proof of Accommodation',
                    proofOfAccommodationFileName,
                    isRequired: true,
                    onUpload: () => _pickFile((fileName) {
                      setState(() {
                        proofOfAccommodationFileName = fileName;
                      });
                    }),
                  ),
                  
                  PaddingGap.md(),
                  
                  _buildDocumentUpload(
                    'Return Flight Ticket',
                    returnFlightTicketFileName,
                    isRequired: false,
                    onUpload: () => _pickFile((fileName) {
                      setState(() {
                        returnFlightTicketFileName = fileName;
                      });
                    }),
                  ),
                  
                  PaddingGap.md(),

                  _buildDocumentUpload(
                    'Additional Document',
                    additionalDocumentFileName,
                    isRequired: false,
                    onUpload: () => _pickFile((fileName) {
                      setState(() {
                        additionalDocumentFileName = fileName;
                      });
                    }),
                  ),
                ],
              ),
            ),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          FabButton.secondary(
            onPressed: () => $.navigator.pop(),
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
          const Expanded(
            child: FabTextStyled(
              'Visa Application',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Apply for Visa Assistance',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Let us help you prepare your travel documents for this event.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildStepTitle() {
    return const FabTextStyled(
      'Step 4 - Upload Required Documents',
      style: FabTypography.displaySemiBold18,
    );
  }

  Widget _buildDocumentUpload(
    String label,
    String? fileName, {
    required bool isRequired,
    required VoidCallback onUpload,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FabTextStyled(
              label,
              style: FabTypography.displayMedium14.copyWith(
                color: FabColors.greyscale900,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              FabTextStyled(
                '*',
                style: FabTypography.displayMedium14.copyWith(
                  color: FabColors.error,
                ),
              ),
            ],
          ],
        ),
        PaddingGap.xs(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: FabColors.greyscale0,
            border: Border.all(color: FabColors.greyscale200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: FabTextStyled(
                  fileName ?? 'Upload File',
                  style: FabTypography.displayRegular14.copyWith(
                    color: fileName != null
                        ? FabColors.greyscale900
                        : FabColors.greyscale300,
                  ),
                ),
              ),
              InkWell(
                onTap: onUpload,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: FabColors.greyscale0,
                    border: Border.all(color: FabColors.greyscale200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FabTextStyled(
                    'Upload',
                    style: FabTypography.displayMedium14.copyWith(
                      color: FabColors.greyscale900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile(Function(String) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      onFilePicked(result.files.single.name);
    }
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FabButton.primary(
        onPressed: () {
          $.navigator.push(const VisaReviewRoute());
          // Check if required documents are uploaded
          // if (invitationLetterFileName != null &&
          //     proofOfAccommodationFileName != null) {
          //   // Navigate to review page
          //   // $.navigator.push(VisaReviewRoute());
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text('Please upload all required documents'),
          //     ),
          //   );
          // }
        },
        size: FabButtonSize.large,
        width: double.infinity,
        child: Text(
          'Submit Application',
          style: FabTypography.displaySemiBold16.copyWith(
            color: FabColors.greyscale0,
          ),
        ),
      ),
    );
  }
}