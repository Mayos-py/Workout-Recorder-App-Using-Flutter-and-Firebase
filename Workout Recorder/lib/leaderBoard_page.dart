import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LeaderboardWidget extends StatefulWidget {
  @override
  _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  late List<Map<String, dynamic>> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Points').orderBy('points', descending: true).get();

    setState(() {
      leaderboardData = querySnapshot.docs.map((DocumentSnapshot doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {'email': data['email'] ?? '', 'points': data['points'] ?? 0};
      }).toList();
    });
  }

  void deleteData() async{

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteUserData');
      await callable.call({});
      print('User data deleted successfully');
    } catch (e) {
      print('Error deleting user data1111: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        actions: [
          ElevatedButton(onPressed: deleteData, child: Text("Delete my data")),
        ],
      ),
      body: leaderboardData == null
          ? CircularProgressIndicator()
          : ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> userData = leaderboardData[index];
          return ListTile(
            title: Text(userData['email']),
            subtitle: Text('Points: ${userData['points']}'),
          );
        },
      ),
    );
  }
}
