import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/attendance/controllers/attendance_history_controller.dart';

class AttendanceHistoryView extends GetView<AttendanceHistoryController> {
  const AttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Riwayat Presensi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.sessions.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('Belum ada riwayat presensi.', style: TextStyle(color: AppColors.grey600, fontSize: 16)),
                ),
              );
            }
            return Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: controller.sessions.length,
                separatorBuilder: (_, _) => const Gap(16),
                itemBuilder: (context, index) {
                  final session = controller.sessions[index];
                  final stats = session['stats'] as Map<String, int>? ?? {};
                  return GestureDetector(
                    onTap: () => _openEditSheet(session, index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                session['date'] ?? '',
                                style: const TextStyle(color: AppColors.grey600, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightPurple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      session['kelas'] ?? '',
                                      style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Gap(8),
                                  const Icon(Icons.edit_outlined, size: 18, color: AppColors.grey500),
                                ],
                              ),
                            ],
                          ),
                          const Gap(10),
                          Text(
                            session['mapel'] ?? '',
                            style: const TextStyle(color: AppColors.grey900, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const Gap(14),
                          const Divider(height: 1),
                          const Gap(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem('Hadir', stats['hadir'] ?? 0, Colors.green),
                              _buildStatItem('Alpa', stats['alpa'] ?? 0, Colors.red),
                              _buildStatItem('Izin', stats['izin'] ?? 0, Colors.blue),
                              _buildStatItem('Sakit', stats['sakit'] ?? 0, Colors.amber),
                            ],
                          ),
                          const Gap(8),
                          const Text(
                            'Ketuk untuk mengubah presensi',
                            style: TextStyle(fontSize: 11, color: AppColors.grey500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedKelas.value.isNotEmpty ? controller.selectedKelas.value : null,
              hint: const Text('Kelas', style: TextStyle(fontSize: 13)),
              isExpanded: true,
              items: controller.kelasOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.selectedKelas.value = val;
                  controller.loadHistory();
                }
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(),
              ),
            )),
          ),
          const Gap(8),
          Expanded(
            child: Obx(() => InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.selectedDate.value = picked;
                  if (controller.selectedKelas.value.isNotEmpty) {
                    controller.loadHistory();
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const Gap(4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }

  void _openEditSheet(Map<String, dynamic> session, int sessionIndex) {
    final editStudents = (session['students'] as List).map((s) {
      return {
        ...Map<String, dynamic>.from(s as Map),
        '_id': s['_id'],
      };
    }).toList();

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _EditSessionSheet(
          session: session,
          students: editStudents,
          onSave: (updatedStudents) {
            controller.updateSessionStudents(session, updatedStudents);
          },
        );
      },
    );
  }
}

class _EditSessionSheet extends StatefulWidget {
  final Map<String, dynamic> session;
  final List<Map<String, dynamic>> students;
  final void Function(List<Map<String, dynamic>> updatedStudents) onSave;

  const _EditSessionSheet({
    required this.session,
    required this.students,
    required this.onSave,
  });

  @override
  State<_EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<_EditSessionSheet> {
  late List<Map<String, dynamic>> _editStudents;

  @override
  void initState() {
    super.initState();
    _editStudents = widget.students.map((s) => Map<String, dynamic>.from(s)).toList();
  }

  void _updateStatus(int index, String status) {
    setState(() {
      _editStudents[index]['status'] = status;
    });
  }

  void _save() {
    widget.onSave(_editStudents);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.session['mapel']} — ${widget.session['kelas']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                        ),
                        const Gap(4),
                        Text(widget.session['date'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.grey600)),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Simpan'),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: _editStudents.length,
                  separatorBuilder: (_, _) => const Divider(height: 12),
                  itemBuilder: (context, index) {
                    final student = _editStudents[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.lightPurple,
                            child: Text(
                              (student['nama'] as String? ?? '?')[0],
                              style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(student['nama'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            'Status: ${student['status'] ?? 'Belum diabsensi'}',
                            style: TextStyle(
                              color: _statusColor(student['status']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statusBtn('Hadir', Colors.green, index, student['status']),
                            _statusBtn('Alpa', Colors.red, index, student['status']),
                            _statusBtn('Sakit', Colors.amber, index, student['status']),
                            _statusBtn('Izin', Colors.blue, index, student['status']),
                          ],
                        ),
                        const Gap(4),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Hadir': return Colors.green;
      case 'Alpa': return Colors.red;
      case 'Sakit': return Colors.amber.shade700;
      case 'Izin': return Colors.blue;
      default: return AppColors.grey600;
    }
  }

  Widget _statusBtn(String label, Color color, int index, String? current) {
    final isSelected = label == current;
    return OutlinedButton(
      onPressed: () => _updateStatus(index, label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : color,
        backgroundColor: isSelected ? color : Colors.white,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(60, 34),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
