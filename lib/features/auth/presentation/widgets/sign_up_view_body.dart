import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:hand_by_hand/core/widgets/custom_welcome_message_container.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/custom_form_text_field.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/birth_date_selector.dart';
import 'package:hand_by_hand/features/auth/presentation/widgets/gender_selector.dart';
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
  int? _day;
  int? _month;
  int? _year;
  String? _gender;
  bool isObscure = true;

  int convertMonthToInt(String month) {
    switch (month) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'Jul':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 0;
    }
  }

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
              message: "Sign up successful.",
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
              message: "Signing up...",
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
                message: "Join us",
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
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "First name",
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Please enter a valid first name";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: width * 0.05),
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "Last name",
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Please enter a valid last name";
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
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
                          SizedBox(height: height * 0.015),
                          BirthDateSelector(
                            onChanged: (day, month, year) {
                              _day = day;
                              if (month != null) {
                                _month = convertMonthToInt(month);
                              }
                              _year = year;
                            },
                          ),
                          SizedBox(height: height * 0.015),
                          GenderSelector(
                            onChanged: (gender) => _gender = gender,
                          ),
                          SizedBox(height: height * 0.03),
                          CustomButton(
                            text: "Sign Up",
                            width: width,
                            onTap: () {
                              if (_formKey.currentState!.validate() &&
                                  _day != null &&
                                  _month != null &&
                                  _year != null &&
                                  _gender != null) {
                                final birthDate = DateTime(
                                  _year!,
                                  _month!,
                                  _day!,
                                );
                                context
                                    .read<AuthCubit>()
                                    .signUpWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      birthDate: birthDate,
                                      gender: _gender!,
                                    );
                              } else {
                                CustomSnackBar.show(
                                  context,
                                  message:
                                      "Please fill in all fields correctly.",
                                  backgroundColor: AppColors.error,
                                  textColor: AppColors.white,
                                  icon: Icons.error,
                                );
                              }
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: height * 0.01),
                          MessageSecondOption(
                            message: "Already have an account?",
                            buttonText: "Log In",
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).pushReplacement(AppRoutes.kSignInView);
                            },
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
