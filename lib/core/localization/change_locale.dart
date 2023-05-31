import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/cache_helper.dart';
import '../service/service_locator.dart';

class LocaleController extends GetxController {
  Locale? language;
  String? lang;
  TaqwimPref sportifyServices = sl.get();

  Future changeLanguage(String languageCode) async {
    Locale locale = Locale(languageCode);
    await sportifyServices.setLang(languageCode);
    Get.updateLocale(locale);
    language = locale;
  }

  @override
  void onInit() {
    String? sharedPredLang = sportifyServices.getLang();

    if (sharedPredLang == 'ar') {
      language = const Locale('ar');
    } else if (sharedPredLang == 'en') {
      language = const Locale('en');
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }

    super.onInit();
  }
}
