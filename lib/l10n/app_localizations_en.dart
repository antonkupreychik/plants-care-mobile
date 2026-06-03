// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeOverline => 'MY GARDEN';

  @override
  String get appTitle => 'PlantCare';

  @override
  String get homeSubtitle =>
      'The app framework is ready.\nYour garden will grow here soon.';

  @override
  String get buildOk => 'Build is working';

  @override
  String get fieldFlavor => 'Flavor';

  @override
  String get fieldApi => 'API';

  @override
  String get fieldDevAuth => 'Dev auth';

  @override
  String get homeGreeting => 'Hello';

  @override
  String get homeSearchTooltip => 'Search';

  @override
  String get homeNotificationsTooltip => 'Notifications';

  @override
  String get homeTodayTitle => 'Today';

  @override
  String homeTodayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String get homeTasksEmpty => 'No tasks for today';

  @override
  String get homeTasksEmptyHint => 'You can relax — all plants are watered';

  @override
  String get homeTodaySeeAll => 'See all';

  @override
  String get todayBack => 'Back';

  @override
  String todayHeroCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Today $count tasks in the garden',
      one: 'Today $count task in the garden',
      zero: 'No tasks in the garden today',
    );
    return '$_temp0';
  }

  @override
  String todaySummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String todaySummaryOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overdue',
      one: '$count overdue',
      zero: 'none overdue',
    );
    return '$_temp0';
  }

  @override
  String get todayFilterAll => 'All';

  @override
  String get todayFilterWatering => 'Watering';

  @override
  String get todayFilterMisting => 'Misting';

  @override
  String get todayFilterFertilizing => 'Fertilizing';

  @override
  String get todayFilterOverdue => 'Overdue';

  @override
  String get todayPhaseMorning => 'Morning';

  @override
  String get todayPhaseEvening => 'Evening';

  @override
  String todaySectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
      zero: 'no tasks',
    );
    return '$_temp0';
  }

  @override
  String get todayOverdueBadge => 'OVERDUE';

  @override
  String get todayEmptyAll => 'No tasks for today';

  @override
  String get todayEmptyAllHint => 'You can relax — all plants are watered';

  @override
  String get todayEmptyFilter => 'No tasks in this category';

  @override
  String get todayEmptyFilterHint => 'Try a different filter';

  @override
  String get homeGardenTitle => 'My garden';

  @override
  String homePlantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants',
      one: '$count plant',
      zero: 'No plants',
    );
    return '$_temp0';
  }

  @override
  String get homeLocationAll => 'All';

  @override
  String get homeAddPlant => 'Add plant';

  @override
  String get homeRoomEmpty => 'No plants in this room yet';

  @override
  String get homeGardenEmptyEyebrow => 'Garden is empty';

  @override
  String get homeGardenEmptyHeading => 'Shall we add the first plant?';

  @override
  String get homeGardenEmptySubtitle =>
      'I\'ll build a care schedule and remind you — just the way you like it.';

  @override
  String get homeRecognizeByPhoto => 'Identify by photo';

  @override
  String get homeStarterIdeasTitle => 'Starter ideas';

  @override
  String get homeStarterMonstera => 'Monstera';

  @override
  String get homeStarterMonsteraHint => 'easy';

  @override
  String get homeStarterSucculent => 'Succulent';

  @override
  String get homeStarterSucculentHint => 'hard to kill';

  @override
  String get homeStarterPothos => 'Pothos';

  @override
  String get homeStarterPothosHint => 'beginner-friendly';

  @override
  String get careActionWatering => 'Water';

  @override
  String get careActionMisting => 'Mist';

  @override
  String get careActionFertilizing => 'Fertilize';

  @override
  String get careActionSoilCheck => 'Check soil';

  @override
  String get careActionUnknown => 'Care';

  @override
  String get careDueOverdue => 'Overdue';

  @override
  String get careDueToday => 'Today';

  @override
  String careDueAt(String time) {
    return 'Today at $time';
  }

  @override
  String get navGarden => 'Garden';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navProfile => 'Me';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork =>
      'No connection. Check your internet and try again';

  @override
  String get errorNotFound => 'Data not found';

  @override
  String get errorAccessDenied => 'Access denied';

  @override
  String get errorUnauthorized => 'Session expired. Please sign in again';

  @override
  String get errorValidation => 'Please check the entered data';

  @override
  String get errorConflict => 'Data has changed. Refresh the screen';

  @override
  String get errorGeneric => 'Something went wrong. Try again later';

  @override
  String get plantCardOverline => 'Plant card';

  @override
  String get plantCardBack => 'Back';

  @override
  String get plantCardMore => 'More';

  @override
  String plantCardWithMeFor(String duration) {
    return 'With me for $duration';
  }

  @override
  String plantCardAgeYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '$count year',
      zero: 'less than a year',
    );
    return '$_temp0';
  }

  @override
  String plantCardAgeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
      zero: 'less than a month',
    );
    return '$_temp0';
  }

  @override
  String scheduleWeekTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This week $count tasks in the garden',
      one: 'This week $count task in the garden',
      zero: 'The garden rests this week',
    );
    return '$_temp0';
  }

  @override
  String scheduleDayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
      zero: 'Free',
    );
    return '$_temp0';
  }

  @override
  String plantCardAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get plantCardStreakTitle => 'Care streak';

  @override
  String plantCardStreakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '$count day in a row',
      zero: 'Streak broken',
    );
    return '$_temp0';
  }

  @override
  String get plantCardStreakHint => 'On-time cares in a row';

  @override
  String get plantCardStreakEmpty => 'No streak yet — start caring on time';

  @override
  String get plantCardNotesTitle => 'Notes';

  @override
  String get plantCardJournalTitle => 'Care journal';

  @override
  String get plantCardJournalEmpty => 'No entries yet';

  @override
  String get plantCardJournalEmptyHint =>
      'Log the first care — and the history will appear here';

  @override
  String get plantCardJournalOnTime => 'on time';

  @override
  String get plantCardLogCare => 'Log care';

  @override
  String plantCardHistoryDate(String date, String time) {
    return '$date, $time';
  }

  @override
  String healthBadgeLabel(int score) {
    return 'HEALTH $score';
  }

  @override
  String get healthScoreUnknown => 'HEALTH —';

  @override
  String healthSemanticScore(int score) {
    return 'Plant health: $score out of 100';
  }

  @override
  String get healthSemanticUnknown => 'Plant health: not enough data';

  @override
  String get careDoneWater => 'Watered';

  @override
  String get careDoneSpray => 'Misted';

  @override
  String get careDoneFertilize => 'Fertilized';

  @override
  String get careDoneUnknown => 'Care done';

  @override
  String get careSheetOverline => 'Log care';

  @override
  String get careSheetTitle => 'What did you do?';

  @override
  String careSheetTitleFor(String plant) {
    return 'Care for $plant';
  }

  @override
  String get careSheetClose => 'Close';

  @override
  String get careSheetTypeLabel => 'Care type';

  @override
  String get careKindWater => 'Water';

  @override
  String get careKindSpray => 'Mist';

  @override
  String get careKindFertilize => 'Fertilize';

  @override
  String get careSheetWhenLabel => 'When done';

  @override
  String get careSheetWhenNow => 'Now';

  @override
  String careSheetWhenValue(String date, String time) {
    return '$date, $time';
  }

  @override
  String get careSheetNoteLabel => 'Note';

  @override
  String get careSheetNoteHint => 'E.g.: watered until drainage';

  @override
  String get careSheetNoteOptional => 'optional';

  @override
  String get careSheetSubmit => 'Log';

  @override
  String get careSheetSubmitted => 'Care logged';

  @override
  String get scheduleIcsTitle => 'Subscribe to calendar';

  @override
  String get scheduleIcsSubtitle => 'Google / Apple Calendar — .ics';

  @override
  String get scheduleToCurrentWeek => 'Current week';

  @override
  String get schedulePreviousWeek => 'Previous week';

  @override
  String get scheduleNextWeek => 'Next week';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogHeading => 'Plant catalog';

  @override
  String get catalogSearchHint => 'Find a species…';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String catalogCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count species',
      one: '$count species',
      zero: 'No species',
    );
    return '$_temp0';
  }

  @override
  String addPlantStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get addPlantOverline => 'New plant';

  @override
  String get addPlantClose => 'Close';

  @override
  String get addPlantBack => 'Back';

  @override
  String get addPlantNext => 'Next';

  @override
  String get addPlantSkip => 'Skip';

  @override
  String get addPlantSubmit => 'Add';

  @override
  String get addPlantSpeciesTitle => 'What plant do you have?';

  @override
  String get addPlantSpeciesSubtitle =>
      'We\'ll find the species, suggest a name and care plan. Not sure — skip it.';

  @override
  String get addPlantSearchHint => 'monstera, ficus, succulent…';

  @override
  String get addPlantSearchEmpty => 'Nothing found';

  @override
  String get addPlantSearchEmptyHint =>
      'Try a different query or skip species selection';

  @override
  String get addPlantSkipSpeciesTitle => 'I don\'t know what it is';

  @override
  String get addPlantSkipSpeciesHint =>
      'We\'ll add it as "Plant". You can update it later.';

  @override
  String get addPlantNameTitle => 'What\'s the name?';

  @override
  String get addPlantNameSubtitle =>
      'A name helps you remember the plant\'s personality.';

  @override
  String get addPlantNameLabel => 'Plant name';

  @override
  String get addPlantNameHint => 'E.g.: Monica';

  @override
  String addPlantNameError(int max) {
    return 'Enter a name (up to $max characters)';
  }

  @override
  String get addPlantRoomLabel => 'Where does it live';

  @override
  String get addPlantRoomNone => 'No room';

  @override
  String get addPlantRoomsEmpty => 'No rooms yet — the plant will go to the garden';

  @override
  String get addPlantCarePlanTitle => 'Care plan';

  @override
  String get addPlantCarePlanSubtitle =>
      'Species recommendations. Cannot be changed yet.';

  @override
  String get addPlantCarePlanReadOnly => 'Read only';

  @override
  String addPlantCarePlanEvery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every $count days',
      one: 'every day',
    );
    return '$_temp0';
  }

  @override
  String get catalogEmpty => 'Catalog is empty';

  @override
  String get catalogEmptyHint => 'Plant species will appear here later';

  @override
  String get catalogSearchEmpty => 'Nothing found';

  @override
  String catalogSearchEmptyHint(String query) {
    return 'Try changing the query "$query"';
  }

  @override
  String get catalogLoadMoreError => 'Failed to load more';

  @override
  String get speciesDetailOverline => 'Species';

  @override
  String get speciesDescriptionTitle => 'Description';

  @override
  String get speciesCareTitle => 'Care';

  @override
  String get speciesPropsTitle => 'Conditions';

  @override
  String get speciesDifficultyLabel => 'Difficulty';

  @override
  String get speciesLightLabel => 'Light';

  @override
  String get speciesDifficultyEasy => 'Easy care';

  @override
  String get speciesDifficultyMedium => 'Moderate care';

  @override
  String get speciesDifficultyHard => 'Demanding care';

  @override
  String get speciesDifficultyUnknown => 'Difficulty not specified';

  @override
  String get speciesLightFullSun => 'Full sun';

  @override
  String get speciesLightBrightIndirect => 'Bright indirect';

  @override
  String get speciesLightPartialShade => 'Partial shade';

  @override
  String get speciesLightShade => 'Shade';

  @override
  String get speciesLightUnknown => 'Light not specified';

  @override
  String get speciesCareWatering => 'Watering';

  @override
  String get speciesCareMisting => 'Misting';

  @override
  String get speciesCareFertilizing => 'Fertilizing';

  @override
  String get speciesCareSoilCheck => 'Soil check';

  @override
  String speciesCareEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every $count days',
      one: 'every $count day',
    );
    return '$_temp0';
  }

  @override
  String speciesWateringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every $count d.',
      one: 'every $count d.',
    );
    return '$_temp0';
  }

  @override
  String get speciesFactDifficulty => 'Difficulty';

  @override
  String get speciesFactLight => 'Light';

  @override
  String get speciesFactWatering => 'Watering';

  @override
  String get speciesToxicTitle => 'Toxic to cats, dogs, and children';

  @override
  String get speciesToxicSubtitle =>
      'Leaf sap irritates mucous membranes. Keep it out of reach.';

  @override
  String get speciesLightTitle => 'Light';

  @override
  String get speciesLightStepShade => 'Shade';

  @override
  String get speciesLightStepPartial => 'Partial';

  @override
  String get speciesLightStepIndirect => 'Indirect';

  @override
  String get speciesLightStepDirect => 'Direct';

  @override
  String get speciesAddToGarden => 'Add to my garden';

  @override
  String get addPlantCarePlanEmpty =>
      'Select a species in the first step to see the care plan';

  @override
  String get addPlantCarePlanNone => 'No care recommendations for this species';

  @override
  String get addPlantConfirmTitle => 'Almost done';

  @override
  String get addPlantConfirmSubtitle =>
      'Check the details and add the plant to your garden.';

  @override
  String get addPlantSummaryName => 'Name';

  @override
  String get addPlantSummaryRoom => 'Room';

  @override
  String get addPlantSummaryCarePlan => 'Care plan';

  @override
  String addPlantSummaryCarePlanCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
      zero: 'no recommendations',
    );
    return '$_temp0';
  }

  @override
  String get addPlantNoteLabel => 'Note';

  @override
  String get addPlantNoteHint => 'E.g.: birthday gift';

  @override
  String get addPlantNoteOptional => 'optional';

  @override
  String get addPlantSubmitted => 'Plant added';

  @override
  String get careDifficultyEasy => 'Easy care';

  @override
  String get careDifficultyMedium => 'Moderate care';

  @override
  String get careDifficultyHard => 'Demanding care';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileOverline => 'SETTINGS';

  @override
  String get profileSectionMore => 'More';

  @override
  String get profileRoomsTitle => 'Homes & places';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutConfirmTitle => 'Sign out?';

  @override
  String get profileSignOutConfirmMessage =>
      'You will be taken to the sign-in screen. To reopen your garden, you\'ll need to sign in with your email.';

  @override
  String get profileSignOutConfirmCancel => 'Cancel';

  @override
  String get profileSignOutConfirmAction => 'Sign out';

  @override
  String get roomsTitle => 'Homes & places';

  @override
  String get roomsOverline => 'MY ROOMS';

  @override
  String get roomsBack => 'Back';

  @override
  String roomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms',
      one: '$count room',
      zero: 'No rooms',
    );
    return '$_temp0';
  }

  @override
  String get roomsDefaultBadge => 'Default';

  @override
  String get roomsAdd => 'Add room';

  @override
  String get roomsEditAction => 'Edit';

  @override
  String get roomsDeleteAction => 'Delete';

  @override
  String get roomsEmptyTitle => 'No rooms yet';

  @override
  String get roomsEmptyHint =>
      'Add a room to group plants by location';

  @override
  String get roomSheetCreateOverline => 'New room';

  @override
  String get roomSheetEditOverline => 'Room';

  @override
  String get roomSheetCreateTitle => 'Add room';

  @override
  String get roomSheetEditTitle => 'Edit room';

  @override
  String get roomSheetClose => 'Close';

  @override
  String get roomSheetNameLabel => 'Name';

  @override
  String get roomSheetNameHint => 'E.g.: Living room';

  @override
  String roomSheetNameError(int max) {
    return 'Enter a name (up to $max characters)';
  }

  @override
  String get roomSheetEmojiLabel => 'Emoji';

  @override
  String get roomSheetEmojiHint => '🪴';

  @override
  String get roomSheetEmojiOptional => 'optional';

  @override
  String get roomSheetCreateSubmit => 'Add';

  @override
  String get roomSheetEditSubmit => 'Save';

  @override
  String get roomCreated => 'Room added';

  @override
  String get roomUpdated => 'Room updated';

  @override
  String get roomDeleted => 'Room deleted';

  @override
  String get roomDeleteConfirmTitle => 'Delete room?';

  @override
  String roomDeleteConfirmMessage(String name) {
    return 'Room "$name" will be deleted.';
  }

  @override
  String get roomDeleteConfirmCancel => 'Cancel';

  @override
  String get roomDeleteConfirmDelete => 'Delete';

  @override
  String get roomMoveOverline => 'Move plants';

  @override
  String get roomMoveTitle => 'Where to move the plants?';

  @override
  String roomMoveSubtitle(String name) {
    return 'Room "$name" has plants. Choose where to move them before deleting.';
  }

  @override
  String get roomMoveClose => 'Close';

  @override
  String get profileAuthPreviewTitle => 'Sign-in screens (preview)';

  @override
  String get authBack => 'Back';

  @override
  String get authBrand => 'PlantCare';

  @override
  String get authLocale => 'EN';

  @override
  String get authWelcomeOverline => 'Plant journal';

  @override
  String get authWelcomeTitle => 'Plants that never get forgotten';

  @override
  String get authWelcomeSubtitle =>
      'Watering, misting, and fertilizing reminders. Just like a caring grandma — but digital.';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authContinueApple => 'Continue with Apple';

  @override
  String get authSocialError => 'Sign-in failed. Please try again.';

  @override
  String get authContinueTelegram => 'Continue with Telegram';

  @override
  String get authOr => 'or';

  @override
  String get authContinueGuest => 'Continue as guest';

  @override
  String get authTerms =>
      'By tapping "Continue", you agree to the terms and privacy policy.';

  @override
  String get authCodeStepIndicator => 'Step 2 of 2';

  @override
  String get authCodeOverline => 'Telegram · verification';

  @override
  String get authCodeTitle => 'Enter the code from the bot chat';

  @override
  String authCodeSubtitle(String bot) {
    return 'We messaged you in $bot. Open Telegram and copy the 6-digit code.';
  }

  @override
  String get authCodeBot => '@PlantCareBot';

  @override
  String authResendIn(String seconds) {
    return 'Send a new code in $seconds';
  }

  @override
  String get authResend => 'Resend code';

  @override
  String get authKeypadBackspace => 'Delete digit';

  @override
  String authKeypadDigit(String digit) {
    return 'Digit $digit';
  }

  @override
  String get authContinue => 'Continue';

  @override
  String get authWelcomeBackOverline => 'Account linked · Telegram';

  @override
  String get authWelcomeBackName => 'Alina';

  @override
  String authWelcomeBackTitle(String name) {
    return 'Hello, $name';
  }

  @override
  String get authWelcomeBackSubtitle =>
      'Your garden will live here. Let\'s add the first plant and get to know it.';

  @override
  String get authChipReminders => 'Reminders';

  @override
  String get authChipJournal => 'Journal';

  @override
  String get authChipCalendar => 'Calendar';

  @override
  String get authAddFirstPlant => 'Add your first plant';

  @override
  String get authGoHome => 'I\'ll just browse';

  @override
  String get authEmailTitle => 'Sign in with email';

  @override
  String get authEmailSubtitle =>
      'Enter your address — we\'ll send a sign-in link. No password needed.';

  @override
  String get authEmailLabel => 'Email address';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authEmailInvalid => 'Check your email address';

  @override
  String get authSendLink => 'Get link';

  @override
  String get authLinkSentTitle => 'Check your email';

  @override
  String get authLinkSentSubtitle =>
      'We sent a sign-in link. Open it on this device.';

  @override
  String get authVerifying => 'Verifying link…';

  @override
  String get authVerifyError =>
      'The link is invalid or expired. Please request a new one.';

  @override
  String get authVerifyRetry => 'Back to sign in';

  @override
  String get authDevTokenLabel => 'Dev: paste token';

  @override
  String get profileArchiveTitle => 'Archive';

  @override
  String get archiveBack => 'Back';

  @override
  String archiveEyebrow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants',
      one: '$count plant',
      zero: 'no plants',
    );
    return 'Archive · $_temp0';
  }

  @override
  String get archiveHeadingLead => 'In ';

  @override
  String get archiveHeadingAccent => 'memory';

  @override
  String get archiveSubtitle =>
      'Plants whose paths have diverged from yours. Their history is here, not in the bin.';

  @override
  String get archiveLivedPrefixGifted => 'Lived with you ·';

  @override
  String get archiveLivedPrefix => 'Lived with you ·';

  @override
  String get archiveOpenDiary => 'Open journal';

  @override
  String get archiveRemember => 'Remember';

  @override
  String get archiveRetrospectiveLabel => 'Retrospective';

  @override
  String archiveRetrospectiveText(String avg) {
    return 'Plants live with you for $avg on average';
  }

  @override
  String get archiveRetrospectiveHint => 'That\'s okay. Each one is a memory and a lesson.';

  @override
  String get archiveEmpty => 'Archive is empty';

  @override
  String get archiveEmptyHint =>
      'Plants you part ways with will appear here.';

  @override
  String weatherHumidity(int humidity) {
    return 'Humidity $humidity%';
  }

  @override
  String get weatherAdviceDeferOk => 'Humid — watering can be deferred';

  @override
  String get weatherAdviceDoNotDefer => 'Dry — don\'t skip watering';

  @override
  String weatherSemanticsWithAdvice(int humidity, String advice) {
    return 'Weather: humidity $humidity%, $advice';
  }

  @override
  String weatherSemanticsHumidityOnly(int humidity) {
    return 'Weather: humidity $humidity%';
  }

  @override
  String get homeLoadingCaption => 'Gathering your garden…';

  @override
  String get offlineBannerTitle => 'No garden connection';

  @override
  String get offlineBannerStatus => 'offline';

  @override
  String get offlineTitleLead => 'Garden is ';

  @override
  String get offlineTitleAccent => 'offline';

  @override
  String get offlineMessage =>
      'Can\'t reach the server. Check your internet — your plants aren\'t going anywhere.';

  @override
  String get firstCareSuccessEyebrow => 'Done';

  @override
  String firstCareSuccessTitleWater(String plant) {
    return '$plant watered';
  }

  @override
  String firstCareSuccessTitleSpray(String plant) {
    return '$plant misted';
  }

  @override
  String firstCareSuccessTitleFertilize(String plant) {
    return '$plant fertilized';
  }

  @override
  String firstCareSuccessTitleGeneric(String plant) {
    return '$plant — care logged';
  }

  @override
  String get firstCareSuccessVerbWater => 'watered';

  @override
  String get firstCareSuccessVerbSpray => 'misted';

  @override
  String get firstCareSuccessVerbFertilize => 'fertilized';

  @override
  String get firstCareSuccessBubble => '"Thank you! Feels so much better 💧"';

  @override
  String get firstCareSuccessFallbackPlantName => 'Plant';

  @override
  String get firstCareSuccessStreakDayOne => 'Streak started · day 1';

  @override
  String get firstCareSuccessNextHint =>
      'I\'ll remind you when it\'s time for the next care.';

  @override
  String get firstCareSuccessNextPrefixWater => 'Next watering — ';

  @override
  String get firstCareSuccessNextPrefixSpray => 'Next misting — ';

  @override
  String get firstCareSuccessNextPrefixFertilize => 'Next fertilizing — ';

  @override
  String get firstCareSuccessNextSuffix => ', I\'ll remind you';

  @override
  String get firstCareSuccessCta => 'Back to garden';

  @override
  String get careHistoryOverline => 'Care journal';

  @override
  String get careHistoryViewAll => 'All';

  @override
  String get careHistorySummaryTotalLabel => 'cares\ntotal';

  @override
  String careHistorySummaryTotalValue(int count) {
    return '$count';
  }

  @override
  String get careHistorySummaryOnTimeLabel => 'on time';

  @override
  String careHistorySummaryOnTimeValue(int percent) {
    return '$percent%';
  }

  @override
  String get careHistorySummaryStreakLabel => 'days\nstreak';

  @override
  String careHistorySummaryStreakValue(int count) {
    return '$count';
  }

  @override
  String get careHistoryFilterAll => 'All';

  @override
  String careHistoryEntryDate(String dow, String day, String time) {
    return '$dow $day · $time';
  }

  @override
  String get careHistoryOnTime => 'ON TIME';

  @override
  String get careHistoryLate => 'LATE';

  @override
  String careHistoryPlantCreated(String name, String date) {
    return '$name joined you · $date';
  }

  @override
  String get careHistoryLoadMore => 'Show more';

  @override
  String get careHistoryLoadMoreError => 'Failed to load more history';

  @override
  String get careHistoryEmptyTitle => 'History';

  @override
  String get careHistoryEmptyTitleAccent => 'just beginning';

  @override
  String get careHistoryEmptyBubble =>
      'I just moved in. Log the first care — and we\'ll start keeping history together.';

  @override
  String careHistoryEmptyAuthor(String name) {
    return '— $name';
  }

  @override
  String get careHistoryEmptyCta => 'Log first care';

  @override
  String get profileReportTitle => 'Monthly report';

  @override
  String get reportShare => 'Share';

  @override
  String get reportBack => 'Back';

  @override
  String reportOverline(String month) {
    return 'Report · $month';
  }

  @override
  String get reportTitleGreat => 'What a great month';

  @override
  String get reportTitleGood => 'Good month';

  @override
  String get reportTitleNeutral => 'Monthly summary';

  @override
  String reportSubtitleStreak(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak days',
      one: '$streak day',
    );
    return '$_temp0 streak of on-time cares. Keep it up.';
  }

  @override
  String get reportSubtitleNoStreak =>
      'Your care history is slowly taking shape.';

  @override
  String get reportStatStreak => 'days\nin a row';

  @override
  String get reportStatDone => 'cares\ndone';

  @override
  String get reportStatOnTime => 'on time';

  @override
  String get reportStatOverdue => 'missed';

  @override
  String get reportNoData => '—';

  @override
  String reportPercent(int value) {
    return '$value%';
  }

  @override
  String get reportByTypeLabel => 'By care type';

  @override
  String get reportTrendLabel => 'By week';

  @override
  String reportTrendWeekDone(int done) {
    String _temp0 = intl.Intl.pluralLogic(
      done,
      locale: localeName,
      other: '$done cares',
      one: '$done care',
    );
    return '$_temp0';
  }

  @override
  String reportWeekLabel(String number) {
    return 'Wk. $number';
  }

  @override
  String get reportShareCta => 'Share report';

  @override
  String get reportEmptyTitle => 'Nothing yet';

  @override
  String get reportEmptyBody =>
      'No cares this month. Log your first care — and your summary will appear here.';

  @override
  String editScheduleOverline(String plant) {
    return 'Schedule · $plant';
  }

  @override
  String get editScheduleTitle => 'How often to care?';

  @override
  String get editScheduleSubtitle => 'Intervals affect reminders and streak';

  @override
  String get editScheduleDone => 'Done';

  @override
  String get editScheduleBack => 'Back';

  @override
  String get editScheduleNextCare => 'Next care';

  @override
  String get editScheduleDisabled => 'Disabled';

  @override
  String get editScheduleEvery => 'Every';

  @override
  String get editScheduleWaterAmount => 'Water amount';

  @override
  String editScheduleDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count d.',
      one: '$count d.',
    );
    return '$_temp0';
  }

  @override
  String editScheduleMlUnit(int count) {
    return '$count ml';
  }

  @override
  String get editScheduleAmountUnset => '—';

  @override
  String get editScheduleDueToday => 'today';

  @override
  String get editScheduleDueTomorrow => 'tomorrow';

  @override
  String get editScheduleDueOverdue => 'overdue';

  @override
  String editScheduleDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count d.',
      one: 'in $count d.',
    );
    return '$_temp0';
  }

  @override
  String get editScheduleResetTitle => 'Reset to recommended';

  @override
  String get editScheduleResetSubtitle =>
      'Intervals from the catalog for your species';

  @override
  String get editScheduleNote =>
      '"In summer I drink more often — you can set watering every 5 days, and switch back to 9 in winter."';

  @override
  String get editScheduleEmptyTitle => 'No schedules yet';

  @override
  String get editScheduleEmptyBody =>
      'No care intervals have been configured for this plant.';

  @override
  String get editScheduleSaveError =>
      'Failed to save schedule. Please try again.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String notificationsHeroCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new from your garden',
      one: '$count new from your garden',
      zero: 'All quiet in your garden',
    );
    return '$_temp0';
  }

  @override
  String get notificationsMarkAllRead => 'Mark as read';

  @override
  String get notificationsGroupToday => 'Today';

  @override
  String get notificationsGroupYesterday => 'Yesterday';

  @override
  String notificationsTimeAt(String time) {
    return 'at $time';
  }

  @override
  String get notificationsLoadMoreError => 'Failed to load more notifications';

  @override
  String get notificationsUnreadSemantic => 'unread';

  @override
  String get notificationsTypeCare => 'Care';

  @override
  String get notificationsTypeAlert => 'Alert';

  @override
  String get notificationsTypeAward => 'Achievement';

  @override
  String get notificationsTypeReport => 'Report';

  @override
  String get notificationsTypeSystem => 'System';

  @override
  String get notificationsEmptyTitleLead => 'All ';

  @override
  String get notificationsEmptyTitleAccent => 'quiet';

  @override
  String get notificationsEmptyMessage =>
      'All plants are happy — not a single care missed. I\'ll check back when someone needs attention.';

  @override
  String get notificationsEmptyChip => 'Garden is fine';

  @override
  String notificationsBadgeTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications: $count unread',
      one: 'Notifications: $count unread',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String get plantCardScheduleTitle => 'Care schedule';

  @override
  String get plantCardScheduleEdit => 'Edit';

  @override
  String get profileNotificationsTitle => 'Notifications & time';

  @override
  String get quietHoursBack => 'Back';

  @override
  String get quietHoursOverline => 'Notifications & time';

  @override
  String get quietHoursTitleLead => 'Quiet ';

  @override
  String get quietHoursTitleAccent => 'hours';

  @override
  String get quietHoursSubtitle =>
      'At night, plants will wait until morning — no push notifications.';

  @override
  String quietHoursRingCount(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours of quiet',
      one: '$hours hour of quiet',
    );
    return '$_temp0';
  }

  @override
  String get quietHoursLegendOn => 'Reminders active';

  @override
  String get quietHoursLegendQuiet => 'Quiet';

  @override
  String get quietHoursStartLabel => 'I sleep at';

  @override
  String get quietHoursEndLabel => 'I wake up at';

  @override
  String get quietHoursParamsSection => 'Parameters';

  @override
  String get quietHoursTimezoneTitle => 'Timezone';

  @override
  String quietHoursTimezoneValue(String city, String gmt) {
    return '$city · $gmt';
  }

  @override
  String get quietHoursDndTitle => 'Do not disturb at night';

  @override
  String get quietHoursDndSubtitle => 'Move overdue to morning';

  @override
  String get quietHoursDigestTitle => 'Morning digest';

  @override
  String get quietHoursDigestSubtitle => 'All day\'s cares in one message';

  @override
  String get quietHoursDigestTime => '9:00';

  @override
  String get quietHoursSoon => 'Coming soon';

  @override
  String get quietHoursQuote =>
      '"If I need watering at 3 AM — I\'ll remind you at 8 AM. Sleep tight."';

  @override
  String get quietHoursSaveError => 'Failed to save. Please try again.';

  @override
  String get timePickerStartOverline => 'Quiet hours start';

  @override
  String get timePickerEndOverline => 'Quiet hours end';

  @override
  String get timePickerStartTitle => 'I sleep at';

  @override
  String get timePickerEndTitle => 'I wake up at';

  @override
  String get timePickerDone => 'Done';

  @override
  String get timezoneBack => 'Back';

  @override
  String get timezoneOverline => 'Timezone';

  @override
  String get timezoneTitleLead => 'When is your ';

  @override
  String get timezoneTitleAccent => 'morning';

  @override
  String get timezoneTitleTail => '?';

  @override
  String get timezoneSearchHint => 'City or region…';

  @override
  String get timezoneSectionRussia => 'Russia';

  @override
  String get timezoneEmpty => 'Nothing found';

  @override
  String get timezoneSelectedHint => 'Selected';

  @override
  String get profileShoppingTitle => 'Shopping list';

  @override
  String get shoppingTitle => 'Shopping list';

  @override
  String shoppingHeroSummary(int total, int bought) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total items · $bought bought',
      one: '$total item · $bought bought',
      zero: 'List is empty',
    );
    return '$_temp0';
  }

  @override
  String get shoppingAddItem => 'Add item';

  @override
  String get shoppingAddSheetOverline => 'Shopping list';

  @override
  String get shoppingAddSheetTitle => 'New item';

  @override
  String get shoppingAddSheetLabel => 'What to buy';

  @override
  String get shoppingAddSheetHint => 'E.g., succulent soil mix';

  @override
  String get shoppingAddSheetSubmit => 'Add';

  @override
  String get shoppingItemDelete => 'Delete item';

  @override
  String get shoppingItemToggle => 'Mark as bought';

  @override
  String get shoppingItemDeleted => 'Item deleted';

  @override
  String get shoppingEmptyTitleLead => 'List is ';

  @override
  String get shoppingEmptyTitleAccent => 'empty';

  @override
  String get shoppingEmptyMessage =>
      'Things for your plants will go here — soil, pots, fertilizers. Add the first item.';

  // ── language screen keys ──────────────────────────────────────────────────

  @override
  String get languageScreenTitle => 'Language';

  @override
  String get languageScreenSubtitle =>
      'Plant replies will be translated too — character stays';

  @override
  String get languageScreenHint =>
      'System language is Russian. Date and time are formatted by selected language.';

  @override
  String get languageBack => 'Back';

  @override
  String get languageScreenTitleLead => 'App ';

  @override
  String get languageScreenTitleAccent => 'language';

  // ── diagnosis screen (issue #36) ─────────────────────────────────────────

  @override
  String get diagnosisRetry => 'Retry';

  @override
  String get diagnosisBadgeWarning => '⚠ Something's wrong';

  @override
  String get diagnosisHealthyTitle => 'All good';

  @override
  String get diagnosisHealthyMessage => 'Plant is healthy — no issues found';

  @override
  String get diagnosisTitleIssues => 'Issues';

  @override
  String get diagnosisSeverityHigh => 'Critical';

  @override
  String get diagnosisSeverityMedium => 'Moderate';

  @override
  String get diagnosisSeverityLow => 'Minor';

  @override
  String get diagnosisSeverityUnknown => '—';

  @override
  String get diagnosisTitleRecommendations => 'Recommendations';

  @override
  String get diagnosisErrorMessage => 'Failed to load diagnosis';

  // ── catalog empty search (issue #32) ─────────────────────────────────────

  @override
  String catalogSearchEmptyTitle(String query) => 'Nothing for "$query"';

  @override
  String get catalogSearchEmptyMessage =>
      'Might be a typo. Try a different spelling or browse popular.';

  @override
  String get catalogSuggestionsTitle => 'Maybe you were looking for';

  @override
  String get catalogNotInCatalogTitle => 'Not in the catalog?';

  @override
  String get catalogNotInCatalogHint =>
      'Add a plant manually — you can set the schedule yourself.';

  @override
  String get catalogNotInCatalogAdd => 'Add';
}
