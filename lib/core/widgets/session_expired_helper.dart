import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/extensions.dart';
import '../routing/routes.dart';
import 'custom_confirmation_dialog.dart';

class SessionExpiredHandler {
  static bool _isDialogShown = false;

  static void handle(BuildContext context) {
    if (_isDialogShown) return;
    _isDialogShown = true;

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomConfirmationDialog(
        title: "session_expired".tr(),
        subtitle: "please_login_again".tr(),
        textConfirmButton: "login".tr(),
        showCancelButton: false,
        onConfirm: () {
          _isDialogShown = false;
          context.pushNamedAndRemoveUntil(
            Routes.loginView,
            predicate: (route) => false,
          );
        },
      ),
    );
  }
}
