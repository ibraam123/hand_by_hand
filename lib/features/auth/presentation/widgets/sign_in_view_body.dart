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
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,

        listener: (context, state) {
          if (state is AuthError) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
              icon: Icons.error,
              duration: const Duration(seconds: 3),
            );
          }
          if (state is AuthSuccess) {
            CustomSnackBar.show(
              context,
              message: "Login successful",
              backgroundColor: AppColors.success,
              textColor: AppColors.white,
              icon: Icons.check,
              duration: const Duration(seconds: 3),
            );
            GoRouter.of(context).go(AppRoutes.kIdentificationView);
          }
          if (state is AuthLoading) {
            CustomSnackBar.show(
              context,
              message: "Logging in...",
              backgroundColor: AppColors.white,
              textColor: Colors.black,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return Stack(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.02),
                            child: SvgPicture.asset(
                              Assets.imagesLoginImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                          CustomTextFormField(
                            hintText: "Email",
                            controller: _emailController,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (EmailValidator.validate(value!) &&
                                  value.isNotEmpty) {
                                return null;
                              } else {
                                return "Please enter a valid email";
                              }
                            },
                          ),
                          SizedBox(height: height * 0.02),
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
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.white,
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
                          CustomButton(
                            text: "Log In",
                            width: width,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<AuthCubit>()
                                    .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                              } else {
                                CustomSnackBar.show(
                                  context,
                                  message: "Please fill in all fields",
                                  backgroundColor: AppColors.error,
                                  textColor: AppColors.white,
                                  icon: Icons.error,
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: height * 0.01),
                          MessageSecondOption(
                            message: "Don't have an account?",
                            buttonText: "Sign Up",
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).pushReplacement(AppRoutes.kSignUpView);
                            },
                          ),
                          SizedBox(height: height * 0.015),
                          Text(
                            "Or",
                            style: TextStyle(
                              color: AppColors.greyDark,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthCubit>().signInWithGoogle();
                                },
                                child: SvgPicture.asset(Assets.imagesGoogleSvg),
                              ),
                              SizedBox(width: width * 0.05),
                              SvgPicture.asset(Assets.imagesAppleSvg),
                              SizedBox(width: width * 0.05),
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthCubit>().signInWithGoogle();
                                },
                                child: SvgPicture.asset(Assets.imagesFacebookSvgrepoComResize , ),
                              ),
                            ],
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
