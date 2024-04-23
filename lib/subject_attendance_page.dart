import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectAttendancePage extends StatefulWidget {
  final String userId;
  SubjectAttendancePage({required this.userId});

  @override
  _SubjectAttendancePageState createState() => _SubjectAttendancePageState();
}

class _SubjectAttendancePageState extends State<SubjectAttendancePage> {
  final Map<String, dynamic> _attendanceData = {}; // Initialize with an empty map

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final attendanceSnapshot = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(widget.userId)
        .get();

    if (attendanceSnapshot.exists) {
      setState(() {
        _attendanceData.addAll(attendanceSnapshot.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject-wise Attendance'),
      ),
      body: _attendanceData.isEmpty
          ? Center(
        child: Text('No attendance data found for the current user.'),
      )
          : ListView(
        children: _attendanceData.entries.map((entry) {
          String subject = entry.key;
          int attended = entry.value['attended'] ?? 0;
          int totalLectures = entry.value['totalLectures'] ?? 5;
          double attendancePercentage =
              (attended / (totalLectures > 0 ? totalLectures : 1)) * 100;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Attended: $attended',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Total Lectures: $totalLectures',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Attendance Percentage: ${attendancePercentage.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
