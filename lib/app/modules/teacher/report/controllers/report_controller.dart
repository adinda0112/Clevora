import 'package:get/get.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import 'package:clevora/app/data/models/result_model.dart';

class ReportController extends GetxController {
  final HasilService _hasilService = Get.find<HasilService>();

  final selectedJurusan = Rxn<String>();
  final selectedKelas = Rxn<String>();
  final selectedMapel = Rxn<String>();

  final isLoading = false.obs;
  final allResults = <ResultModel>[].obs;

  final Map<String, List<String>> kelasByJurusan = {
    'IPA': ['X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2'],
    'IPS': ['X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2'],
  };

  final List<String> mapelList = [
    'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sosiologi', 'Ekonomi',
    'Biologi', 'Fisika', 'Sejarah', 'PJOK', 'Prakarya dan Kewirausahaan',
    'Pendidikan Agama Islam', 'Seni Budaya', 'Bahasa Jawa', 'Kimia',
  ];

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
