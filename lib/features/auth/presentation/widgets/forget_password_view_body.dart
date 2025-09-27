import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';
import 'package:hand_by_hand/core/widgets/custom_welcome_message_container.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/custom_form_text_field.dart';
import '../../../../core/config/routes.dart';
import '../logic/auth_cubit.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return SafeArea(
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is ForgotPasswordError) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              backgroundColor: AppColors.error,
              icon: Icons.error,
            );
          }
          if (state is ForgotPasswordSuccess) {
            CustomSnackBar.show(
              context,
              message: "Password reset email sent!",
              backgroundColor: AppColors.success,
              icon: Icons.check,
            );
            GoRouter.of(context).go(AppRoutes.kSignInView);
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;

          return Stack(
            children: [
              CustomMessageContainer(
                width: width,
                height: height,
                message: "Forgot Password?",
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFormField(
                            hintText: "Enter your email",
                            controller: _emailController,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  EmailValidator.validate(value)) {
                                return null;
                              } else {
                                return "Please enter a valid email";
                              }
                            },
                          ),
                          SizedBox(height: height * 0.03),
                          CustomButton(
                            isLoading: isLoading,
                            text: "Send Reset Link",
                            width: width,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<AuthCubit>()
                                    .sendPasswordResetEmail(
                                  _emailController.text.trim(),
                                );
                              } else {
                                CustomSnackBar.show(
                                  context,
                                  message: "Please enter a valid email",
                                  backgroundColor: AppColors.error,
                                  icon: Icons.error,
                                );
                              }
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: height * 0.02),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushReplacement(AppRoutes.kSignInView);
                            },
                            child: Text(
                              "Back to Sign In",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
