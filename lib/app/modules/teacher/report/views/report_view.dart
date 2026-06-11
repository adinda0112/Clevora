import 'package:flutter/material.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  String? selectedJurusan;
  String? selectedKelas;
  String? selectedMapel;

  final Map<String, List<String>> kelasByJurusan = {
    'IPA': ['X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2'],
    'IPS': ['X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2'],
  };

  final List<String> mapelList = [
    'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sosiologi', 'Ekonomi', 
    'Biologi', 'Fisika', 'Sejarah', 'PJOK', 'Prakarya dan Kewirausahaan', 
    'Pendidikan Agama Islam', 'Seni Budaya', 'Bahasa Jawa', 'Kimia'
  ];

  final List<Map<String, dynamic>> dummyStudents = [
    {'nama': 'Budi Santoso', 'pretest': 70, 'posttest': 85, 'ujian': 90},
    {'nama': 'Siti Aminah', 'pretest': 65, 'posttest': 80, 'ujian': 92},
    {'nama': 'Andi Wijaya', 'pretest': 50, 'posttest': 70, 'ujian': 78},
    {'nama': 'Rina Permata', 'pretest': 75, 'posttest': 85, 'ujian': 88},
    {'nama': 'Dewi Lestari', 'pretest': 80, 'posttest': 90, 'ujian': 95},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Laporan Nilai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: selectedKelas != null 
          ? (selectedMapel != null ? _buildStudentList() : _buildMapelSelection()) 
          : _buildJurusanKelasSelection(),
    );
  }

  Widget _buildJurusanKelasSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Jurusan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: _JurusanCard(
                  title: 'IPA',
                  isSelected: selectedJurusan == 'IPA',
                  onTap: () {
                    setState(() {
                      selectedJurusan = 'IPA';
                    });
                  },
                ),
              ),
              const Gap(16),
              Expanded(
                child: _JurusanCard(
                  title: 'IPS',
                  isSelected: selectedJurusan == 'IPS',
                  onTap: () {
                    setState(() {
                      selectedJurusan = 'IPS';
                    });
                  },
                ),
              ),
            ],
          ),
          const Gap(32),
          if (selectedJurusan != null) ...[
            Text('Daftar Kelas $selectedJurusan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
            const Gap(16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kelasByJurusan[selectedJurusan!]!.length,
              itemBuilder: (context, index) {
                final kelas = kelasByJurusan[selectedJurusan!]![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(kelas, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.primaryPurple),
                    onTap: () {
                      setState(() {
                        selectedKelas = kelas;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapelSelection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedKelas = null;
                  });
                },
              ),
              const Gap(8),
              Text(
                'Kelas $selectedKelas',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: mapelList.length,
            itemBuilder: (context, index) {
              final mapel = mapelList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(mapel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.primaryPurple),
                  onTap: () {
                    setState(() {
                      selectedMapel = mapel;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedMapel = null;
                  });
                },
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  'Nilai $selectedMapel\nKelas $selectedKelas',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: dummyStudents.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final student = dummyStudents[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.lightPurple,
                  child: Text(
                    student['nama'][0],
                    style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(student['nama'], style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildScoreBadge('Pre', student['pretest']),
                      _buildScoreBadge('Post', student['posttest']),
                      _buildScoreBadge('UAS', student['ujian']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(String label, int score) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
        const Gap(4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: score >= 80 ? const Color(0xFFEAF3DE) : AppColors.lightAmber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 12,
              color: score >= 80 ? const Color(0xFF3B6D11) : const Color(0xFF633806),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _JurusanCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _JurusanCard({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primaryPurple : AppColors.grey200),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primaryPurple.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.grey600,
            ),
          ),
        ),
      ),
    );
  }
}
