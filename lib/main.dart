import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'scffLogin.dart';
import 'shop.dart';
import 'style.dart' as style; // 변수 중복 방지를 위한 명칭 생성(방법1)

/* get, post 같은 서버와의 통신을 할 때 http 패키지 외에 Dio 패키지도 존재. Dio 패키지가 좀 더 편의성이 높음 */
import 'package:http/http.dart' as http;
import 'dart:convert';

/* 스크롤 관련 패키지 */
import 'package:flutter/rendering.dart';

/* 폰에 저장된 이미지 불러오기 */
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/* 폰 캐쉬에 데이터 저장 */
import 'package:shared_preferences/shared_preferences.dart';

/* 새페이지 오른쪽에서 슬라이드 애니메이션 (쉬운방법) */
import 'package:flutter/cupertino.dart';

/* State를 따로 보관하는 보관함 */
import 'package:provider/provider.dart';

/* notification */
import 'package:test_instagram/notification.dart';

/* firebase */
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Authentication */
import 'package:firebase_auth/firebase_auth.dart';

final fireStore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

/*var imgList = [];
var likesList = [];
var userList = [];
var contentList = [];*/

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      /*ChangeNotifierProvider(
        create: (c) => StateStore(),*/
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => StateStore()),
          ChangeNotifierProvider(create: (c) => StateStore2()),
        ],
        child: MaterialApp(
          theme: style.theme,
          /*initialRoute: "/",
          routes: {
            "/": (c) => Text("첫페이지"),
            "/detail": (c) => Text("둘째페이지")
          },*/
          home: MyApp(),
        ),
      )
  );
}

//var textStyle = TextStyle();  // text의 스타일을 변수로 할당해서 사용 가능

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;  // 현재 상태
  /*var list = [1, 2, 3]; // List 선언
  var map = { // Map 선언
    "name": "jhon",
    "age": 20
  };*/
  // List, Map 모두 자바스크립트랑 똑같음.

  var isScaffold = "N";

  /*codingApple 코드*/
  var data = [];
  var cnt = 0;
  var userImage;
  var userContent;

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  DateTime dt = DateTime.now();

  insertData() {
    var newData = {
      "id": data.length,
      "image": userImage,
      "likes": 0,
      "date": "${dt.month} ${dt.day}",
      "content": userContent,
      "liked": false,
      "user": "tester"
    };

    setState(() {
      data.insert(0, newData);
    });
  }

  getUserContent(text) {
    setState(() {
      userContent = text;
    });
  }

  getData() async {
    /* Dio 패키지도 깔아서 써보자 */
    var res = await http.get(Uri.parse("https://codingapple1.github.io/app/data.json"));
    var parsedRes = jsonDecode(res.body);
    /*for(var i = 0; i < parsedRes.length; i++) {
       imgList.add(parsedRes[i]['image']);
       likesList.add(parsedRes[i]['likes']);
       userList.add(parsedRes[i]['user']);
       contentList.add(parsedRes[i]['content']);
    }*/

    /* 예외처리 */
    /* if 조건문 외에 FutureBuilder 위젯을 사용해도 된다. */
    // FutuerBuilder() : 103번째 줄
    if (res.statusCode == 200) {
      // 성공시 코드
    } else {
      // 실패시 코드
    }

    setState(() {
      data = parsedRes;
    });
  }

  addCnt() {
    setState(() {
      cnt++;
    });
  }

  saveData() async {
    var storage = await SharedPreferences.getInstance();  // 저장공간 오픈
    /*storage.setString("name", "jhon");
    storage.setBool("bool", true);
    var res = storage.getString('name');
    var res2 = storage.getBool("bool");
    storage.remove("name");
    var map = {"age": 20};
    storage.setString("map", jsonEncode(map));
    var res = storage.getString("map") ?? "없는데요";
    var res2 = jsonDecode(res);
    //print(res2);
    print(res2['age']);*/
  }

  @override
  void initState() {  // initState 함수는 async를 붙일 수 없게 설정되어 있기 때문에 async-await을 쓸려면 함수 밖에서 선언해야한다.
    super.initState();
    //var res = await http.get(Uri.parse("https://codingapple1.github.io/app/data.json"));

    //print(res.body);

    saveData();
    initNotification(context);
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          showNotification2();
        },
      ),
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add_photo_alternate_outlined),
              onPressed: () async {
                if(auth.currentUser?.uid == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => ScffLogin()),
                  );
                } else {
                  var picker = ImagePicker();
                  var image = await picker.pickImage(
                      source: ImageSource.gallery); // 이미지 1개 갤러리에서 선택가능
                  // var image = await picker.pickMultiImage(); // 이미지 여러 개 선택 가능 -> List 형태로 담긴다.
                  // var image = await picker.pickVideo(sourc: VideoSource.gallery);  // 영상 1개 갤러리에서 선택가능
                  if (image != null) {
                    setState(() {
                      userImage = File(image.path);
                    });
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) =>
                          Upload(userImage: userImage,
                              data: data,
                              insertData: insertData,
                              getUserContent: getUserContent))
                  );
                }
              },
              iconSize: 30,
            ),
          ],
          title: Text("Instagram"),
      ),  // 배너에 icon 생성
      //body: Icon(Icons.star), // body content에 icon 생성
      //body: Text('', /*style: textStyle,*/ ), // 변수화된 textStyle을 사용 가능
      //body: TextButton(onPressed: (){}, child: Text('안녕'),),
      /*body: Theme(
          data: ThemeData(
            textTheme:
          ), // 중간에 theme을 새로 만들어서 적용하는 방법. 이 방식으로 하면 위쪽에 선언된 스타일이 아닌 더 가까운 이곳의 스타일을 적용받는다.
          child: Container()
      ),*/
      //body: Text('hello', style: Theme.of(context).textTheme.bodyMedium,),
      //body: Text("hello", style: Theme.of(context).textTheme.bodyLarge,), // 이렇게 원하는 스타일을 가져와서 적용시킬 수 있다.
      body: [Home(data: data, addData: addData, cnt: cnt, addCnt: addCnt), auth.currentUser?.uid != null ? Shop() : Login(), auth.currentUser?.uid != null ? Account() : Login()][tab],
      /*body: [FutureBuilder(future: data, builder: () {
        // future에 입력한 Future가 완료되면 builder 안의 위젯을 보여준다.

        // 단점 : 데이터가 계속 추가돼서 보여줘야하는 경우에 불편함. -> 데이터 추가하는 방법이 힘듬.
        // 장점 : 데이터 추가 없이 한번만 호출해서 보여주면 될 때 유용함.
      }), Text("샵페이지")][tab],*/
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "샵",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "계정",
          )
        ],
      ),

    );
  }
}

