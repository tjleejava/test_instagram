import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Authentication */
import 'package:firebase_auth/firebase_auth.dart';

final fireStore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  /* 회원 가입 */
  signUp() async {
    try {
      var res = await auth.createUserWithEmailAndPassword(
          email: "test@test.com",
          password: "123456",
      );
      //res.user?.updateDisplayName("jhon");
      print(res.user);
    } catch(e) {
      print(e);
    }
  }

  /* 로그인 */
  login() async {
    try{
      await auth.signInWithEmailAndPassword(
          email: "test@test.com",
          password: "123456",
      );
    } catch(e) {
      print(e);
    }

    if(auth.currentUser?.uid == null) {
      print("로그인 안되어있음");
    } else {
      //print(auth.currentUser?.displayName);
      print("로그인 되어있음");
    }
  }

  /* 로그아웃 */
  logout() async {
    await auth.signOut();
  }

  /* 데이터 조회 */
  getData() async {
    try {
      //var res = await fireStore.collection('product').doc('nh7Bqn0M7AiglkcDSUo1').get();
      var res = await fireStore.collection('product').get();  // 'product'내의 데이터 모두 조회
      //var res = await fireStore.collection("product").where().get();  // 조건을 통해서 데이터 조회
       //var res = await fireStore.collection("product").doc("wdnepIfFQl5SgJRKWte5").delete();  // 해당 document 삭제
      // var res = await fireStore.collection("product").doc().update({"name" : "test"});  // 해당 document 업데이트
      //print(res['name']);

      for (var doc in res.docs) {
        print(doc['name']);
      }
    } catch(e) {
      print('데이터 조회 중 에러 발생!');
    }
  }

  /* 데이터 저장 */
  saveData() async {
    try {
      var res = await fireStore.collection("product").add({"name" : "내복", 'price' : 8000});
    } catch(e) {
      print("데이터 저장 중 에러 발생!");
    }
  }

  @override
  void initState() {
    super.initState();
    logout();
    //signUp();
    //login();
    getData();
    //saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("샵페이지!"),
    );
  }
}
