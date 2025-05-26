import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:country_picker/country_picker.dart';
import 'router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  final objectBoxNutrientRepo = ObjectBoxNutrientRepository(objectBox);
  await objectBoxNutrientRepo.initialize(); // populate the database from csv if needed

  runApp(MyApp(objectBoxNutrientRepo: objectBoxNutrientRepo));
}

class MyApp extends StatefulWidget {
  final ObjectBoxNutrientRepository objectBoxNutrientRepo;

  const MyApp({super.key, required this.objectBoxNutrientRepo});

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
    //final nutrientRepository = NutrientRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        //Provider<NutrientRepository>.value(value: nutrientRepository),
        Provider<ObjectBoxRecipeRepository>.value(value: ObjectBoxRecipeRepository(objectBox)),
        Provider<ObjectBoxNutrientRepository>.value(value: widget.objectBoxNutrientRepo),

        // --- ViewModels (depend on Repositories) ---
        ChangeNotifierProxyProvider<ObjectBoxRecipeRepository, HomePageViewModel>(
          create: (context) => HomePageViewModel(
            context.read<ObjectBoxRecipeRepository>(),
            context.read<ObjectBoxNutrientRepository>(),
          ),
          update: (context, objectBoxRepo, previousViewModel) =>
              previousViewModel ??
              HomePageViewModel(objectBoxRepo, context.read<ObjectBoxNutrientRepository>()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'Shefu',
        theme: AppColor().theme.copyWith(
          inputDecorationTheme: AppColor().theme.inputDecorationTheme.copyWith(
            contentPadding: const EdgeInsets.all(8.0),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
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
