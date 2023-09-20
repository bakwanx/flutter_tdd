import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/impl_repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
void main() {
  late NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource =
      MockNumberTriviaRemoteDataSource();
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource =
      MockNumberTriviaLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();

  setUp(() {
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(
      text: "",
      number: 1,
      found: true,
      type: "",
    );
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      expect(true, await mockNetworkInfo.isConnected);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        "should return remote data when the call to remote data source is successful",
        () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaRemoteDataSource
              .getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is successful",
        () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
          );
          verify(
            mockNumberTriviaLocalDataSource.cacheNumberTrivia(
              tNumberTriviaModel,
            ),
          );
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaRemoteDataSource
              .getConcreteNumberTrivia(tNumber));
          // verifyZeroInteractions(mockNumberTriviaLocalDataSource); // make sure there is no cache proccess when failure
          expect(result, equals(Left(ServerFailure())));
          // debugPrint("pesan ${result}");
        },
      );
    });

    runTestsOffline(
      () {

        test(
          "should return last locally cached data when the cached data is present",
          () async {
            // arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer(
              (_) async => tNumberTriviaModel,
            );
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          "should return CacheFailure() when there is no cached data present",
          () async {
            // arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      },
    );
  });

  group("getRandomNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(
      text: "test trivia",
      number: 123,
      found: true,
      type: "",
    );
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // assert
      expect(true, await mockNetworkInfo.isConnected);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        "should return remote data when the call to remote data source is successful",
            () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDataSource
              .getRandomNumberTrivia());//make sure this function is called
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is successful",
            () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(
            mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
          );
          verify(
            mockNumberTriviaLocalDataSource.cacheNumberTrivia(
              tNumberTriviaModel,
            ),
          );
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
            () async {
          // // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDataSource
              .getRandomNumberTrivia());
          // verifyZeroInteractions(mockNumberTriviaLocalDataSource); // make sure there is no cache proccess when failure
          expect(result, equals(Left(ServerFailure())));
          // debugPrint("pesan ${result}");
        },
      );
    });

    runTestsOffline(
          () {
        test(
          "should return last locally cached data when the cached data is present",
              () async {
            // arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer(
                  (_) async => tNumberTriviaModel,
            );
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          "should return CacheFailure() when there is no cached data present",
              () async {
            // arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      },
    );
  });
}
