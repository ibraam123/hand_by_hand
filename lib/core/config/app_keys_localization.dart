/// `AppKeys` is a utility class that centralizes all localization keys used within the application.
/// This approach helps in managing and accessing localized strings more efficiently.

/// `AppKeys` is a utility class that centralizes all localization keys used within the application.
/// This helps avoid hardcoding strings and makes localization easier to maintain.
class AppKeys {
  // App
  static const String appName = 'app_name';
}

/// Authentication Keys
abstract class AuthKeys {
  static const String passwordMustBeAtLeast6Characters = 'auth.password_must_be_at_least_6_characters';
  static const String sendResetLink = 'auth.send_reset_link';
  static const String joinUs = 'auth.join_us';
  static const String firstName = 'auth.first_name';
  static const String lastName = 'auth.last_name';
  static const String email = 'auth.email';
  static const String password = 'auth.password';
  static const String dateOfBirth = 'auth.date_of_birth';
  static const String day = 'auth.day';
  static const String month = 'auth.month';
  static const String year = 'auth.year';
  static const String gender = 'auth.gender';
  static const String female = 'auth.female';
  static const String male = 'auth.male';
  static const String signUp = 'auth.sign_up';
  static const String alreadyHaveAccount = 'auth.already_have_account';
  static const String logIn = 'auth.log_in';
  static const String welcomeBack = 'auth.welcome_back';
  static const String rememberMe = 'auth.remember_me';
  static const String forgotPassword = 'auth.forgot_password';
  static const String dontHaveAccount = 'auth.dont_have_account';
  static const String continueWithGoogle = 'auth.continue_with_google';
  static const String or = 'auth.or';
  static const String forgotPasswordQuestion = 'auth.forgot_password_question';
  static const String passwordResetEmailSent = 'auth.password_reset_email_sent';
  static const String pleaseEnterValidEmail = 'auth.please_enter_valid_email';



  // Hints
  static const String enterYourEmail = 'auth.enter_your_email';
  static const String enterYourPassword = 'auth.enter_your_password';
  static const String enterFirstName = 'auth.enter_first_name';
  static const String enterLastName = 'auth.enter_last_name';
  static const String enterDateOfBirth = 'auth.enter_date_of_birth';
  static const String enterGender = 'auth.enter_gender';
  static const String enterPassword = 'auth.enter_password';
  static const String enterConfirmPassword = 'auth.enter_confirm_password';
  static const String pleaseFillInAllFields = 'auth.please_fill_in_all_fields';
}

/// Onboarding Keys
abstract class OnboardingKeys {
  static const String whoAreYou = 'onboarding.who_are_you';
  static const String chooseExperience = 'onboarding.choose_experience';
  static const String livingWithDisability = 'onboarding.living_with_disability';
  static const String regularUser = 'onboarding.regular_user';
  static const String helpingFamily = 'onboarding.helping_family';
  static const String loginSuccessful = 'onboarding.login_successful';
  static const String toEveryone = 'onboarding.to_everyone';
  static const String youAreNotAlone = 'onboarding.you_are_not_alone';
  static const String inspirationalMessage = 'onboarding.inspirational_message';
  static const String getStarted = 'onboarding.get_started';
  static const String screen1Title = 'onboarding.screen1_title';
  static const String screen1Description = 'onboarding.screen1_description';
  static const String screen2Title = 'onboarding.screen2_title';
  static const String screen2Description = 'onboarding.screen2_description';
  static const String screen3Title = 'onboarding.screen3_title';
  static const String screen3Description = 'onboarding.screen3_description';
}

/// Navigation Keys
abstract class NavigationKeys {
  static const String home = 'navigation.home';
  static const String notifications = 'navigation.notifications';
  static const String profile = 'navigation.profile';
  static const String signLanguage = 'navigation.sign_language';
  static const String aboutUs = 'navigation.about_us';
  static const String favorites = 'navigation.favorites';
  static const String community = 'navigation.community';
  static const String posts = 'navigation.posts';
  static const String helpSupport = 'navigation.help_support';
}

