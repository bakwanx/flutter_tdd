import 'dart:convert';
import 'dart:io';

import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpClientSuccess200(){
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(fixture('trivia.json'), 200),
    );
  }

  void setUpClientFailure404(){
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response('Something when wrong', 404),
    );
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test("should return NumberTrivia when response code is 200(success)", () async {
      // arrange
      setUpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw a ServerException when the response code is 4040 or other", () async {
      // arrange
      setUpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being 
      the endpoint and with application/json header''',
          () async {
        // arrange
        setUpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test("should return NumberTrivia when response code is 200(success)", () async {
      // arrange
      setUpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw a ServerException when the response code is 4040 or other", () async {
      // arrange
      setUpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
