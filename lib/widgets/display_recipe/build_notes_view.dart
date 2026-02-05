import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildNotesView(BuildContext context, DisplayRecipeViewModel viewModel) {
  return SingleChildScrollView(
    // allow scrolling long notes
    padding: const EdgeInsets.all(4.0),
    child: Column(
      children: [
        noteCard(
          context: context,
          title: AppLocalizations.of(context)!.notes,
          icon: Icons.menu_book_outlined,
          text: Text(viewModel.recipe?.notes ?? ""),
        ),
        if (viewModel.recipe?.makeAhead != null && viewModel.recipe!.makeAhead.isNotEmpty)
          noteCard(
            context: context,
            title: AppLocalizations.of(context)!.makeAhead,
            icon: Icons.access_time,
            text: Text(viewModel.recipe?.makeAhead ?? ""),
          ),

        // Display FAQ
        if (viewModel.recipe != null && viewModel.recipe!.questions.isNotEmpty)
          noteCard(
            context: context,
            title: AppLocalizations.of(context)!.questions,
            icon: Icons.question_answer_outlined,
            text: Column(
              crossAxisAlignment: .start,
              children: viewModel.recipe!.questions.map((qaString) {
                final parts = qaString.split('\nA: ');
                final question = parts[0].replaceFirst('Q: ', '');
                final answer = parts.length > 1 ? parts[1] : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(answer),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        if (viewModel.recipe?.source != null && viewModel.recipe!.source.isNotEmpty)
          noteCard(
            context: context,
            title: AppLocalizations.of(context)!.source,
            icon: Icons.language,
            text: GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse(viewModel.recipe!.source))) {
                  throw Exception('Could not launch url');
                }
              },
              child: Text(
                viewModel.recipe!.source,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
