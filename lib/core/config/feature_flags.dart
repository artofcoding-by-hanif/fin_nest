/// Feature flags for enabling/disabling features centrally
/// 
/// This enum defines all available feature flags in the application.
/// Each flag can be toggled on/off based on environment, remote config, or local overrides.
enum FeatureFlag {
  // Authentication Features
  biometricAuth,
  socialLogin,
  twoFactorAuth,
  
  // Dashboard Features
  dashboardWidgets,
  customizableDashboard,
  
  // Transaction Features
  recurringTransactions,
  transactionCategories,
  transactionAttachments,
  bulkTransactions,
  
  // Budget Features
  budgetAlerts,
  budgetRecommendations,
  sharedBudgets,
  
  // Goal Features
  goalMilestones,
  goalSharing,
  autoSavings,
  
  // Investment Features
  stockTracking,
  cryptoTracking,
  portfolioAnalysis,
  investmentRecommendations,
  
  // Insights Features
  aiInsights,
  spendingPatterns,
  savingsRecommendations,
  financialHealthScore,
  
  // Notification Features
  pushNotifications,
  emailNotifications,
  smsNotifications,
  inAppNotifications,
  
  // Sync Features
  cloudSync,
  autoSync,
  bankSync,
  
  // Profile Features
  profileCustomization,
  multipleProfiles,
  
  // Settings Features
  darkMode,
  exportData,
  importData,
  
  // Advanced Features
  offlineMode,
  debugMode,
  betaFeatures,
  analytics,
  crashReporting,
}

/// Extension to get feature flag metadata
extension FeatureFlagExtension on FeatureFlag {
  /// Get the feature flag key (used for storage and remote config)
  String get key {
    return toString().split('.').last;
  }
  
  /// Get a human-readable name for the feature
  String get displayName {
    switch (this) {
      // Authentication
      case FeatureFlag.biometricAuth:
        return 'Biometric Authentication';
      case FeatureFlag.socialLogin:
        return 'Social Login';
      case FeatureFlag.twoFactorAuth:
        return 'Two-Factor Authentication';
      
      // Dashboard
      case FeatureFlag.dashboardWidgets:
        return 'Dashboard Widgets';
      case FeatureFlag.customizableDashboard:
        return 'Customizable Dashboard';
      
      // Transactions
      case FeatureFlag.recurringTransactions:
        return 'Recurring Transactions';
      case FeatureFlag.transactionCategories:
        return 'Transaction Categories';
      case FeatureFlag.transactionAttachments:
        return 'Transaction Attachments';
      case FeatureFlag.bulkTransactions:
        return 'Bulk Transactions';
      
      // Budgets
      case FeatureFlag.budgetAlerts:
        return 'Budget Alerts';
      case FeatureFlag.budgetRecommendations:
        return 'Budget Recommendations';
      case FeatureFlag.sharedBudgets:
        return 'Shared Budgets';
      
      // Goals
      case FeatureFlag.goalMilestones:
        return 'Goal Milestones';
      case FeatureFlag.goalSharing:
        return 'Goal Sharing';
      case FeatureFlag.autoSavings:
        return 'Auto Savings';
      
      // Investments
      case FeatureFlag.stockTracking:
        return 'Stock Tracking';
      case FeatureFlag.cryptoTracking:
        return 'Crypto Tracking';
      case FeatureFlag.portfolioAnalysis:
        return 'Portfolio Analysis';
      case FeatureFlag.investmentRecommendations:
        return 'Investment Recommendations';
      
      // Insights
      case FeatureFlag.aiInsights:
        return 'AI Insights';
      case FeatureFlag.spendingPatterns:
        return 'Spending Patterns';
      case FeatureFlag.savingsRecommendations:
        return 'Savings Recommendations';
      case FeatureFlag.financialHealthScore:
        return 'Financial Health Score';
      
      // Notifications
      case FeatureFlag.pushNotifications:
        return 'Push Notifications';
      case FeatureFlag.emailNotifications:
        return 'Email Notifications';
      case FeatureFlag.smsNotifications:
        return 'SMS Notifications';
      case FeatureFlag.inAppNotifications:
        return 'In-App Notifications';
      
      // Sync
      case FeatureFlag.cloudSync:
        return 'Cloud Sync';
      case FeatureFlag.autoSync:
        return 'Auto Sync';
      case FeatureFlag.bankSync:
        return 'Bank Sync';
      
      // Profile
      case FeatureFlag.profileCustomization:
        return 'Profile Customization';
      case FeatureFlag.multipleProfiles:
        return 'Multiple Profiles';
      
      // Settings
      case FeatureFlag.darkMode:
        return 'Dark Mode';
      case FeatureFlag.exportData:
        return 'Export Data';
      case FeatureFlag.importData:
        return 'Import Data';
      
      // Advanced
      case FeatureFlag.offlineMode:
        return 'Offline Mode';
      case FeatureFlag.debugMode:
        return 'Debug Mode';
      case FeatureFlag.betaFeatures:
        return 'Beta Features';
      case FeatureFlag.analytics:
        return 'Analytics';
      case FeatureFlag.crashReporting:
        return 'Crash Reporting';
    }
  }
  
  /// Get description for the feature
  String get description {
    switch (this) {
      case FeatureFlag.biometricAuth:
        return 'Enable fingerprint/face recognition login';
      case FeatureFlag.socialLogin:
        return 'Login with Google, Apple, or Facebook';
      case FeatureFlag.aiInsights:
        return 'AI-powered financial insights and recommendations';
      case FeatureFlag.bankSync:
        return 'Automatically sync transactions from your bank';
      default:
        return 'Enable or disable $displayName';
    }
  }
}

