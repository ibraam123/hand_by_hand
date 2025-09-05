import 'package:flutter/material.dart';

import '../widgets/options_view_body.dart';

class OptionsView extends StatelessWidget {
  const OptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.person_3_outlined),
            onPressed: (){

            },
          )
        ],
        title: const Text(
          'Me 💪 Living with a disability',
          style: TextStyle(fontWeight:FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: const OptionsViewBody(),
    );
  }
}
