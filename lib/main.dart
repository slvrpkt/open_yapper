import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'screens/customization_screen.dart';
import 'screens/history_screen.dart';
// import 'screens/home_screen.dart'; // Commented out - History is main page
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'views/onboarding_view.dart';
import 'widgets/screen_container.dart';
import 'services/native_bridge.dart';
import 'services/recording_history_service.dart';
import 'services/recording_service.dart';
import 'services/settings_storage.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final historyService = RecordingHistoryService();
  final recordingService = RecordingService(
    historyService: historyService,
    loadApiKey: loadGeminiApiKey,
    loadModel: () async => 'gemini-flash-lite-latest',
  );

  NativeBridge.instance.setHotkeyCallbacks(
    onStart: () => recordingService.toggleRecording(),
    onStop: () => recordingService.stopRecording(),
    onHoldDown: () => recordingService.startRecording(),
    onHoldUp: () => recordingService.stopRecording(),
  );
  NativeBridge.instance.setCancelCallback(() => recordingService.cancelRecordingOrProcessing());

  runApp(
    MainApp(
      recordingService: recordingService,
      historyService: historyService,
    ),
  );

  // Start hotkey listener after the window is created and platform channel is ready
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final config = await loadHotkeyConfig();
    await NativeBridge.instance.setHotkeyConfig(
      startKeyCode: config.startKeyCode,
      startFlags: config.startFlags,
      stopKeyCode: config.stopKeyCode,
      stopFlags: config.stopFlags,
      holdKeyCode: config.holdKeyCode,
      holdFlags: config.holdFlags,
    );
    await NativeBridge.instance.startHotkeyListener();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.recordingService,
    required this.historyService,
  });

  final RecordingService recordingService;
  final RecordingHistoryService historyService;

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme.withTypography();
    return MaterialApp(
      title: 'Open Yapper',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.dark,
      home: MainScaffold(
        recordingService: recordingService,
        historyService: historyService,
      ),
    );
  }
}

enum RailDestination { history, stats, customization, settings }

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: NavigationRail(
        extended: false,
        backgroundColor: Colors.transparent,
        indicatorColor: colorScheme.primary,
        groupAlignment: 0.0,
        destinations: [
          NavigationRailDestination(
            icon: IconTheme(
              data: IconThemeData(color: colorScheme.onSurfaceVariant),
              child: const Tooltip(
                message: 'History',
                child: Icon(Symbols.history),
              ),
            ),
            selectedIcon: IconTheme(
              data: IconThemeData(color: colorScheme.surface),
              child: const Tooltip(
                message: 'History',
                child: Icon(Symbols.history, fill: 1),
              ),
            ),
            label: Text(
              'History',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          NavigationRailDestination(
            icon: IconTheme(
              data: IconThemeData(color: colorScheme.onSurfaceVariant),
              child: const Tooltip(
                message: 'Stats',
                child: Icon(Symbols.emoji_events),
              ),
            ),
            selectedIcon: IconTheme(
              data: IconThemeData(color: colorScheme.surface),
              child: const Tooltip(
                message: 'Stats',
                child: Icon(Symbols.emoji_events, fill: 1),
              ),
            ),
            label: Text(
              'Stats',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          NavigationRailDestination(
            icon: IconTheme(
              data: IconThemeData(color: colorScheme.onSurfaceVariant),
              child: const Tooltip(
                message: 'Customization',
                child: Icon(Symbols.tune),
              ),
            ),
            selectedIcon: IconTheme(
              data: IconThemeData(color: colorScheme.surface),
              child: const Tooltip(
                message: 'Customization',
                child: Icon(Symbols.tune, fill: 1),
              ),
            ),
            label: Text(
              'Customization',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          NavigationRailDestination(
            icon: IconTheme(
              data: IconThemeData(color: colorScheme.onSurfaceVariant),
              child: const Tooltip(
                message: 'Settings',
                child: Icon(Symbols.settings),
              ),
            ),
            selectedIcon: IconTheme(
              data: IconThemeData(color: colorScheme.surface),
              child: const Tooltip(
                message: 'Settings',
                child: Icon(Symbols.settings, fill: 1),
              ),
            ),
            label: Text(
              'Settings',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.recordingService,
    required this.historyService,
  });

  final RecordingService recordingService;
  final RecordingHistoryService historyService;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  RailDestination _selectedDestination = RailDestination.history;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Row(
            children: [
              AppSidebar(
                selectedIndex: _selectedDestination.index,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedDestination = RailDestination.values[index];
                  });
                },
              ),
              Expanded(
                child: ScreenContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: switch (_selectedDestination) {
                          RailDestination.history => HistoryScreen(
                              historyService: widget.historyService,
                            ),
                          RailDestination.stats => StatsScreen(
                              historyService: widget.historyService,
                            ),
                          RailDestination.customization => CustomizationScreen(
                              historyService: widget.historyService,
                            ),
                          RailDestination.settings => SettingsScreen(
                              recordingService: widget.recordingService,
                              onHotKeyChanged: () async {
                                final config = await loadHotkeyConfig();
                                await NativeBridge.instance.setHotkeyConfig(
                                  startKeyCode: config.startKeyCode,
                                  startFlags: config.startFlags,
                                  stopKeyCode: config.stopKeyCode,
                                  stopFlags: config.stopFlags,
                                  holdKeyCode: config.holdKeyCode,
                                  holdFlags: config.holdFlags,
                                );
                              },
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        OnboardingView(recordingService: widget.recordingService),
      ],
    );
  }
}
