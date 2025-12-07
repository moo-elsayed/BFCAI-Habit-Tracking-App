import 'package:flutter/cupertino.dart';

class BottomNavigationBarEntity {
  BottomNavigationBarEntity({required this.icon});

  final IconData icon;
}

List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(icon: CupertinoIcons.home),
  BottomNavigationBarEntity(icon: CupertinoIcons.add_circled),
  BottomNavigationBarEntity(icon: CupertinoIcons.settings),
];
