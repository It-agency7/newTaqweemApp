import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/client/dio_client.dart';
import 'package:taqwim/core/helpers/notification_helper.dart';
import 'package:taqwim/core/requests/app_data_request.dart';
import 'package:taqwim/features/home/presentation/controller/prayer_times_cubit/prayer_times_cubit.dart';
import 'package:volume_control/volume_control.dart';
import '../../../features/home/presentation/controller/prayer_times_cubit/prayer_times_cubit_states.dart';
import '../../../features/profile_screen/data/repo/terms_and_conditions_repo.dart';
import '../../../features/profile_screen/data/src/terms_and_conditions_remote_datasource.dart';
import '../../components/custom_button.dart';
import '../../helpers/cache_helper.dart';
import '../../routes/routes_manager.dart';
import '../../service/service_locator.dart';
import '../../utils/color_manager.dart';
import '../../utils/strings_manager.dart';
import '../../utils/values_manager.dart';
import 'main_states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit(this.appDataRemoteDataSource) : super(HomeInitial());
  final AppDataRemoteDataSource appDataRemoteDataSource;

  static MainCubit get(context) => BlocProvider.of(context);

  List<String> tones = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  String startDay = 'saturday';

  void getAppData() async {
    emit(HomeLoadingInProgress());
    bool notificationEnabled = await NotificationService.getNotificationStatus();
    // Get the current volume, min=0, max=1
    double _val = await VolumeControl.volume;
    //get the selected city
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCity = prefs.getString('selectedCity') ?? '';
    if (prefs.getString('lang') == null) {
      prefs.setString('lang', 'ar');
    }
    if (prefs.getString('tone') == null) {
      prefs.setString('tone', 't1');
    }
    if (prefs.getString('startDay') == '') {
      prefs.setString('startDay', 'saturday');
    }
    if (prefs.getString("channelKey") == null) {
      prefs.setString("channelKey", "t1");
    }
    String lang = prefs.getString('lang') ?? 'ar';
    String? tone = prefs.getString('tone');
    String startDay = prefs.getString('startDay') ?? 'saturday';
    this.startDay = startDay;
    appDataRemoteDataSource.getAppData().then((value) {
      emit(HomeLoadingSuccess(value, notificationEnabled, _val, selectedCity, lang, tone!, startDay));
    }).catchError((error) {
      emit(HomeLoadingFailure(error.toString()));
    });
  }

  void changeNotificationStatus(bool status) async {
    //change notification status only in HomeLoadingSuccess state
    if (state is HomeLoadingSuccess) {
      emit(HomeLoadingSuccess(
          (state as HomeLoadingSuccess).applicationDataModel,
          status,
          (state as HomeLoadingSuccess).volume,
          (state as HomeLoadingSuccess).selectedCity,
          (state as HomeLoadingSuccess).lang,
          (state as HomeLoadingSuccess).tone,
          (state as HomeLoadingSuccess).startDay));
    }
  }

  void changeVolume(double val) {
    //change notification status only in HomeLoadingSuccess state
    if (state is HomeLoadingSuccess) {
      emit(HomeLoadingSuccess(
          (state as HomeLoadingSuccess).applicationDataModel,
          (state as HomeLoadingSuccess).notificationStatus,
          val,
          (state as HomeLoadingSuccess).selectedCity,
          (state as HomeLoadingSuccess).lang,
          (state as HomeLoadingSuccess).tone,
          (state as HomeLoadingSuccess).startDay));
    }
  }

  void changeCity(String city) {
    //change notification status only in HomeLoadingSuccess state
    if (state is HomeLoadingSuccess) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('selectedCity', city);
      });
      //PrayerTimesCubit().loadPrayerTimesOfDate(DateTime.now(), city: city);
      //loadPrayerTimesOfDate from PrayerTimesCubit
      PrayerTimesCubit prayerTimesCubit = PrayerTimesCubit();
      print("PrayerTimesLoadingSuccess And City Is: $city");
      prayerTimesCubit.loadPrayerTimesOfDate(DateTime.now(), city: city);
      emit(HomeLoadingSuccess(
          (state as HomeLoadingSuccess).applicationDataModel,
          (state as HomeLoadingSuccess).notificationStatus,
          (state as HomeLoadingSuccess).volume,
          city,
          (state as HomeLoadingSuccess).lang,
          (state as HomeLoadingSuccess).tone,
          (state as HomeLoadingSuccess).startDay));
    }
  }

  void changeLang(String lang) {
    //change notification status only in HomeLoadingSuccess state
    if (state is HomeLoadingSuccess) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('lang', lang);
      });
      emit(HomeLoadingSuccess(
          (state as HomeLoadingSuccess).applicationDataModel,
          (state as HomeLoadingSuccess).notificationStatus,
          (state as HomeLoadingSuccess).volume,
          (state as HomeLoadingSuccess).selectedCity,
          lang,
          (state as HomeLoadingSuccess).tone,
          (state as HomeLoadingSuccess).startDay));
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            height: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const AuthorizedBottomSheet(),
          ),
        );
      },
    );
  }

  bool isAuthorized() {
    String? token = sl<TaqwimPref>().getToken();
    return token != null; //* <--- يسلم مسعد
    // if (token == null) {
    //   return false;
    // }
    // return true;
  }

  void changeTone(String tone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tone', tone);
    prefs.setString("channelKey", tone);
    emit(HomeLoadingSuccess(
        (state as HomeLoadingSuccess).applicationDataModel,
        (state as HomeLoadingSuccess).notificationStatus,
        (state as HomeLoadingSuccess).volume,
        (state as HomeLoadingSuccess).selectedCity,
        (state as HomeLoadingSuccess).lang,
        tone,
        (state as HomeLoadingSuccess).startDay));
  }

  void getTone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tone = prefs.getString('tone');
    //copy the current state and change the tone
    if (state is HomeLoadingSuccess) {
      emit(HomeLoadingSuccess(
          (state as HomeLoadingSuccess).applicationDataModel,
          (state as HomeLoadingSuccess).notificationStatus,
          (state as HomeLoadingSuccess).volume,
          (state as HomeLoadingSuccess).selectedCity,
          (state as HomeLoadingSuccess).lang,
          tone!,
          (state as HomeLoadingSuccess).startDay));
    }
  }

  void changeStartDay(String day) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('startDay', day);
    startDay = day;
    emit(HomeLoadingSuccess(
        (state as HomeLoadingSuccess).applicationDataModel,
        (state as HomeLoadingSuccess).notificationStatus,
        (state as HomeLoadingSuccess).volume,
        (state as HomeLoadingSuccess).selectedCity,
        (state as HomeLoadingSuccess).lang,
        (state as HomeLoadingSuccess).tone,
        day));
  }
}

class AuthorizedBottomSheet extends StatelessWidget {
  const AuthorizedBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DistancesManager.screenPadding,
          vertical: DistancesManager.screenPadding * 2,
        ),
        child: Column(
          children: [
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.darkGrey.withOpacity(.3),
                  width: 4,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person_2_outlined,
                  color: ColorManager.darkGrey.withOpacity(.3),
                  size: 60,
                ),
              ),
            ),
            18.ph,
            Text(
              StringsManager.loginFirst,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            10.ph,
            Text(
              "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            23.ph,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: StringsManager.createAccount1,
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesManager.register);
                    },
                  ),
                ),
                10.pw,
                Expanded(
                  child: CustomButton(
                    title: StringsManager.login,
                    textColor: ColorManager.primary,
                    backgroundColor: ColorManager.secondary,
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesManager.login);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
