import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/icon_broken.dart';
import '../../../../core/routes/routes_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../controller/login/states.dart';

import '../controller/login/cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AssetsManager.taqwimLogo,
          width: 72.0,
          height: 44.0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              IconBroken.Notification,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
        leading: IconButton(
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
      ),
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingSuccessState) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'تم بنجاح',
              text: 'login ${state.loginModel.message}',
              confirmBtnText: StringsManager.okay.tr,
              confirmBtnColor: Colors.green,
            ).then((value) {
              Get.offAllNamed(RoutesManager.home);
            });
          } else if (state is LoginLoadingFailState) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: StringsManager.error.tr,
              text: state.error,
              confirmBtnText: StringsManager.okay.tr,
              confirmBtnColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return ConditionalBuilder(
            condition: state is! LoginLoadingInProgressState,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(DistancesManager.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringsManager.signIn.tr,
                        style: TextStylesManager.headline.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Form(
                        key: cubit.loginFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: cubit.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return StringsManager.emailError1.tr;
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return StringsManager.emailError2.tr;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: StringsManager.email.tr,
                              ),
                            ),
                            DistancesManager.gapSmall.ph,
                            TextFormField(
                              controller: cubit.passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return StringsManager.passwordError1.tr;
                                } else if (value.length < 8) {
                                  return StringsManager.passwordError2.tr;
                                }
                                return null;
                              },
                              obscureText: cubit.isPassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(cubit.suffix),
                                  onPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                ),
                                labelText: StringsManager.password.tr,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  StringsManager.forgotPassword.tr,
                                  style: TextStylesManager.bodyMedium.copyWith(
                                    color: ColorManager.primary,
                                  ),
                                ),
                              ),
                            ),
                            16.ph,
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (cubit.loginFormKey.currentState!
                                        .validate()) {
                                      cubit.login(
                                        email: cubit.emailController.text,
                                        password: cubit.passwordController.text,
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorManager.primary),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size.fromHeight(44.0),
                                    ),
                                  ),
                                  child: Text(
                                    StringsManager.signIn.tr,
                                  ),
                                ),
                                const SizedBox(
                                  width: DistancesManager.gapNormal,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Get.toNamed(RoutesManager.register);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        side: const BorderSide(
                                            color: ColorManager.darkPrimary,
                                            width: 8.0),
                                      ),
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size.fromHeight(44.0),
                                    ),
                                  ),
                                  child: Text(
                                    StringsManager.createAccount.tr,
                                    style: const TextStyle(
                                      color: ColorManager.darkPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            fallback: (BuildContext context) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        },
      ),
    );
  }
}
