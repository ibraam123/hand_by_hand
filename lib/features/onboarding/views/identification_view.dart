import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_styles.dart';

import '../widgets/identification_view_body.dart';

class IdentificationView extends StatelessWidget {
  const IdentificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IdentificationViewBody(),
       appBar:AppBar(
         backgroundColor: Colors.transparent,
         title: Text('Who are you?' , style:  AppTextStyles.bold24.copyWith(
           fontSize: 20.sp
         ), ),
         centerTitle: true,
         elevation: 0,
       ) ,
    );
  }
}
