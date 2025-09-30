import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/utils/helper/theme_cubit.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("language".tr()), // Use localization key
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "choose_language".tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),

                    // English Option
                    ListTile(
                      title: const Text("English"),
                      trailing: state.isEnglish
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        if (!state.isEnglish) {
                          context.read<ThemeCubit>().toggleLanguage(context);
                        }
                      },
                    ),
                    const Divider(),

                    // Arabic Option
                    ListTile(
                      title: const Text("العربية"),
                      trailing: !state.isEnglish
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        if (state.isEnglish) {
                          context.read<ThemeCubit>().toggleLanguage(context);
                        }
                      },
                    ),
                  ],
                ),

                // Loading overlay
                if (state.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
