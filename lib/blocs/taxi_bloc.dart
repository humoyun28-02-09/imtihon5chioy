import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/taxi_event.dart';
import '../blocs/taxi_state.dart';
import '../view_model/taxi_view_model.dart';

class TaxiBloc extends Bloc<TaxiEvent, TaxiState> {
  final TaxiViewModel viewModel;

  TaxiBloc(this.viewModel) : super(TaxiState.initial()) {
    on<ConnectSocketEvent>((event, emit) async {
      emit(state.copyWith(status: 'bog‘lanmoqda'));
      await viewModel.connectSocket((lat, lng) {
        add(UpdateTaxiLocationEvent(LatLng(lat, lng)));
      });
      emit(state.copyWith(status: 'bog‘langan'));
    });

    on<UpdateTaxiLocationEvent>((event, emit) {
      emit(state.copyWith(taxiLocation: event.location));
    });
  }
}
