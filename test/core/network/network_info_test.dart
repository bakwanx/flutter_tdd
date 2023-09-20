import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
void main(){
  late NetworkInfoImpl networkInfo;
  MockConnectivity mockConnectivity = MockConnectivity();

  setUp(() {
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group("isConnected", () {
    test("should get connection", () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.wifi);

      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    });

    test("should not get connection", () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.none);

      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, false);
    });

  });
}