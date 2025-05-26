import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shefu/main.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:provider/provider.dart';

Widget openModalSettingsButton(BuildContext context, ThemeData theme, [AppLocalizations? l10n]) {
  return GestureDetector(
    onTap: () {
      _showSettingsModal(context, theme);
    },
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.colorScheme.primary,
      ),
      child: SvgPicture.asset(
        'assets/icons/filter.svg',
        colorFilter: ColorFilter.mode(AppColor.colorScheme.onPrimary, BlendMode.srcIn),
        width: 24,
        height: 24,
      ),
    ),
  );
}

void _showSettingsModal(BuildContext context, ThemeData theme) {
  final l10n = AppLocalizations.of(context)!;
  final appState = Provider.of<MyAppState>(context, listen: false);
  String currentLanguage = Localizations.localeOf(context).languageCode;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: const EdgeInsets.all(
              20.0,
            ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
            child: Wrap(
              runSpacing: 16.0,
              children: [
                // Language Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.language, style: theme.textTheme.titleMedium),
                    DropdownButton<String>(
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        backgroundColor: theme.dialogBackgroundColor,
                      ),
                      icon: Icon(Icons.language, color: theme.colorScheme.primary),
                      items: AppLocalizations.supportedLocales.map((l) => l.languageCode).map((
                        String item,
                      ) {
                        String displayName = getLanguageDisplayName(item);
                        return DropdownMenuItem<String>(value: item, child: Text(displayName));
                      }).toList(),
                      onChanged: (String? newValue) async {
                        if (newValue != null && newValue != currentLanguage) {
                          // Close the current modal first
                          Navigator.pop(context);
                          await MyApp.setLocale(context, Locale(newValue));
                          // Small delay to ensure locale change is applied
                          await Future.delayed(const Duration(milliseconds: 100));
                          // Reopen the modal with the new language
                          if (context.mounted) {
                            _showSettingsModal(context, theme);
                          }
                        }
                      },
                      value: currentLanguage,
                      dropdownColor: theme.dialogBackgroundColor,
                    ),
                  ],
                ),
                // Measurement System Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.measurementSystem, style: theme.textTheme.titleMedium),
                    Row(
                      children: [
                        Text(
                          l10n.metric,
                          style: TextStyle(
                            color: appState.measurementSystem == MeasurementSystem.metric
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: appState.measurementSystem == MeasurementSystem.metric
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Switch(
                          value: appState.measurementSystem == MeasurementSystem.us,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (bool isUS) {
                            appState.setMeasurementSystem(
                              isUS ? MeasurementSystem.us : MeasurementSystem.metric,
                            );
                            setModalState(() {}); // Update the UI to reflect the change
                          },
                        ),
                        Text(
                          l10n.us,
                          style: TextStyle(
                            color: appState.measurementSystem == MeasurementSystem.us
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: appState.measurementSystem == MeasurementSystem.us
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Text(l10n.tips, style: theme.textTheme.titleMedium),
                _buildTipTile(theme, Icons.search, l10n.tipSearch),
                _buildTipTile(theme, Icons.egg_outlined, l10n.tipIngredients),
                _buildTipTile(theme, Icons.fact_check_outlined, l10n.tipShoppingList),
                _buildTipTile(theme, Icons.cloud_download_outlined, l10n.tipImport),
                _buildTipTile(theme, Icons.calculate_outlined, l10n.tipNutritionalValues),

                // measurement system
                const Divider(),

                // // Profile Settings Title
                // Text(l10n.profileSettings, // Use l10n here
                //     style: theme.textTheme.titleLarge),

                // // Gender Selection

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(l10n.gender, // Use l10n here
                //         style: theme.textTheme.titleMedium),
                //     ChoiceChip(
                //       label: Text(l10n.male), // Use l10n here
                //       selected: selectedGender == 'male',
                //       onSelected: (selected) {
                //         setModalState(() {
                //           selectedGender = selected ? 'male' : null;
                //           // TODO: Update State
                //         });
                //       },
                //     ),
                //     ChoiceChip(
                //       label: Text(l10n.female), // Use l10n here
                //       selected: selectedGender == 'female',
                //       onSelected: (selected) {
                //         setModalState(() {
                //           selectedGender = selected ? 'female' : null;
                //           // TODO: Update State
                //         });
                //       },
                //     ),
                //     ChoiceChip(
                //       label: Text(l10n.other), // Use l10n here
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
                // Text(l10n.dietaryRestrictions, // Use l10n here
                //     style: theme.textTheme.titleMedium),
                // SwitchListTile(
                //   title: Text(l10n.vegan), // Use l10n here
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
                //   title: Text(l10n.glutenFree), // Use l10n here
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
                //   child: Text(l10n.close), // Use l10n here
                // ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildTipTile(ThemeData theme, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.0, color: theme.colorScheme.primary),
        const SizedBox(width: 12.0),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    ),
  );
}
