import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/diet_recorder_widget.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:firstapp/recording_provider_info.dart';
import 'diet_recorder_test.mocks.dart';

@GenerateMocks([RecordingProvider])
void main() {
  testWidgets('Diet Recorder Widget Test', (WidgetTester tester) async {
    RecordingProvider model = MockRecordingProvider();
    await tester.pumpWidget(
        ChangeNotifierProvider.value(
            value: model,
            child: const MaterialApp(
                home: Material(
                    child: DietRecorderWidget()
                )
            )
        )
    );
    
    await tester.enterText(find.byType(TextField).at(0), 'Pizza');
    await tester.enterText(find.byType(TextField).at(1), '10');
    await tester.pump();

    await tester.tap(find.text('Submit'));
    await tester.pump();

    await tester.tap(find.byKey(Key('dropdown')));
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsOneWidget);
  });
}
