import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreRecord {

    final String name;

    final int completeTime;

    final DateTime dateCreated;

    ScoreRecord({
        this.name,
        this.completeTime,
        this.dateCreated
    });

    factory ScoreRecord.fromJson(Map<String, dynamic> json) =>
        ScoreRecord(
            name: json['name'] as String,
            completeTime: json['completeTime'] as int,
            dateCreated: json['dateUpdated'] != null
                ? (json['dateUpdated'] as Timestamp).toDate() : DateTime.now()
        );
}