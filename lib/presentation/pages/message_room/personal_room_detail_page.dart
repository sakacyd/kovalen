import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/utils/matchmaking_utils.dart';
import 'package:kovalen/presentation/bloc/message_room/room_detail_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/matchmaking_card.dart';

class PersonalRoomDetailPage extends StatefulWidget {
  final String userId;

  const PersonalRoomDetailPage({super.key, required this.userId});

  static route({required String userId}) => MaterialPageRoute(
    builder: (context) => PersonalRoomDetailPage(userId: userId),
  );

  @override
  State<PersonalRoomDetailPage> createState() => _PersonalRoomDetailPageState();
}

class _PersonalRoomDetailPageState extends State<PersonalRoomDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<RoomDetailBloc>().add(
      FetchPersonalRoomDetailEvent(widget.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: CustomAppBar(
        title: 'Profil Pengguna',
        showAvatar: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<RoomDetailBloc, RoomDetailState>(
        builder: (context, state) {
          if (state is RoomDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppPallete.primary),
            );
          } else if (state is RoomDetailFailure) {
            return Center(child: Text(state.message));
          } else if (state is PersonalRoomDetailLoaded) {
            final user = state.user;
            final interests = user.interests;

            // Calculate distance and match percentage
            final currentUser = context.read<AppUserCubit>().state;
            double distance = 0.0;
            int matchPercentage = 0;

            if (currentUser is AppUserLoggedIn) {
              final myUser = currentUser.user;
              distance = MatchmakingUtils.calculateDistance(
                myUser.latitude,
                myUser.longitude,
                user.latitude,
                user.longitude,
              );
              matchPercentage = MatchmakingUtils.calculateMatchPercentage(
                myUser,
                user,
                distance,
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: MatchmakingCard(
                  name: user.fullName,
                  semester: user.semester.toString(),
                  major: user.studyProgramName ?? user.studyProgramId,
                  distance: '${distance.toStringAsFixed(1)} km',
                  matchPercentage: matchPercentage,
                  imageUrl: user.avatarUrl,
                  interests: interests,
                  ratingScore: user.ratingScore,
                  ratingCount: user.ratingCount,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
