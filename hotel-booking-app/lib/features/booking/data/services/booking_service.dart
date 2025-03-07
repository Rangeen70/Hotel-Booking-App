import 'dart:convert';
import 'package:hotel_booking/app/shared_prefs/token_shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_booking/app/constants/api_endpoints.dart';
import 'package:hotel_booking/features/booking/data/models/booking_model.dart';
import 'package:hotel_booking/features/booking/data/models/confirmed_booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  final http.Client _httpClient = http.Client();

  Future<Map<String, dynamic>> bookHotel(BookingModel bookingData) async {
    try {
      late String finaltoken;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await TokenSharedPrefs(prefs).getToken();
      token.fold((l) => '', (r) => finaltoken = r);

      print(finaltoken);
      final response = await _httpClient.post(
        Uri.parse('${ApiEndpoints.baseUrl}booking/book-hotel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $finaltoken',
        },
        body: bookingData.toJsonString(),
      );

      print(response.body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData,
          'message': 'Booking successful',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to book hotel',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  Future<List<BookingModel>> getUserBookings() async {
    late String finaltoken;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenSharedPrefs(prefs).getToken();
    token.fold((l) => '', (r) => finaltoken = r);

    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}booking'),
        headers: {
          'Authorization': 'Bearer $finaltoken',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((booking) => BookingModel.fromJson(booking)).toList();
      } else {
        throw Exception('Failed to fetch user bookings');
      }
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  Future<List<ConfirmedBookingModel>> getUserConfirmedBookings() async {
    late String finaltoken;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await TokenSharedPrefs(prefs).getToken();
    token.fold((l) => '', (r) => finaltoken = r);

    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}booking'),
        headers: {
          'Authorization': 'Bearer $finaltoken',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return ConfirmedBookingModel.fromJsonList(data);
      } else {
        throw Exception(
            'Failed to fetch user bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings: ${e.toString()}');
      throw Exception('An error occurred: ${e.toString()}');
    }
  }
}
