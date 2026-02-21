import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/dictation_service.dart';
import 'services/hotkey_storage.dart';
import 'theme.dart';

const _railExtendedKey = 'navigation_rail_extended';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();

  final dictationService = DictationService();

  final hotKey = await loadRecordHotKey();
  await hotKeyManager.register(
    hotKey,
    keyDownHandler: (_) => dictationService.toggle(),
  );

  runApp(MainApp(
    dictationService: dictationService,
    onHotKeyChanged: () async {
      await hotKeyManager.unregisterAll();
      final newHotKey = await loadRecordHotKey();
      await hotKeyManager.register(
        newHotKey,
        keyDownHandler: (_) => dictationService.toggle(),
      );
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.dictationService,
    required this.onHotKeyChanged,
  });

  final DictationService dictationService;
  final VoidCallback onHotKeyChanged;

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.light().textTheme);
    return MaterialApp(
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: MainScaffold(
        dictationService: dictationService,
        onHotKeyChanged: onHotKeyChanged,
      ),
    );
  }
}

enum RailDestination { home, customization }

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.dictationService,
    required this.onHotKeyChanged,
  });

  final DictationService dictationService;
  final VoidCallback onHotKeyChanged;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  RailDestination _selectedDestination = RailDestination.home;
  bool _railExtended = true;

  @override
  void initState() {
    super.initState();
    _loadRailState();
  }

  Future<void> _loadRailState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _railExtended = prefs.getBool(_railExtendedKey) ?? true;
        });
      }
    } catch (_) {
      // SharedPreferences may not be available (e.g. web, some IDEs)
      // Keep default: rail extended
    }
  }

  Future<void> _saveRailState(bool extended) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_railExtendedKey, extended);
    } catch (_) {
      // Silently ignore if persistence isn't available
    }
  }

  void _toggleRail() {
    setState(() {
      _railExtended = !_railExtended;
      _saveRailState(_railExtended);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: _railExtended,
            leading: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      _railExtended
                          ? Symbols.left_panel_close
                          : Symbols.left_panel_open,
                    ),
                    onPressed: _toggleRail,
                    tooltip: _railExtended ? 'Minimize' : 'Expand',
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Symbols.home),
                selectedIcon: Icon(Symbols.home, fill: 1),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Symbols.tune),
                selectedIcon: Icon(Symbols.tune, fill: 1),
                label: Text('Customization'),
              ),
            ],
            selectedIndex: _selectedDestination.index,
            onDestinationSelected: (index) {
              setState(() {
                _selectedDestination = RailDestination.values[index];
              });
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  title: Text(
                    _selectedDestination == RailDestination.home
                        ? 'Home'
                        : 'Customization',
                  ),
                ),
                Expanded(
                  child: _selectedDestination == RailDestination.home
                      ? _HomeBody(dictationService: widget.dictationService)
                      : _CustomizationBody(
                          dictationService: widget.dictationService,
                          onHotKeyChanged: widget.onHotKeyChanged,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordButton extends StatefulWidget {
  const _RecordButton({
    required this.isListening,
    required this.onPressed,
  });

  final bool isListening;
  final VoidCallback onPressed;

  @override
  State<_RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<_RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final scale = widget.isListening ? _pulseAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        icon: Icon(
          widget.isListening ? Symbols.stop : Symbols.mic,
          size: 24,
        ),
        label: Text(widget.isListening ? 'Stop' : 'Record'),
        style: FilledButton.styleFrom(
          backgroundColor: widget.isListening
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.dictationService});

  final DictationService dictationService;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dictationService,
      builder: (context, _) {
        if (dictationService.initError != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.error, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Speech recognition error: ${dictationService.initError}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (!dictationService.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final displayText = dictationService.displayText;
        final isEmpty = displayText.isEmpty;
        final isListening = dictationService.isListening;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    isEmpty
                        ? (isListening
                            ? 'Listening...'
                            : 'Press hotkey or tap record to dictate')
                        : displayText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isEmpty)
                    TextButton.icon(
                      onPressed: dictationService.clearTranscript,
                      icon: const Icon(Symbols.delete_outline, size: 18),
                      label: const Text('Clear'),
                    )
                  else
                    const SizedBox.shrink(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: _RecordButton(
                      isListening: isListening,
                      onPressed: dictationService.toggle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomizationBody extends StatefulWidget {
  const _CustomizationBody({
    required this.dictationService,
    required this.onHotKeyChanged,
  });

  final DictationService dictationService;
  final VoidCallback onHotKeyChanged;

  @override
  State<_CustomizationBody> createState() => _CustomizationBodyState();
}

class _CustomizationBodyState extends State<_CustomizationBody> {
  HotKey? _currentHotKey;

  @override
  void initState() {
    super.initState();
    _loadHotKey();
  }

  Future<void> _loadHotKey() async {
    final hotKey = await loadRecordHotKey();
    if (mounted) setState(() => _currentHotKey = hotKey);
  }

  Future<void> _onHotKeyRecorded(HotKey hotKey) async {
    await saveRecordHotKey(hotKey);
    widget.onHotKeyChanged();
    if (mounted) setState(() => _currentHotKey = hotKey);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Text(
            'Record Hotkey',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Press the hotkey to start or stop dictation. Works even when the app is in the background.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          HotKeyRecorder(
            onHotKeyRecorded: _onHotKeyRecorded,
          ),
          if (_currentHotKey != null) ...[
            const SizedBox(height: 8),
            Text(
              'Current: ${_currentHotKey!.debugName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
