import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'faculty_home.dart';
import 'faculty_profile.dart';


class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({Key? key}) : super(key: key);
  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  final navigationkey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;


  @override
  Widget build(BuildContext context) {
    final screen = [
      const FacultyHome(),
      const FacultyProfile(),
    ];
    final items = <Widget>
    [
      const Icon(Icons.home_outlined,size: 30,),
      const Icon(Icons.person_outline_outlined,size: 30,),
      // const Icon(Icons.logout,size: 30,),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: screen[index],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationkey,
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) => setState(() { this.index = index;}),
        )
    );
  }
}