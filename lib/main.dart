import 'package:flutter/material.dart';
import 'package:swipe_up_menu/swipe_up_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SwipeUpMenu(
        body: <Widget>[
          Scaffold(appBar: AppBar(title: Text("Page 1"), centerTitle:  true), backgroundColor: Colors.black45,),
          Scaffold(appBar: AppBar(title: Text("Page 2"), centerTitle:  true)),
          Scaffold(appBar: AppBar(title: Text("Page 3"), centerTitle:  true)),
          Scaffold(appBar: AppBar(title: Text("Page 4"), centerTitle:  true)),
          Scaffold(appBar: AppBar(title: Text("Page 5"), centerTitle:  true)),
        ],
        items: <SwipeUpMenuItem>[
          SwipeUpMenuItem(title: "Menu 1", icon: Icons.home, backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: "Menu 2", icon: Icons.mail, backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: "Menu 3", icon: Icons.phone, backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: "Menu 4", icon: Icons.search, backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: "Menu 5", backgroundColor: Colors.blue),
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
