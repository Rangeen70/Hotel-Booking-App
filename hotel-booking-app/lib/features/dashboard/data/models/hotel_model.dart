import 'package:intl/intl.dart';

class HotelModel {
  final String id;
  final String name;
  final String type;
  final String city;
  final String address;
  final String description;
  final int rating;
  final List<String> rooms;
  final double cheapestPrice;
  final bool featured;
  final String photos;
  final String reservationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  HotelModel({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.address,
    required this.description,
    required this.rating,
    required this.rooms,
    required this.cheapestPrice,
    required this.featured,
    required this.photos,
    required this.reservationStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  String get imageUrl => 'http://localhost:8000/uploads/$photos';

  String get formattedPrice => NumberFormat.currency(
        symbol: 'Rs. ',
        decimalDigits: 0,
      ).format(cheapestPrice);

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      city: json['city'],
      address: json['address'],
      description: json['description'],
      rating: json['rating'],
      rooms: List<String>.from(json['rooms']),
      cheapestPrice: json['cheapestPrice'].toDouble(),
      featured: json['featured'],
      photos: json['photos'],
      reservationStatus: json['reservationStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
