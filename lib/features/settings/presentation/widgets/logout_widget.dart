import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/features/auth/presentation/managers/logout_cubit/logout_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/widgets/settings_tile.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../domain/entities/settings_tile_entity.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.pop();
          AppToast.showToast(
            context: context,
            title: "logged_out_successfully".tr(),
            type: .success,
          );
          context.pushNamedAndRemoveUntil(
            Routes.loginView,
            predicate: (Route<dynamic> route) => false,
          );
        }
        if (state is LogoutLoading) {
          AppDialogs.showLoadingDialog(context);
        }
        if (state is LogoutFailure) {
          context.pop();
          AppToast.showToast(
            context: context,
            title: state.errorMessage,
            type: .error,
          );
        }
      },
      child: SettingsTile(
        settingsTileEntity: SettingsTileEntity(
          title: "log_out".tr(),
          icon: Icons.logout_rounded,
          isDestructive: true,
          onTap: () {
            showCupertinoDialog(
              context: context,
              builder: (_) => CustomConfirmationDialog(
                title: "log_out_confirmation".tr(),
                textConfirmButton: "ok".tr(),
                textCancelButton: "cancel".tr(),
                onConfirm: () async {
                  context.read<LogoutCubit>().logout();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
