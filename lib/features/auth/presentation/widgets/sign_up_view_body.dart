import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/custom_form_text_field.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/message_second_option.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../logic/auth_cubit.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;




  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return SafeArea(
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AuthError) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
              icon: Icons.error,
            );
          }
          if (state is AuthSuccess) {
            GoRouter.of(context).go(AppRoutes.kIdentificationView);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

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
                        Text(
                          AuthKeys.joinUs.tr(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.h),
                        Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: AuthKeys.firstName.tr(),
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return AuthKeys.enterFirstName.tr();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: AuthKeys.lastName.tr(),
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return AuthKeys.enterLastName.tr();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          CustomTextFormField(
                            hintText: AuthKeys.email.tr(),
                            controller: _emailController,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (EmailValidator.validate(value!) &&
                                  value.isNotEmpty) {
                                return null;
                              } else {
                                return AuthKeys.pleaseEnterValidEmail.tr();
                              }
                            },
                          ),
                          SizedBox(height: 16.h),
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
                                isObscure ? Icons.visibility_off : Icons.visibility,
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
                          SizedBox(height: 32.h),
                          CustomButton(
                            text: AuthKeys.signUp.tr(),
                            width: width,
                            isLoading: isLoading,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUpWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                );
                              } else {
                                CustomSnackBar.show(
                                  context,
                                  message: AuthKeys.pleaseFillInAllFields.tr(),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  textColor: Theme.of(context).colorScheme.onError,
                                  icon: Icons.error,
                                );
                              }
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 16.h),
                          MessageSecondOption(
                            message: AuthKeys.alreadyHaveAccount.tr(),
                            buttonText: AuthKeys.logIn.tr(),
                            onTap: () {
                              GoRouter.of(context)
                                  .pushReplacement(AppRoutes.kSignInView);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}
