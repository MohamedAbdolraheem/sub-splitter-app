import 'package:flutter/material.dart';
import '../extensions/translation_extension.dart';

/// Examples of how to use the Translation extension on BuildContext
class TranslationExamples extends StatelessWidget {
  const TranslationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.appName), // Short syntax for app name
      ),
      body: Column(
        children: [
          // Basic translation usage
          Text(context.tr.welcomeBack),
          Text(context.tr.manageSubscriptions),

          // Translation with parameters
          Text(context.tr.invitedBy('أحمد محمد')), // Arabic name
          Text(context.tr.expiresAt('15/02/2024')),

          // Conditional layout based on language
          if (context.isArabic)
            const Text('هذا النص يظهر فقط بالعربية')
          else
            const Text('This text shows only in English'),

          // RTL-aware alignment
          Row(
            mainAxisAlignment:
                context
                    .startMainAxisAlignment, // Right for Arabic, Left for English
            children: [
              Text(context.tr.createGroup),
              const SizedBox(width: 8),
              Text(context.tr.joinGroup),
            ],
          ),

          // RTL-aware cross alignment
          Column(
            crossAxisAlignment:
                context
                    .startCrossAxisAlignment, // End for Arabic, Start for English
            children: [
              Text(context.tr.pendingInvites),
              Text(context.tr.upcomingPayments),
            ],
          ),

          // Currency formatting with SAR
          Text('${context.tr.youOwe}: 150.50 ر.س'),
          Text('${context.tr.owedToYou}: 75.25 ر.س'),

          // Date formatting
          Text('${context.tr.dueDate}: ${DateTime.now().toString()}'),

          // Error and success messages
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr.profileUpdated)),
              );
            },
            child: Text(context.tr.save),
          ),

          // Validation messages
          TextFormField(
            decoration: InputDecoration(
              labelText: context.tr.email,
              errorText: context.tr.emailInvalid,
            ),
          ),

          // Quick actions with proper alignment
          Row(
            mainAxisAlignment: context.startMainAxisAlignment,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(context.tr.createGroup),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(context.tr.joinGroup),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Example of using the extension in a custom widget
class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use RTL-aware alignment
      alignment: context.startAlignment,
      child: Column(
        // Use RTL-aware cross alignment
        crossAxisAlignment: context.startCrossAxisAlignment,
        children: [
          Text(context.tr.appName),
          Text(context.tr.appTagline),

          // Conditional content based on language
          if (context.isArabic)
            const Icon(Icons.language, color: Colors.green)
          else
            const Icon(Icons.language, color: Colors.blue),
        ],
      ),
    );
  }
}
