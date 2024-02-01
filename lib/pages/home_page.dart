import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_uygulama_2/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore bağlantı
  FirestoreServices firestoreServices = FirestoreServices();

  // text edition kontrolleri
  TextEditingController gorevAciklama = TextEditingController();
  TextEditingController gorevBaslangic = TextEditingController();
  TextEditingController gorevBitis = TextEditingController();

  Future<void> openGorevBox({String? docID}) async {
    if (docID != null) {
      var documentReference =
          FirebaseFirestore.instance.collection('gorevler').doc(docID);

      var documentSnapshot = await documentReference.get();
      var gorevAAciklama = documentSnapshot.data()?['gorevAciklama'];
      var gorevBBaslangic = documentSnapshot.data()?['gorevBaslangic'];
      var gorevBBitis = documentSnapshot.data()?['gorevBitis'];

      gorevAciklama.text = gorevAAciklama;
      gorevBaslangic.text = gorevBBaslangic;
      gorevBitis.text = gorevBBitis;
    }
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (content) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gorevAciklama,
              decoration: const InputDecoration(hintText: 'Gorev Aciklamasi'),
            ),
            TextField(
              controller: gorevBaslangic,
              decoration:
                  const InputDecoration(hintText: 'Gorev baslangic tarihi'),
            ),
            TextField(
              controller: gorevBitis,
              decoration: const InputDecoration(hintText: 'Gorev bitis tarihi'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                // KAYDET
                if (docID == null) {
                  firestoreServices.gorevEkle(
                      gorevAciklama.text, gorevBaslangic.text, gorevBitis.text);
                }
                // UPDATE
                else {
                  firestoreServices.gorevGuncelle(docID, gorevAciklama.text,
                      gorevBaslangic.text, gorevBitis.text);
                }

                gorevAciklama.clear();
                gorevBaslangic.clear();
                gorevBitis.clear();
                Navigator.pop(context);
              },
              child: const Text('Ekle'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Ana Sayfa'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openGorevBox,
        child: const Text(
          'Görev Ekle',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreServices.getGorevStream(),
        builder: (context, snapshot) {
          // data var ise
          if (snapshot.hasData) {
            List gorevlerList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: gorevlerList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = gorevlerList[index];
                String docID = document.id;

                // get gorev from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String gorevAciklamaa = data['gorevAciklama'];
                String gorevBaslangicc = data['gorevBaslangic'];
                String gorevBitiss = data['gorevBitis'];

                return Card(
                  color: Colors.blueGrey,
                  margin: const EdgeInsets.only(top: 40),
                  child: ListTile(
                    title: Text(gorevAciklamaa),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // UPDATE
                        IconButton(
                          onPressed: () => openGorevBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),

                        // DELETE
                        IconButton(
                          onPressed: () => firestoreServices.gorevSil(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    subtitle: Text(
                        'Gorev baslangic: $gorevBaslangicc ,  gorev bitis: $gorevBitiss'),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
