import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/provider/recipes_provider.dart';
import 'provider/my_app_state.dart';
import 'screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(create: (_) => MyAppState()),
        ChangeNotifierProvider<RecipesProvider>(
            create: (_) => RecipesProvider()),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        debugShowCheckedModeBanner: false,
        title: 'Shefu',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
