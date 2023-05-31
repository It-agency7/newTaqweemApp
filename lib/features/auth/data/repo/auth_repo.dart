import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/strings_manager.dart';
import '../models/register_model.dart';
import '../source/web_service.dart';

class AuthRepository {
  final AuthWebServices authWebServices;
  final NetworkInfo networkInfo;

  AuthRepository({
    required this.authWebServices,
    required this.networkInfo,
  });

  Future<Either<Failure, RegisterModel>> register({
    required String userName,
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await authWebServices.register(
          email: email,
          password: password,
          userName: userName,
          fcmToken: fcmToken,
        );
        return Right(result);
      } else {
        return Left(OfflineFailure(StringsManager.internetFailure.tr));
      }
    } on RegisterException catch (failure) {
      return Left(ServerFailure(failure.registerErrorModel.errorMessage));
    }
  }

  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await authWebServices.login(
          email: email,
          password: password,
          fcmToken: fcmToken,
        );
        return Right(result);
      } else {
        return Left(OfflineFailure(StringsManager.internetFailure.tr));
      }
    } on LoginException catch (failure) {
      return Left(ServerFailure(failure.loginErrorModel.errorMessage));
    }
  }
}
