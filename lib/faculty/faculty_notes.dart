import 'dart:io';
import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FacultyNotes extends StatefulWidget {
  const FacultyNotes({Key? key}) : super(key: key);

  @override
  State<FacultyNotes> createState() => _FacultyNotesState();
}

class _FacultyNotesState extends State<FacultyNotes> {

  String url = "";
  int? num;
  uploadDataToFirebase() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;

    //uploading
    var pdfFile = FirebaseStorage.instance.ref().child("notes").child(fileName);
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    //  to cloud firebase

    await FirebaseFirestore.instance.collection("notes").doc('num').set(
      {
        'url':url,
        'num': fileName,
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.indigo[300],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: (){
          uploadDataToFirebase();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.docs.isEmpty){
              return const Center(child: Text('Files Not Added.',style: TextStyle(color: Colors.grey,fontSize: 20),));
            } else {
              return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,i){
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadPdf(url:x["url"])));
                  },
                  child: Padding(
                    padding:  const EdgeInsetsDirectional.only(start: 20,end: 20,top: 40),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      color: Colors.blue[100],
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        child: Text((x['num']),textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Bold",fontSize: 30),),
                      ),
                    ),
                  ),
                );
              });
            }
          } else {
            return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red),
          );
          }
        }
      ),
    );
  }
}
