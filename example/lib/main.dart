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
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SwipeUpMenu(
      body: <Widget>[
        Scaffold(
            appBar: AppBar(title: Text("Page 1", style: TextStyle(color: Colors.white)), centerTitle: true),
            backgroundColor: Colors.blue),
        Scaffold(
            appBar: AppBar(title: Text("Page 2", style: TextStyle(color: Colors.white)), centerTitle: true),
            backgroundColor: Colors.yellow),
        Scaffold(
            appBar: AppBar(title: Text("Page 3", style: TextStyle(color: Colors.white)), centerTitle: true),
            backgroundColor: Colors.red),
        Scaffold(
            appBar: AppBar(title: Text("Page 4", style: TextStyle(color: Colors.white)), centerTitle: true),
            backgroundColor: Colors.green),
        Scaffold(
            appBar: AppBar(title: Text("Page 5", style: TextStyle(color: Colors.white)), centerTitle: true),
            backgroundColor: Colors.purple),
      ],
      items: <SwipeUpMenuItem>[
        SwipeUpMenuItem(
            title: Text("Menu 1", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.home, color: Colors.white),
            backgroundColor: Colors.blue),
        SwipeUpMenuItem(
            title: Text("Menu 2", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.mail, color: Colors.white),
            backgroundColor: Colors.yellow),
        SwipeUpMenuItem(
            title: Text("Menu 3", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.phone, color: Colors.white),
            backgroundColor: Colors.red),
        SwipeUpMenuItem(
            title: Text("Menu 4", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.search, color: Colors.white),
            backgroundColor: Colors.green),
        SwipeUpMenuItem(title: Text("Menu 5", style: TextStyle(color: Colors.white)), backgroundColor: Colors.purple),
      ],
      animationDuration: Duration(milliseconds: 50),
    );
  }
}