import 'package:boilerplate_app/core/presentation/connectivity_watcher.dart';
import 'package:boilerplate_app/core/themes/dark_theme.dart';
import 'package:boilerplate_app/core/themes/light_theme.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key, required this.initialScreen});

  final Widget initialScreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Boilerplate',
        darkTheme: darkTheme,
        theme: darkTheme,
        home: ConnectivityWatcher(child: initialScreen));
  }
}
