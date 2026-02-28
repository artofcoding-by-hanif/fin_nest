import 'package:flutter/material.dart';

/// Model for an onboarding page/slide
class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });
}

/// Predefined onboarding pages for FinNest
class OnboardingPages {
  static const List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Track Your Finances',
      description:
          'Keep track of all your income and expenses in one place. Monitor your financial health with detailed insights and reports.',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Manage Your Accounts',
      description:
          'Organize multiple bank accounts, credit cards, and cash. Get a complete overview of your financial portfolio.',
      icon: Icons.account_balance,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Set Savings Goals',
      description:
          'Create savings goals for your dreams - vacation, emergency fund, or a new car. Track your progress and stay motivated.',
      icon: Icons.savings,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Budget & Plan',
      description:
          'Create budgets for different categories and stick to them. Get alerts when you\'re close to your limits.',
      icon: Icons.pie_chart,
      color: Colors.purple,
    ),
    OnboardingPage(
      title: 'Recurring Transactions',
      description:
          'Set up recurring income and expenses. Never forget a bill payment or subscription with smart reminders.',
      icon: Icons.repeat,
      color: Colors.teal,
    ),
    OnboardingPage(
      title: 'Secure & Private',
      description:
          'Your data is stored securely on your device. Enable biometric authentication for extra security.',
      icon: Icons.security,
      color: Colors.red,
    ),
  ];
}

