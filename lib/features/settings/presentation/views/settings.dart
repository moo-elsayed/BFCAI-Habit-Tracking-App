import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/logout_cubit/logout_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:habit_tracking_app/features/settings/presentation/widgets/user_info_widget.dart';
import '../widgets/logout_widget.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.read<SettingsCubit>();
    return SingleChildScrollView(
      padding: .symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          CustomAppBar(title: "settings".tr()),
          Gap(16.h),
          UserInfoWidget(userInfoEntity: settingsCubit.userInfoEntity),
          Gap(24.h),
          SettingsSection(),
          Gap(24.h),
          BlocProvider(
            create: (context) => LogoutCubit(getIt.get<LogoutUseCase>()),
            child: LogoutWidget(),
          ),
        ],
      ),
    );
  }
}
