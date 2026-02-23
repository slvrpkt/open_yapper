import 'package:flutter_test/flutter_test.dart';
import 'package:open_yapper/services/prompt_builder.dart';

void main() {
  group('PromptBuilder format intent coverage', () {
    test('teaches model to treat spoken directives as instructions', () {
      final prompt = PromptBuilder.build(tone: 'normal');

      expect(prompt, contains('FORMAT INTENT'));
      expect(prompt, contains('Spoken control phrases are instructions, not content'));
      expect(prompt, contains('"format this as an email"'));
      expect(prompt, contains('"add this to my to-do list"'));
    });

    test('defines supported formats and selection/fallback rules', () {
      final prompt = PromptBuilder.build(tone: 'normal');

      expect(
        prompt,
        contains(
          'Supported formats: email, todoList, bulletList, numberedSteps, paragraph.',
        ),
      );
      expect(prompt, contains('if format intent is unclear, default to paragraph.'));
      expect(prompt, contains('Greeting + sign-off cues -> email'));
      expect(prompt, contains('Sequential cues ("first", "then", "finally", steps) -> numberedSteps'));
      expect(prompt, contains('"do these three things"'));
      expect(prompt, contains('split into one item per line'));
      expect(prompt, contains('producing a numbered list'));
      expect(prompt, contains("keep the speaker's own lead-in/context line when present"));
      expect(prompt, contains('Never invent a new list title'));
      expect(prompt, contains('Preserve context in every list item'));
    });

    test('includes explicit format precedence order', () {
      final prompt = PromptBuilder.build(
        tone: 'formal',
        customPrompt: 'Use concise professional language.',
      );

      expect(prompt, contains('Precedence for format decisions:'));
      expect(prompt, contains('- explicit spoken format command'));
      expect(prompt, contains('- USER INSTRUCTIONS FOR THIS APP (style/detail constraints)'));
      expect(prompt, contains('dominant style/format authority'));
    });
  });
}
