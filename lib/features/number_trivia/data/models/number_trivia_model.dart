import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel(
      {required super.text,
      required super.number,
      required super.found,
      required super.type});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) => NumberTriviaModel(
    text: json["text"],
    number: (json["number"] as num).toInt(),
    found: json["found"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "number": number,
    "found": found,
    "type": type,
  };

}
