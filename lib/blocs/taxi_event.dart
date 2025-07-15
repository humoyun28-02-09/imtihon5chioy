import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TaxiEvent {}

class InitializeTaxiEvent extends TaxiEvent {}

class UpdateTaxiLocationEvent extends TaxiEvent {
  final LatLng location;

  UpdateTaxiLocationEvent(this.location);
}
