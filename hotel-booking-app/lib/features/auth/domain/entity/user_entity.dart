import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? photo;

  const UserEntity({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.photo,
    required phone,
  });

  @override
  List<Object?> get props => [id, email, username];
}
