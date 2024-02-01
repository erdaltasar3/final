import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
// kolelsiyon oluşturma
  final CollectionReference gorevler =
      FirebaseFirestore.instance.collection('gorevler');

  // CREATE
  Future<void> gorevEkle(
      String gorevAciklama, String gorevBaslangic, String gorevBitis) {
    return gorevler.add({
      'gorevAciklama': gorevAciklama,
      'gorevBaslangic': gorevBaslangic,
      'gorevBitis': gorevBitis,
      'timestamp': Timestamp.now(),
    });
  }

  // READ
  Stream<QuerySnapshot> getGorevStream() {
    final gorevStream =
        gorevler.orderBy('timestamp', descending: true).snapshots();

    return gorevStream;
  }

  // UPDATE
  Future<void> gorevGuncelle(
    String docID,
    String yeniGorevAciklama,
    String yeniGorevBaslangic,
    String yeniGorevBitis,
  ) {
    return gorevler.doc(docID).update(
      {
        'gorevAciklama': yeniGorevAciklama,
        'gorevBaslangic': yeniGorevBaslangic,
        'gorevBitis': yeniGorevBitis,
        'timestamp': Timestamp.now(),
      },
    );
  }

  // DELETE
  Future<void> gorevSil(String docId) {
    return gorevler.doc(docId).delete();
  }
}
