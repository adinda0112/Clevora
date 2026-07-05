import 'dart:convert';
import 'package:get/get.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/routes/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as dio;

class AttendanceService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  IO.Socket? socket;

  void initSocket(String kelasId, Function(dynamic) onAttendanceUpdated) {
    if (socket != null && socket!.connected) return;
    
    final socketUrl = Api.baseUrl.replaceAll('/api', '');
    
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket!.connect();
    
    socket!.onConnect((_) {
      print('Connected to Socket.IO');
      socket!.emit('join_kelas', kelasId);
    });
    
    socket!.on('attendance_scanned', (data) {
      onAttendanceUpdated(data);
    });

    socket!.on('attendance_updated', (data) {
      onAttendanceUpdated(data);
    });
    
    socket!.onDisconnect((_) => print('Disconnected from Socket.IO'));
  }

  void disconnectSocket() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> getAttendance({
    required String kelas,
    int? bulan,
    int? tahun,
  }) async {
    final queryParams = <String, dynamic>{'kelas': kelas};
    if (bulan != null) queryParams['bulan'] = bulan;
    if (tahun != null) queryParams['tahun'] = tahun;

    final response = await _apiProvider.dio.get('/absensi', queryParameters: queryParams);
    if (response.data?['success'] == true) {
      return response.data['data'] ?? {};
    }
    throw response.data?['message'] ?? 'Gagal mengambil data absensi';
  }

  Future<bool> recordAttendance({
    required List<Map<String, dynamic>> records,
    required String tanggal,
    required String kelas,
    String? mapel,
  }) async {
    final response = await _apiProvider.dio.post('/absensi', data: {
      'records': records,
      'tanggal': tanggal,
      'kelas': kelas,
      'mapel': mapel,
    });
    return response.data?['success'] ?? false;
  }

  Future<String> generateQr({
    required String kelas,
    required String mapel,
    String? tanggal,
  }) async {
    final response = await _apiProvider.dio.post('/absensi/qr-generate', data: {
      'kelas': kelas,
      'mapel': mapel,
      'tanggal': tanggal,
    });
    if (response.data?['success'] == true) {
      return response.data['qrToken'];
    }
    throw response.data?['message'] ?? 'Gagal generate QR';
  }

  Future<bool> scanQr({
    required String qrToken,
  }) async {
    try {
      final position = await _getCurrentLocation();
      
      final data = <String, dynamic>{
        'qrToken': qrToken,
      };
      
      if (position != null) {
        data['latitude'] = position.latitude;
        data['longitude'] = position.longitude;
      }

      final response = await _apiProvider.dio.post('/absensi/scan-qr', data: data);
      return response.data?['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> scanFace({
    required String kelas,
    required String mapel,
    required String imagePath,
    String? tanggal,
  }) async {
    try {
      final position = await _getCurrentLocation();
      
      final formData = dio.FormData.fromMap({
        'kelas': kelas,
        'mapel': mapel,
        if (tanggal != null) 'tanggal': tanggal,
        if (position != null) 'latitude': position.latitude,
        if (position != null) 'longitude': position.longitude,
        'foto_wajah': await dio.MultipartFile.fromFile(imagePath),
      });

      final response = await _apiProvider.dio.post('/absensi/scan-face', data: formData);
      return response.data?['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
