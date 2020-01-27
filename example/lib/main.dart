import 'package:flutter/material.dart';
import 'package:swipe_up_menu/swipe_up_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Up Menu Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SwipeUpMenu(
        body: <Widget>[
          Scaffold(appBar: AppBar(title: Text("Page 1"), centerTitle:  true), backgroundColor: Colors.blue),
          Scaffold(appBar: AppBar(title: Text("Page 2"), centerTitle:  true), backgroundColor: Colors.yellow),
          Scaffold(appBar: AppBar(title: Text("Page 3"), centerTitle:  true), backgroundColor: Colors.red),
          Scaffold(appBar: AppBar(title: Text("Page 4"), centerTitle:  true), backgroundColor: Colors.green),
          Scaffold(appBar: AppBar(title: Text("Page 5"), centerTitle:  true), backgroundColor: Colors.purple),
        ],
        items: <SwipeUpMenuItem>[
          SwipeUpMenuItem(title: Text("Menu 1"), icon: Icon(Icons.home, color: Colors.white), backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: Text("Menu 2"), icon: Icon(Icons.mail, color: Colors.white), backgroundColor: Colors.yellow),
          SwipeUpMenuItem(title: Text("Menu 3"), icon: Icon(Icons.phone, color: Colors.white), backgroundColor: Colors.red),
          SwipeUpMenuItem(title: Text("Menu 4"), icon: Icon(Icons.search, color: Colors.white), backgroundColor: Colors.green),
          SwipeUpMenuItem(title: Text("Menu 5"), backgroundColor: Colors.purple),
        ],
        startIndex: 0,
        onChange: (index){
          print(index);
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teste de Menu"), centerTitle: true),
    );
  }
}
