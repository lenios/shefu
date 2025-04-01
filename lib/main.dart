import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/my_app_state.dart';
import 'package:country_picker/country_picker.dart';
import 'providers/database_provider.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/nutrients_repository.dart';
import 'router/app_router.dart';
import 'l10n/app_localizations.dart';
import 'viewmodels/home_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(
          create: (_) => MyAppState(),
        ),
        // Database provider is the foundation
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
        // Get the repositories from the database provider
        Provider<RecipeRepository>(
          create: (context) => RecipeRepository(
              Provider.of<DatabaseProvider>(context, listen: false).database),
        ),
        Provider<NutrientsRepository>(
          create: (context) => NutrientsRepository(
              Provider.of<DatabaseProvider>(context, listen: false).database),
        ),
        // Get the nutrients provider
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
              Provider.of<RecipeRepository>(context, listen: false)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Future<void> setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
    // Now save user selected language in preferences for next reboot
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', newLocale.languageCode);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = Locale(prefs.getString('language_code') ?? 'en');
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Shefu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates +
          [CountryLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ja')],
    );
  }
}

class SplashScreen extends StatelessWidget {
  final String message;

  const SplashScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
