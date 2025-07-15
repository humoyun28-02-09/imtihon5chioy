import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiState {
  final String status;
  final LatLng? taxiLocation;
  final List<LatLng> polylineCoordinates;
  final String? distance;
  final String? eta;

  TaxiState({
    required this.status,
    this.taxiLocation,
    this.polylineCoordinates = const [],
    this.distance,
    this.eta,
  });

  factory TaxiState.initial() => TaxiState(
    status: 'boshlang‘ich',
    taxiLocation: const LatLng(41.3050, 69.2500),
  );

  TaxiState copyWith({
    String? status,
    LatLng? taxiLocation,
    List<LatLng>? polylineCoordinates,
    String? distance,
    String? eta,
  }) {
    return TaxiState(
      status: status ?? this.status,
      taxiLocation: taxiLocation ?? this.taxiLocation,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      distance: distance ?? this.distance,
      eta: eta ?? this.eta,
    );
  }
}
