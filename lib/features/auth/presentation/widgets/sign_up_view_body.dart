import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
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


  static const _monthMap = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
  };
  int convertMonthToInt(String month) {
    return _monthMap[month]!;
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

          return Stack(
            children: [
              CustomMessageContainer(
                width: width,
                height: height,
                message: AuthKeys.joinUs.tr(),
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
                              SizedBox(width: width * 0.05),
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
                          SizedBox(height: height * 0.02),
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
                            text: AuthKeys.signUp.tr(),
                            width: width,
                            isLoading: isLoading,
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
                                context.read<AuthCubit>().signUpWithEmailAndPassword(
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
                                  message: AuthKeys.pleaseFillInAllFields.tr(),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  textColor: Theme.of(context).colorScheme.onError,
                                  icon: Icons.error,
                                );
                              }
                            },
                            color: AppColors.primary,
                          ),
                          SizedBox(height: height * 0.01),
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
            ],
          );
        },
      ),
    );
  }
}
