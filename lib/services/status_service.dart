import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mutfak/model/status.dart';

class StatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //status eklemek için
  Future<void> addStatus(String status) async {
    var ref = _firestore.collection("Status");

    var documentRef = await ref.add({'status': status});

    return Status(
      id: documentRef.id,
      status: status,
    );
  }

  //status göstermek için
  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("Status").snapshots();

    return ref;
  }

  //status silmek için
  Future<void> removeStatus(String docId) {
    var ref = _firestore.collection("Status").doc(docId).delete();

    return ref;
  }
}
