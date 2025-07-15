import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiState {
  final String status;
  final LatLng? taxiLocation;

  TaxiState({required this.status, this.taxiLocation});

  factory TaxiState.initial() =>
      TaxiState(status: 'boshlang‘ich', taxiLocation: null);

  TaxiState copyWith({String? status, LatLng? taxiLocation}) {
    return TaxiState(
      status: status ?? this.status,
      taxiLocation: taxiLocation ?? this.taxiLocation,
    );
  }
}
