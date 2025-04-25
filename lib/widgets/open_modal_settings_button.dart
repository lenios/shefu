import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shefu/main.dart';
import 'package:shefu/utils/app_color.dart';

import '../l10n/app_localizations.dart';

Widget openModalSettingsButton(
    BuildContext context, ThemeData theme, AppLocalizations localization) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
          isScrollControlled: true, // Allow sheet to take more height if needed
          context: context,
          backgroundColor: theme.dialogBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) {
            String currentLanguage =
                Localizations.localeOf(context).languageCode;

            String? selectedGender;
            bool isVegan = false;
            bool isGlutenFree = false;

            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    // Language Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localization.language,
                            style: theme.textTheme.titleMedium),
                        DropdownButton<String>(
                          style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              backgroundColor: theme.dialogBackgroundColor),
                          icon: Icon(Icons.language,
                              color: theme.colorScheme.primary),
                          items: AppLocalizations.supportedLocales
                              .map((l) => l.languageCode)
                              .map((String item) {
                            return DropdownMenuItem<String>(
                                value: item, child: Text(item.toUpperCase()));
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null &&
                                newValue != currentLanguage) {
                              MyApp.setLocale(context, Locale(newValue));
                              setModalState(() {
                                currentLanguage = newValue;
                              });
                            }
                          },
                          value: currentLanguage,
                          dropdownColor: theme.dialogBackgroundColor,
                        ),
                      ],
                    ),

                    Divider(color: theme.dividerColor),

                    // // Profile Settings Title
                    // Text(AppLocalizations.of(context)!.profileSettings,
                    //     style: theme.textTheme.titleLarge),

                    // // Gender Selection

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Text(localization.gender,
                    //         style: theme.textTheme.titleMedium),
                    //     ChoiceChip(
                    //       label: Text(localization.male),
                    //       selected: selectedGender == 'male',
                    //       onSelected: (selected) {
                    //         setModalState(() {
                    //           selectedGender = selected ? 'male' : null;
                    //           // TODO: Update State
                    //         });
                    //       },
                    //     ),
                    //     ChoiceChip(
                    //       label: Text(localization.female),
                    //       selected: selectedGender == 'female',
                    //       onSelected: (selected) {
                    //         setModalState(() {
                    //           selectedGender = selected ? 'female' : null;
                    //           // TODO: Update State
                    //         });
                    //       },
                    //     ),
                    //     ChoiceChip(
                    //       label: Text(localization.other),
                    //       selected: selectedGender == 'other',
                    //       onSelected: (selected) {
                    //         setModalState(() {
                    //           selectedGender = selected ? 'other' : null;
                    //           // TODO: Update State
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),

                    // Divider(color: theme.dividerColor),

                    // // Dietary Restrictions
                    // Text(localization.dietaryRestrictions,
                    //     style: theme.textTheme.titleMedium),
                    // SwitchListTile(
                    //   title: Text(localization.vegan),
                    //   value: isVegan,
                    //   onChanged: (bool value) {
                    //     setModalState(() {
                    //       isVegan = value;
                    //       // TODO: Update State
                    //     });
                    //   },
                    //   secondary: Icon(Icons.eco,
                    //       color:
                    //           isVegan ? Colors.green : theme.iconTheme.color),
                    // ),
                    // SwitchListTile(
                    //   title: Text(localization.glutenFree),
                    //   value: isGlutenFree,
                    //   onChanged: (bool value) {
                    //     setModalState(() {
                    //       isGlutenFree = value;
                    //       // TODO: Update State
                    //     });
                    //   },
                    //   secondary: Icon(Icons.no_meals,
                    //       color: isGlutenFree
                    //           ? Colors.orange
                    //           : theme.iconTheme.color),
                    // ),

                    // SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () => Navigator.pop(context),
                    //   child: Text(AppLocalizations.of(context)!.close),
                    // ),
                  ],
                ),
              );
            });
          });
    },
    child: Container(
      width: 40, // Slightly larger tap target
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.colorScheme.primary, // Use theme color
      ),
      child: SvgPicture.asset(
        'assets/icons/filter.svg',
        colorFilter: ColorFilter.mode(
            AppColor.colorScheme.onPrimary, BlendMode.srcIn), // Use theme color
        width: 24, // Explicit size
        height: 24,
      ),
    ),
  );
}
