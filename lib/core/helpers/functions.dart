import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

bool isArabic(BuildContext context) => context.locale.languageCode == 'ar';

String getErrorMessage(result) =>
    ((result.exception as dynamic).message ?? result.exception.toString())
        .replaceAll('Exception: ', '');
