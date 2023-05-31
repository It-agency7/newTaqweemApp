import 'package:flutter/cupertino.dart';

import '../src/terms_and_conditions_remote_datasource.dart';

class TermsAndConditionsRepo{
  final TermsAndConditionsRemoteDataSource _api;

  TermsAndConditionsRepo(this._api);

  Future<String> getTermsAndConditions() async {
    return await _api.getTermsAndConditions();
  }

  Future<int> changePassword(String oldPassword, String newPassword) async {
    return await _api.changePassword(oldPassword, newPassword);
  }
}