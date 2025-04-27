import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:country_picker/country_picker.dart';
import 'repositories/nutrient_repository.dart';
import 'repositories/recipe_repository.dart';
import 'router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NutrientRepository().initialize();
  await RecipeRepository().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Future<void> setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
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

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get singleton instances of repositories
    final nutrientRepository = NutrientRepository();
    final recipeRepository = RecipeRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(create: (_) => MyAppState()),
        // --- Repositories (provided as singletons) ---
        Provider<NutrientRepository>.value(value: nutrientRepository),
        Provider<RecipeRepository>.value(value: recipeRepository),

        // --- ViewModels (depend on Repositories) ---
        ChangeNotifierProxyProvider<RecipeRepository, HomePageViewModel>(
          create: (context) => HomePageViewModel(context.read()),
          update: (context, recipeRepo, previousViewModel) => HomePageViewModel(context.read()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'Shefu',
        theme: AppColor().theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          CountryLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  void setLocale(Locale locale) {
    // Ensure the new locale is supported before setting it
    if (AppLocalizations.supportedLocales.contains(locale)) {
      setState(() {
        _locale = locale;
      });
    }
  }
}
