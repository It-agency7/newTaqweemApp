class Endpoints {
  Endpoints._();

  static const String baseUrl = "https://calender.engmahmoudali.com/api/";
  static const String loginEP = "login";
  static const String registerEP = "register";
  static const String holidaysEP = "holidays";
  static const String adsEP = "ads";
  static const String notesEP = "notes";
  static const String serverNotes = "notes-server";
  static const String tasksEP = "tasks";
  static const String termsAndConditionsEP = "terms-and-conditions";
  static const String deleteAccountEP = "delete-account";
  static const String applicationData = "app";
  static const String passwordReset = "change-password";
  static const String updateProfile = 'update';
  static const String user = 'user';

  static const receiveTimeout = Duration(seconds: 15);
  static const connectionTimeout = Duration(seconds: 15);
}
