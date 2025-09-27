import 'package:flutter/material.dart';

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
          'Who are you?',
          style: Theme.of(context).textTheme.displayLarge!
        ),
         centerTitle: true,
         elevation: 0,
       ) ,
    );
  }
}
