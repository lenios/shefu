import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/provider/nutrients_provider.dart';
import 'package:shefu/provider/recipes_provider.dart';
import 'provider/my_app_state.dart';
import 'screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:country_picker/country_picker.dart';

void main() async {
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(create: (_) => MyAppState()),
        ChangeNotifierProvider<RecipesProvider>(
            create: (_) => RecipesProvider()),
        ChangeNotifierProvider<NutrientsProvider>(
            create: (_) => NutrientsProvider()),
      ],
      child: MaterialApp(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'Shefu',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates +
            [CountryLocalizations.delegate],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('ja')],
        home: const HomePage(),
      ),
    );
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
}
