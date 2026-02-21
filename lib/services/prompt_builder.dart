/// Builds the system prompt for voice-to-text processing based on target app and tone.
class PromptBuilder {
  PromptBuilder._();

  static const _defaultTone = 'normal';

  /// Valid tone values for per-app configuration.
  static const List<String> validTones = [
    'casual',
    'normal',
    'informal',
    'formal',
  ];

  /// Builds the system prompt for Gemini based on target app, tone, and optional custom prompt.
  static String build({
    required String tone,
    String? targetApp,
    String? customPrompt,
  }) {
    final appContext = targetApp != null && targetApp.isNotEmpty
        ? 'The user is speaking into "$targetApp". Use this as a hint for formatting (e.g., Mail app suggests email format, Notes suggests flexible structure).'
        : 'Use context clues from the content to determine the best format.';

    final toneInstruction = _toneInstructions[tone] ?? _toneInstructions[_defaultTone]!;

    final customSection = customPrompt != null && customPrompt.trim().isNotEmpty
        ? '''

8. USER INSTRUCTIONS (follow these precisely): $customPrompt
'''
        : '';

    return '''
You are a voice-to-text assistant. The user is dictating via voice. Your job is to produce clean, well-formatted text ready to paste.

1. TRANSCRIBE: Listen to the audio and produce accurate text.

2. CLEAN: Remove filler words and verbal tics (um, uh, like, you know, I mean, sort of, kind of, etc.). Fix grammar and punctuation. Output proper sentences with correct capitalization.

3. LANGUAGE: Detect the language the user is speaking and respond ONLY in that same language. Never default to English if the user spoke another language.

4. TONE: $toneInstruction

5. FORMAT: Adapt output based on content:
   - Shopping lists, task lists, to-dos → use bullet points (• or -)
   - Emails → format with subject line and body
   - Casual conversation → natural paragraphs
   - Formal correspondence → structured, professional layout

6. CONTEXT: $appContext

7. OUTPUT: Return ONLY the cleaned text to paste. No preamble, no markdown formatting, no commentary, no "Here is..." or similar.$customSection''';
  }

  static const _toneInstructions = {
    'casual': 'Use a relaxed, conversational tone. Natural and friendly.',
    'normal': 'Use a balanced, neutral tone. Clear and readable.',
    'informal': 'Use a slightly relaxed tone. Professional but approachable.',
    'formal': 'Use a formal, professional tone. Polished and proper.',
  };
}
