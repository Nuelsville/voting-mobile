import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/providers/position_provider.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/main_screen.dart';
import 'package:testing/screens/sign_in_screen.dart';

import 'providers/auth_provider.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => PositionProvider()),
      ],
      child: VotingApp(),
    ),
  );
}

class VotingApp extends StatefulWidget {
  const VotingApp({super.key});

  @override
  State<VotingApp> createState() => _VotingAppState();
}

class _VotingAppState extends State<VotingApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isAuthenticated) {
                  return MainScreen();
                } else {
                  return OnboardingScreen();
                }
              },
            ),
        '/sign-in': (context) => SignInScreen(),
      },
    );
  }
}

final ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xFF013220),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF013220),
    onPrimary: Colors.white,
    secondary: Color(0xFFA3E4C9), // Light Green
    onSecondary: Colors.black,
    // background: Color(0xFFF5F5F5),
    // onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
    bodySmall: TextStyle(color: Colors.black54, fontSize: 14),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF013220),
    foregroundColor: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xFF013220), // Dark Green
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark Background
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF013220),
    onPrimary: Colors.white,
    secondary: Color(0xFFA3E4C9), // Light Green
    onSecondary: Colors.black,
    // background: Color(0xFF121212),
    // onBackground: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
    error: Color(0xFFD32F2F),
    onError: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white60, fontSize: 14),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF013220),
    foregroundColor: Colors.white,
  ),
);
