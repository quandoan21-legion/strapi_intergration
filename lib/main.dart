import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/event_controller.dart';
import 'screens/home_shell.dart';
import 'screens/splash_screen.dart';
import 'services/strapi_api_client.dart';

void main() {
  runApp(const TechEventsApp());
}

class TechEventsApp extends StatelessWidget {
  const TechEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StrapiApiClient>(
          create: (_) => StrapiApiClient(),
          dispose: (_, client) => client.dispose(),
        ),
        ChangeNotifierProvider<EventController>(
          create: (context) =>
              EventController(context.read<StrapiApiClient>())..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Tech-Events Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        ),
        home: const SplashScreen(navigateTo: HomeShell()),
      ),
    );
  }
}
