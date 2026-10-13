import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';

enum _Gender { man, woman }

Future<void> showCalorieNeedsDialog(BuildContext context) async {
  final calories = await showDialog<int>(
    context: context,
    builder: (dialogContext) => const _CalorieNeedsDialog(),
  );
  if (calories != null && context.mounted) {
    await context.read<MyAppState>().setDailyValueCalories(calories);
  }
}

class _CalorieNeedsDialog extends StatefulWidget {
  const _CalorieNeedsDialog();

  @override
  State<_CalorieNeedsDialog> createState() => _CalorieNeedsDialogState();
}

class _CalorieNeedsDialogState extends State<_CalorieNeedsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _ageController = TextEditingController(
    text: _formatNumber(context.read<MyAppState>().calorieNeedsAge),
  );
  late final _weightController = TextEditingController(
    text: _formatNumber(context.read<MyAppState>().calorieNeedsWeight),
  );
  late final _heightController = TextEditingController(
    text: _formatNumber(context.read<MyAppState>().calorieNeedsHeight),
  );
  late _Gender _gender = context.read<MyAppState>().calorieNeedsIsMale
      ? _Gender.man
      : _Gender.woman;
  late double _activityFactor = context.read<MyAppState>().calorieNeedsActivityFactor;

  static String _formatNumber(double? value) =>
      value == null ? '' : (value == value.truncateToDouble() ? value.toInt() : value).toString();

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  double? _number(TextEditingController controller) => double.tryParse(controller.text);

  String? _requiredNumber(String? value, String label) {
    final number = value == null ? null : double.tryParse(value);
    if (number == null || number <= 0) return '$label must be a positive number';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final age = _number(_ageController)!;
    final weight = _number(_weightController)!;
    final height = _number(_heightController)!;
    final isMale = _gender == _Gender.man;
    context.read<MyAppState>().setCalorieNeedsInputs(
      age: age,
      weight: weight,
      height: height,
      isMale: isMale,
      activityFactor: _activityFactor,
    );
    final base = 10 * weight + 6.25 * height - 5 * age + (isMale ? 5 : -161);
    final calories = (base * _activityFactor).round();
    Navigator.of(context).pop(calories.clamp(1, 10000));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.calorieNeeds),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup<_Gender>(
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value!),
                child: Column(
                  children: [
                    RadioListTile<_Gender>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.male),
                      value: _Gender.man,
                    ),
                    RadioListTile<_Gender>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.female),
                      value: _Gender.woman,
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: l10n.age),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _requiredNumber(value, l10n.age),
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: l10n.weight),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _requiredNumber(value, l10n.weight),
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: l10n.height),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _requiredNumber(value, l10n.height),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<double>(
                initialValue: _activityFactor,
                decoration: InputDecoration(labelText: l10n.activityLevel),
                items: [
                  DropdownMenuItem(value: 1.2, child: Text(l10n.activitySedentary)),
                  DropdownMenuItem(value: 1.375, child: Text(l10n.activityLight)),
                  DropdownMenuItem(value: 1.55, child: Text(l10n.activityModerate)),
                  DropdownMenuItem(value: 1.725, child: Text(l10n.activityVeryActive)),
                ],
                onChanged: (value) => setState(() => _activityFactor = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
