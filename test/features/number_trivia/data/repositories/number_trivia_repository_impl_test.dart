import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/platform/network_info.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/impl_repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
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

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(
      text: "",
      number: 1,
      found: true,
      type: "",
    );
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    // test("should check if device is online", () async {
    //   // arrange
    //   when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   // act
    //   repository.getConcreteNumberTrivia(tNumber);
    //   // assert
    //   expect(true, await mockNetworkInfo.isConnected);
    //   verify(mockNetworkInfo.isConnected);
    // });


    group("device is online", () async {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          "should return remote data when the call to remote data source is successful",
              () async {
            // // arrange
            // when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(1))
            //     .thenAnswer((_) async => tNumberTrivia);
            // // act
            // final result = await repository.getConcreteNumberTrivia(tNumber);
            // // assert
            // verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
            // expect(result, equals(Right(tNumberTrivia)));
          });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });

  });


}
