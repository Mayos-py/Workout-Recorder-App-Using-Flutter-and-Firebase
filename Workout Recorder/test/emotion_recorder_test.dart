import 'package:firstapp/emotion_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:firstapp/recording_provider_info.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'emotion_recorder_test.mocks.dart';

@GenerateMocks([RecordingProvider])
void main() {
  testWidgets('Emotion Recorder Widget Test', (WidgetTester tester) async {
    RecordingProvider model = MockRecordingProvider();

    await tester.pumpWidget(
        ChangeNotifierProvider.value(
            value: model,
            child: const MaterialApp(
                home: Material(
                    child: EmotionRecorderWidget()
                )
            )
        )
    );

    await tester.tap(find.text('😜'));
    await tester.pump();

    expect(find.textContaining(RegExp(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')), findsOneWidget);
    expect(find.text('😜'), findsOneWidget);
  });
}
