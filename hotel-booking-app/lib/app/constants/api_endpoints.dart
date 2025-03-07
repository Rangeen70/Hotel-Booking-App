class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // // For Android Emulator
  // api_endpoints
  static const String baseUrl = "http://10.0.2.2:8000/api/";

  // For iPhone
  // static const String baseUrl = "http://localhost:6278/api/v1/";

  // ============= Auth Routes =============
  static const String login = "user/login";
  static const String register = "user/register";
  static const String deleteUser = "auth/delete/";
  static const String getAllUsers = "auth/getAllUsers/";

  // ============= Hotel Routes =============
  static const String getHotels = "hotel";

  // static const String imageUrl = "http://localhost:6278/public/uploads/";
  // static const String imageUrl = "http://10.0.2.2:5000/public/uploads/";
  static const String imageUrl = "http://10.0.2.2:8000/uploads/";

  static const String uploadImage = "auth/uploadImage";
}
