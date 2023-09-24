import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';


@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  late GetConcreteNumberTrivia usecase;
  final NumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();

  setUp(() {
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  const tNumberTrivia = NumberTrivia(
    text: "",
    number: 1,
    found: true,
    type: "",
  );
  test("should get trivia for the number from the repository", () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(1)).thenAnswer(
      (_) async => Right(tNumberTrivia),
    );

    // act
    final result = await usecase(Params(number: tNumber));

    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
