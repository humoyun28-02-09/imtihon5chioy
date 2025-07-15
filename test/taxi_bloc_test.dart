import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_app_imtihon/blocs/taxi_bloc.dart';
import 'package:user_app_imtihon/blocs/taxi_event.dart';
import 'package:user_app_imtihon/blocs/taxi_state.dart';
import 'package:user_app_imtihon/view_model/taxi_view_model.dart';

import 'taxi_bloc_test.mocks.dart';

@GenerateMocks([TaxiViewModel])
void main() {
  late TaxiBloc taxiBloc;
  late MockTaxiViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockTaxiViewModel();
    taxiBloc = TaxiBloc(mockViewModel);
  });

  test('Boshlang‘ich holat to‘g‘ri', () {
    expect(taxiBloc.state, TaxiState.initial());
  });

  test('Socket ulanganda bog‘langan holat chiqadi', () async {
    when(mockViewModel.connectSocket(any)).thenAnswer((_) async {});

    taxiBloc.add(ConnectSocketEvent());

    await untilCalled(mockViewModel.connectSocket(any));

    expectLater(
      taxiBloc.stream,
      emitsInOrder([
        TaxiState(status: 'bog‘lanmoqda', taxiLocation: null),
        TaxiState(status: 'bog‘langan', taxiLocation: null),
      ]),
    );
  });
}
