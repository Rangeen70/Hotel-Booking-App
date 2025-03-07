import 'dart:convert';

class BookingModel {
  final String checkInDate;
  final String checkOutDate;
  final String guests;
  final String hotelId;
  final String room;
  final String? userId; // Optional: can be set during API call
  final String? userName; // Optional: for display purposes
  final String? userEmail; // Optional: for display purposes

  BookingModel({
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.hotelId,
    required this.room,
    this.userId,
    this.userName,
    this.userEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'guests': guests,
      'hotelId': hotelId,
      'room': room,
      if (userId != null) 'userId': userId,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      guests: json['guests'].toString(),
      hotelId: json['hotelId'],
      room: json['room'],
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }
}
