import 'package:flutter/material.dart';
import 'package:fiesta_pueblos_app/services/supabase_service.dart';
import 'package:fiesta_pueblos_app/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiesta_pueblos_app/screens/home_screen.dart';
import 'package:fiesta_pueblos_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rural Fest',
      theme: AppTheme.lightTheme,
      home: Supabase.instance.client.auth.currentSession != null
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
