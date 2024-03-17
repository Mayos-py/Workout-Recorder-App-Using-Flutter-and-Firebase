import 'package:firstapp/widget_switching_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'entity/workout.dart';
import 'recording_provider_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkoutRecorderWidget extends StatefulWidget {
  final AppDatabase database;
  const WorkoutRecorderWidget(this.database, {Key? key}) : super(key: key);

  @override
  createState() => _WorkoutRecorderWidgetState();
}

class _WorkoutRecorderWidgetState extends State<WorkoutRecorderWidget> {
  TextEditingController quantityController = TextEditingController();
  List<Workout> workoutDataList = [];
  String? selectedExercise;
  String? quantity;

  final List<String> exercises = [
    "Crunches", "Leg Raises", "Plank", "Bicycle Crunches", "Mountain Climbers", "Jumping Jacks", "Push-ups", "Reverse Crunches"
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final workouts = await widget.database.workoutDAO.getWorkouts();
    setState(() {
      workoutDataList = workouts;
    });
  }

  void recordWorkout() async {
    DateTime time = DateTime.now();
    context.read<RecordingProvider>().recordEvent("Workout", time);

    await widget.database.workoutDAO.addWorkout(Workout(
      null,
      selectedExercise!,
      quantity!,
      time.toString(),
    ));
    fetchData();

    quantityController.clear();
    selectedExercise = null;
  }

  Future<void> deleteWorkout(Workout workout) async {
    await widget.database.workoutDAO.deleteWorkout(workout);
    fetchData();
  }

  Widget buildListItem(Workout workout, WidgetStyle currentStyle) {
    return currentStyle == WidgetStyle.cupertino
        ? CupertinoListTile(
      title: Text(workout.workout),
      subtitle: Text('${workout.quantity} - ${workout.recordedDateTime}'),
      trailing: IconButton(
        icon: Icon(CupertinoIcons.delete),
        onPressed: () => deleteWorkout(workout),
      ),
    )
        : ListTile(
      title: Text(workout.workout),
      subtitle: Text('${workout.quantity} - ${workout.recordedDateTime}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => deleteWorkout(workout),
      ),
    );
  }

  Widget buildListSection(WidgetStyle currentStyle) {
    return currentStyle == WidgetStyle.cupertino
        ? CupertinoListSection(
      children: workoutDataList.map((workout) => buildListItem(workout, currentStyle)).toList(),
    )
        : ListView(
      shrinkWrap: true,
      children: workoutDataList.map((workout) => buildListItem(workout, currentStyle)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quantityLabel = Text('${AppLocalizations.of(context)!.quantityLabel}:');
    final submitButtonLabel = Text('${AppLocalizations.of(context)!.submitButton}');

    return Consumer<WidgetSwitching>(
      builder: (context, widgetSwitching, child) {
        final currentStyle = widgetSwitching.currentStyle;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              '${AppLocalizations.of(context)!.workoutInstruction}:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedExercise = exercises[index];
                });
              },
              children: exercises.map((exercise) {
                return Text(exercise);
              }).toList(),
            )
                : DropdownButton<String>(
              key: const Key('exerciseDropdown'),
              hint: Text('${AppLocalizations.of(context)!.workoutDropdownInstruction}:'),
              value: selectedExercise,
              items: exercises.map((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise,
                  child: Text(exercise),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedExercise = value;
                });
              },
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoTextFormFieldRow(
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  quantity = value;
                });
              },
              prefix: quantityLabel,
            )
                : TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  quantity = value;
                });
              },
              decoration: InputDecoration(
                label: quantityLabel,
              ),
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoButton.filled(
              onPressed: recordWorkout,
              child: submitButtonLabel,
            )
                : ElevatedButton(
              onPressed: () {
                recordWorkout();
              },
              child: submitButtonLabel,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            buildListSection(currentStyle),
          ],
        );
      },
    );
  }
}
