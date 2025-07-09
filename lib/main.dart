import 'package:flutter/material.dart';
import 'package:notes_app/configs/theme_notifier.dart';
import 'package:notes_app/helpers/onboarding_status_helper.dart';
import 'package:notes_app/models/detail_notes_arguments.dart';
import 'package:notes_app/screens/about_screen.dart';
import 'package:notes_app/screens/detail_note_screen.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? hasSeenOnboarding;
  @override
  void initState() {
    super.initState();
    _getOnboardingStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (hasSeenOnboarding == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder:
          (context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: value,
            initialRoute: hasSeenOnboarding! ? '/' : '/onboarding',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(builder: (context) => HomeScreen());
              } else if (settings.name == '/detail-note') {
                final args = settings.arguments as DetailNotesArguments;
                return MaterialPageRoute(
                  builder:
                      (context) => DetailNoteScreen(
                        notes: args.notes,
                        idEditNote: args.idEditNote,
                      ),
                );
              } else if (settings.name == '/about') {
                return MaterialPageRoute(builder: (context) => AboutScreen());
              } else if (settings.name == '/onboarding') {
                return MaterialPageRoute(
                  builder: (context) => OnboardingScreen(),
                );
              }
              return null;
            },
          ),
    );
  }

  Future<void> _getOnboardingStatus() async {
    final bool result = await getOnboardingStatus();
    setState(() {
      hasSeenOnboarding = result;
    });
  }
}