/* 부모가 보낸 state 등록은 StatefulWidget에서 해야하고, 사용은 둘째 클래스인 State에서 해야한다. */
class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData, this.cnt, this.addCnt}) : super(key: key);
  final data;
  final addData;
  final cnt;
  final addCnt;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  getMoreData() async {
    var res = await http.get(Uri.parse("https://codingapple1.github.io/app/more1.json"));
    var parsedRes = jsonDecode(res.body);

    widget.addData(parsedRes);
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        if(widget.cnt < 1) {
          getMoreData();
          widget.addCnt();
        } else {
          print("데이터가 없습니다.");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty) {
      return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (c, i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image.asset("images/sb.jpeg"),
            /*Image.network(imgList[idx]),
          Text("좋아요 ${likesList[idx]}"),
          Text("글쓴이 : ${userList[idx]}"),
          Text("글내용 : ${contentList[idx]}"),*/
            widget.data[i]['image'].runtimeType == String ? Image.network(widget.data[i]['image'],) : Image.file(widget.data[i]['image'], height: 400, fit: BoxFit.cover),
            Text("좋아요 ${widget.data[i]['likes']}"),
            GestureDetector(
              child: Text("글쓴이 : ${widget.data[i]['user']}"),
              onTap: () {
                Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (c) => Profile()),
                    //CupertinoPageRoute(builder: (c) => Profile())
                    PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => Profile(),
                        transitionsBuilder: (c, a1, a2, child) => // child : 애니메이션을 적용할 페이지가 들어가있음. 지금은 Profile()
                          FadeTransition(opacity: a1, child: child),
                        //transitionDuration: Duration(milliseconds: 1500)
                          /*SlideTransition(
                              position: Tween(
                                begin: Offset(-1.0, 1.0), // x좌표, y좌표
                                end: Offset(0.0, 0.0),
                              ).animate(a1),
                              child: child,
                          )*/
                    )
                );
              },
            ),
            Text("업로드일 : ${widget.data[i]['date']}"),
            Text("글내용 : ${widget.data[i]['content']}"),
            SizedBox(height: 20),
          ],
        );
      });
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Upload extends StatefulWidget {
  const Upload({Key? key, this.userImage, this.data, this.insertData, this.getUserContent}) : super(key: key);
  final userImage;
  final data;
  final insertData;
  final getUserContent;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram"),
        actions: [
          IconButton(
              onPressed: () {
                widget.getUserContent(txt.text);
                widget.insertData();

                Navigator.pop(context);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(widget.userImage), // 파일 경로로 이미지 띄우는 법
          Text("이미지 업로드 화면"),
          TextField(
            controller: txt,
          ),
          IconButton(onPressed: () {
            Navigator.pop(context);
          },
              icon: Icon(Icons.close)
          ),
        ],
      )
    );
  }
}

