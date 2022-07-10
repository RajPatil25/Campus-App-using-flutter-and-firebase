import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/student/student_reset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import '../firebase/signIn.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);
  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  static const String _title = 'Log In';
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Auth auth = Auth();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(_title),
        backgroundColor: Colors.indigo[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              isKeyboardVisible
                  ? SizedBox(
                      child: Lottie.network(
                          "https://assets1.lottiefiles.com/temp/lf20_vKPgdY.json"),
                    )
                  : Container(
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/icons/student_login.gif",
                          ),
                        ],
                      ),
                    ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Student',
                    style: TextStyle(fontSize: 30, fontFamily: 'Custom'),
                  )),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: TextFormField(
                        controller: emailController,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Enter Email Address';
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ), //Email TextField
                    Container(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: TextFormField(
                        obscureText: !isVisible,
                        validator: (pswd) {
                          if (pswd == null || pswd.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: const Icon(Icons.remove_red_eye))),
                      ),
                    ), //Password TextField
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontSize: 17),
                          ),
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              if (await FirebaseFirestore.instance.doc('Email/${emailController.text}').get().then((value) => value.exists)) {
                                if(await auth.signIn(username: emailController.text, password: passwordController.text) != null) {
                                  Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (_) => const Wrapper()));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect Email Address or Password'),));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect Email Address'),
                                ));
                              }
                            } else {
                              setState(() {});
                            }
                          },
                        )),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                            child: const Text(
                              'Reset Password',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ResetPassword()));
                            })),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
