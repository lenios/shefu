import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/my_app_state.dart';
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

  // Pre-initialize database to avoid UI freezes later
  final databaseProvider = DatabaseProvider();
  await databaseProvider.initDatabase();

  // Pre-initialize repositories to avoid UI freezes
  final recipeRepository = RecipeRepository(databaseProvider.database);
  final nutrientsRepository = NutrientsRepository(databaseProvider.database);

  // Ensure nutrients data is loaded before app starts
  await nutrientsRepository.ensureNutrientsPopulated();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(
          create: (_) => MyAppState(),
        ),
        // Provide the already initialized database provider
        ChangeNotifierProvider<DatabaseProvider>.value(
          value: databaseProvider,
        ),
        // Provide the already initialized repositories
        Provider<RecipeRepository>.value(
          value: recipeRepository,
        ),
        Provider<NutrientsRepository>.value(
          value: nutrientsRepository,
        ),
        // Create view models with the pre-initialized repositories
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(recipeRepository),
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
