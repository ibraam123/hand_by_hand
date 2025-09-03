import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RememberAndForgetMessage extends StatefulWidget {
  const RememberAndForgetMessage({super.key});

  @override
  State<RememberAndForgetMessage> createState() => _RememberAndForgetMessageState();
}

class _RememberAndForgetMessageState extends State<RememberAndForgetMessage> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
              activeColor: Colors.blue, // fill color when checked
              checkColor: Colors.white, // tick color
              side: BorderSide( // border color when unchecked
                color: _rememberMe ? Colors.blue : Colors.grey,
                width: 2,
              ),
              shape: RoundedRectangleBorder( // optional for rounded checkbox
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
          onPressed: () {},
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
  }
}

