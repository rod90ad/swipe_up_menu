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
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  bool scroll = true;
  
  @override
  Widget build(BuildContext context) {
    return SwipeUpMenu(
        body: <Widget>[
          Scaffold(appBar: AppBar(title: Text("Page 1"), centerTitle:  true), backgroundColor: Colors.blue),
          Scaffold(appBar: AppBar(title: Text("Page 2"), centerTitle:  true), backgroundColor: Colors.yellow),
          Scaffold(appBar: AppBar(title: Text("Page 3"), centerTitle:  true), backgroundColor: Colors.red),
          Scaffold(appBar: AppBar(title: Text("Page 4"), centerTitle:  true), backgroundColor: Colors.green),
          Scaffold(appBar: AppBar(title: Text("Page 5"), centerTitle:  true), backgroundColor: Colors.purple),
          MachineScreen(scroll)
        ],
        items: <SwipeUpMenuItem>[
          SwipeUpMenuItem(title: Text("Menu 1"), icon: Icon(Icons.home, color: Colors.white), backgroundColor: Colors.blue),
          SwipeUpMenuItem(title: Text("Menu 2"), icon: Icon(Icons.mail, color: Colors.white), backgroundColor: Colors.yellow),
          SwipeUpMenuItem(title: Text("Menu 3"), icon: Icon(Icons.phone, color: Colors.white), backgroundColor: Colors.red),
          SwipeUpMenuItem(title: Text("Menu 4"), icon: Icon(Icons.search, color: Colors.white), backgroundColor: Colors.green),
          SwipeUpMenuItem(title: Text("Menu 5"), backgroundColor: Colors.purple),
          SwipeUpMenuItem(title: Text("MACHINES"), backgroundColor: Colors.purple),
        ],
        startIndex: 0,
        onChange: (index){
          print(index);
        },
        animationDuration: Duration(milliseconds: 50),
        canScroll: (can){
          setState(() {
            scroll=can;
          });
        },
      );
  }
}

class MachineScreen extends StatefulWidget {
  
  final bool scroll;

  MachineScreen(this.scroll);

  @override
  _MachineScreenState createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
  
  ScrollController controller = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    print(SwipeUpMenu.of(context).scrollPhysics);
    return Scaffold(
      appBar: AppBar(
          title: Text("MACHINES", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: NotificationListener(
        onNotification: SwipeUpMenu.of(context).notificationListener,
        child: ListView(
          primary: false,
          children: List.generate(
              10,
              (index) => Container(
                    child: Text("Widget $index",
                        style: TextStyle(color: Colors.white)),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(6),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: Offset(0.0, 0.5))
                        ]),
                  )),
        ),
      ),
      );
  }
}
