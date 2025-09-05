import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes.dart';
import '../../logic/auth_cubit.dart';

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
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  side: BorderSide(
                    color: rememberMe ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Text(
                  "Remember me",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.kForgetPasswordView);
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
