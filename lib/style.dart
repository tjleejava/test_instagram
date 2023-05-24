import 'package:flutter/material.dart';

//var _example; // 변수 중복 방지 '_' 붙이기(방법2) -> 모든 파일에서 유일한 변수로 동작. 다른 파일에서 이 변수 사용 불가. 즉, import해서 사용 안됨.

var theme = ThemeData(
  /*textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey,
    )
  ),*/  // button styling
  //iconTheme: IconThemeData(color: Colors.black), // 모든 icon에 스타일 적용
  appBarTheme: AppBarTheme( // 배너에 스타일 적용
      color: Colors.white,
      centerTitle: false,
      elevation: 1,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
      actionsIconTheme: IconThemeData(color: Colors.black) // 이 icon은 배너에 포함된 놈이라 위에서 적용한 스타일에 영향을 받지 않아 따로 스타일을 지정함.
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.blue),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
    //unselectedItemColor: Colors.black,
  ),
);