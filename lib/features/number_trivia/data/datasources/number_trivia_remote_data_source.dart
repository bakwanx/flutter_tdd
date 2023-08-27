import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource{
  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  // calls the remote api, and throws [Server Exception] for all error codes
  Future<NumberTrivia> getRandomNumberTrivia();
}