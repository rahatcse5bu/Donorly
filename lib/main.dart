import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/app_constants.dart';
import 'providers/user_provider.dart';
import 'providers/donation_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Firebase Auth persistence is handled automatically on mobile platforms
  // No need to call setPersistence() as it's only available on web
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => DonationProvider()),
      ],
      child: MaterialApp(
        title: 'Donorly',
        theme: ThemeData(
          primaryColor: AppConstants.primaryColor,
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            primary: AppConstants.primaryColor,
            secondary: AppConstants.accentColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
