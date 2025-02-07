import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/user_entity.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id') // Maps the server field "_id" to the "userId" field
  final String? id;
  final String name;
  final String username;
  final String email;
  final String password;

  // @JsonKey(name: 'photo') // Maps the server field "photo" to the "image" field
  final String? photo;

  const UserApiModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.photo,
  });

  const UserApiModel.empty()
      : id = '',
        name = '',
        username = '',
        email = '',
        password = '',
        photo = '';

  /// Factory constructor for creating a `UserApiModel` from JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      photo: json['photo'] as String?,
    );
  }

  /// Converts the current instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'photo': photo,
    };
  }

  /// Converts the API model to a domain entity
  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        username: username,
        email: email,
        password: password,
        photo: photo,
        phone: null,
      );

  /// Converts a domain entity to an API model
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      photo: entity.photo,
    );
  }

  /// Converts a list of API models to a list of entities
  static List<UserEntity> toEntityList(List<UserApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        password,
        photo,
      ];
}
