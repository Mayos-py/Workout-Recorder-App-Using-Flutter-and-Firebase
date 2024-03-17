import 'package:firstapp/entity/emotions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'recording_provider_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EmotionRecorderWidget extends StatefulWidget {
  final AppDatabase database;
  const EmotionRecorderWidget(this.database, {super.key});

  @override
  createState() => _EmotionRecorderWidgetState();
}

class _EmotionRecorderWidgetState extends State<EmotionRecorderWidget> {
  _EmotionRecorderWidgetState();
  final List<String> emojis = [
    "😜", "😥", "😰", "🤨", "😮", "😕", "😐", "😅", "😄", "😁", "😌", "🤗", "😏", "😇", "🙄", "😬", "🥺", "😋", "😢", "🤔", "😎", "😂", "😍", "😊"
  ];

   List<Emotion> selectedEmotionsList = [];

   @override
   void initState() {
     super.initState();
     fetchData();
   }

   Future<void> fetchData() async {
     final emotions = await widget.database.emotionDAO.getEmotions();
     if (emotions.isNotEmpty) {
       setState(() {
         selectedEmotionsList = emotions;
       });
     }
   }

   Future<void> deleteEmotion(Emotion emotion) async {
     await widget.database.emotionDAO.deleteEmotion(emotion);
     fetchData();
   }

   void addEmotion(String emoji) async {
     DateTime time = DateTime.now();
     context.read<RecordingProvider>().recordEvent("Emotion", time);
     final emotion = Emotion(null, emoji, time.toString());
     await widget.database.emotionDAO.addEmotion(emotion);
     fetchData();
   }

   @override
   Widget build(BuildContext context) {
     return Container(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const SizedBox(height: 50),
           Text(
             '${AppLocalizations.of(context)!.emotionInstruction}:',
             style: const TextStyle(fontSize: 18),
           ),
           const SizedBox(height: 16),
           Wrap(
             spacing: 8,
             children: emojis.map((emoji) {
               return GestureDetector(
                 onTap: () => addEmotion(emoji),
                 child: Text(
                   emoji,
                   style: const TextStyle(fontSize: 24),
                 ),
               );
             }).toList(),
           ),
           const SizedBox(height: 16),
           SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: selectedEmotionsList.map((emotion) {
                 return Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       '${emotion.emotion} - ${emotion.recordedDateTime},',
                       style: const TextStyle(fontSize: 18),
                     ),
                     IconButton(
                       icon: Icon(Icons.delete),
                       onPressed: () => deleteEmotion(emotion),
                     ),
                   ],
                 );
               }).toList(),
             ),
           ),
         ],
       ),
     );
   }
}
