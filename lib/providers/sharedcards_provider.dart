import 'package:cloud_firestore/cloud_firestore.dart';

class SharedCards {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> doclist;

  SharedCards(this.doclist);
}
