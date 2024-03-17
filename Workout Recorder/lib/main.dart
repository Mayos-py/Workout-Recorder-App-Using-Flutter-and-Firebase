import 'package:firstapp/recording_provider_info.dart';
import 'package:firstapp/widget_switching_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'emotion_recorder_widget.dart';
import 'diet_recorder_widget.dart';
import 'workout_recorder_widget.dart';
import 'status_widget.dart';
import 'firebase_Initializer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppDatabase database = await $FloorAppDatabase.databaseBuilder('recorderDatabase5.db').build();

  final router = GoRouter(
      initialLocation: '/registerLogin',
      routes: [
        GoRoute(
          path: '/emotion',
          builder: (context, state) => EmotionRecorderWidget(database),
        ),
        GoRoute(
          path: '/diet',
          builder: (context, state) => DietRecorderWidget(database),
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => WorkoutRecorderWidget(database),
        ),
        GoRoute(
          path: '/registerLogin',
          builder: (context, state) => FirebaseInitializer()
        )
      ]
  );
  runApp(MyApp(database, router));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final router;
  const MyApp(this.database, this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecordingProvider(database),
        ),
        ChangeNotifierProvider(
          create: (context) => WidgetSwitching(WidgetStyle.material),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
        home: Scaffold(
          body: Column(
            children: [
              AppBar(
                actions: [
                  Consumer<WidgetSwitching>(
                    builder: (context, widgetSwitching, child) {
                      return Row(
                        children: [
                          Checkbox(
                            value: widgetSwitching.currentStyle == WidgetStyle.cupertino,
                            onChanged: (value) {
                              widgetSwitching.setStyle(
                                value == true ? WidgetStyle.cupertino : WidgetStyle.material,
                              );
                            },
                          ),
                          Text('Cupertino'),
                        ],
                      );
                    },
                  ),

                ],
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topRight,
                 child: StatusWidget(database),
              ),
              Expanded(
                child: RecorderContainer(database, router)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecorderContainer extends StatefulWidget {
  final AppDatabase database;
  final router;
  const RecorderContainer(this.database, this.router, {super.key});

  @override
  State<RecorderContainer> createState() => _RecorderContainerState(database, router);
}

class _RecorderContainerState extends State<RecorderContainer> {
  final AppDatabase database;
  final router;
  _RecorderContainerState(this.database, this.router);

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: <Widget>[
        const FirebaseInitializer(),
        SingleChildScrollView(child: EmotionRecorderWidget(database)),
        SingleChildScrollView(child: DietRecorderWidget(database)),
        SingleChildScrollView(child: WorkoutRecorderWidget(database)),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          switch (index) {
            case 0:
              router.go('/registerLogin');
              break;
            case 1:
              router.go('/emotion');
              break;
            case 2:
              router.go('/diet');
              break;
            case 3:
              router.go('/workout');
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: "LeaderBoard",
          ),
          NavigationDestination(
            icon: const Icon(Icons.mood),
            label: AppLocalizations.of(context)!.emotionLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fastfood),
            label: AppLocalizations.of(context)!.dietLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center),
            label: AppLocalizations.of(context)!.workoutLabel,
          ),
        ],
      ),
    );
  }
}


