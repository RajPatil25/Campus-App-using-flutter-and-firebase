
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfile
{
  late final String uid;

  StudentProfile({required this.uid});

  final CollectionReference cr = FirebaseFirestore.instance.collection('Student_Detail');
  Stream<QuerySnapshot> get prn
  {
    return cr.snapshots();
  }
  // static Map<String,dynamic> info = {};
  // static CollectionReference cr = FirebaseFirestore.instance.collection('Student_Detail');
  // final String prn;
  //
  //
  //
  //  const StudentProfile({Key? key,required this.prn});
  // static Future<void> getData(String prn) async
  // {
  //   DocumentSnapshot qs = await cr.doc(prn).get();
  //   info = qs.data() as Map<String,dynamic>;
  // }

}

// child: Column(
//   children: [
//     Text(info['Name']['First']),
//     Text(info['Name']['Last']),
//     Text(info['Name']['Middle']),
//     // Text(info['Mobile'][0]),
//
//   ],
// ),


