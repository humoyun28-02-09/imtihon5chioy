import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaxiViewModel {
  IO.Socket? socket;

  Future<void> connectSocket(Function(double, double) onLocationUpdate) async {
    socket = IO.io('http://192.168.1.100:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.on('connect', (_) {
      print('✅ Foydalanuvchi socketga ulandi');
    });

    socket!.on('taxiLocation', (data) {
      try {
        final lat = data['lat'] as double;
        final lng = data['lng'] as double;
        onLocationUpdate(lat, lng);
      } catch (e) {
        print('❌ taxiLocation parsingda xato: $e');
      }
    });
  }
}
