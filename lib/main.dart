import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'screens/customization_screen.dart';
import 'screens/history_screen.dart';
// import 'screens/home_screen.dart'; // Commented out - History is main page
import 'screens/settings_screen.dart';
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

  NativeBridge.instance.setHotkeyCallback(() => recordingService.toggleRecording());
  NativeBridge.instance.setCancelCallback(() => recordingService.cancelRecordingOrProcessing());

  runApp(
    MainApp(
      recordingService: recordingService,
      historyService: historyService,
    ),
  );

  // Start hotkey listener after the window is created and platform channel is ready
  WidgetsBinding.instance.addPostFrameCallback((_) async {
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
      themeMode: ThemeMode.system,
      home: MainScaffold(
        recordingService: recordingService,
        historyService: historyService,
      ),
    );
  }
}

enum RailDestination { history, customization, settings }

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
      color: colorScheme.surfaceContainer,
      child: NavigationRail(
        extended: false,
        backgroundColor: Colors.transparent,
        indicatorColor: colorScheme.surface,
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
            selectedIcon: const Tooltip(
              message: 'History',
              child: Icon(Symbols.history, fill: 1),
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
                message: 'Customization',
                child: Icon(Symbols.palette),
              ),
            ),
            selectedIcon: const Tooltip(
              message: 'Customization',
              child: Icon(Symbols.palette, fill: 1),
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
            selectedIcon: const Tooltip(
              message: 'Settings',
              child: Icon(Symbols.settings, fill: 1),
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
                      const SizedBox(height: 8),
                      AppBar(
                        title: Text(
                          switch (_selectedDestination) {
                            RailDestination.history => 'History',
                            RailDestination.customization => 'Customization',
                            RailDestination.settings => 'Settings',
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        centerTitle: false,
                        leadingWidth: 0,
                        titleSpacing: 24,
                      ),
                      Expanded(
                        child: switch (_selectedDestination) {
                          RailDestination.history => HistoryScreen(
                              historyService: widget.historyService,
                            ),
                          RailDestination.customization => CustomizationScreen(
                              historyService: widget.historyService,
                            ),
                          RailDestination.settings => SettingsScreen(
                              recordingService: widget.recordingService,
                              onHotKeyChanged: () {},
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
