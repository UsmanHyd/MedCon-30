import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medcon30/splash_screen.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart' as theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => theme.ThemeProvider(),
      child: Consumer<theme.ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MedCon',
            theme: ThemeData(
              primaryColor: const Color(0xFF0288D1),
              brightness:
                  themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor:
                  themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
              cardColor: themeProvider.isDarkMode
                  ? const Color(0xFF222328)
                  : Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor:
                    themeProvider.isDarkMode ? Colors.grey[850] : Colors.white,
                foregroundColor: const Color(0xFF0288D1),
                elevation: 0,
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
