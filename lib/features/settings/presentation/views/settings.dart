import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/widgets/custom_app_bar.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/logout_cubit/logout_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/widgets/user_info_widget.dart';
import '../../../../core/helpers/functions.dart';
import '../../domain/entities/settings_tile_entity.dart';
import '../widgets/logout_widget.dart';
import '../widgets/settings_tile.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.read<SettingsCubit>();
    return Padding(
      padding: .symmetric(horizontal: 16.w),
      child: Column(
        spacing: 12.h,
        children: [
          CustomAppBar(title: "settings".tr()),
          UserInfoWidget(userInfoEntity: settingsCubit.userInfoEntity),
          SettingsTile(
            settingsTileEntity: getThemeTile(
              context: context,
              currentThemeName: getCurrentTheme(context).name.tr(),
            ),
          ),
          SettingsTile(settingsTileEntity: getLanguageTile(context)),
          BlocProvider(
            create: (context) => LogoutCubit(getIt.get<LogoutUseCase>()),
            child: const LogoutWidget(),
          ),
        ],
      ),
    );
  }
}
