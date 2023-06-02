import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/client/dio_client.dart';
import 'package:taqwim/core/controllers/main_cubit/main_states.dart';
import 'package:taqwim/core/localization/change_locale.dart';
import 'package:taqwim/features/profile_screen/data/repo/terms_and_conditions_repo.dart';
import 'package:taqwim/features/profile_screen/data/src/terms_and_conditions_remote_datasource.dart';
import 'package:taqwim/features/profile_screen/presentation/screens/terms_condition.dart';
import 'package:taqwim/features/profile_screen/presentation/screens/who_us.dart';
import '../../../../core/client/endpoints.dart';
import '../../../../core/controllers/main_cubit/main_cubit.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/routes/routes_manager.dart';
import '../../../../core/service/service_locator.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/no_internet_connection.dart';
import '../../../auth/presentation/screens/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    return Scaffold(
      appBar: TopAppBar(),
      drawer: TopAppBar().buildDrawer(context),
      onDrawerChanged: (value) async {
        if (!value) {
          await sl<AudioPlayer>().stop();
        }
      },
      bottomNavigationBar: AppBottomNavigationBar(3),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool isConnected = connectivity != ConnectivityResult.none;
          if (isConnected) {
            return ProfileBodyWidget(
              mainCubit: mainCubit,
            );
          } else {
            return const NoInternetConnectionWidget();
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ProfileBodyWidget extends StatelessWidget {
  const ProfileBodyWidget({
    super.key,
    required this.mainCubit,
  });

  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    LocaleController localeController = Get.put(LocaleController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(DistancesManager.screenPadding),
        child: BlocBuilder<MainCubit, MainStates>(builder: (context, state) {
          return Align(
            alignment: state is HomeLoadingSuccess
                ? state.lang == 'ar'
                    ? Alignment.topRight
                    : Alignment.topLeft
                : Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(RoutesManager.notes);
                  },
                  child: Text(
                    'notes'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                mainCubit.isAuthorized()
                    ? TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesManager.editProfile);
                        },
                        child: Text(
                          'edit_profile'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
                if (!mainCubit.isAuthorized())
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(RoutesManager.register);
                    },
                    child: Text(
                      'create_new_account'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, decoration: TextDecoration.underline),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndCondition()));
                  },
                  child: Text(
                    'privacy'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const WhoUs());
                  },
                  child: Text(
                    'who_us'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                mainCubit.isAuthorized()
                    ? TextButton(
                        onPressed: () async {
                          //change password
                          TextEditingController oldPasswordController = TextEditingController();
                          TextEditingController newPasswordController = TextEditingController();
                          Get.dialog(
                            AlertDialog(
                              title: Text('change_password'.tr),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'old_password'.tr,
                                    ),
                                    controller: oldPasswordController,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'new_password'.tr,
                                    ),
                                    controller: newPasswordController,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('cancel'.tr)),
                                TextButton(
                                    onPressed: () async {
                                      DioClient _dioClient = DioClient();
                                      int responseCode =
                                          await TermsAndConditionsRepo(TermsAndConditionsRemoteDataSource(_dioClient))
                                              .changePassword(oldPasswordController.text, newPasswordController.text);
                                      if (responseCode == 200) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('save'.tr)),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'change_password'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
                mainCubit.isAuthorized()
                    ? TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //are you sure you want to delete your account
                                return AlertDialog(
                                  title: Text('are_you_sure'.tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancel'.tr)),
                                    TextButton(
                                        onPressed: () async {
                                          await (await SharedPreferences.getInstance()).clear();
                                          await sl.reset();
                                          await setupLocator();
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                                        },
                                        child: Text('yes'.tr)),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'logout'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
                mainCubit.isAuthorized()
                    ? TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //are you sure you want to delete your account
                                return AlertDialog(
                                  title: Text('are_you_sure'.tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancel'.tr)),
                                    TextButton(
                                        onPressed: () async {
                                          DioClient _dioClient = DioClient();
                                          final response = await _dioClient.get(path: Endpoints.deleteAccountEP);

                                          if (response.statusCode == 200) {
                                            Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                          }
                                        },
                                        child: Text('yes'.tr)),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'delete_account'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
                !mainCubit.isAuthorized()
                    ? TextButton(
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                        },
                        child: Text(
                          'login'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
