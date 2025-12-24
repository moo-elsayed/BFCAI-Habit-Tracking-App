import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/helpers/di.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/features/app_section/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import 'package:habit_tracking_app/features/home/presentation/views/home.dart';
import 'package:habit_tracking_app/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:habit_tracking_app/features/settings/presentation/views/settings.dart';

class AppSection extends StatefulWidget {
  const AppSection({super.key});

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  final List<Widget> _pages = [
    const Home(),
    BlocProvider(
      create: (context) =>
          SettingsCubit(getIt.get<AppPreferencesService>())..getUserInfo(),
      child: const Settings(),
    ),
  ];
  late ValueNotifier _selectedIndex;

  void _onItemTapped(int index) async {
    if (index == 1) {
      bool? myBool = await context.pushNamed(Routes.habitEditorView);
      if (myBool != null && myBool) {
        if (mounted) {
          context.read<HomeCubit>().getAllHabits();
          context.read<HomeCubit>().getHabitsByDate(DateTime.now());
        }
      }
    } else {
      _selectedIndex.value = index == 2 ? 1 : 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, value, child) =>
              IndexedStack(index: value, children: _pages),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, value, child) => CustomBottomNavigationBar(
          onItemTapped: _onItemTapped,
          selectedIndex: value == 0 ? 0 : 2,
        ),
      ),
    );
  }
}
