import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class CreateUserParams extends Equatable {
  final String? id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? photo;

  const CreateUserParams({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.photo,
    required String phone,
  });

  @override
  List<Object?> get props => [
        name,
        username,
        email,
        password,
        photo,
      ];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'photo': photo,
    };
  }
}

class CreateUserUsecase implements UsecaseWithParams<void, CreateUserParams> {
  final IUserRepository userRepository;

  const CreateUserUsecase({required this.userRepository});

  @override
  Future<Either<Failure, void>> call(CreateUserParams params) async {
    // Create the user entity from the params
    final userEntity = UserEntity(
      id: null,
      // The ID will be generated automatically
      name: params.name,
      username: params.username,
      email: params.email,
      password: params.password,
      photo: params.photo, phone: null,
      // dob: params.dob,
    );

    // Call the repository method to create the user
    return await userRepository.createUser(userEntity);
  }
}
