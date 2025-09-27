import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/routes.dart';
import '../../../../../core/utils/helper/theme_cubit.dart';

class MenuDrawerItems extends StatelessWidget {
  const MenuDrawerItems({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final List<Widget> menuItems = [
      ListTile(
        leading: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.blue,
        ),
        title: Text(isDarkMode ? "Light Mode" : "Dark Mode"),
        onTap: () {
          context.read<ThemeCubit>().toggleTheme();
        },
      ),
      ListTile(
        leading: const Icon(Icons.info, color: Colors.blue),
        title: const Text("About"),
        onTap: () {
          GoRouter.of(context).push(AppRoutes.kKnowAboutUs);
        },
      ),
      ListTile(
          leading: const Icon(Icons.star, color: Colors.blue),
          title: const Text("Rate Us"),
          onTap: () async {
            const url =
                "https://play.google.com/store/apps/details?id=com.kakaogames.gbod&pcampaignid=web_share";
            if (await canLaunchUrl(
              Uri.parse(url),
            )) {
              await launchUrl(
                Uri.parse(url),
              );
            } else {
              throw 'Could not launch $url';
            }
          }),
      ListTile(
        leading: const Icon(Icons.share, color: Colors.blue),
        title: const Text("Share"),
        onTap: () {
          SharePlus.instance.share(ShareParams(
            subject: "Hand By Hand",
            text:
                "https://play.google.com/store/apps/details?id=com.kakaogames.gbod&pcampaignid=web_share",
          ));
        },
      ),
    ];

    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return menuItems[index];
      },
    );
  }
}
