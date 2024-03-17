import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/workout_recorder_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:firstapp/recording_provider_info.dart';
import 'package:provider/provider.dart';
import 'workout_recorder_test.mocks.dart';

@GenerateMocks([RecordingProvider])
void main() {
  testWidgets('Workout Recorder Widget Test', (WidgetTester tester) async {
    RecordingProvider model = MockRecordingProvider();
    await tester.pumpWidget(
        ChangeNotifierProvider.value(
            value: model,
            child: const MaterialApp(
                home: Material(
                    child: WorkoutRecorderWidget()
                )
            )
        )
    );

    await tester.tap(find.byKey(const Key('exerciseDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crunches'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('quantityTextField')), '10');

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('Crunches')), findsOneWidget);
    expect(find.byKey(Key('10')), findsOneWidget);
    expect(find.byKey(Key('Timestamp')), findsOneWidget);

  });
}