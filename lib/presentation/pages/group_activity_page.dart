import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';

import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/group_activity/group_activity_bloc.dart';
import 'package:kovalen/presentation/bloc/group_schedule/group_schedule_bloc.dart';
import 'package:kovalen/presentation/widgets/rating_dialog.dart';

class GroupActivityPage extends StatefulWidget {
  final String scheduleId;
  final String roomId;

  const GroupActivityPage({
    super.key,
    required this.scheduleId,
    required this.roomId,
  });

  static route({required String scheduleId, required String roomId}) =>
      MaterialPageRoute(
        builder: (context) =>
            GroupActivityPage(scheduleId: scheduleId, roomId: roomId),
      );

  @override
  State<GroupActivityPage> createState() => _GroupActivityPageState();
}

class _GroupActivityPageState extends State<GroupActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final _materialController = TextEditingController();
  final _goalsController = TextEditingController();

  @override
  void dispose() {
    _summaryController.dispose();
    _materialController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _submitActivity() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupActivityBloc>().add(
        SubmitGroupActivityEvent(
          scheduleId: widget.scheduleId,
          roomId: widget.roomId,
          activitySummary: _summaryController.text.trim(),
          materialCovered: _materialController.text.trim(),
          nextGoals: _goalsController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Rekaman Kegiatan'),
      body: BlocConsumer<GroupActivityBloc, GroupActivityState>(
        listener: (context, state) {
          if (state is GroupActivityFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is GroupActivitySuccess) {
            // Tandai schedule sebagai complete
            context.read<GroupScheduleBloc>().add(
              CompleteGroupScheduleEvent(widget.scheduleId),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rekaman berhasil disimpan.')),
            );
            Navigator.pop(context);

            // Tampilkan dialog rating
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => RatingDialog(roomId: widget.roomId),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Isi Laporan Pertemuan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Catat hasil pembelajaran bersama kelompok Anda.',
                    style: TextStyle(color: AppPallete.textOutline),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _summaryController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Ringkasan Kegiatan (Wajib)',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Ringkasan tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _materialController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Materi yang Dicakup (Opsional)',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _goalsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Target Pertemuan Selanjutnya (Opsional)',
                      alignLabelWithHint: true,
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
                    onPressed: _submitActivity,
                    child: const Text(
                      'Simpan Rekaman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
