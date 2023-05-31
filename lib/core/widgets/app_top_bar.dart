import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taqwim/core/functions/launch_url.dart';
import 'package:taqwim/core/helpers/notification_helper.dart';
import 'package:taqwim/core/utils/constant_manager.dart';
import 'package:taqwim/core/utils/shimmer_container.dart';
import '../components/custom_dropdown.dart';
import '../controllers/main_cubit/main_cubit.dart';
import '../controllers/main_cubit/main_states.dart';
import '../helpers/cache_helper.dart';
import '../localization/change_locale.dart';
import '../service/service_locator.dart';
import '../utils/assets_manager.dart';
import '../utils/color_manager.dart';
import '../utils/icon_broken.dart';
import '../utils/values_manager.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  TopAppBar({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<MainCubit, MainStates>(
        builder: (context, state) {
          return state is HomeLoadingSuccess
              ? CachedNetworkImage(
                  imageUrl: state.applicationDataModel.logo,
                  width: 72.0,
                  height: 44.0,
                )
              : const ShimmerContainer(
                  width: 72.0,
                  height: 44.0,
                );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Image.asset(
            AssetsManager.lang,
            width: 29.0,
            height: 21.67,
            fit: BoxFit.fill,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          if (showBackButton) {
            Get.back();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          showBackButton
              ? Directionality.of(context) == TextDirection.rtl
                  ? FontAwesomeIcons.angleRight
                  : FontAwesomeIcons.angleLeft
              : FontAwesomeIcons.barsStaggered,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  Widget buildDrawer(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Drawer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
                end: 20.0,
                top: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'select_your_location'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  CustomDropDown(
                    initialValue: state is HomeLoadingSuccess
                        ? state.selectedCity == ''
                            ? ConstantsManager.saCities[0].englishName
                            : state.selectedCity
                        : ConstantsManager.saCities[0].englishName,
                    onChanged: (val) {
                      BlocProvider.of<MainCubit>(context).changeCity(val!);
                    },
                    items: ConstantsManager.saCities.map((e) {
                      print("languageCode ${LocaleController().language?.languageCode}");
                      return DropdownMenuItem(
                        value: e.englishName,
                        child: Text(sl<TaqwimPref>().getLang().isNotEmpty && sl<TaqwimPref>().getLang() == 'ar'
                            ? e.arabicName
                            : e.englishName),
                      );
                    }).toList(),
                  ),
                  DistancesManager.gapSmall.ph,
                  Text(
                    'language'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  CustomDropDown(
                    initialValue: 'ar',
                    onChanged: (val) async {
                      await LocaleController().changeLanguage(val!);
                      MainCubit.get(context).changeLang(val);
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'ar',
                        child: Text(
                          'arabic'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text(
                          'english'.tr,
                        ),
                      ),
                    ],
                  ),
                  DistancesManager.gapSmall.ph,
                  Text(
                    'alarm'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  CustomDropDown(
                    initialValue: state is HomeLoadingSuccess ? state.tone : "t${MainCubit.get(context).tones[0]}",
                    onChanged: (val) async {
                      BlocProvider.of<MainCubit>(context).changeTone(val!);
                      NotificationService.notificationInitialize();
                      if (val != null) {
                        String audioasset = "assets/audio/${val}.mp3";
                        ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
                        Uint8List audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
                        int result = await sl<AudioPlayer>().playBytes(audiobytes);

                        if (result == 1) {
                          await Future.delayed(const Duration(seconds: 6), () async {
                            await sl<AudioPlayer>().stop();
                          });
                        } else {
                          print("Error while playing audio.");
                        }
                      }
                    },
                    items: MainCubit.get(context).tones.map((e) {
                      return DropdownMenuItem(
                        onTap: () {},
                        value: "t$e",
                        child: Text("RingTone 0$e"),
                      );
                    }).toList(),
                  ),
                  DistancesManager.gapSmall.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'voice_degree'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: ColorManager.primary,
                          inactiveColor: ColorManager.darkGrey,
                          thumbColor: Colors.white,
                          value: state is HomeLoadingSuccess ? state.volume : 0.0,
                          onChanged: (val) {
                            BlocProvider.of<MainCubit>(context).changeVolume(val);
                          },
                        ),
                      )
                    ],
                  ),
                  DistancesManager.gapSmall.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'enable_notifications'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Expanded(
                        child: Switch(
                            value: state is HomeLoadingSuccess ? state.notificationStatus : false,
                            onChanged: (val) {
                              NotificationService.enableNotification(val);
                              MainCubit.get(context).changeNotificationStatus(val);
                            },
                            activeTrackColor: ColorManager.primary,
                            inactiveTrackColor: ColorManager.darkGrey,
                            thumbColor: MaterialStateProperty.all<Color>(Colors.white)),
                      ),
                    ],
                  ),
                  DistancesManager.gapSmall.ph,
                  Text(
                    'start_week'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  CustomDropDown(
                    initialValue: state is HomeLoadingSuccess ? state.startDay ?? 'saturday' : 'saturday',
                    onChanged: (val) {
                      BlocProvider.of<MainCubit>(context).changeStartDay(val!);
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'saturday',
                        child: Text(
                          'Saturday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'sunday',
                        child: Text(
                          'Sunday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'monday',
                        child: Text(
                          'Monday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'tuesday',
                        child: Text(
                          'Tuesday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'wednesday',
                        child: Text(
                          'Wednesday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'thursday',
                        child: Text(
                          'Thursday'.tr,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'friday',
                        child: Text(
                          'Friday'.tr,
                        ),
                      ),
                    ],
                  ),
                  DistancesManager.gapSmall.ph,
                  Text(
                    'contact_us'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(color: ColorManager.lightGrey, borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      state is HomeLoadingSuccess ? state.applicationDataModel.contactUs : '00000000000',
                      style: TextStyle(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                  DistancesManager.gapSmall.ph,
                  Text(
                    'ad_with_us'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(color: ColorManager.lightGrey, borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      state is HomeLoadingSuccess ? state.applicationDataModel.addWithUs : '00000000000',
                      style: TextStyle(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                  DistancesManager.gapNormal.ph,
                  Row(
                    children: [
                      Text(
                        'share_app'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      IconButton(
                        onPressed: () {
                          Share.share('Download Taqwem App',
                              subject: 'https://play.google.com/store/apps/details?id=com.taqwem.app');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.share,
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                  DistancesManager.gapSmall.ph,
                  const Text(
                    'follow_us',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  12.ph,
                  BlocBuilder<MainCubit, MainStates>(
                    builder: (context, state) {
                      return state is HomeLoadingSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    launchUrl(state.applicationDataModel.facebook);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.squareFacebook,
                                    color: ColorManager.primary,
                                    size: 45.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(state.applicationDataModel.twitter);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.squareTwitter,
                                    color: ColorManager.primary,
                                    size: 45.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(state.applicationDataModel.instagram);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.squareInstagram,
                                    color: ColorManager.primary,
                                    size: 45.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(state.applicationDataModel.youtube);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.squareYoutube,
                                    color: ColorManager.primary,
                                    size: 45.0,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    launchUrl(state.applicationDataModel.linkedin);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.linkedin,
                                    color: ColorManager.primary,
                                    size: 45.0,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [for (int i = 0; i < 5; i++) const ShimmerContainer(height: 42, width: 42)],
                            );
                    },
                  ),
                  DistancesManager.gapNormal.ph,
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Version',
                          style: GoogleFonts.poppins(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '1.0.012312',
                          style: GoogleFonts.poppins(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DistancesManager.gapLarge.ph,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
