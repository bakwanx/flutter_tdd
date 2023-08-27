import 'dart:convert';

import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(
    text: "",
    number: 1,
    found: true,
    type: "",
  );

  test("should be a subclass of NumberTrivia entity", () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson',(){
    test('should return a valid model when the JSON number is an integer', () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should return a valid model when the JSON number is regarded as a double', () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
  });

  group("toJson",() {
    test("should return a Json Map containing the proper data", () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectMap = {
        "text": "",
        "number": 1,
        "found": true,
        "type": ""
      };
      expect(result, expectMap);
    });
  });
}
