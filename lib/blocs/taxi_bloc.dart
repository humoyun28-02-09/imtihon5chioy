import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app_imtihon/blocs/taxi_event.dart';
import 'package:taxi_app_imtihon/blocs/taxi_state.dart';
import 'package:taxi_app_imtihon/view_model/taxi_view_model.dart';

class TaxiBloc extends Bloc<TaxiEvent, TaxiState> {
  final TaxiViewModel viewModel;

  TaxiBloc(this.viewModel) : super(TaxiState.initial()) {
    on<InitializeTaxiEvent>(_onInit);
    on<UpdateTaxiLocationEvent>(_onLocationUpdate);
  }

  Future<void> _onInit(
    InitializeTaxiEvent event,
    Emitter<TaxiState> emit,
  ) async {
    emit(state.copyWith(status: 'boshlanmoqda'));

    viewModel.connectSocket((LatLng location) {
      add(UpdateTaxiLocationEvent(location));
    });

    await viewModel.getRoute(
      origin: const LatLng(41.3050, 69.2500),
      destination: const LatLng(41.2995, 69.2401),
    );

    emit(
      state.copyWith(
        status: 'bog‘langan',
        polylineCoordinates: viewModel.polylineCoordinates,
        distance: viewModel.distance,
        eta: viewModel.eta,
      ),
    );
  }

  void _onLocationUpdate(
    UpdateTaxiLocationEvent event,
    Emitter<TaxiState> emit,
  ) {
    emit(state.copyWith(taxiLocation: event.location));
  }
}
