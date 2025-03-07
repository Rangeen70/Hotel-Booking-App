import 'package:dio/dio.dart';
import 'package:hotel_booking/app/constants/api_endpoints.dart';
import '../models/hotel_model.dart';

class HotelService {
  final Dio _dio = Dio();

  Future<List<HotelModel>> getHotels() async {
    try {
      final response =
          await _dio.get(ApiEndpoints.baseUrl + ApiEndpoints.getHotels);

      if (response.statusCode == 200) {
        final List<dynamic> hotelsJson = response.data;
        return hotelsJson.map((json) => HotelModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hotels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load hotels: $e');
    }
  }
}
