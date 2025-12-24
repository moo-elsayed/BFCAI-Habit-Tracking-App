import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../domain/entities/user_info_entity.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.userInfoEntity});

  final UserInfoEntity userInfoEntity;

  @override
  Widget build(BuildContext context) {
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
}