class StateStore extends ChangeNotifier {
  var name = "John Kim";
  var follower = 0;
  var isFollower = false;
  var profileImage = [];

  getData() async {
    var res = await http.get(Uri.parse("https://codingapple1.github.io/app/profile.json"));
    var parsedRes = jsonDecode(res.body);
    profileImage = parsedRes;
    notifyListeners();
  }

  changeName() {
    name = "John Park";
    notifyListeners();
  }

  follow() {
    follower++;
    isFollower = true;
    notifyListeners();
  }

  unfollow() {
    follower--;
    isFollower = false;
    notifyListeners();
  }
}

class StateStore2 extends ChangeNotifier {
  var name = "John Kim";
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<StateStore2>().name),),
      //body: Text("프로필 페이지"),
      /*body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.account_circle, size: 50,),
          Text("팔로워 ${context.watch<StateStore>().follower.toString()}명"),
          ElevatedButton(
            onPressed: () {
              context.read<StateStore>().changeName();
            },
            child: Text("버튼")
          )
        ],
      ),*/
      /*body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.account_circle, size: 50),
            Text("팔로워 ${context.watch<StateStore>().follower}명"),
            ElevatedButton(
              onPressed: () {
                if(!context.read<StateStore>().isFollower) {
                  context.read<StateStore>().follow();
                } else {
                  context.read<StateStore>().unfollow();
                }
              },
              child: Text("팔로우")
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<StateStore>().getData();
                },
                child: Text("사진 가져오기")
            )
          ],
        )
      ),*/
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: CustomScrollView(
          slivers: [
            //SliverList(delegate: delegate), // ListView
            SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverPadding(
                padding: EdgeInsets.only(bottom: 20)
            ), // Container
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => Container(
                    child:
                      context.watch<StateStore>().profileImage.isNotEmpty ? Image.network(context.watch<StateStore>().profileImage[i]) : Image.network("/"),
                  ),
                  childCount: context.watch<StateStore>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            ), // GridView
            //SliverAppBar(), // AppBar
          ],
        )
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.account_circle, size: 50),
        Text("팔로워 ${context.watch<StateStore>().follower}명"),
        ElevatedButton(
            onPressed: () {
              if(!context.read<StateStore>().isFollower) {
                context.read<StateStore>().follow();
              } else {
                context.read<StateStore>().unfollow();
              }
            },
            child: Text("팔로우")
        ),
        ElevatedButton(
            onPressed: () {
              context.read<StateStore>().getData();
            },
            child: Text("사진 가져오기")
        )
      ],
    );
  }
}

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomScrollView(
            slivers: [
              //SliverList(delegate: delegate), // ListView
              SliverToBoxAdapter(
                child: AccountHeader(),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(bottom: 20)
              ), // Container
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (c, i) => Container(
                    child:
                    context.watch<StateStore>().profileImage.isNotEmpty ? Image.network(context.watch<StateStore>().profileImage[i]) : Image.network("/"),
                  ),
                  childCount: context.watch<StateStore>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              ), // GridView
              //SliverAppBar(), // AppBar
            ],
          )
      ),
    );
  }
}

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.account_circle, size: 50),
        Text("팔로워 ${context.watch<StateStore>().follower}명"),
        ElevatedButton(
            onPressed: () {
              auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text("로그아웃")
        )
      ],
    );
  }
}
