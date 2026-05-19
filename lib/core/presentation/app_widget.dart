import 'package:boilerplate_app/core/presentation/connectivity_watcher.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key, required this.initialScreen});

  final Widget initialScreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Boilerplate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: ConnectivityWatcher(child: initialScreen));
  }
}
