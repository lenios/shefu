import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'i18n.dart';
import 'screens/home.dart';

void main() => runApp(GetMaterialApp(
    theme: ThemeData.light(),
    translations: I18n(),
    locale: Locale('fr', 'FR'),
    fallbackLocale: Locale('en', 'US'),
    home: Home()));
