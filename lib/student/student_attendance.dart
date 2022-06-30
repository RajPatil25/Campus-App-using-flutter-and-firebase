import 'package:flutter/material.dart';

class StudentAttendance extends StatefulWidget {
   Map<String,dynamic> attendance;

  StudentAttendance({Key? key,required this.attendance}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  @override
  Widget build(BuildContext context) {
    print('${widget.attendance} asasaassasa');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: widget.attendance.length,
        itemBuilder: (BuildContext context,int index) {
          String key = widget.attendance.keys.elementAt(index);
          return Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        // alignment: Alignment.center,
                        height: 100,
                        // width: 300,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(50),
                                topEnd: Radius.circular(50),
                                bottomEnd: Radius.circular(50),
                                bottomStart: Radius.circular(50)),
                            color: Colors.limeAccent
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4,child: Text(key,style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),textAlign: TextAlign.center)),
                            Expanded(child: Text(widget.attendance[key].entries.where((e) => e.value == true).toList().length.toString(),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
    // return Container();
  }
}