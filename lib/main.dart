import 'package:boilerplate_app/core/presentation/app_widget.dart';
import 'package:boilerplate_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      
      child: AppWidget(
        initialScreen: ChatScreen(),
      ),
    ),
  );
}
