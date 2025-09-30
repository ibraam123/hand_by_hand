import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/faq_help_item.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/section_help_titile.dart';

import 'contact_us_card.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(Profile.helpSupport.tr() , style: TextStyle(color: isDarkMode ? Colors.white : Colors.black  , fontWeight: FontWeight.bold) ,),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SectionHelpTitle(title: HelpSupport.faq.tr()),
            const SizedBox(height: 16),
            FaqHelpItem(
              question: HelpSupport.faq1.tr() ,
              answer:
                HelpSupport.freq1desc.tr(),
            ),
            FaqHelpItem(
              question: HelpSupport.faq2.tr() ,
              answer:
                  HelpSupport.freq2desc.tr(),
            ),
            FaqHelpItem(
              question: HelpSupport.faq3.tr() ,
              answer:
                  HelpSupport.freq3desc.tr(),
            ),
            FaqHelpItem(
              question: HelpSupport.faq4.tr() ,
              answer:
                  HelpSupport.freq4desc.tr(),
            ),
            const SizedBox(height: 24),
            SectionHelpTitle(title: HelpSupport.contactSupport.tr()),
            const SizedBox(height: 16),
            ContactUsCard(
              icon: Icons.phone,
              title: HelpSupport.phone.tr(),
              subtitle: "+20 120 138 2622",
              uri: Uri(scheme: 'tel', path: '+201201382622'),
              errorMessage: 'Could not launch phone dialer',
            ),
            const SizedBox(height: 12),
            ContactUsCard(
              icon: Icons.email,
              title: HelpSupport.email.tr(),
              subtitle: "ibraam.software@gmail.com",
              uri: Uri(scheme: 'mailto', path: 'ibraam.software@gmail.com'),
              errorMessage: 'Could not launch email app',
            ),
            const SizedBox(height: 12),
            ContactUsCard(
              icon: Icons.facebook,
              title: HelpSupport.facebook.tr(),
              subtitle: "Visit our Facebook page",
              uri: Uri(
                    scheme: 'https',
                    host: 'www.facebook.com',
                    path: '/ibraam.magdy.848247', // Replace with your actual page
                  ),
              errorMessage: 'Could not launch Facebook',
            ),
            const SizedBox(height: 24),
            Text(
              HelpSupport.supportMessage.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

}
