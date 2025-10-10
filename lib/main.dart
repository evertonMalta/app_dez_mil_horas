import 'package:app_muito_brabo/screens/auth/forgot_password_screen.dart';
import 'package:app_muito_brabo/screens/auth/login_screen.dart';
import 'package:app_muito_brabo/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'screens/add_edit_topic_screen.dart';
import 'screens/home_screen.dart';
import 'screens/log_study_session_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/topic_detail_screen.dart';
import 'services/service_locator.dart'; 
import 'utils/app_routes.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Estudos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (ctx) => const LoginScreen(),
        AppRoutes.signup: (ctx) => const SignupScreen(),
        AppRoutes.forgotPassword: (ctx) => const ForgotPasswordScreen(),
        AppRoutes.home: (ctx) => const HomeScreen(),
        AppRoutes.topicDetail: (ctx) => const TopicDetailScreen(),
        AppRoutes.addEditTopic: (ctx) => const AddEditTopicScreen(),
        AppRoutes.logStudySession: (ctx) => const LogStudySessionScreen(),
        AppRoutes.profile: (ctx) => const ProfileScreen(),
        AppRoutes.about: (ctx) => const AboutScreen(),

      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => const LoginScreen());
      },
    );
  }
}
