import 'package:audioplayers/audioplayers.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/features/notes_screen/data/repos/tasks_repo.dart';
import 'package:taqwim/features/notes_screen/data/source/tasks_remote_datasource.dart';
import '../../features/notes_screen/presentation/controller/notes_cubit/notes_cubit.dart';
import '../helpers/cache_helper.dart';
import '../../features/auth/presentation/controller/login/cubit.dart';
import '../../features/holidays_screen/data/repo/holiday_times_repo.dart';
import '../../features/holidays_screen/data/src/holidays_remote_datasource.dart';
import '../../features/notes_screen/data/repos/notes_repo.dart';
import '../../features/home/data/repo/ads_repo.dart';
import '../../features/home/data/src/ads_remote_datasource.dart';
import '../../features/notes_screen/data/source/notes_remote_datasource.dart';
import '../client/dio_client.dart';
import '../connection/network_info.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/data/source/web_service.dart';
import '../../features/auth/presentation/controller/register/cubit.dart';
import '../requests/app_data_request.dart';

GetIt sl = GetIt.instance;
Future<void> setupLocator() async {
  //* cubit
  sl.registerLazySingleton(
    () => RegisterCubit(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton(
    () => LoginCubit(authRepository: sl<AuthRepository>()),
  );

  //* repo
  sl.registerLazySingleton(() => AuthRepository(authWebServices: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => HolidayTimesRepository(sl<HolidaysRemoteDataSource>()));
  sl.registerLazySingleton(() => AdsRepo(sl<AdsRemoteDataSource>()));
  sl.registerLazySingleton(() => NotesRepo(sl<NotesRemoteDataSource>()));
  sl.registerLazySingleton(() => TasksRepo(sl<TasksRemoteDataSource>()));

  //* data source
  sl.registerLazySingleton(() => AuthWebServices(sl<DioClient>()));
  sl.registerLazySingleton(() => HolidaysRemoteDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => AdsRemoteDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => NotesRemoteDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => TasksRemoteDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => AppDataRemoteDataSource(sl<DioClient>()));

  /// network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetwotkInfoImpl(
      internetConnectionChecker: sl(),
    ),
  );

  //* EXTERNAL
  sl.registerLazySingleton(() => InternetConnectionChecker());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => AudioPlayer());

  sl.registerLazySingleton(() => TaqwimPref(sharedPreferences));
  sl.registerLazySingleton(() => DioClient());
}
