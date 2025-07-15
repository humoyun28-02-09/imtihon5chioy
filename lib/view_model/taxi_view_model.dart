import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaxiViewModel {
  IO.Socket? socket;
  List<LatLng> polylineCoordinates = [];
  String? distance;
  String? eta;

  final String googleApiKey = 'AIzaSyDklE2adHNKrJzQ44X2iXULt2FOjOEm6Us';

  void connectSocket(Function(LatLng) onTaxiLocationReceived) {
    socket = IO.io('http://your-server-ip:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print('✅ Taksi socketga ulandi');
    });

    socket!.on('taxiLocation', (data) {
      if (data != null && data['lat'] != null && data['lng'] != null) {
        final double lat = data['lat'];
        final double lng = data['lng'];
        final LatLng location = LatLng(lat, lng);
        onTaxiLocationReceived(location);
      }
    });

    socket!.on('disconnect', (_) {
      print('⚠️ Socket uzildi');
    });
  }

  void sendLocation(double lat, double lng) {
    socket?.emit('taxiLocation', {'lat': lat, 'lng': lng});
  }

  Future<void> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      distance = '1.2 km';
      eta = '4 min';
    }
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
  }
}
