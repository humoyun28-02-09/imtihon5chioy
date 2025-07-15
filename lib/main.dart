import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app_imtihon/blocs/taxi_bloc.dart';
import 'package:taxi_app_imtihon/blocs/taxi_event.dart';
import 'package:taxi_app_imtihon/blocs/taxi_state.dart';
import 'package:taxi_app_imtihon/view_model/taxi_view_model.dart';

void main() {
  runApp(const TaxiApp());
}

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taksi Haydovchisi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            TaxiBloc(TaxiViewModel())..add(InitializeTaxiEvent()),
        child: const TaxiHomePage(),
      ),
    );
  }
}

class TaxiHomePage extends StatefulWidget {
  const TaxiHomePage({super.key});

  @override
  State<TaxiHomePage> createState() => _TaxiHomePageState();
}

class _TaxiHomePageState extends State<TaxiHomePage> {
  GoogleMapController? _mapController;
  final LatLng _userLocation = const LatLng(41.2995, 69.2401);
  LatLng _taxiLocation = const LatLng(41.3050, 69.2500);
  List<LatLng> _polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taksi Haydovchisi'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<TaxiBloc, TaxiState>(
        builder: (context, state) {
          if (state.taxiLocation != null) {
            _taxiLocation = state.taxiLocation!;
            print(_mapController);
          }
          if (state.polylineCoordinates.isNotEmpty) {
            _polylineCoordinates = state.polylineCoordinates;
          }
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _taxiLocation,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('foydalanuvchi'),
                    position: _userLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('taksi'),
                    position: _taxiLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('yo‘nalish'),
                    points: _polylineCoordinates,
                    color: Colors.blue,
                    width: 6,
                  ),
                },
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Text(
                    'Masofa: ${state.distance ?? 'Hisoblanmoqda...'} km\nYetib borish: ${state.eta ?? 'Hisoblanmoqda...'} min',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
