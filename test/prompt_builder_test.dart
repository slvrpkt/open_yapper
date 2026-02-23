import 'package:flutter_test/flutter_test.dart';
import 'package:open_yapper/services/prompt_builder.dart';

void main() {
  group('PromptBuilder', () {
    test('includes explicit and implicit formatting intent rules', () {
      final prompt = PromptBuilder.build(tone: 'normal');

      expect(
        prompt,
        contains('Supported formats: email, todoList, bulletList'),
      );
      expect(prompt, contains("keep the speaker's own lead-in/context line when present"));
      expect(prompt, contains('Never invent a new list title'));
      expect(prompt, contains('Preserve context in every list item'));
      expect(
        prompt,
        contains('Spoken control phrases are instructions, not content'),
      );
      expect(prompt, contains('if format intent is unclear'));
    });

    test('keeps app custom prompt as dominant section', () {
      final prompt = PromptBuilder.build(
        tone: 'formal',
        customPrompt: 'Always write concise answers.',
      );

      expect(prompt, contains('USER INSTRUCTIONS FOR THIS APP'));
      expect(prompt, contains('Always write concise answers.'));
      expect(prompt, contains('dominant style/format authority'));
    });

    test('gen z mode still preserves format and strips control phrases', () {
      final prompt = PromptBuilder.build(tone: 'casual', genZ: true);

      expect(prompt, contains('keep that format'));
      expect(prompt, contains('Treat spoken control phrases as instructions'));
      expect(prompt, contains('If no explicit control phrase appears'));
    });
  });
}
