part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

final class OnboardingSubmit extends OnboardingEvent {
  final String program;
  final String semester;
  final List<String> interests;

  OnboardingSubmit({
    required this.program,
    required this.semester,
    required this.interests,
  });
}
