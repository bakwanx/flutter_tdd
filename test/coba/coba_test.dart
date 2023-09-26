import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coba_test.mocks.dart';
// class CobaRepositoryMock extends Mock implements CobaRepository{}
@GenerateNiceMocks([MockSpec<CobaRepository>()])
void main(){
  late MockCobaRepository mockCobaRepository = MockCobaRepository();
  late ClassObjectDipanggil classObjectDipanggil;
  // print(classObjectDipanggil.methodObject());
  setUp(() {
    classObjectDipanggil = ClassObjectDipanggil(mockCobaRepository);
  });
  group("test group", () {
    test("test methodCoba isCalled", (){
      when(mockCobaRepository.methodCoba(any)).thenAnswer((_) => "test");
      final result = classObjectDipanggil.methodObject("");

      expect(result, "test");
    });
  });

}

abstract class CobaRepository{
  String methodCoba(String text);
}


class ClassCobaImpl implements CobaRepository {

  @override
  String methodCoba(String text) => text;

}

class ClassObjectDipanggil {
  final CobaRepository cobaRepository;
  ClassObjectDipanggil(this.cobaRepository);

  String methodObject(String text) => cobaRepository.methodCoba(text);
}

