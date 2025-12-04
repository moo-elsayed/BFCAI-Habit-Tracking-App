import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/di.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';
import '../managers/onboarding_cubit/onboarding_cubit.dart';
import '../widgets/onboarding_view_body.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => OnboardingCubit(getIt.get<LocalStorageService>()),
        child: const OnboardingViewBody(),
      ),
    );
  }
}
