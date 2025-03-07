part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class LoadImage extends RegisterEvent {
  final File file;

  const LoadImage({
    required this.file,
  });
}

class RegisterUser extends RegisterEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  final String? photo;

  const RegisterUser({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.photo,
  });

  @override
  List<Object> get props => [
        name,
        username,
        email,
        password,
      ];
}
