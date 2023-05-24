import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Authentication */
import 'package:firebase_auth/firebase_auth.dart';

/* 토스트 메세지 */
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

final fireStore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class ScffLogin extends StatefulWidget {
  const ScffLogin({Key? key}) : super(key: key);

  @override
  State<ScffLogin> createState() => _ScffLoginState();
}

class _ScffLoginState extends State<ScffLogin> {

  String email = "";
  String pw = "";

  @override
  void initState() {
    super.initState();

    if(auth.currentUser?.uid != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  signin() async {
    try{
      await auth.signInWithEmailAndPassword(
        email: email,
        password: pw,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } catch(e) {
      print(e);
      showToast(e.toString());
    }

    /*if(auth.currentUser?.uid == null) {
      print("로그인 안되어있음");
    } else {
      //print(auth.currentUser?.displayName);
      print("로그인 되어있음");
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Instagram"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Email Here",
                  labelText: 'Email',
                ),
                onChanged: (text) {
                  setState(() {
                    email = text;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Password Here",
                  labelText: 'pw',
                ),
                onChanged: (text) {
                  setState(() {
                    pw = text;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text("회원가입"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(pw.length < 6) {
                      showToast("비밀번호는 최소 6자입니다");
                    } else {
                      signin();
                    }
                  },
                  child: Text("로그인"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showToast(msg) {
  if(msg.contains("Given String is empty or null")) {
    Fluttertoast.showToast(
      msg: "이메일을 입력해주세요",
      gravity: ToastGravity.BOTTOM, // 토스트 메시지 뜨는 위치
      backgroundColor: Colors.blue,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT, // 토스트 메시지 지속시간
    );
  } else if(msg.contains("The email address is badly fomatted")) {
    Fluttertoast.showToast(
      msg: "이메일 형식이 올바르지 않습니다",
      gravity: ToastGravity.BOTTOM, // 토스트 메시지 뜨는 위치
      backgroundColor: Colors.blue,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT, // 토스트 메시지 지속시간
    );
  } else if(msg.contains("There is no user")) {
    Fluttertoast.showToast(
      msg: "존재하지 않는 계정입니다",
      gravity: ToastGravity.BOTTOM, // 토스트 메시지 뜨는 위치
      backgroundColor: Colors.blue,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT, // 토스트 메시지 지속시간
    );
  } else if(msg.contains("The password is invalid")) {
    Fluttertoast.showToast(
      msg: "비밀번호가 일치하지 않습니다",
      gravity: ToastGravity.BOTTOM, // 토스트 메시지 뜨는 위치
      backgroundColor: Colors.blue,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT, // 토스트 메시지 지속시간
    );
  } else {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM, // 토스트 메시지 뜨는 위치
      backgroundColor: Colors.blue,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT, // 토스트 메시지 지속시간
    );
  }
}