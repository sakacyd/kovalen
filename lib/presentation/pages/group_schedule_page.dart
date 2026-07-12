import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';

import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/group_schedule/group_schedule_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kovalen/presentation/pages/group_activity_page.dart';

class GroupSchedulePage extends StatefulWidget {
  final String roomId;
  const GroupSchedulePage({super.key, required this.roomId});

  static route({required String roomId}) => MaterialPageRoute(
        builder: (context) => GroupSchedulePage(roomId: roomId),
      );

  @override
  State<GroupSchedulePage> createState() => _GroupSchedulePageState();
}

class _GroupSchedulePageState extends State<GroupSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _locationUrlController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    context.read<GroupScheduleBloc>().add(FetchActiveScheduleEvent(widget.roomId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationNameController.dispose();
    _locationUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (!mounted) return;
      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
        });
      }
    }
  }

  void _submitSchedule() {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
      final meetingTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      context.read<GroupScheduleBloc>().add(
        CreateGroupScheduleEvent(
          roomId: widget.roomId,
          title: _titleController.text.trim(),
          meetingTime: meetingTime,
          locationName: _locationNameController.text.trim(),
          locationUrl: _locationUrlController.text.trim(),
        ),
      );
    } else if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal dan waktu pertemuan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Jadwal Pertemuan'),
      body: BlocConsumer<GroupScheduleBloc, GroupScheduleState>(
        listener: (context, state) {
          if (state is GroupScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is GroupScheduleActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is GroupScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupScheduleLoaded) {
            final schedule = state.schedule;
            
            if (schedule != null) {
              // Menampilkan jadwal aktif
              final timeFormatted = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(schedule.meetingTime);
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.event, size: 64, color: AppPallete.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Jadwal Pertemuan Aktif',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Judul:', style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.textOutline)),
                            Text(schedule.title, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 12),
                            const Text('Waktu:', style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.textOutline)),
                            Text(timeFormatted, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 12),
                            const Text('Lokasi:', style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.textOutline)),
                            Text(schedule.locationName, style: const TextStyle(fontSize: 16)),
                            if (schedule.locationUrl != null && schedule.locationUrl!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text('Tautan/Map URL:', style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.textOutline)),
                              Text(schedule.locationUrl!, style: const TextStyle(fontSize: 14, color: Colors.blue)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          GroupActivityPage.route(scheduleId: schedule.id, roomId: schedule.roomId),
                        );
                      },
                      child: const Text('Selesaikan & Isi Rekaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              );
            } else {
              // Form buat jadwal
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Buat Jadwal Baru',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Hanya ada 1 jadwal pertemuan aktif dalam satu grup.',
                        style: TextStyle(color: AppPallete.textOutline),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppPallete.stroke),
                        ),
                        leading: const Icon(Icons.calendar_today, color: AppPallete.primary),
                        title: Text(_selectedDate == null || _selectedTime == null
                            ? 'Pilih Waktu Pertemuan'
                            : '${DateFormat('dd MMM yyyy').format(_selectedDate!)} ${_selectedTime!.format(context)}'),
                        onTap: _pickDateTime,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Pertemuan (Mis: Belajar Matematika)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lokasi (Mis: Perpustakaan, Zoom)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Tautan (Opsional: Link Zoom / Gmaps)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submitSchedule,
                        child: const Text('Buat Jadwal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }
}
