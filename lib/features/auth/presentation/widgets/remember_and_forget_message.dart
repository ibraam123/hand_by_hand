import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import '../../../../core/config/routes.dart';
import '../logic/auth_cubit.dart';

class RememberAndForgetMessage extends StatelessWidget {
  const RememberAndForgetMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        bool rememberMe = false;
        if (state is RememberMe) {
          rememberMe = state.isSelected;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<AuthCubit>().toggleRememberMe(value);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: Theme.of(context).colorScheme.onPrimary,
                  side: BorderSide(
                    color: rememberMe
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Text(AuthKeys.rememberMe.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        color: Theme.of(context).hintColor)),
              ],
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.kForgetPasswordView);
              },
              child: Text(
                AuthKeys.forgotPasswordQuestion.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
