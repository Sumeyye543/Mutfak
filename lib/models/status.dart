import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String id;
  String status;

  Status({this.id, this.status});

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    return Status(
      id: snapshot.id,
      status: snapshot["status"],
    );
  }
}
