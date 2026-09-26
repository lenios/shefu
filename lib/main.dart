import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/database/app_database.dart';
import 'package:shefu/database/legacy/objectbox_migration.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/utils/path_utils.dart';
import 'package:shefu/utils/theme.dart';

import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:country_picker/country_picker.dart';

import 'router/app_router.dart';

import 'package:flutter_localizations/flutter_localizations.dart' as flutter_localizations;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PathUtils.init();
  final db = AppDatabase.open();

  final nutrientRepository = NutrientRepository(db);
  final nutrientsReady = nutrientRepository.initialize();
  unawaited(nutrientsReady.catchError((Object e) => debugPrint('Nutrients unavailable: $e')));

  var legacyMigrationFailed = false;
  try {
    await ObjectBoxMigration(
      db: db,
      nutrients: nutrientRepository,
      documentsDirectory: PathUtils.documentsDirectory!,
    ).run();
  } catch (e, stackTrace) {
    // The legacy store is untouched: the import is retried on next launch.
    legacyMigrationFailed = true;
    debugPrint('ObjectBox migration failed: $e\n$stackTrace');
  }

  runApp(
    MyApp(
      recipeRepository: RecipeRepository(db),
      nutrientRepository: nutrientRepository,
      legacyMigrationFailed: legacyMigrationFailed,
    ),
  );
}

class const MyApp({
  super.key,
  required final RecipeRepository recipeRepository,
  required final NutrientRepository nutrientRepository,

  /// Shows a notice that recipes from the ObjectBox era are not imported yet.
  final bool legacyMigrationFailed = false,
}) extends StatefulWidget {
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
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late bool _legacyNoticePending = widget.legacyMigrationFailed;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _showLegacyMigrationNotice(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(l10n.legacyMigrationFailed),
        duration: const Duration(seconds: 15),
        showCloseIcon: true,
      ),
    );
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        Provider<RecipeRepository>.value(value: widget.recipeRepository),
        Provider<NutrientRepository>.value(value: widget.nutrientRepository),

        // --- ViewModels (depend on Repositories) ---
        ChangeNotifierProxyProvider<RecipeRepository, HomePageViewModel>(
          create: (context) => HomePageViewModel(context.read<RecipeRepository>()),
          update: (context, recipeRepository, previousViewModel) =>
              previousViewModel ?? HomePageViewModel(recipeRepository),
        ),
      ],
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          if (appState.useMaterialYou) {
            return DynamicColorBuilder(
              builder: (lightDynamic, darkDynamic) =>
                  _buildMaterialAppRouter(lightDynamic, darkDynamic, appState),
            );
          }

          return _buildMaterialAppRouter(null, null, appState);
        },
      ),
    );
  }

  Widget _buildMaterialAppRouter(
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
    MyAppState appState,
  ) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      scaffoldMessengerKey: _messengerKey,
      builder: (context, child) {
        if (_legacyNoticePending) {
          _legacyNoticePending = false;
          WidgetsBinding.instance.addPostFrameCallback((_) => _showLegacyMigrationNotice(context));
        }
        return child!;
      },
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Shefu',
      themeMode: appState.themeMode,
      theme: buildLightTheme(lightDynamic, appState.useMaterialYou).copyWith(
        inputDecorationTheme: buildLightTheme(lightDynamic, appState.useMaterialYou)
            .inputDecorationTheme
            .copyWith(
              contentPadding: const EdgeInsets.all(8.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
      ),
      darkTheme: buildDarkTheme(darkDynamic, appState.useMaterialYou).copyWith(
        inputDecorationTheme: buildDarkTheme(darkDynamic, appState.useMaterialYou)
            .inputDecorationTheme
            .copyWith(
              contentPadding: const EdgeInsets.all(8.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
      ),
      localizationsDelegates:
          flutter_localizations.GlobalMaterialLocalizations.delegates +
          GlobalMaterialLocalizations.delegates +
          const [AppLocalizations.delegate, CountryLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
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
