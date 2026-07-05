import 'package:get/get.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import 'package:clevora/app/data/models/result_model.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class ReportController extends GetxController {
  final HasilService _hasilService = Get.find<HasilService>();
  final AuthService _authService = Get.find<AuthService>();

  final selectedJurusan = Rxn<String>();
  final selectedKelas = Rxn<String>();
  final selectedMapel = Rxn<String>();

  final isLoading = false.obs;
  final isLoadingClasses = false.obs;
  final allResults = <ResultModel>[].obs;

  final kelasByJurusan = <String, List<String>>{}.obs;
  final mapelList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTeacherMapel();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    isLoadingClasses.value = true;
    try {
      final classes = await _hasilService.getClasses();
      kelasByJurusan.assignAll(classes);
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat daftar kelas: $e');
    } finally {
      isLoadingClasses.value = false;
    }
  }

  void _loadTeacherMapel() {
    final user = _authService.currentUser.value;
    if (user != null && user.mapel != null && user.mapel!.isNotEmpty) {
      mapelList.value = user.mapel!.split(',').map((e) => e.trim()).toList();
    }
  }

  List<ResultModel> get filteredResults {
    if (selectedKelas.value == null || selectedMapel.value == null) return [];
    return allResults.where((r) {
      final kelasMatch = r.siswaKelas == selectedKelas.value;
      final mapelMatch = r.kuisMapel.toLowerCase() == selectedMapel.value!.toLowerCase();
      return kelasMatch && mapelMatch;
    }).toList();
  }

  List<String> get studentNames {
    final names = <String>{};
    for (final r in filteredResults) {
      names.add(r.siswaNama);
    }
    return names.toList()..sort();
  }

  List<ResultModel> resultsForStudent(String nama) {
    return filteredResults.where((r) => r.siswaNama == nama).toList();
  }

  void selectJurusan(String jurusan) {
    selectedJurusan.value = jurusan;
    selectedKelas.value = null;
    selectedMapel.value = null;
    allResults.clear();
  }

  void selectKelas(String kelas) {
    selectedKelas.value = kelas;
    selectedMapel.value = null;
    allResults.clear();
  }

  void selectMapel(String mapel) {
    selectedMapel.value = mapel;
    fetchResults();
  }

  void backFromKelas() {
    selectedKelas.value = null;
    selectedMapel.value = null;
    allResults.clear();
  }

  void backFromMapel() {
    selectedMapel.value = null;
    allResults.clear();
  }

  Future<void> fetchResults() async {
    if (selectedKelas.value == null) return;
    isLoading.value = true;
    try {
      final results = await _hasilService.getHasil(kelas: selectedKelas.value);
      allResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat data nilai: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
