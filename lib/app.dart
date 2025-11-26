import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/screens/lista_pessoas_screen.dart';
import 'package:gym_tracker/theme/app_theme.dart';

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalStorageService()..loadData(),
        ),
      ],
      child: MaterialApp(
        title: 'GymTracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ListaPessoasScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
