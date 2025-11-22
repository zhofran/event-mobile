// ignore_for_file: must_be_immutable

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class EWalletPhonePage extends StatefulWidget {
  EWalletPhonePage({
    required this.eventName,
    required this.eventDate,
    required this.paymentChannel,
    this.imageUrl,
    required this.expiryTime,
    super.key,
  });

  final String eventName;
  final String eventDate;
  final String paymentChannel;
  final String? imageUrl;
  final String expiryTime;

  @override
  State<EWalletPhonePage> createState() => _EWalletPhonePageState();
}

class _EWalletPhonePageState extends State<EWalletPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+62';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
                padding: EdgeInsets.zero,
                children: [
                  PaddingGap.md(),
                  _buildHeaderSection(),
                  PaddingGap.md(),
                  _buildSelectedChannelCard(),
                  PaddingGap.lg(),
                  _buildPhoneNumberSection(),
                  PaddingGap.md(),
                  _buildImportantNote(),
                  PaddingGap.lg(),
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
            onPressed: () {
              Navigator.pop(context);
            },
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: Column(
              children: [
                FabTextStyled(
                  widget.eventName,
                  style: FabTypography.displaySemiBold18,
                  textAlign: TextAlign.center,
                ),
                PaddingGap.xs(),
                FabTextStyled(
                  widget.eventDate,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const FabTextStyled(
            'E-Wallet',
            style: FabTypography.displaySemiBold18,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: FabColors.warning50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  // color: FabColors.warning,
                ),
                PaddingGap.xs(),
                FabTextStyled(
                  widget.expiryTime,
                  style: FabTypography.displaySemiBold12.copyWith(
                    // color: FabColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedChannelCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FabColors.primary,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: FabColors.primary25,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                widget.imageUrl ?? '',
                width: 40,
                height: 40,
                package: 'design',
              )
              // FabTextStyled(
              //   widget.paymentChannel[0].toUpperCase(),
              //   style: FabTypography.displaySemiBold16.copyWith(
              //     color: FabColors.primary,
              //   ),
              // ),
            ),
          ),
          PaddingGap.md(),
          Expanded(
            child: FabTextStyled(
              widget.paymentChannel,
              style: FabTypography.displaySemiBold16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: FabColors.primary25,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FabTextStyled(
              'Selected',
              style: FabTypography.displaySemiBold12.copyWith(
                color: FabColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FabTextStyled(
            'Enter your phone number',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          PaddingGap.sm(),
          const FabTextStyled(
            'Phone Number',
            style: FabTypography.displaySemiBold14,
          ),
          PaddingGap.sm(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FabColors.greyscale300,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      FabTextStyled(
                        _countryCode,
                        style: FabTypography.displayRegular14,
                      ),
                      PaddingGap.xs(),
                      Container(
                        width: 1,
                        height: 24,
                        color: FabColors.greyscale300,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '812-3456-7890',
                      hintStyle: FabTypography.displayRegular14.copyWith(
                        color: FabColors.greyscale300,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: FabTypography.displayRegular14,
                  ),
                ),
              ],
            ),
          ),
          PaddingGap.sm(),
          FabTextStyled(
            'Enter phone number registered with ${widget.paymentChannel}',
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FabColors.warning,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FabColors.warning,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: FabColors.textPrimary,
            size: 20,
          ),
          PaddingGap.sm(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FabTextStyled(
                  'Important Note',
                  style: FabTypography.displaySemiBold14.copyWith(
                    color: FabColors.textPrimary,
                  ),
                ),
                PaddingGap.xs(),
                FabTextStyled(
                  'Make sure your ${widget.paymentChannel} balance is sufficient and the number is correct',
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: FabButton.primary(
        onPressed: _phoneController.text.isEmpty
            ? null
            : () {
                // Navigate to confirmation page
                // Navigator.push(context, ...);
              },
        size: FabButtonSize.large,
        width: double.infinity,
        child: const Text('Continue'),
      ),
    );
  }
}