abstract class Home {
  static const String welcome = 'home.welcome';
  static const String loading = 'home.loading';
  static const String error = 'home.error';

  static const String accessiblePlaces = 'home.accessible_places';
  static const String accessiblePlacesSub = 'home.accessible_places_sub';
  static const String explorePlaces = 'home.explore_places';

  static const String signLessons = 'home.sign_lessons';
  static const String signLessonsSub = 'home.sign_lessons_sub';
  static const String startLearning = 'home.start_learning';

  static const String roleModels = 'home.role_models';
  static const String roleModelsSub = 'home.role_models_sub';
  static const String getInspired = 'home.get_inspired';

  static const String community = 'home.community';
  static const String communitySub = 'home.community_sub';
  static const String joinCommunity = 'home.join_community';
  static const String addPlace = 'home.add_place';
}

abstract class Profile {
  static const String editProfile = 'profile.edit_profile';
  static const String helpSupport = 'profile.help_support';
  static const String feedback = 'profile.feedback';
  static const String darkMode = 'profile.dark_mode';
  static const String lightMode = 'profile.light_mode';
  static const String about = 'profile.about';
  static const String rateUs = 'profile.rate_us';
  static const String share = 'profile.share';
}

abstract class SignLanguage {
  static const String watchVideo = 'sign_language.watch_video';
  static const String hello = 'sign_language.hello';
  static const String helloDesc = 'sign_language.hello_desc';
  static const String sorry = 'sign_language.sorry';
  static const String sorryDesc = 'sign_language.sorry_desc';
  static const String iloveyou = 'sign_language.iloveyou';
  static const String iloveyouDesc = 'sign_language.iloveyou_desc';
  static const String please = 'sign_language.please';
  static const String pleaseDesc = 'sign_language.please_desc';
  static const String yes = 'sign_language.yes';
  static const String yesDesc = 'sign_language.yes_desc';
  static const String goodNight = 'sign_language.good_night';
  static const String goodNightDesc = 'sign_language.good_night_desc';
}

abstract class Favorites {
  static const String empty = 'favorites.empty';
  static const String removed = 'favorites.removed';
  static const String location = 'favorites.location';
}

abstract class About{
  static const String ourMission = 'about.our_mission';
  static const String missionDesc = 'about.mission_desc';
  static const String ourStory = 'about.our_story';
  static const String storyDesc = 'about.story_desc';
  static const String featuresImpact = 'about.features_impact';
  static const String feature1 = 'about.feature1';
  static const String feature2 = 'about.feature2';
  static const String feature3 = 'about.feature3';
  static const String feature4 = 'about.feature4';
}

abstract class Community {
  static const String enterTitle = 'community.enter_title';
  static const String postTitle = "community.post_title";
  static const String communityChat = 'community.community_chat';
  static const String chatMessaging = 'community.chat_messaging';
  static const String chatDesc = 'community.chat_desc';
  static const String socialFeed = 'community.social_feed';
  static const String socialDesc = 'community.social_desc';
  static const String typeMessage = 'community.type_message';
  static const String addComment = 'community.add_comment';
  static const String send = 'community.send';
  static const String post = 'community.post';
  static const String like = 'community.like';
  static const String comments = 'community.comments';
  static const String share = 'community.share';
}

abstract class Notifications{
  static const String notifications = 'notifications.notifications';
  static const String noNotifications = 'notifications.no_notifications';
  static const String remove = 'notifications.remove';
}

abstract class HelpSupport {
  static const String faq = 'help_support.faq';
  static const String faq1 = 'help_support.faq1';
  static const String faq2 = 'help_support.faq2';
  static const String faq3 = 'help_support.faq3';
  static const String faq4 = 'help_support.faq4';
  static const String contactSupport = 'help_support.contact_support';
  static const String phone = 'help_support.phone';
  static const String email = 'help_support.email';
  static const String facebook = 'help_support.facebook';
  static const String facebookPage = 'help_support.facebook_page';
  static const String supportMessage = 'help_support.support_message';
  static const String freq1desc = 'help_support.freq1desc';
  static const String freq2desc = 'help_support.freq2desc';
  static const String freq3desc = 'help_support.freq3desc';
  static const String freq4desc = 'help_support.freq4desc';
}

