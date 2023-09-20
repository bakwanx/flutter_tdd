import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource{
  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}