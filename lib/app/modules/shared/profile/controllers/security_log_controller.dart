import 'package:get/get.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class SecurityLogModel {
  final String id;
  final String action;
  final String endpoint;
  final String ipAddress;
  final String status;
  final DateTime createdAt;
  final String? userAgent;

  SecurityLogModel({
    required this.id,
    required this.action,
    required this.endpoint,
    required this.ipAddress,
    required this.status,
    required this.createdAt,
    this.userAgent,
  });

  factory SecurityLogModel.fromJson(Map<String, dynamic> json) {
    return SecurityLogModel(
      id: json['_id'] ?? '',
      action: json['action'] ?? '',
      endpoint: json['endpoint'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']).toLocal() : DateTime.now(),
      userAgent: json['userAgent'],
    );
  }
}

class SecurityLogController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  final logs = <SecurityLogModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.dio.get('/logs');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        logs.value = data.map((e) => SecurityLogModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat log keamanan');
    } finally {
      isLoading.value = false;
    }
  }
}
