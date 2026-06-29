part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingSuccess extends OnboardingState {}

final class OnboardingFailure extends OnboardingState {
  final String message;

  OnboardingFailure(this.message);
}
