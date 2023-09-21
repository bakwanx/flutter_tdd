import 'dart:convert';

import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if(response.statusCode == 200){
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
