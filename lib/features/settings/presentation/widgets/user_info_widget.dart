import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../domain/entities/user_info_entity.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          current is SettingsSuccess && current.process == .getUserInfo,
      builder: (context, state) {
        if (state is SettingsSuccess) {
          UserInfoEntity userInfoEntity = state.userInfoEntity;
          return Container(
            padding: .symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.habitCardColor(context),
              borderRadius: .circular(24.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.primary(context),
                  child: Text(
                    userInfoEntity.firstLetter,
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
                ),
                Gap(16.w),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 4.h,
                  children: [
                    Text(
                      userInfoEntity.userName,
                      style: AppTextStyles.font16WhiteSemiBold(
                        context,
                      ).copyWith(color: AppColors.textPrimary(context)),
                    ),
                    Text(
                      userInfoEntity.email,
                      style: AppTextStyles.font14CustomColor(
                        AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
