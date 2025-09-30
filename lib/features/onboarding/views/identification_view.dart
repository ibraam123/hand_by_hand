import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';

import '../widgets/identification_view_body.dart';

class IdentificationView extends StatelessWidget {
  const IdentificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const IdentificationViewBody(),
       appBar:AppBar(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         title: Text(
          OnboardingKeys.whoAreYou.tr(),
          style: Theme.of(context).textTheme.displayLarge!
        ),
         centerTitle: true,
         elevation: 0,
       ) ,
    );
  }
}
