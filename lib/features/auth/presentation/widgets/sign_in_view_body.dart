import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/custom_form_text_field.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/message_second_option.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/remember_and_forget_message.dart';

import '../../../../core/config/routes.dart';
import '../../../../generated/assets.dart';
import '../../../home/presentation/logic/profile_cubit.dart';
import '../logic/auth_cubit.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool isObscure = true;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  SvgPicture.asset(
                    Assets.imagesLoginImage,
                    height: 200.h,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    AuthKeys.welcomeBack.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

                  CustomTextFormField(
                    hintText: AuthKeys.email.tr(),
                        controller: _emailController,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              EmailValidator.validate(value)) {
                            return null;
                          } else {
                            return AuthKeys.pleaseEnterValidEmail.tr();
                          }
                        },
                      ),
                  SizedBox(height: 16.h),
                  // Password Field
                  CustomTextFormField(
                        hintText: AuthKeys.password.tr(),
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
                            return AuthKeys.passwordMustBeAtLeast6Characters.tr();
                          }
                        },
                      ),
                  SizedBox(height: 8.h),
                  const RememberAndForgetMessage(),
                  SizedBox(height: 32.h),

                  // BlocConsumer handles both login + google buttons
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: _authListener,
                        builder: (context, state) {
                          final isEmailLoading = state is AuthLoading && state.action == AuthAction.email;
                          final isGoogleLoading = state is AuthLoading && state.action == AuthAction.google;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomButton(
                                isLoading: isEmailLoading,
                                text: AuthKeys.logIn.tr(),
                                width: width,
                                onTap: _signInWithEmailAndPassword,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 16.h),
                              MessageSecondOption(
                                message: AuthKeys.dontHaveAccount.tr(),
                                buttonText: AuthKeys.signUp.tr(),
                                onTap: _navigateToSignUp,
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  const Expanded(child: Divider(thickness: 1)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      AuthKeys.or.tr(),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.greyDark),
                                    ),
                                  ),
                                  const Expanded(child: Divider(thickness: 1)),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              CustomButton(
                                isLoading: isGoogleLoading, 
                                text: AuthKeys.continueWithGoogle.tr(),
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
      context.read<ProfileCubit>().loadProfile();
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
        message: AuthKeys.pleaseFillInAllFields.tr(),
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
