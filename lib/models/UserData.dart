class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  String? name;
  String? collegeName;
  String? dob;
  String? disabilityType;
  String? examMode;
  String? registerNumber;
  String? password;

  // Method to clear the data, useful for testing or logging out.
  void clear() {
    name = null;
    collegeName = null;
    dob = null;
    disabilityType = null;
    examMode = null;
    registerNumber = null;
    password = null;
  }
}
