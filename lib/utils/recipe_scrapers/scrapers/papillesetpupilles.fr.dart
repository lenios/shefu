import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../abstract_scraper.dart';
import '../utils.dart';

class PapillesEtPupillesScraper extends AbstractScraper {
  PapillesEtPupillesScraper(super.pageData, super.url);

  @override
  String image() {
    final imageElement = soup.querySelector('.post_content img');
    if (imageElement != null && imageElement.attributes.containsKey('src')) {
      return imageElement.attributes['src']!;
    }
    return super.image();
  }

  @override
  List<String> ingredients() {
    final postContent = soup.querySelector('.post_content');
    if (postContent == null) {
      return super.ingredients();
    }

    for (final element in postContent.children) {
      if (element.localName == 'h2' && element.text.trim().toLowerCase() == 'ingrédients') {
        var sibling = element.nextElementSibling;
        while (sibling != null) {
          if (sibling.localName == 'ul') {
            return sibling.querySelectorAll('li').map((e) => e.text.trim()).toList();
          }
          sibling = sibling.nextElementSibling;
        }
      }
    }

    return super.ingredients();
  }

  @override
  List<String> instructionsList() {
    final postContent = soup.querySelector('.post_content');
    if (postContent == null) {
      return super.instructionsList();
    }

    final instructions = <String>[];
    final instructionHeadings = ['préparation', 'cuisson', 'le repos'];
    bool isCapturing = false;

    for (final element in postContent.children) {
      if (element.localName != null && element.localName!.startsWith('h')) {
        // any heading
        isCapturing = instructionHeadings.contains(element.text.trim().toLowerCase());
      } else if (element.localName == 'p' && isCapturing) {
        final instructionText = element.text.trim();
        if (instructionText.isNotEmpty) {
          instructions.add(instructionText);
        }
      }
    }

    if (instructions.isNotEmpty) {
      return instructions;
    }

    return super.instructionsList();
  }

  @override
  List<Map<String, String>> questions() {
    final faq = <Map<String, String>>[];
    final questions = soup.querySelectorAll('.post_content h3.inline');
    for (final question in questions) {
      final answer = question.nextElementSibling;
      if (answer != null && answer.localName == 'p') {
        faq.add({'question': question.text.trim(), 'answer': answer.text.trim()});
      }
    }
    return faq;
  }

  @override
  String yields() {
    final yields = super.yields();
    return getYields(yields);
  }

  @override
  List<String> stepImages() => _findMediaForSteps('img');

  @override
  List<String> stepVideos() => _findMediaForSteps('iframe');

  // Find media (images, videos) just after each instruction step
  List<String> _findMediaForSteps(String selector) {
    final postContent = soup.querySelector('.post_content') ?? soup.body;

    final instructions = instructionsList();
    final cleanInstructions = instructions.map((i) => parse(i).body!.text.trim()).toList();
    final allPs = postContent!.children
        .where((e) => e.localName == 'p' && e.text.trim().isNotEmpty)
        .toList();

    final result = List<String?>.filled(instructions.length, null);
    int pIndex = 0;

    for (int i = 0; i < instructions.length; i++) {
      Element? instructionElement;
      for (int j = pIndex; j < allPs.length; j++) {
        if (allPs[j].text.trim() == cleanInstructions[i]) {
          instructionElement = allPs[j];
          pIndex = j;
          break;
        }
      }

      if (instructionElement == null) continue;

      Element? nextInstructionElement;
      if (i + 1 < instructions.length) {
        for (int j = pIndex + 1; j < allPs.length; j++) {
          if (allPs[j].text.trim() == cleanInstructions[i + 1]) {
            nextInstructionElement = allPs[j];
            break;
          }
        }
      }

      String? mediaSrc;
      var sibling = instructionElement.nextElementSibling;
      while (sibling != null && sibling != nextInstructionElement) {
        final elements = sibling.querySelectorAll(selector);
        if (elements.isNotEmpty) {
          mediaSrc = elements.last.attributes['src'];
        }
        sibling = sibling.nextElementSibling;
      }
      result[i] = mediaSrc;
    }

    return result.map((e) => e ?? '').toList();
  }
}
