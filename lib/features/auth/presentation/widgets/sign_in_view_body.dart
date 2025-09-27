import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';
import 'package:hand_by_hand/core/widgets/custom_welcome_message_container.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/custom_form_text_field.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/message_second_option.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/remember_and_forget_message.dart';

import '../../../../core/config/routes.dart';
import '../../../../generated/assets.dart';
import '../logic/auth_cubit.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return SafeArea(
      child: Stack(
        children: [
          CustomMessageContainer(
            width: width,
            height: height,
            message: "Welcome back",
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
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: SvgPicture.asset(Assets.imagesLoginImage),
                      ),
                      // Email Field
                      CustomTextFormField(
                        hintText: "Email",
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
                      SizedBox(height: height * 0.02),
                      // Password Field
                      CustomTextFormField(
                        hintText: "Password",
                        controller: _passwordController,
                        obscureText: isObscure,
                        prefixIcon: Icons.lock,
                        suffixIconButton: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.length >= 6) {
                            return null;
                          } else {
                            return "Password must be at least 6 characters";
                          }
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      const RememberAndForgetMessage(),
                      SizedBox(height: height * 0.02),

                      // BlocConsumer handles both login + google buttons
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: _authListener,
                        builder: (context, state) {
                          final isEmailLoading = state is AuthLoading && state.action == AuthAction.email;
                          final isGoogleLoading = state is AuthLoading && state.action == AuthAction.google;

                          return Column(
                            children: [
                              CustomButton(
                                isLoading: isEmailLoading,
                                text: "Log In",
                                width: width,
                                onTap: _signInWithEmailAndPassword,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: height * 0.01),
                              MessageSecondOption(
                                message: "Don't have an account?",
                                buttonText: "Sign Up",
                                onTap: _navigateToSignUp,
                              ),
                              SizedBox(height: height * 0.015),
                              Text(
                                "Or",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppColors.greyDark),
                              ),
                              SizedBox(height: height * 0.015),
                              CustomButton(
                                isLoading: isGoogleLoading,
                                text: "Continue with Google",
                                width: width,
                                onTap: _signInWithGoogle,
                                color: AppColors.primary,
                                iconAssets: Assets.imagesGoogleSvg,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthError) {
      CustomSnackBar.show(
        context,
        message: state.errorMessage,
        backgroundColor: AppColors.error,
        icon: Icons.error,
      );
    }
    if (state is AuthSuccess) {
      GoRouter.of(context).go(AppRoutes.kIdentificationView);
    }
  }

  void _signInWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      CustomSnackBar.show(
        context,
        message: "Please fill in all fields",
        backgroundColor: AppColors.error,
        icon: Icons.error,
      );
    }
  }

  void _navigateToSignUp() {
    GoRouter.of(context).pushReplacement(AppRoutes.kSignUpView);
  }

  void _signInWithGoogle() {
    context.read<AuthCubit>().signInWithGoogle();
  }
}
