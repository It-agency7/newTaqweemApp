import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../core/routes/routes_manager.dart';
import '../controller/register/cubit.dart';
import '../controller/register/states.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/icon_broken.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
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
          onPressed: () {
            Get.back();
          },
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(
            IconBroken.Arrow_Right_2,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterLoadingSuccessState) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'تم بنجاح',
              text: 'register ${state.registerModel.message}',
              confirmBtnText: StringsManager.okay.tr,
              confirmBtnColor: Colors.green,
            ).then((value) {
              Get.toNamed(RoutesManager.home);
            });
          } else if (state is RegisterLoadingFailState) {
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
          RegisterCubit cubit = RegisterCubit.get(context);
          return ConditionalBuilder(
              condition: state is! RegisterLoadingInProgressState,
              fallback: (BuildContext context) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator.adaptive(),
                        Text(
                          'Loading',
                          style: TextStyle(
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    ),
                  ),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(DistancesManager.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringsManager.createAccount.tr,
                          style: TextStylesManager.headline.copyWith(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Form(
                          key: cubit.registerFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: cubit.nameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return StringsManager.nameError.tr;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringsManager.name.tr,
                                ),
                              ),
                              DistancesManager.gapSmall.ph,
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
                              DistancesManager.gapSmall.ph,
                              TextFormField(
                                controller:
                                    cubit.passwordConfirmationController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return StringsManager.confirmPasswordError1
                                        .tr;
                                  } else if (value !=
                                      cubit.passwordController.text) {
                                    return StringsManager.confirmPasswordError2
                                        .tr;
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText:
                                      StringsManager.confirmPassword.tr,
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: ColorManager.primary,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isChecked = newValue!;
                                      });
                                    },
                                  ),
                                  Text(
                                    StringsManager.termsAndConditions.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              16.ph,
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (cubit.registerFormKey.currentState!
                                            .validate()) {
                                          if (!isChecked) {
                                            // Show error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(StringsManager
                                                    .termsError
                                                    .tr),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            // Allow user to sign up
                                            cubit.register(
                                              userName:
                                                  cubit.nameController.text,
                                              email: cubit.emailController.text,
                                              password:
                                                  cubit.passwordController.text,
                                            );
                                          }
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
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size.fromHeight(44.0),
                                        ),
                                      ),
                                      child: Text(
                                        StringsManager.createAccount.tr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
