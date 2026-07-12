import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/rating/rating_bloc.dart';
import 'package:kovalen/core/common/entities/user.dart';

class RatingDialog extends StatefulWidget {
  final String roomId;
  
  const RatingDialog({super.key, required this.roomId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _currentIndex = 0;
  double _currentScore = 0;
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RatingBloc>().add(FetchRoomParticipantsEvent(widget.roomId));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitRating(User targetUser, List<User> participants) {
    if (_currentScore == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih minimal 1 bintang')),
      );
      return;
    }

    context.read<RatingBloc>().add(
      SubmitUserRatingEvent(
        targetUserId: targetUser.id,
        score: _currentScore,
        feedback: _feedbackController.text.trim(),
      ),
    );

    // Reset untuk form berikutnya
    setState(() {
      _currentScore = 0;
      _feedbackController.clear();
      _currentIndex++;
    });

    if (_currentIndex >= participants.length) {
      Navigator.of(context).pop(); // Tutup dialog jika sudah semua dinilai
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<RatingBloc, RatingState>(
          listener: (context, state) {
            if (state is RatingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is RatingError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is RatingLoading) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is RoomParticipantsLoaded) {
              final participants = state.participants;
              
              if (participants.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tidak ada partisipan lain untuk dinilai.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Tutup'),
                    )
                  ],
                );
              }

              if (_currentIndex >= participants.length) {
                return const SizedBox.shrink(); // Akan segera di-pop()
              }

              final currentUserToRate = participants[_currentIndex];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nilai ${currentUserToRate.fullName}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentIndex + 1} dari ${participants.length} anggota',
                    style: const TextStyle(color: AppPallete.textOutline, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bintang Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _currentScore ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentScore = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Feedback Text Field
                  TextField(
                    controller: _feedbackController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Komentar tambahan (opsional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Skip rating user ini
                          setState(() {
                            _currentScore = 0;
                            _feedbackController.clear();
                            _currentIndex++;
                          });
                          if (_currentIndex >= participants.length) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Lewati', style: TextStyle(color: AppPallete.textOutline)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _submitRating(currentUserToRate, participants),
                        child: Text(_currentIndex == participants.length - 1 ? 'Selesai' : 'Lanjut'),
                      ),
                    ],
                  ),
                ],
              );
            }

            return const SizedBox(height: 200);
          },
        ),
      ),
    );
  }
}