abstract class General {
  static const String ok = 'general.ok';
  static const String yes = 'general.yes';
  static const String noPostsYet = 'general.no_posts_yet';
  static const String noCommentsYet = 'general.no_comments_yet';
  static const String noRoleModelsYet = 'general.no_role_models_yet';
  static const String beTheFirstToShare = 'general.be_the_first_to_share';
  static const String fireNotification = 'general.fire_notification';
  static const String newPost = 'general.new_post';
  static const String postedBy = 'general.posted_by';
  static const String loading = 'general.loading';
  static const String error = 'general.error';
  static const String success = 'general.success';
  static const String save = 'general.save';
  static const String cancel = 'general.cancel';
  static const String delete = 'general.delete';
  static const String add = 'general.add';
  static const String edit = 'general.edit';
  static const String search = 'general.search';
  static const String settings = 'general.settings';
  static const String logout = 'general.logout';
  static const String submit = 'general.submit';
  static const String thanksFeedback = 'general.thanksFeedback';
  static const String enterYourFeedback = 'general.enter_your_feedback';
}

abstract class RoleModels {
  static const String title = 'role_models.title';
  static const String discoverInspiration = 'role_models.discover_inspiration';
  static const String viewDetails = 'role_models.view_details';
  static const String achievements = 'role_models.achievements';
  static const String story = 'role_models.story';
}

abstract class CategoriesPlaces {
  static const String all = 'categories_places.all';
  static const String cafe = 'categories_places.cafe';
  static const String restaurant = 'categories_places.restaurant';
  static const String park = 'categories_places.park';
  static const String clinic = 'categories_places.clinic';
  static const String pharmacy = 'categories_places.pharmacy';
  static const String mall = 'categories_places.mall';
  static const String hospital = 'categories_places.hospital';
}

abstract class CategoriesSignLanguage{
  static const String all = 'categories_lessons.all';
  static const String beginner = 'categories_lessons.beginner';
  static const String intermediate = 'categories_lessons.intermediate';
  static const String hard = 'categories_lessons.hard';
  static const String veryHard = 'categories_lessons.very_hard';
}

abstract class AccessiblePlaces {
  static const String title = 'accessible_places.title';
  static const String searchPlaces = 'accessible_places.search_places';
  static const String nearby = 'accessible_places.nearby';
  static const String accessibilityFeatures = 'accessible_places.accessibility_features';
  static const String wheelchair = 'accessible_places.wheelchair';
  static const String braille = 'accessible_places.braille';
  static const String hearing = 'accessible_places.hearing';
  static const String distance = 'accessible_places.distance';
  static const String directions = 'accessible_places.directions';
  static const String call = 'accessible_places.call';
  static const String addPlace = 'accessible_places.add_place';
  static const String placeName = 'accessible_places.place_name';
  static const String latitude = 'accessible_places.latitude';
  static const String longitude = 'accessible_places.longitude';
  static const String category = 'accessible_places.category';
  static const String selectCategory = 'accessible_places.select_category';
  static const String enterLatitude = 'accessible_places.enter_latitude';
  static const String enterLongitude = 'accessible_places.enter_longitude';
  static const String enterName = 'accessible_places.enter_name';
}

abstract class Places {
  static const String title = 'places.title';
  static const String searchPlaces = 'places.search_places';
  static const String nearby = 'places.nearby';
  static const String accessibilityFeatures = 'places.accessibility_features';
  static const String wheelchair = 'places.wheelchair';
  static const String braille = 'places.braille';
  static const String hearing = 'places.hearing';
  static const String distance = 'places.distance';
  static const String directions = 'places.directions';
  static const String call = 'places.call';
}

