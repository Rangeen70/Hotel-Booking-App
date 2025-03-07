import 'dart:convert';

class ConfirmedBookingModel {
  final String id;
  final HotelInfo hotel;
  final String user;
  final String room;
  final String checkInDate;
  final String checkOutDate;
  final double totalPrice;
  final String status;
  final int guests;
  final String createdAt;
  final String updatedAt;

  ConfirmedBookingModel({
    required this.id,
    required this.hotel,
    required this.user,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.guests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConfirmedBookingModel.fromJson(Map<String, dynamic> json) {
    return ConfirmedBookingModel(
      id: json['_id'],
      hotel: HotelInfo.fromJson(json['hotel']),
      user: json['user'],
      room: json['room'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      guests: json['guests'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'hotel': hotel.toJson(),
      'user': user,
      'room': room,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'totalPrice': totalPrice,
      'status': status,
      'guests': guests,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static List<ConfirmedBookingModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ConfirmedBookingModel.fromJson(json))
        .toList();
  }
}

class HotelInfo {
  final String id;
  final String name;
  final String address;
  final List<String> photos;

  HotelInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.photos,
  });

  factory HotelInfo.fromJson(Map<String, dynamic> json) {
    // Handle photos, which could be a single string or a list
    List<String> photosList = [];
    if (json['photos'] != null) {
      if (json['photos'] is String) {
        photosList.add(json['photos']);
      } else if (json['photos'] is List) {
        photosList = List<String>.from(json['photos']);
      }
    }

    return HotelInfo(
      id: json['_id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      photos: photosList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'photos': photos,
    };
  }
}
