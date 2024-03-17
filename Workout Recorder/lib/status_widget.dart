import 'package:firstapp/entity/RecordingPoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'recording_provider_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusWidget extends StatefulWidget {
  final AppDatabase database;
  const StatusWidget(this.database, {super.key});

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  String? lastRecordedType;
  DateTime? lastRecordedTime;
  int? recordingPoints;
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final List<Status> statusList = await widget.database.StatusDAO.getLatestRecord();
    if (statusList.isNotEmpty && !isDataFetched) {
      final Status status = statusList.first;
      lastRecordedType = status.lastRecordedType;
      lastRecordedTime = DateTime.fromMillisecondsSinceEpoch(status.lastRecordedTime);
      recordingPoints = status.recordingPoints;

      setState(() {
        isDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isDataFetched = false;
    fetchData();
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocalizations.of(context)!.lastRecordedTime}: $lastRecordedTime'),
          Text('${AppLocalizations.of(context)!.lastRecordedType}: $lastRecordedType'),
          Text('${AppLocalizations.of(context)!.pointsLabel}: $recordingPoints'),
          Text('${AppLocalizations.of(context)!.levelLabel}: ${context.watch<RecordingProvider>().calculateDedicationLevel()}'),
        ],
      ),
    );
  }
}
