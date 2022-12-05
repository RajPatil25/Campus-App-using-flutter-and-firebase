import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FacultyAttendance extends StatefulWidget {
  final Map subject;
  final String date;

  const FacultyAttendance({Key? key,required this.subject, required this.date}) : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  Map<String,dynamic> rolls = {};
  Map<String,bool> rollattend = {};
  Future markAttendance() async {
    Map<String,dynamic> mark = {};
    mark[widget.date] = rollattend;
    widget.subject[0].set(mark,SetOptions(merge: true));
  }
  Future perStudentAttendance()async{
    rollattend.forEach((key, value) async {
      DocumentSnapshot ds = await rolls[key].get();
      Map<String,dynamic> info = ds.data() as Map<String,dynamic>;
      String PRN = info['PRN'];
      DocumentReference student = FirebaseFirestore.instance.doc('Student_Detail/${PRN}/Attendane/${widget.subject[2]}');
      // DocumentSnapshot stu = await student.get();
      Map<String,dynamic> mark = {};
      mark[widget.date] = value;
      student.set(mark,SetOptions(merge: true));
    });
  }
  Future<Map<String,dynamic>> getStudentList() async {
    DocumentSnapshot rolllist = await widget.subject[1].get();
    rolls = rolllist.data() as Map<String,dynamic>;
    rolls.forEach((key, value) async {
      rollattend[key] = false;
    });
    await Future.delayed(const Duration(milliseconds: 350));
    return rollattend;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudentList(),
      builder: (context,AsyncSnapshot rollattend){
        if(rollattend.connectionState == ConnectionState.waiting){
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red)
              )
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("Attendance",style: TextStyle(fontFamily: 'MuliBold'),),
              backgroundColor: Colors.indigo[300],
            ),
            body: ListView.builder(
            itemCount: rollattend.data.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                margin: const EdgeInsetsDirectional.only(start: 15,top: 20,end: 15),
                alignment: Alignment.center,
                height: 70,
                decoration:  BoxDecoration(
                    borderRadius:
                    const BorderRadiusDirectional.only(
                        topStart: Radius.circular(50),
                        topEnd: Radius.circular(50),
                        bottomStart: Radius.circular(50)),
                    color: Colors.blue[50]),
                child: Center(
                  child: StatefulBuilder(
                    builder: (BuildContext context,setState) => CheckboxListTile(
                      activeColor: Colors.transparent,
                      checkColor: Colors.black,
                          title: Text(rollattend.data.keys.elementAt(index)),
                          value: rollattend.data[rollattend.data.keys.elementAt(index)],
                          secondary: const Icon(Icons.checklist_rtl_outlined),
                          onChanged:(_){
                            setState(() => rollattend.data[rollattend.data.keys.elementAt(index)] = !rollattend.data[rollattend.data.keys.elementAt(index)]);
                    },
                  ),
                ),
                ),
              );
            },
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 1,
              backgroundColor: Colors.indigo[200],
              foregroundColor: Colors.black,
              onPressed: () {
                markAttendance();
                perStudentAttendance();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(Icons.done_outline_rounded),
              label: const Text("Submit",style: TextStyle(fontFamily: 'MuliBold'),),
            ),
          );
        }
      }
    );
  }
}

