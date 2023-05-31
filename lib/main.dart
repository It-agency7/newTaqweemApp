import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart' as GetLibrary;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:taqwim/core/helpers/notification_helper.dart';
import 'package:taqwim/core/requests/app_data_request.dart';
import 'package:taqwim/features/notes_screen/data/repos/tasks_repo.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit.dart';
import 'package:taqwim/features/profile_screen/presentation/screens/edit_profile.dart';
import 'core/helpers/notification.dart';
import 'core/localization/change_locale.dart';
import 'core/localization/translations.dart';
import 'features/auth/presentation/controller/login/cubit.dart';
import 'features/auth/presentation/controller/register/cubit.dart';
import 'features/home/data/repo/ads_repo.dart';
import 'features/home/presentation/controller/ads_cubit/ads_cubit.dart';
import 'features/notes_screen/data/repos/notes_repo.dart';
import 'features/notes_screen/presentation/screens/add_note_screen.dart';
import 'core/service/service_locator.dart';
import 'core/controllers/main_cubit/main_cubit.dart';
import 'core/routes/routes_manager.dart';
import 'core/utils/theme_manager.dart';
import 'features/auth/presentation/screens/login.dart';
import 'features/auth/presentation/screens/register.dart';
import 'features/holidays_screen/presentation/screens/holidays_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/notes_screen/presentation/screens/notes_screen.dart';
import 'features/profile_screen/presentation/screens/profile_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/utils/language_manager.dart';

void main() async {
  log('--main');
  WidgetsFlutterBinding.ensureInitialized();
  log('--main: WidgetsFlutterBinding.ensureInitialized');

  await Firebase.initializeApp();
  log('--main: Firebase.initializeApp');

  await setupLocator();
  log('--main: setUpLocator');

  NotificationService.notificationInitialize();
  log('--NotificationService.notificationInitialize');

  final firebaseMessaging = FCM();
  firebaseMessaging.setNotifications();
  log("--Notification Fcm Done");

  runApp(const Taqwim());
}

class Taqwim extends StatelessWidget {
  const Taqwim({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController localeController = Get.put(LocaleController());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              MainCubit(sl<AppDataRemoteDataSource>())..getAppData(),
        ),
        BlocProvider.value(
          value: sl<RegisterCubit>(),
        ),
        BlocProvider.value(
          value: sl<LoginCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) => AdsCubit(sl<AdsRepo>()),
        ),
        BlocProvider(
          create: (context) => NotesCubit(sl<NotesRepo>(), sl<TasksRepo>()),
        ),
      ],
      child: Directionality(
        // ignore: unrelated_type_equality_checks
        textDirection: localeController.language?.languageCode == ARABIC_LOCALE
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GetLibrary.GetMaterialApp(
          translations: TaqweemTranslations(),
          locale: localeController.language,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeManager.getLightTheme(),
          title: 'تقويم اعمال جدة',
          initialRoute: RoutesManager.home,
          getPages: [
            GetPage(
              name: RoutesManager.login,
              page: () => const LoginScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.register,
              page: () => const RegisterScreen(),
              transition: Transition.rightToLeftWithFade,
              curve: Curves.ease,
            ),
            GetPage(
              name: RoutesManager.home,
              page: () => const HomeScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.notes,
              page: () => const NotesScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.addNote,
              page: () => AddNoteScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.holidays,
              page: () => const HolidaysScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.profile,
              page: () => const ProfileScreen(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: RoutesManager.editProfile,
              page: () =>  EditProfileScreen(),
              transition: Transition.fadeIn,
            ),
          ],
        ),
      ),
    );
  }
}
