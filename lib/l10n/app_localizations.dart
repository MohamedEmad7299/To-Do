import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TO-DO'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Please login to your account or create new account to continue'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get repeatPassword;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forgetPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get loginWithFacebook;

  /// No description provided for @registerWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Register with Google'**
  String get registerWithGoogle;

  /// No description provided for @registerWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Register with Facebook'**
  String get registerWithFacebook;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// No description provided for @pleaseSignInFirst.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first to enable fingerprint login'**
  String get pleaseSignInFirst;

  /// No description provided for @authenticateToEnable.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to enable fingerprint login'**
  String get authenticateToEnable;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Manage your tasks'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Description.
  ///
  /// In en, this message translates to:
  /// **'You can easily manage all of your daily tasks in TO-DO for free'**
  String get onboarding1Description;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Create daily routine'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Description.
  ///
  /// In en, this message translates to:
  /// **'In TO-DO you can create your personalized routine to stay productive'**
  String get onboarding2Description;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Organize your tasks'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Description.
  ///
  /// In en, this message translates to:
  /// **'You can organize your daily tasks by adding your tasks into separate categories'**
  String get onboarding3Description;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @sortedBy.
  ///
  /// In en, this message translates to:
  /// **'Sorted by: '**
  String get sortedBy;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nameAZ;

  /// No description provided for @priority112.
  ///
  /// In en, this message translates to:
  /// **'Priority (1-12)'**
  String get priority112;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @whatToDoToday.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do today?'**
  String get whatToDoToday;

  /// No description provided for @tapToAddTasks.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your tasks'**
  String get tapToAddTasks;

  /// No description provided for @tasksLeft.
  ///
  /// In en, this message translates to:
  /// **'Task left'**
  String get tasksLeft;

  /// No description provided for @tasksLeftPlural.
  ///
  /// In en, this message translates to:
  /// **'Tasks left'**
  String get tasksLeftPlural;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Task done'**
  String get tasksDone;

  /// No description provided for @tasksDonePlural.
  ///
  /// In en, this message translates to:
  /// **'Tasks done'**
  String get tasksDonePlural;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @taskNameHint.
  ///
  /// In en, this message translates to:
  /// **'Do math homework'**
  String get taskNameHint;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @pleaseEnterTaskName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task name'**
  String get pleaseEnterTaskName;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectPriority.
  ///
  /// In en, this message translates to:
  /// **'Please select a priority'**
  String get pleaseSelectPriority;

  /// No description provided for @pleaseSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get pleaseSelectDateTime;

  /// No description provided for @taskAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task added successfully!'**
  String get taskAddedSuccessfully;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Task Priority'**
  String get taskPriority;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get chooseTime;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get sat;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategory;

  /// No description provided for @longPressToDelete.
  ///
  /// In en, this message translates to:
  /// **'Long press on custom categories to delete'**
  String get longPressToDelete;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirmPrefix.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"'**
  String get deleteCategoryConfirmPrefix;

  /// No description provided for @deleteCategoryConfirmSuffix.
  ///
  /// In en, this message translates to:
  /// **'\"?'**
  String get deleteCategoryConfirmSuffix;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @categoryDeletedSuccessPrefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get categoryDeletedSuccessPrefix;

  /// No description provided for @categoryDeletedSuccessSuffix.
  ///
  /// In en, this message translates to:
  /// **' deleted successfully!'**
  String get categoryDeletedSuccessSuffix;

  /// No description provided for @categoryDeleteFailedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category: '**
  String get categoryDeleteFailedPrefix;

  /// No description provided for @categoryCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully!'**
  String get categoryCreatedSuccess;

  /// No description provided for @categoryCreateFailedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Failed to create category: '**
  String get categoryCreateFailedPrefix;

  /// No description provided for @usingDefaultCategoriesPrefix.
  ///
  /// In en, this message translates to:
  /// **'Using default categories: '**
  String get usingDefaultCategoriesPrefix;

  /// No description provided for @createNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Create New Category'**
  String get createNewCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get chooseIcon;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @pleaseEnterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get pleaseEnterCategoryName;

  /// No description provided for @pleaseSelectColor.
  ///
  /// In en, this message translates to:
  /// **'Please select a color'**
  String get pleaseSelectColor;

  /// No description provided for @pleaseSelectIcon.
  ///
  /// In en, this message translates to:
  /// **'Please select an icon'**
  String get pleaseSelectIcon;

  /// No description provided for @categoryGrocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get categoryGrocery;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categorySport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get categorySport;

  /// No description provided for @categoryDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get categoryDesign;

  /// No description provided for @categoryUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get categoryUniversity;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @categoryMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryMusic;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryMovie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get categoryMovie;

  /// No description provided for @categoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get categoryHome;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @uptodo.
  ///
  /// In en, this message translates to:
  /// **'Uptodo'**
  String get uptodo;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @changeAccountName.
  ///
  /// In en, this message translates to:
  /// **'Change account name'**
  String get changeAccountName;

  /// No description provided for @changeAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Change account password'**
  String get changeAccountPassword;

  /// No description provided for @changeAccountImage.
  ///
  /// In en, this message translates to:
  /// **'Change account Image'**
  String get changeAccountImage;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About US'**
  String get aboutUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @helpFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get helpFeedback;

  /// No description provided for @supportUs.
  ///
  /// In en, this message translates to:
  /// **'Support US'**
  String get supportUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String logoutFailed(Object error);

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @fingerprintLogin.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint Login'**
  String get fingerprintLogin;

  /// No description provided for @fingerprintDescription.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint to quickly access your account'**
  String get fingerprintDescription;

  /// No description provided for @enableFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint authentication'**
  String get enableFingerprint;

  /// No description provided for @notAvailableOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get notAvailableOnDevice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @freeUpStorage.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get freeUpStorage;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @clearAllTasks.
  ///
  /// In en, this message translates to:
  /// **'Clear All Tasks'**
  String get clearAllTasks;

  /// No description provided for @clearAllTasksMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all tasks? This action cannot be undone and will permanently delete all your tasks.'**
  String get clearAllTasksMessage;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @allTasksCleared.
  ///
  /// In en, this message translates to:
  /// **'All tasks cleared successfully!'**
  String get allTasksCleared;

  /// No description provided for @fingerprintEnabled.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint login enabled'**
  String get fingerprintEnabled;

  /// No description provided for @fingerprintDisabled.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint login disabled'**
  String get fingerprintDisabled;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required to enable fingerprint login'**
  String get passwordRequired;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// No description provided for @biometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to access your account'**
  String get biometricAuthReason;

  /// No description provided for @biometricAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication required'**
  String get biometricAuthTitle;

  /// No description provided for @authenticationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Authentication cancelled'**
  String get authenticationCancelled;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication not available'**
  String get biometricNotAvailable;

  /// No description provided for @biometricCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to check biometric availability'**
  String get biometricCheckFailed;

  /// No description provided for @noUserSignedInBefore.
  ///
  /// In en, this message translates to:
  /// **'No user has signed in before. Please sign in manually first.'**
  String get noUserSignedInBefore;

  /// No description provided for @failedToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in'**
  String get failedToSignIn;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for that email.'**
  String get emailAlreadyInUse;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get invalidEmail;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during registration'**
  String get registrationError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided.'**
  String get wrongPassword;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login'**
  String get loginError;

  /// No description provided for @googleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled.'**
  String get googleSignInCancelled;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Error during Google sign-in.'**
  String get googleSignInError;

  /// No description provided for @googleSignInUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during Google sign-in'**
  String get googleSignInUnexpectedError;

  /// No description provided for @facebookSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Facebook sign-in was cancelled.'**
  String get facebookSignInCancelled;

  /// No description provided for @facebookSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Facebook sign-in failed'**
  String get facebookSignInFailed;

  /// No description provided for @facebookSignInError.
  ///
  /// In en, this message translates to:
  /// **'Error during Facebook sign-in.'**
  String get facebookSignInError;

  /// No description provided for @facebookSignInUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during Facebook sign-in'**
  String get facebookSignInUnexpectedError;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tooManyAttempts;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send password reset email'**
  String get passwordResetFailed;

  /// No description provided for @passwordResetUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while sending reset email'**
  String get passwordResetUnexpectedError;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent! Check your email.'**
  String get passwordResetLinkSent;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get enterYourPassword;

  /// No description provided for @passwordDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'To enable fingerprint login, please enter your password. It will be stored securely on your device.'**
  String get passwordDialogMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {year}'**
  String lastUpdated(Object year);

  /// No description provided for @ppIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get ppIntroduction;

  /// No description provided for @ppIntroductionText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TO-DO App. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this privacy policy carefully.'**
  String get ppIntroductionText;

  /// No description provided for @ppInformationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get ppInformationWeCollect;

  /// No description provided for @ppInformationWeCollectText.
  ///
  /// In en, this message translates to:
  /// **'We collect information that you provide directly to us when you:\n\n• Create an account\n• Use our task management features\n• Contact us for support\n• Enable biometric authentication\n\nThis may include your email address, name, and task data.'**
  String get ppInformationWeCollectText;

  /// No description provided for @ppHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get ppHowWeUse;

  /// No description provided for @ppHowWeUseText.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process and complete transactions\n• Send you technical notices and support messages\n• Respond to your comments and questions\n• Protect against fraudulent or illegal activity'**
  String get ppHowWeUseText;

  /// No description provided for @ppDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage and Security'**
  String get ppDataStorage;

  /// No description provided for @ppDataStorageText.
  ///
  /// In en, this message translates to:
  /// **'Your data is securely stored using Firebase services. We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.\n\nBiometric data (fingerprint) is stored locally on your device and never transmitted to our servers.'**
  String get ppDataStorageText;

  /// No description provided for @ppDataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get ppDataSharing;

  /// No description provided for @ppDataSharingText.
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:\n\n• With your consent\n• To comply with legal obligations\n• To protect our rights and safety'**
  String get ppDataSharingText;

  /// No description provided for @ppYourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get ppYourRights;

  /// No description provided for @ppYourRightsText.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n• Access your personal data\n• Correct inaccurate data\n• Delete your account and data\n• Opt-out of certain data collection\n• Export your data'**
  String get ppYourRightsText;

  /// No description provided for @ppChildrensPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get ppChildrensPrivacy;

  /// No description provided for @ppChildrensPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Our service is not intended for users under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.'**
  String get ppChildrensPrivacyText;

  /// No description provided for @ppChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get ppChanges;

  /// No description provided for @ppChangesText.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last updated\" date.'**
  String get ppChangesText;

  /// No description provided for @ppContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get ppContact;

  /// No description provided for @ppContactText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: support@todoapp.com\nWebsite: www.todoapp.com'**
  String get ppContactText;

  /// No description provided for @tosAgreement.
  ///
  /// In en, this message translates to:
  /// **'Agreement to Terms'**
  String get tosAgreement;

  /// No description provided for @tosAgreementText.
  ///
  /// In en, this message translates to:
  /// **'By accessing and using TO-DO App, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these Terms of Service, please do not use our application.'**
  String get tosAgreementText;

  /// No description provided for @tosUseLicense.
  ///
  /// In en, this message translates to:
  /// **'Use License'**
  String get tosUseLicense;

  /// No description provided for @tosUseLicenseText.
  ///
  /// In en, this message translates to:
  /// **'Permission is granted to temporarily use TO-DO App for personal, non-commercial use only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the application materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer the software\n• Remove any copyright or proprietary notations\n• Transfer the materials to another person'**
  String get tosUseLicenseText;

  /// No description provided for @tosUserAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get tosUserAccounts;

  /// No description provided for @tosUserAccountsText.
  ///
  /// In en, this message translates to:
  /// **'When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms.\n\nYou are responsible for:\n• Safeguarding your password\n• Any activities or actions under your account\n• Notifying us immediately of any unauthorized use'**
  String get tosUserAccountsText;

  /// No description provided for @tosAcceptableUse.
  ///
  /// In en, this message translates to:
  /// **'Acceptable Use'**
  String get tosAcceptableUse;

  /// No description provided for @tosAcceptableUseText.
  ///
  /// In en, this message translates to:
  /// **'You agree not to use the app to:\n\n• Violate any laws or regulations\n• Infringe on intellectual property rights\n• Transmit harmful code or viruses\n• Harass, abuse, or harm others\n• Engage in unauthorized access\n• Interfere with the app\'s functionality'**
  String get tosAcceptableUseText;

  /// No description provided for @tosContentOwnership.
  ///
  /// In en, this message translates to:
  /// **'Content Ownership'**
  String get tosContentOwnership;

  /// No description provided for @tosContentOwnershipText.
  ///
  /// In en, this message translates to:
  /// **'You retain all rights to the tasks and content you create in the app. By using our service, you grant us a limited license to store and process your content solely for the purpose of providing the service.\n\nWe reserve the right to remove content that violates these terms.'**
  String get tosContentOwnershipText;

  /// No description provided for @tosServiceAvailability.
  ///
  /// In en, this message translates to:
  /// **'Service Availability'**
  String get tosServiceAvailability;

  /// No description provided for @tosServiceAvailabilityText.
  ///
  /// In en, this message translates to:
  /// **'We strive to provide uninterrupted service, but we do not guarantee that:\n\n• The app will be available at all times\n• The app will be error-free\n• Defects will be corrected immediately\n• The app is free of viruses or harmful components'**
  String get tosServiceAvailabilityText;

  /// No description provided for @tosDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer of Warranties'**
  String get tosDisclaimer;

  /// No description provided for @tosDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'The app is provided \"AS IS\" and \"AS AVAILABLE\" without any warranties of any kind, either express or implied. We do not warrant that the app will meet your requirements or that it will be uninterrupted, timely, secure, or error-free.'**
  String get tosDisclaimerText;

  /// No description provided for @tosLimitation.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get tosLimitation;

  /// No description provided for @tosLimitationText.
  ///
  /// In en, this message translates to:
  /// **'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses.'**
  String get tosLimitationText;

  /// No description provided for @tosDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get tosDataBackup;

  /// No description provided for @tosDataBackupText.
  ///
  /// In en, this message translates to:
  /// **'While we take regular backups of your data, you are responsible for maintaining your own backup copies of important information. We recommend exporting your tasks regularly.'**
  String get tosDataBackupText;

  /// No description provided for @tosTermination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get tosTermination;

  /// No description provided for @tosTerminationText.
  ///
  /// In en, this message translates to:
  /// **'We may terminate or suspend your account and access to the app immediately, without prior notice or liability, for any reason, including if you breach these Terms.\n\nUpon termination, your right to use the app will immediately cease. You may delete your account at any time from the app settings.'**
  String get tosTerminationText;

  /// No description provided for @tosChangesToTerms.
  ///
  /// In en, this message translates to:
  /// **'Changes to Terms'**
  String get tosChangesToTerms;

  /// No description provided for @tosChangesToTermsText.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect.\n\nBy continuing to use the app after revisions become effective, you agree to be bound by the revised terms.'**
  String get tosChangesToTermsText;

  /// No description provided for @tosGoverningLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get tosGoverningLaw;

  /// No description provided for @tosGoverningLawText.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which we operate, without regard to its conflict of law provisions.'**
  String get tosGoverningLawText;

  /// No description provided for @tosContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get tosContactInfo;

  /// No description provided for @tosContactInfoText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms of Service, please contact us at:\n\nEmail: legal@todoapp.com\nWebsite: www.todoapp.com\nSupport: support@todoapp.com'**
  String get tosContactInfoText;

  /// No description provided for @changeAccountNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Account Name'**
  String get changeAccountNameTitle;

  /// No description provided for @updateYourDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Update Your Display Name'**
  String get updateYourDisplayName;

  /// No description provided for @displayNameDescription.
  ///
  /// In en, this message translates to:
  /// **'This name will be displayed on your profile and throughout the app.'**
  String get displayNameDescription;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @updateName.
  ///
  /// In en, this message translates to:
  /// **'Update Name'**
  String get updateName;

  /// No description provided for @displayNameInfo.
  ///
  /// In en, this message translates to:
  /// **'Your display name can be changed at any time and is visible to you throughout the app.'**
  String get displayNameInfo;

  /// No description provided for @accountNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account name updated successfully'**
  String get accountNameUpdated;

  /// No description provided for @failedToUpdateName.
  ///
  /// In en, this message translates to:
  /// **'Failed to update name'**
  String get failedToUpdateName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @nameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get nameMaxLength;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update Your Password'**
  String get updateYourPassword;

  /// No description provided for @updatePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new secure password.'**
  String get updatePasswordDescription;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @reenterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get reenterNewPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get passwordRequirements;

  /// No description provided for @atLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters long'**
  String get atLeast6Characters;

  /// No description provided for @differentFromCurrent.
  ///
  /// In en, this message translates to:
  /// **'Different from current password'**
  String get differentFromCurrent;

  /// No description provided for @useStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Use a strong, unique password'**
  String get useStrongPassword;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @newPasswordMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password'**
  String get newPasswordMustBeDifferent;

  /// No description provided for @pleaseConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @newPasswordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'New password is too weak. Please use a stronger password'**
  String get newPasswordTooWeak;

  /// No description provided for @requiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log out and log in again before changing your password'**
  String get requiresRecentLogin;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get passwordChangeFailed;

  /// No description provided for @socialProviderPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Password change is only available for email/password accounts. You signed in with a social provider.'**
  String get socialProviderPasswordChange;

  /// No description provided for @changeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Image'**
  String get changeProfileImage;

  /// No description provided for @updateYourProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Update Your Profile Picture'**
  String get updateYourProfilePicture;

  /// No description provided for @choosePhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo from your gallery or take a new one.'**
  String get choosePhotoDescription;

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get selectPhoto;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @photoRequirements.
  ///
  /// In en, this message translates to:
  /// **'Photo Requirements'**
  String get photoRequirements;

  /// No description provided for @imageResized.
  ///
  /// In en, this message translates to:
  /// **'Image will be resized to 512x512'**
  String get imageResized;

  /// No description provided for @supportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supported formats: JPG, PNG'**
  String get supportedFormats;

  /// No description provided for @chooseClearPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose a clear photo of yourself'**
  String get chooseClearPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @removeCurrentPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Current Photo'**
  String get removeCurrentPhoto;

  /// No description provided for @removeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Profile Image'**
  String get removeProfileImage;

  /// No description provided for @removeImageConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove your profile image?'**
  String get removeImageConfirmation;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated successfully'**
  String get profileImageUpdated;

  /// No description provided for @profileImageRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile image removed successfully'**
  String get profileImageRemoved;

  /// No description provided for @pleaseSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image first'**
  String get pleaseSelectImage;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @failedToTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to take photo'**
  String get failedToTakePhoto;

  /// No description provided for @failedToUpdateImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update image'**
  String get failedToUpdateImage;

  /// No description provided for @failedToRemoveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove image'**
  String get failedToRemoveImage;

  /// No description provided for @aboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsTitle;

  /// No description provided for @flutterDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get flutterDeveloper;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern task management app built with Flutter to help you organize your daily tasks efficiently.'**
  String get appDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @connectWithMe.
  ///
  /// In en, this message translates to:
  /// **'Connect With Me'**
  String get connectWithMe;

  /// No description provided for @madeWithFlutter.
  ///
  /// In en, this message translates to:
  /// **'Made with Flutter'**
  String get madeWithFlutter;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @findAnswers.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions about UpTodo'**
  String get findAnswers;

  /// No description provided for @stillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get stillNeedHelp;

  /// No description provided for @contactSupportAt.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team at'**
  String get contactSupportAt;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a new task?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'Tap the \"+\" button at the bottom of your screen to create a new task. Fill in the task name, description, select a category, set priority, and choose a date and time. Then tap \"Create Task\" to save it.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'What do the priority levels mean?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Tasks have three priority levels:\n\n• High Priority (Flag 1): Urgent and important tasks that need immediate attention\n• Medium Priority (Flag 2): Important but not urgent tasks\n• Low Priority (Flag 3): Tasks that can be done when time permits\n\nPriority helps you organize and focus on what matters most.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'How can I mark a task as complete?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'Simply tap the checkbox next to any task to mark it as complete. The task will be moved to your completed tasks list. You can always view completed tasks by filtering your task view.'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'What happens to completed tasks?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks are automatically deleted after 24 hours to keep your task list clean and organized. This helps improve app performance and keeps you focused on current tasks.\n\nDon\'t worry - you can still access completed tasks within the 24-hour window by filtering your task view.'**
  String get faqAnswer4;

  /// No description provided for @faqQuestion5.
  ///
  /// In en, this message translates to:
  /// **'How do I enable fingerprint login?'**
  String get faqQuestion5;

  /// No description provided for @faqAnswer5.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Security and toggle on \"Fingerprint Login\". You\'ll need to authenticate with your fingerprint and, if you signed in with email/password, enter your password to securely store your credentials.\n\nFingerprint login provides quick and secure access to your account.'**
  String get faqAnswer5;

  /// No description provided for @faqQuestion6.
  ///
  /// In en, this message translates to:
  /// **'Can I edit or delete a task?'**
  String get faqQuestion6;

  /// No description provided for @faqAnswer6.
  ///
  /// In en, this message translates to:
  /// **'Yes! Tap on any task to view its details. From there, you can:\n\n• Edit task information by tapping the edit button\n• Delete the task by tapping the delete button\n• Mark it as complete/incomplete\n\nYou can also swipe left on a task in the list for quick actions.'**
  String get faqAnswer6;

  /// No description provided for @faqQuestion7.
  ///
  /// In en, this message translates to:
  /// **'How do task categories work?'**
  String get faqQuestion7;

  /// No description provided for @faqAnswer7.
  ///
  /// In en, this message translates to:
  /// **'Categories help you organize tasks by type or context. Choose from predefined categories like Work, Personal, Shopping, Health, or Other when creating a task.\n\nYou can filter your task list by category to focus on specific areas of your life.'**
  String get faqAnswer7;

  /// No description provided for @faqQuestion8.
  ///
  /// In en, this message translates to:
  /// **'Is my data safe and private?'**
  String get faqQuestion8;

  /// No description provided for @faqAnswer8.
  ///
  /// In en, this message translates to:
  /// **'Absolutely! All your tasks are securely stored in Firebase and are only accessible to you. Your credentials are encrypted, and biometric data (fingerprint) never leaves your device.\n\nWe take your privacy seriously and never share your data with third parties.'**
  String get faqAnswer8;

  /// No description provided for @faqQuestion9.
  ///
  /// In en, this message translates to:
  /// **'Can I use the app offline?'**
  String get faqQuestion9;

  /// No description provided for @faqAnswer9.
  ///
  /// In en, this message translates to:
  /// **'The app requires an internet connection to sync your tasks across devices and save changes to the cloud. However, you can view previously loaded tasks offline.\n\nChanges made offline will be synced automatically when you reconnect to the internet.'**
  String get faqAnswer9;

  /// No description provided for @faqQuestion10.
  ///
  /// In en, this message translates to:
  /// **'How do I sign out of my account?'**
  String get faqQuestion10;

  /// No description provided for @faqAnswer10.
  ///
  /// In en, this message translates to:
  /// **'To sign out, go to your Profile screen and tap the \"Logout\" button. You\'ll be asked to confirm before signing out.\n\nMake sure all your tasks are synced before signing out to avoid losing any data.'**
  String get faqAnswer10;

  /// No description provided for @faqQuestion11.
  ///
  /// In en, this message translates to:
  /// **'What should I do if I forgot my password?'**
  String get faqQuestion11;

  /// No description provided for @faqAnswer11.
  ///
  /// In en, this message translates to:
  /// **'On the login screen, tap \"Forgot Password?\" and enter your email address. We\'ll send you a password reset link to your email.\n\nFollow the instructions in the email to create a new password and regain access to your account.'**
  String get faqAnswer11;

  /// No description provided for @faqQuestion12.
  ///
  /// In en, this message translates to:
  /// **'Can I sync tasks across multiple devices?'**
  String get faqQuestion12;

  /// No description provided for @faqAnswer12.
  ///
  /// In en, this message translates to:
  /// **'Yes! Your tasks are automatically synced across all devices where you\'re signed in with the same account. Simply log in with your email or social account on any device.\n\nChanges are synced in real-time, so you\'ll always have access to your latest tasks.'**
  String get faqAnswer12;

  /// No description provided for @helpAndFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get helpAndFeedback;

  /// No description provided for @wereHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help!'**
  String get wereHereToHelp;

  /// No description provided for @browseHelpTopics.
  ///
  /// In en, this message translates to:
  /// **'Browse help topics or send us your feedback'**
  String get browseHelpTopics;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @sendUsYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get sendUsYourFeedback;

  /// No description provided for @weLoveToHear.
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear from you!'**
  String get weLoveToHear;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @feedbackType.
  ///
  /// In en, this message translates to:
  /// **'Feedback Type'**
  String get feedbackType;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get yourFeedback;

  /// No description provided for @tellUsWhatYouThink.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think...'**
  String get tellUsWhatYouThink;

  /// No description provided for @generalFeedback.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalFeedback;

  /// No description provided for @bugReport.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get bugReport;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @thankYouForFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouForFeedback;

  /// No description provided for @helpGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpGettingStarted;

  /// No description provided for @helpGettingStartedDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to UpTodo! Start by creating your first task using the \"+\" button. Organize your tasks by categories, set priorities, and never miss a deadline with our reminder system.\n\nExplore the app to discover all features and make the most of your productivity journey.'**
  String get helpGettingStartedDesc;

  /// No description provided for @helpManagingTasks.
  ///
  /// In en, this message translates to:
  /// **'Managing Your Tasks'**
  String get helpManagingTasks;

  /// No description provided for @helpManagingTasksDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your tasks organized:\n\n• Create tasks with detailed descriptions\n• Assign categories for better organization\n• Set priority levels (High, Medium, Low)\n• Add due dates and times\n• Mark tasks as complete when done\n\nSwipe left on tasks for quick actions like edit and delete.'**
  String get helpManagingTasksDesc;

  /// No description provided for @helpAccountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get helpAccountProfile;

  /// No description provided for @helpAccountProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience:\n\n• Update your profile picture\n• Change your display name\n• Update your password for security\n• Enable biometric login for quick access\n• Sync across multiple devices\n\nYour data is securely stored and accessible only to you.'**
  String get helpAccountProfileDesc;

  /// No description provided for @helpSecurityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get helpSecurityPrivacy;

  /// No description provided for @helpSecurityPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'We take your security seriously:\n\n• All data is encrypted and stored securely in Firebase\n• Biometric authentication available for quick secure access\n• Your credentials are never shared with third parties\n• Fingerprint data never leaves your device\n\nYou have full control over your data at all times.'**
  String get helpSecurityPrivacyDesc;

  /// No description provided for @helpTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get helpTroubleshooting;

  /// No description provided for @helpTroubleshootingDesc.
  ///
  /// In en, this message translates to:
  /// **'Having issues? Try these steps:\n\n• Make sure you have a stable internet connection\n• Check if the app is updated to the latest version\n• Try signing out and signing back in\n• Clear the app cache if experiencing performance issues\n• Restart your device\n\nIf problems persist, contact our support team.'**
  String get helpTroubleshootingDesc;

  /// No description provided for @helpTipsBestPractices.
  ///
  /// In en, this message translates to:
  /// **'Tips & Best Practices'**
  String get helpTipsBestPractices;

  /// No description provided for @helpTipsBestPracticesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get the most out of UpTodo:\n\n• Review your tasks at the start of each day\n• Use priority levels to focus on what matters\n• Break large tasks into smaller, manageable ones\n• Set realistic deadlines to avoid stress\n• Regularly archive or delete completed tasks\n• Use categories to organize different areas of your life'**
  String get helpTipsBestPracticesDesc;

  /// No description provided for @supportUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Us'**
  String get supportUsTitle;

  /// No description provided for @supportOurWork.
  ///
  /// In en, this message translates to:
  /// **'Support Our Work'**
  String get supportOurWork;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Your support helps us keep the app free and continuously improve it with new features'**
  String get supportDescription;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @whySupport.
  ///
  /// In en, this message translates to:
  /// **'Why Support?'**
  String get whySupport;

  /// No description provided for @newFeatures.
  ///
  /// In en, this message translates to:
  /// **'New Features'**
  String get newFeatures;

  /// No description provided for @helpDevelopFeatures.
  ///
  /// In en, this message translates to:
  /// **'Help us develop exciting new features'**
  String get helpDevelopFeatures;

  /// No description provided for @bugFixes.
  ///
  /// In en, this message translates to:
  /// **'Bug Fixes'**
  String get bugFixes;

  /// No description provided for @supportMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Support ongoing maintenance and improvements'**
  String get supportMaintenance;

  /// No description provided for @freeForever.
  ///
  /// In en, this message translates to:
  /// **'Free Forever'**
  String get freeForever;

  /// No description provided for @keepAppFree.
  ///
  /// In en, this message translates to:
  /// **'Keep the app free for everyone'**
  String get keepAppFree;

  /// No description provided for @developerSupport.
  ///
  /// In en, this message translates to:
  /// **'Developer Support'**
  String get developerSupport;

  /// No description provided for @buyUsCoffee.
  ///
  /// In en, this message translates to:
  /// **'Buy us a coffee to keep us motivated'**
  String get buyUsCoffee;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Every contribution, no matter how small, makes a huge difference. Thank you for your support!'**
  String get thankYouMessage;

  /// No description provided for @detailsCopied.
  ///
  /// In en, this message translates to:
  /// **'details copied to clipboard!'**
  String get detailsCopied;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @changeThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Change Theme Color'**
  String get changeThemeColor;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskName;

  /// No description provided for @enterTaskName.
  ///
  /// In en, this message translates to:
  /// **'Enter task name'**
  String get enterTaskName;

  /// No description provided for @enterTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter task description'**
  String get enterTaskDescription;

  /// No description provided for @taskNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Task name cannot be empty'**
  String get taskNameEmpty;

  /// No description provided for @taskUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdatedSuccessfully;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get deleteTaskConfirm;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @dueTime.
  ///
  /// In en, this message translates to:
  /// **'Due Time'**
  String get dueTime;

  /// No description provided for @markAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markAsComplete;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @noCompletedTasks.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks'**
  String get noCompletedTasks;

  /// No description provided for @noTasksForDate.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this date'**
  String get noTasksForDate;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @focusModeDescription.
  ///
  /// In en, this message translates to:
  /// **'While your focus mode is on, all of your notifications will be off'**
  String get focusModeDescription;

  /// No description provided for @startFocusing.
  ///
  /// In en, this message translates to:
  /// **'Start Focusing'**
  String get startFocusing;

  /// No description provided for @stopFocusing.
  ///
  /// In en, this message translates to:
  /// **'Stop Focusing'**
  String get stopFocusing;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @applications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get applications;

  /// No description provided for @youSpent.
  ///
  /// In en, this message translates to:
  /// **'You spent'**
  String get youSpent;

  /// No description provided for @minutesToday.
  ///
  /// In en, this message translates to:
  /// **'min on it today'**
  String get minutesToday;

  /// No description provided for @appsThatMayDistract.
  ///
  /// In en, this message translates to:
  /// **'Apps that may consume your time'**
  String get appsThatMayDistract;

  /// No description provided for @commonDistraction.
  ///
  /// In en, this message translates to:
  /// **'Common distraction'**
  String get commonDistraction;

  /// No description provided for @chooseThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme Color'**
  String get chooseThemeColor;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
