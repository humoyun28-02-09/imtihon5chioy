import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app_imtihon/blocs/taxi_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app_imtihon/blocs/taxi_event.dart';
import 'package:user_app_imtihon/blocs/taxi_state.dart';
import 'package:user_app_imtihon/view_model/taxi_view_model.dart';

void main() {
  runApp(const UserApp());
}

class UserApp extends StatefulWidget {
  const UserApp({super.key});

  @override
  State<UserApp> createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foydalanuvchi Taxi Kuzatuvchisi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            TaxiBloc(TaxiViewModel())..add(ConnectSocketEvent()),
        child: const UserHomePage(),
      ),
    );
  }
}

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  GoogleMapController? _mapController;
  final LatLng _userLocation = LatLng(41.2995, 69.2401);
  LatLng _taxiLocation = LatLng(41.2995, 69.2401);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taksi Kuzatuvchi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<TaxiBloc, TaxiState>(
        builder: (context, state) {
          if (state.taxiLocation != null) {
            _taxiLocation = state.taxiLocation!;
            print(_mapController);
          }
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
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
                    state.status == 'bog‘langan'
                        ? 'Taksi sizga yetib kelmoqda...'
                        : 'Taksi bilan bog‘lanmoqda...',
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
