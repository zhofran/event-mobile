// ignore_for_file: max_lines_for_file, max_lines_for_function
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../cubits/register.cubit.dart';

@RoutePage()
class OTPVerificationPage extends StatefulWidget {
  OTPVerificationPage({required this.onResult, required this.idUser, super.key});

  final Function(bool didChange) onResult;
  int idUser;

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> with TickerProviderStateMixin {
  final registerCubit = $.get<RegisterCubit>();
  
  late FormGroup form;
  late AnimationController _timerController;
  bool _isLoading = false;
  bool _canResend = false;
  int _remainingSeconds = 59;

  // Controllers and focus nodes for OTP inputs
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();

    log('Log result: ${widget.idUser}', name: 'OTP Verification');
    
    // Initialize form with simple validation
    form = FormGroup({
      'otp': FormControl<String>(
        validators: [Validators.required],
      ),
    });

    // Initialize timer
    _timerController = AnimationController(
      duration: const Duration(seconds: 59),
      vsync: this,
    );
    
    _startTimer();
    
    // Ensure no field has focus initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var focusNode in _otpFocusNodes) {
        focusNode.unfocus();
      }
    });
  }

  void _startTimer() {
    _timerController..reset()
    ..forward()
    
    ..addListener(() {
      setState(() {
        _remainingSeconds = (59 * (1 - _timerController.value)).round();
      });
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Handle OTP input changes with automatic navigation
  void _onOTPChanged(String value, int index) {
    // Ensure only one digit is entered
    if (value.length > 1) {
      _otpControllers[index].text = value.substring(value.length - 1);
      _otpControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _otpControllers[index].text.length),
      );
    }
    
    // Move to next field if current field is filled and not the last field
    if (value.isNotEmpty && index < 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpFocusNodes[index + 1].requestFocus();
      });
    } else if (value.isNotEmpty && index == 5) {
      // Last field, remove focus to hide keyboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpFocusNodes[index].unfocus();
      });
    }
    
    // Update the form control with complete OTP
    _updateOTPFormControl();
  }

  // Update the form control with current OTP value
  void _updateOTPFormControl() {
    String otpValue = _otpControllers.map((controller) => controller.text).join();
    form.control('otp').value = otpValue;
  }

  // Handle paste operation
  void _handlePaste(String pastedText, int currentIndex) {
    // Clean the pasted text (remove non-digits and limit to 6 characters)
    final cleanText = pastedText.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 6.clamp(0, pastedText.length));
    
    if (cleanText.isEmpty) return;
    
    // Clear current field first
    _otpControllers[currentIndex].clear();
    
    if (cleanText.length == 6) {
      // Full OTP pasted - fill all fields from the beginning
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = cleanText[i];
      }
      // Move focus to the last field and unfocus to hide keyboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpFocusNodes[5].unfocus();
      });
    } else {
      // Partial text - fill from current index
      for (int i = 0; i < cleanText.length && (currentIndex + i) < 6; i++) {
        _otpControllers[currentIndex + i].text = cleanText[i];
      }
      // Move focus to next empty field or last filled field
      final nextIndex = (currentIndex + cleanText.length).clamp(0, 5);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (nextIndex < 6) {
          _otpFocusNodes[nextIndex].requestFocus();
        }
      });
    }
    
    _updateOTPFormControl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              // Header with back button and title
              _buildAppBar(),
              
              // Main content area - properly centered
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // OTP Verification Form
                        _buildOTPVerificationForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [ 
          FabButton.secondary(
            onPressed: () {
              $.navigator.pop();
            },
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
              'OTP Verification',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          FabButton.secondary(
            onPressed: () => {},
            isIconOnly: true,
            iconWidget: Assets.images.icons.questionLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPVerificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Verify Your OTP',
          style: FabTypography.heading3SemiBold.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.lg(),
        
        // OTP Input Fields
        _buildOTPInputFields(),
        
        PaddingGap.md(),
        
        // Timer Display
        Center(child: _buildTimerDisplay()),

        PaddingGap.md(),
        
        // Continue Button
        _buildContinueButton(),

        PaddingGap.md(),
        
        // Resend OTP Link
        _buildResendOTPLink(),
      ],
    );
  }

  Widget _buildOTPInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: FabColors.background,
            border: Border.all(
              color: FabColors.greyscale200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            style: FabTypography.displaySemiBold18.copyWith(
              color: FabColors.greyscale700,
            ),
            onChanged: (value) {
              // Prevent recursive calls by checking if the value is different
              if (value.isNotEmpty) {
                // Handle paste operation (multiple characters)
                if (value.length > 1) {
                  _handlePaste(value, index);
                  return;
                }
                
                // Ensure only single digit
                if (value.length == 1 && RegExp(r'^[0-9]$').hasMatch(value)) {
                  _onOTPChanged(value, index);
                }
              } else {
                // Handle backspace - move to previous field
                if (index > 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _otpFocusNodes[index - 1].requestFocus();
                  });
                }
                _updateOTPFormControl();
              }
            },
            onTap: () {
              // Clear field when tapped for better UX
              if (_otpControllers[index].text.isNotEmpty) {
                _otpControllers[index].clear();
                _updateOTPFormControl();
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimerDisplay() {
    return FabTextStyled(
      '0.${_remainingSeconds.toString().padLeft(2, '0')}',
      style: FabTypography.displayMedium18.copyWith(
        color: FabColors.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildResendOTPLink() {
    return Row(
      children: [
        FabTextStyled(
          "Didn't receive the code? ",
          style: FabTypography.displayRegular16.copyWith(
            color: FabColors.greyscale500,
          ),
        ),
        GestureDetector(
          onTap: _remainingSeconds == 0 ? _resendOTP : null,
          child: FabTextStyled(
            'Resend OTP',
            style: FabTypography.displayRegular16.copyWith(
              color: _remainingSeconds == 0 ? FabColors.primary : FabColors.greyscale400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FabButton.primary(
        isLoading: _isLoading,
        size: FabButtonSize.large,
        onPressed: _handleOTPVerification,
        child: Text(
          'Continue',
          style: FabTypography.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _resendOTP() {
    // Reset timer and restart
    _startTimer();
    
    // TODO: Implement actual OTP resend logic
    print('Resending OTP...');
  }

  Future<void> _handleOTPVerification() async {
    // Get current OTP value
    final otp = _otpControllers.map((controller) => controller.text).join();
    
    // Validate OTP length and content
    if (otp.length == 6 && RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
      setState(() {
        _isLoading = true;
      });

      // Log the OTP data (in real app, this would be sent to API)
      final verify = await registerCubit.verifyOtp(OTP: otp, id: widget.idUser.toString());

      // print('OTP Verification Data:');
      // print('OTP: $otp');

      // Simulate OTP verification process
      // await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful OTP verification
      if (verify) {
        widget.onResult(true);
        await $.navigator.replace(RoleSelectionRoute(onResult: widget.onResult));
      }
    } else {
      // Show error or highlight empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      
      // Focus on first empty field
      for (int i = 0; i < 6; i++) {
        if (_otpControllers[i].text.isEmpty) {
          _otpFocusNodes[i].requestFocus();
          break;
        }
      }
    }
  }
}
