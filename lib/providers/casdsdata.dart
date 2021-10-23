import 'package:cloud_firestore/cloud_firestore.dart';

class AllCardsData {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> doclist;

  AllCardsData(this.doclist);

  List<String> getidlist() {
    List<String> temp = [];
    for (var v in doclist) {
      temp.add(v.id);
    }
    return temp;
  }

  int getindexfromid(String id) {
    for (var v in doclist) {
      if (id == v.id) {
        return doclist.indexOf(v);
      }
    }
    return -1;
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? getcardsnapshot(String id) {
    for (var v in doclist) {
      if (id == v.id) {
        return v;
      }
    }
    return null;
  }
}
