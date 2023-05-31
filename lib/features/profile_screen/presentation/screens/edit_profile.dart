// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/client/dio_client.dart';
import 'package:taqwim/core/client/endpoints.dart';
import 'package:taqwim/core/controllers/main_cubit/main_cubit.dart';
import 'package:taqwim/core/routes/routes_manager.dart';
import 'package:taqwim/core/service/service_locator.dart';
import 'package:taqwim/core/utils/color_manager.dart';
import 'package:taqwim/core/utils/strings_manager.dart';
import 'package:taqwim/core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:taqwim/core/widgets/app_top_bar.dart';
import 'package:taqwim/core/widgets/no_internet_connection.dart';
import 'package:taqwim/features/profile_screen/data/models/get_user_resonse.dart';
import 'package:taqwim/features/profile_screen/data/models/update_profile_respnse.dart';
import 'package:taqwim/features/profile_screen/data/repo/terms_and_conditions_repo.dart';
import 'package:taqwim/features/profile_screen/data/src/terms_and_conditions_remote_datasource.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var res = await sl<DioClient>().get(path: Endpoints.user);

      GetUserResopnse responseModel = GetUserResopnse.fromJson(res.data);
      log(json.encode(responseModel.name));

      userNameController.text = responseModel.name;
      emailController.text = responseModel.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: bodyWidgets(),
    );
  }

  Widget bodyWidgets() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              onChanged: (value) {
                userNameController.text = value;
                userNameController.selection = TextSelection.fromPosition(TextPosition(offset: userNameController.text.length));
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return StringsManager.errorUserName.tr;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: StringsManager.name.tr,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                emailController.text = value;
                emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return StringsManager.emailError1.tr;
                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                  return StringsManager.emailError2.tr;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: StringsManager.email.tr,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                validateAndVerify();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorManager.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(44.0),
                ),
              ),
              child: Text(
                StringsManager.edit.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateAndVerify() async {
    try {
      if (!_formKey.currentState!.validate()) {
      } else {
        var result = await sl<DioClient>().put(path: Endpoints.updateProfile, data: {
          'name': userNameController.text.toString(),
          'email': emailController.text.toString(),
        });

        UpdateProfileResponse responseModel = UpdateProfileResponse.fromJson(result);

        if (responseModel.status == true) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'تم بنجاح',
            text: '',
            confirmBtnText: StringsManager.okay.tr,
            confirmBtnColor: Colors.green,
          ).then((value) {
            Get.offAllNamed(RoutesManager.home);
          });
        } else {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: StringsManager.error.tr,
            text: '',
            confirmBtnText: StringsManager.okay.tr,
            confirmBtnColor: Colors.red,
          );
        }
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
