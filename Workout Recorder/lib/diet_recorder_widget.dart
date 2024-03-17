import 'package:firstapp/entity/diet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'recording_provider_info.dart';
import 'package:firstapp/widget_switching_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DietRecorderWidget extends StatefulWidget {
  final AppDatabase database;
  const DietRecorderWidget(this.database, {super.key});

  @override
  createState() => _DietRecorderWidgetState();
}

class _DietRecorderWidgetState extends State<DietRecorderWidget> {
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Set<String> distinctFoodNames = {};
  List<Diet> dietRecords = [];
  bool isEditing = false;
  Diet? editingDiet;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void addDiet() async {
    String food = foodController.text;
    String quantity = quantityController.text;
    DateTime recordTime = DateTime.now();
    context.read<RecordingProvider>().recordEvent("Diet", recordTime);

    if (food.isNotEmpty && quantity.isNotEmpty) {
      if (isEditing && editingDiet != null) {
        editingDiet!.quantity = quantity;
        await widget.database.dietDAO.updateQuantity(editingDiet!);
        setState(() {
          isEditing = false;
          editingDiet = null;
        });
      } else {
        final diet = Diet(null, food, quantity, recordTime.toString());
        await widget.database.dietDAO.addDietRecords(diet);
      }
      fetchData();
      foodController.clear();
      quantityController.clear();
    }
  }

  Future<void> deleteDiet(Diet diet) async {
    await widget.database.dietDAO.deleteDiet(diet);
    fetchData();
  }

  void startEditing(Diet diet) {
    setState(() {
      isEditing = true;
      editingDiet = diet;
      foodController.text = diet.food;
      quantityController.text = diet.quantity;
    });
  }

  Future<void> fetchData() async {
    final diets = await widget.database.dietDAO.getDietRecords();
    setState(() {
      dietRecords = diets;
      distinctFoodNames = diets.map((diet) => diet.food).toSet();
    });
  }

  Widget buildListItem(Diet diet, WidgetStyle currentStyle) {
    return currentStyle == WidgetStyle.cupertino
        ? CupertinoListTile(
      title: Text(diet.food),
      subtitle: Text(diet.quantity),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            onPressed: () => startEditing(diet),
            child: const Icon(CupertinoIcons.pencil),
          ),
          CupertinoButton(
            onPressed: () => deleteDiet(diet),
            child: const Icon(CupertinoIcons.delete),
          ),
        ],
      ),
    )
        : ListTile(
      title: Text(diet.food),
      subtitle: Text(diet.quantity),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => startEditing(diet),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteDiet(diet),
          ),
        ],
      ),
    );
  }

  Widget buildListSection(WidgetStyle currentStyle) {
    return currentStyle == WidgetStyle.cupertino
        ? CupertinoListSection(
      children: dietRecords.map((diet) => buildListItem(diet, currentStyle)).toList(),
    )
        : ListView(
      shrinkWrap: true,
      children: dietRecords.map((diet) => buildListItem(diet, currentStyle)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodLabel = Text('${AppLocalizations.of(context)!.foodLabel}:');
    final quantityLabel = Text('${AppLocalizations.of(context)!.quantityLabel}:');
    final submitButtonLabel = Text('${AppLocalizations.of(context)!.submitButton}');

    return Consumer<WidgetSwitching>(
      builder: (context, widgetSwitching, child) {
        final currentStyle = widgetSwitching.currentStyle;

        return Column(
          children: [
            const SizedBox(height: 50),
            Text(
              '${AppLocalizations.of(context)!.dietInstruction}:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  foodController.text = distinctFoodNames.elementAt(index);
                });
              },
              children: distinctFoodNames.map((food) {
                return Text(food);
              }).toList(),
            )
                : DropdownButton<String>(
              key: const Key('dropdown'),
              hint: Text('${AppLocalizations.of(context)!.dietDropdownInstruction}:'),
              value: null,
              items: distinctFoodNames.map((food) {
                return DropdownMenuItem<String>(
                  value: food,
                  child: Text(food),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  foodController.text = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoTextFormFieldRow(
              controller: foodController,
              prefix: foodLabel,
            )
                : TextFormField(
              controller: foodController,
              decoration: InputDecoration(
                label: foodLabel,
              ),
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoTextFormFieldRow(
              controller: quantityController,
              keyboardType: TextInputType.number,
              prefix: quantityLabel,
            )
                : TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: quantityLabel,
              ),
            ),
            const SizedBox(height: 16),
            currentStyle == WidgetStyle.cupertino
                ? CupertinoButton.filled(
              onPressed: addDiet,
              child: submitButtonLabel,
            )
                : ElevatedButton(
              onPressed: () {
                addDiet();
              },
              child: submitButtonLabel,
            ),
            const SizedBox(height: 16),
            if (dietRecords.isNotEmpty) buildListSection(currentStyle),
          ],
        );
      },
    );
  }
}