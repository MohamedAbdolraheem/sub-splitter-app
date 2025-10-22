import 'package:flutter/material.dart';
import '../extensions/translation_extension.dart';
import 'localized_text.dart';

/// Demo page showing font switching between Arabic (Cairo) and English (Lora)
class FontDemoPage extends StatelessWidget {
  const FontDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedHeading(context.tr.appName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: context.startCrossAxisAlignment,
          children: [
            // Current language info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: context.startCrossAxisAlignment,
                  children: [
                    LocalizedHeading('Font Demo', fontSize: 20),
                    const SizedBox(height: 8),
                    LocalizedBodyText(
                      'Current Language: ${context.isArabic ? "Arabic" : "English"}',
                    ),
                    LocalizedBodyText('Font Family: ${context.fontFamily}'),
                    LocalizedBodyText(
                      'Text Direction: ${context.textDirection.name}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Arabic text with Cairo font
            if (context.isArabic) ...[
              LocalizedHeading('نص باللغة العربية', fontSize: 24),
              const SizedBox(height: 8),
              LocalizedBodyText(
                'هذا النص يستخدم خط القاهرة للعربية. الخط يبدو جميلاً ومقروءاً للنصوص العربية.',
                fontSize: 16,
              ),
              const SizedBox(height: 16),
              LocalizedBodyText(
                'مرحباً بك في تطبيق مقسم الاشتراكات! يمكنك إدارة اشتراكاتك المشتركة وتقسيم المصاريف بسهولة.',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ],

            // English text with Lora font
            if (context.isEnglish) ...[
              LocalizedHeading('English Text', fontSize: 24),
              const SizedBox(height: 8),
              LocalizedBodyText(
                'This text uses the Lora font for English. The font looks beautiful and readable for English texts.',
                fontSize: 16,
              ),
              const SizedBox(height: 16),
              LocalizedBodyText(
                'Welcome to the Subscription Splitter app! You can easily manage your shared subscriptions and split expenses.',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ],

            const SizedBox(height: 24),

            // Font style examples
            LocalizedHeading('Font Style Examples', fontSize: 20),
            const SizedBox(height: 16),

            // Different text styles
            LocalizedHeading('Heading Text', fontSize: 18),
            const SizedBox(height: 8),
            LocalizedBodyText('Body text with normal weight'),
            const SizedBox(height: 4),
            LocalizedBodyText(
              'Body text with bold weight',
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            LocalizedCaption('Caption text with smaller size'),
            const SizedBox(height: 4),
            LocalizedButtonText('Button text with medium weight'),

            const SizedBox(height: 24),

            // Currency examples
            LocalizedHeading('Currency Examples', fontSize: 20),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    LocalizedBodyText('You Owe'),
                    LocalizedHeading(
                      '150.50 ر.س',
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ],
                ),
                Column(
                  children: [
                    LocalizedBodyText('Owed to You'),
                    LocalizedHeading(
                      '75.25 ر.س',
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // RTL/LTR layout examples
            LocalizedHeading('Layout Examples', fontSize: 20),
            const SizedBox(height: 16),

            // RTL-aware row
            Row(
              mainAxisAlignment: context.startMainAxisAlignment,
              children: [
                LocalizedButtonText('Create Group'),
                const SizedBox(width: 8),
                LocalizedButtonText('Join Group'),
              ],
            ),

            const SizedBox(height: 16),

            // RTL-aware column
            Column(
              crossAxisAlignment: context.startCrossAxisAlignment,
              children: [
                LocalizedBodyText('• Pending Invites'),
                LocalizedBodyText('• Upcoming Payments'),
                LocalizedBodyText('• My Groups'),
              ],
            ),

            const SizedBox(height: 24),

            // Font family info
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: context.startCrossAxisAlignment,
                  children: [
                    LocalizedHeading('Font Information', fontSize: 18),
                    const SizedBox(height: 8),
                    LocalizedBodyText('Arabic Font: ${context.arabicFont}'),
                    LocalizedBodyText('English Font: ${context.englishFont}'),
                    LocalizedBodyText('Current Font: ${context.fontFamily}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
