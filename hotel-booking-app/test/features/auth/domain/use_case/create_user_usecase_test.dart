import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/error/failure.dart';
import 'package:hotel_booking/features/auth/domain/entity/user_entity.dart';
import 'package:hotel_booking/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late CreateUserUsecase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = CreateUserUsecase(userRepository: repository);
  });

  const UserParams = CreateUserParams(
    name: 'name',
    email: 'email',
    phone: 'phone',
    username: 'username',
    password: 'password',
    photo: 'photo',
  );

  final authEntity = UserEntity(
    id: null,
    name: UserParams.name,
    username: UserParams.username,
    phone: UserParams.photo,
    email: UserParams.email,
    password: UserParams.password,
    photo: UserParams.photo,
  );

  test('should call registerUser in the repository with correct params',
      () async {
    // Arrange
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(UserParams);

    // Assert
    expect(result, const Right(null));
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return Left(Failure) when registration fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Registration failed');
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await useCase(UserParams);

    // Assert
    expect(result, Left(failure));
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should call the createUser method with the correct parameters',
      () async {
    // Arrange
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => const Right(null));

    // Act
    await useCase(UserParams);

    // Assert
    verify(() => repository.createUser(authEntity)).called(1);
    expect(authEntity.name, 'name');
    expect(authEntity.email, 'email');
    expect(authEntity.username, 'username');
    expect(authEntity.password, 'password');
    expect(authEntity.photo, 'photo');
  });

  test('should return a success result when registration is successful',
      () async {
    // Arrange
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(UserParams);

    // Assert
    expect(result, const Right(null));
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  // Test 1: Should return an error when user creation fails due to invalid email or password
  test(
      'should return an error when user creation fails due to invalid email or password',
      () async {
    // Arrange
    final failure = ApiFailure(message: 'Invalid email or password');
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await useCase(UserParams);

    // Assert
    expect(result, Left(failure));
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  // Test 2: Should return an error when the repository fails due to server issues
  test('should return an error when repository fails due to server issues',
      () async {
    // Arrange
    final failure = ApiFailure(message: 'Server error');
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await useCase(UserParams);

    // Assert
    expect(result, Left(failure));
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  // Test 3: Should not make additional calls to the repository after the first interaction
  test(
      'should not make additional calls to the repository after the first interaction',
      () async {
    // Arrange
    when(() => repository.createUser(authEntity))
        .thenAnswer((_) async => const Right(null));

    // Act
    await useCase(UserParams);
    await useCase(UserParams); // Call again to ensure no extra interaction

    // Assert
    verify(() => repository.createUser(authEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
